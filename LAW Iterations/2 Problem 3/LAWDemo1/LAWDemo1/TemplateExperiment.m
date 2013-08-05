//
//  TemplateExpirement.m
//  LAWDemo1
//
//  Created by Daniel Ho on 6/4/12.
//

#import "TemplateExperiment.h"

@implementation DraggableWord
@synthesize label;
@synthesize text;

- (id)initWithFrame:(CGRect)frame andParent:(id)parentWindow andText:(NSString*)wordText
{
    self = [super initWithFrame:frame];
    if (self) {
        originalCenter = self.center;
        parent = (TemplateExperiment*)parentWindow;
        text = wordText;
    }
    return self;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([parent wordOutOfBounds:self])
    {
        [parent removeWord:self];
    }
    else
    {
        if (![parent reorderWordsWithMovedWord:self])
        {
            [UIView animateWithDuration:0.2     // slide back to original position
                             animations:^{
                                 self.center = originalCenter;
                             }];
        }
        else
        {
            [parent redrawWords];
        }
    }
}

@end

@implementation TemplateExperiment

@synthesize correctStrings;
@synthesize incorrectStrings;

- (id)initWithDictionary:(NSMutableDictionary*)dict
{
    self = [super initWithDictionary:dict];
    if (self) 
    {
        lectureFile = @"id3-2.mp4";
        
        [self.problemTitle setText:@"Sentence Composition: Proper and Common Nouns"];
        
        [problemDesc setText:@"Write a complete sentence that answers the question by clicking on the words from the lists.\nTo remove a word from your answer, click and drag it out of the box. Use RESET to remove all your words"];
        
        //instruction
        NSArray *questionArray = [dict objectForKey:@"question"];
        
        //create sentence
        UIFont *font = [UIFont fontWithName:@"Arial" size:25];
        int x = 60;
        int y = 200;
        NSString *sentence = [dict objectForKey:@"sentence"];
        CGSize textSize = [sentence sizeWithFont:font];
        UILabel *sentenceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(x, y, textSize.width, textSize.height)] autorelease];
        [sentenceLabel setBackgroundColor:[UIColor clearColor]];
        [sentenceLabel setText:sentence];
        [sentenceLabel setFont:font];
        [sentenceLabel setUserInteractionEnabled:YES];
        [self.view addSubview:sentenceLabel];
        
        y += 50;
        //create the instructions
        int i = 0;
        for (i = 0; i < [questionArray count]; i++)
        {
            NSString *question = [questionArray objectAtIndex:i];
            textSize = [question sizeWithFont:font];
            UILabel *questionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(x, y, textSize.width, textSize.height)] autorelease];
            [questionLabel setBackgroundColor:[UIColor clearColor]];
            [questionLabel setText:question];
            [questionLabel setFont:font];
            [questionLabel setUserInteractionEnabled:YES];
            [self.view addSubview:questionLabel];
            
            x = x + textSize.width;
            if (x > 800)
            {
                x = 60;
                y += textSize.height + 10;
            }
        }
        
        y += 50;
        NSDictionary *wordListDict = [self getWordListDictionaryForValue:[dict objectForKey:@"wordlistnumber"]];
        [self buildWordListsWithDictionary:wordListDict atY:y];
        
        //Create the array to hold all the words that drag
        wordViews = [[NSMutableArray alloc] initWithCapacity:10];
        
        UIButton *resetButton = [[[UIButton alloc] initWithFrame:CGRectMake(60, 650, 75, 30)] autorelease];
        [resetButton setBackgroundColor:[UIColor grayColor]];
        [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
        [resetButton addTarget:self action:@selector(resetTapped) forControlEvents:UIControlEventTouchUpInside];
        [resetButton.layer setCornerRadius:5.f];
        [resetButton.layer setMasksToBounds:YES];
        [self.view addSubview:resetButton];
        
        feedbackLabel = [[[UILabel alloc] initWithFrame:CGRectMake(60, 550, 500, 200)] autorelease];
        [feedbackLabel setBackgroundColor:[UIColor clearColor]];
        [feedbackLabel setTextColor:[UIColor blackColor]];
        [feedbackLabel setFont:font];
        [feedbackLabel setNumberOfLines:0];
        [feedbackLabel setHidden:YES];
        [self.view addSubview:feedbackLabel];
        
        //Box for the sentence
        UIView* sentenceBox = [[[UIView alloc] initWithFrame:CGRectMake(50, 530, [[UIScreen mainScreen] bounds].size.height - 100, 70)] autorelease];
        [sentenceBox.layer setBorderWidth:1.f];
        [sentenceBox.layer setBorderColor:[UIColor blackColor].CGColor];
        [self.view addSubview:sentenceBox];
        
        //Set parser string
        NSString* parser = [self getContentsOfFile:[NSString stringWithFormat:@"sl%@", [dict objectForKey:@"parser"]]];
        [self generateCorrectAndIncorrectListsFromString:parser];
        
        //Word to drag when clicked
        draggableWord = [[DraggableWord alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [draggableWord setBackgroundColor:[UIColor clearColor]];
        [draggableWord setUserInteractionEnabled:YES];
        [draggableWord setHidden:YES];
        [self.view addSubview:draggableWord];
    
        TemplateControls *control = [[[TemplateControls alloc] initWithFrame:CGRectMake(0, 700, 1024, 68) andParent:self] autorelease];
        [self.view addSubview:control];
    }
    
    return self;
}

-(void)dealloc
{
    [draggableWord release];
    [wordViews release];
    self.correctStrings = nil;
    self.incorrectStrings = nil;

    [super dealloc];
}

#pragma mark - Correct and Incorrect

-(void)generateCorrectAndIncorrectListsFromString:(NSString*)parser
{
    NSString* exercise = [templateDict objectForKey:@"parserexercise"];
    
    parser = [parser stringByReplacingOccurrencesOfString:exercise withString:@""];
    parser = [parser stringByReplacingOccurrencesOfString:@"------" withString:@""];
    NSArray* components = [parser componentsSeparatedByString:@"---xs---"];
    
    NSString* correct = [components objectAtIndex:0];
    NSString* incorrect = [components objectAtIndex:1];
    
    components = [correct componentsSeparatedByString:@"\n"];
    self.correctStrings = [NSMutableDictionary dictionaryWithCapacity:[components count]];
    for (NSString* component in components)
    {
        if (component.length > 0)
            [correctStrings setValue:@"correct" forKey:[component lowercaseString]];
    }
    
    components = [incorrect componentsSeparatedByString:@"\n"];
    self.incorrectStrings = [NSMutableDictionary dictionaryWithCapacity:[components count]];
    for (NSString* component in components)
    {
        if (component.length > 0)
        {
            NSArray* incorrectComponents = [component componentsSeparatedByString:@"="];
            NSString *trimmedKey = [[incorrectComponents objectAtIndex:0] stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *trimmedFeedback = [[incorrectComponents objectAtIndex:1] stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            trimmedFeedback = [trimmedFeedback stringByReplacingOccurrencesOfString:@"|" withString:@""];
            [incorrectStrings setValue:trimmedFeedback forKey:[trimmedKey lowercaseString]];
        }
    }
}

#pragma mark - Building the Word Lists

-(NSMutableDictionary*)getWordListDictionaryForValue:(NSString*)wordListName
{
    NSString* content = [self getContentsOfFile:[NSString stringWithFormat:@"wordhash_%@", wordListName]];
    
    NSCharacterSet* charSet = [NSCharacterSet characterSetWithCharactersInString:@"{}\""];
    content = [[content componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
    
    NSArray *components = [content componentsSeparatedByString:@"],"];
    
    // Get each category and its list
    NSMutableDictionary* wordListDict = [NSMutableDictionary dictionaryWithCapacity:[components count]];
    charSet = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
    for (NSString *component in components)
    {
        NSArray* category = [component componentsSeparatedByString:@":"];
        
        NSString* list = [category objectAtIndex:1];
        list = [[list componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
        
        NSArray* words = [list componentsSeparatedByString:@","];
        [wordListDict setObject:words forKey:[category objectAtIndex:0]];
    }
    
    return wordListDict;
}

-(void)buildWordListsWithDictionary:(NSDictionary*)wordListDict atY:(float)y
{
    NSArray* categories = [wordListDict allKeys];
    float x = 60;
    
    for (NSString* key in categories)
    {
        x += [self buildListWithTitle:key andWords:[wordListDict objectForKey:key] atPoint:CGPointMake(x, y)] + 40;
    }
}

-(float)buildListWithTitle:(NSString*)title andWords:(NSArray*)words atPoint:(CGPoint)coords
{
    float x = coords.x;
    float y = coords.y;
    
    UIFont* font = [UIFont fontWithName:@"Arial" size:20];
    CGSize textSize = [title sizeWithFont:font];
    UILabel* titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(x, y, textSize.width + 10, textSize.height)] autorelease];
    [titleLabel setBackgroundColor:[UIColor grayColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [self.view addSubview:titleLabel];
    
    y += 30;
    int i = 0;
    for (i = 0; i < [words count]; i++)
    {
        NSString *word = [words objectAtIndex:i];
        textSize = [word sizeWithFont:font];
        UIButton* wordButton = [[[UIButton alloc] initWithFrame:CGRectMake(x, y, textSize.width, textSize.height)] autorelease];
        [wordButton setTitle:word forState:UIControlStateNormal];
        [wordButton setBackgroundColor:[UIColor clearColor]];
        [wordButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [wordButton addTarget:self action:@selector(wordTouchesBegan:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [wordButton addTarget:self action:@selector(wordTouchesBegan:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
        [wordButton addTarget:self action:@selector(wordTouchesEnded:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
        [wordButton addTarget:self action:@selector(wordTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:wordButton];
        y += 30;
    }
    
    return titleLabel.frame.size.width;
}

#pragma mark - Managing DraggableWords

-(void)redrawWords
{
    DraggableWord* wordToRemove = nil;
    float x = 60;
    int index = 0;
    for (DraggableWord* word in wordViews)
    {
        if (index == 0)
            [word.label setText:[word.text capitalizedString]];
        else if (index == [wordViews count]- 1)
            [word.label setText:[NSString stringWithFormat:@"%@.", word.text]];
        else
            [word.label setText:word.text];
        
        UIFont *font = [UIFont fontWithName:@"Arial" size:25];
        CGSize textSize = [word.label.text sizeWithFont:font];
        
        if (x + textSize.width >= [[UIScreen mainScreen] bounds].size.height - 70)
        {
            wordToRemove = word;
            break;
        }
        
        [word setFrame:CGRectMake(x, 550, textSize.width, textSize.height)];
        [word.label setFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
        x += word.frame.size.width + 5;
        index++;
    }
    
    if (wordToRemove)
    {
        [wordToRemove removeFromSuperview];
        [wordViews removeObject:wordToRemove];
    }
}

-(BOOL)reorderWordsWithMovedWord:(DraggableWord*)movedWord
{
    int oldPos = -1;
    int i = 0;
    for (DraggableWord* word in wordViews)
    {
        if (![movedWord isEqual:word])
        {
            // If movedWord is before the origin of word, insert before it
            if (movedWord.frame.origin.x < word.frame.origin.x)
                break;
        }
        else
            oldPos = i;
        
        i++;
    }
    if (oldPos == i - 1)
    {
        return NO;  //the word isn't moved
    }
    else if (oldPos == -1)   //movedWord was moved back
    {
        [wordViews removeObject:movedWord];
        [wordViews insertObject:movedWord atIndex:i];
    }
    else                //movedWord was moved forward
    {
        [wordViews insertObject:movedWord atIndex:i];
        [wordViews removeObjectAtIndex:oldPos];
    }
    
    return YES;
}

-(NSString*)getConstructedString
{
    NSString* constructedString = @"";
    
    for (DraggableWord* word in wordViews)
    {
        if (constructedString.length > 0)
            constructedString = [NSString stringWithFormat:@"%@ %@", constructedString, word.text];
        else
            constructedString = word.text;
    }
    return constructedString;
}

-(BOOL)wordOutOfBounds:(DraggableWord*)word
{
    return word.frame.origin.y < 500 || (word.frame.origin.y > 550 + word.frame.size.height + 50);
}

-(void)removeWord:(DraggableWord*)word
{
    [word removeFromSuperview];
    [wordViews removeObject:word];
    [self redrawWords];
}

#pragma mark - Checking Answer
-(BOOL)checkCorrect
{
    BOOL ret = NO;
    NSString* message = @"";
    
    NSString* constructedSentenceString = [[NSString stringWithFormat:@"%@.",[self getConstructedString]] lowercaseString];
    if ([correctStrings objectForKey:constructedSentenceString])
    {
        ret = YES;
    }
    else if ([incorrectStrings objectForKey:constructedSentenceString])
    {
        message = [incorrectStrings objectForKey:constructedSentenceString];
    }
    else
    {
        message = @"Parser is not available.  Please try again.";
    }
    CGSize constrainSize = CGSizeMake(800, 60);
    NSString *fontName = @"Arial";
    int fontSize = [self constrainString:message withFontSize:25 toFont:fontName toSize:constrainSize];
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    CGSize textSize = [message sizeWithFont:font constrainedToSize:constrainSize];
    float yPos = self.view.frame.size.width - textSize.height - 105;
    [feedbackLabel setFrame:CGRectMake(feedbackLabel.frame.origin.x, yPos, textSize.width, textSize.height)];
    [feedbackLabel setText:message];
    [feedbackLabel setFont:font];
    [feedbackLabel setHidden:YES];
    return ret;
}

#pragma mark - Button Delegates

- (void) wordTouchesBegan:(UIButton*)button withEvent:(UIEvent*)event
{
    if (state == kExerciseStateLocked)
        return;
    
    if (!((DraggableWord*)draggableWord).label)
    {
        UIFont *font = [UIFont fontWithName:@"Arial" size:25];
        CGSize textSize = [button.titleLabel.text sizeWithFont:font];
        UILabel *constructedLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)] autorelease];
        [constructedLabel setBackgroundColor:[UIColor clearColor]];
        [constructedLabel setFont:font];
        [constructedLabel setNumberOfLines:0];
        [constructedLabel setUserInteractionEnabled:YES];
        [constructedLabel setText:button.titleLabel.text];
        
        [draggableWord setFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
        ((DraggableWord*)draggableWord).label = constructedLabel;
        [draggableWord addSubview:constructedLabel];
        
        [draggableWord setHidden:NO];
    }
    NSSet* touches = [event allTouches];
    // When a touch starts, get the current location in the view
    draggableWord.center = [[touches anyObject] locationInView:self.view];
}

- (void) wordTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (state == kExerciseStateLocked)
        return;
    
    [draggableWord setHidden:YES];
    
    if (![self wordOutOfBounds:draggableWord])
    {
        NSString* wordText = ((DraggableWord*)draggableWord).label.text;
        
        UIFont *font = [UIFont fontWithName:@"Arial" size:25];
        CGSize textSize = [wordText sizeWithFont:font];
        UILabel *constructedLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)] autorelease];
        [constructedLabel setBackgroundColor:[UIColor clearColor]];
        [constructedLabel setFont:font];
        [constructedLabel setNumberOfLines:0];
        [constructedLabel setUserInteractionEnabled:YES];
        [constructedLabel setText:wordText];
        
        DraggableWord* thisWord = [[[DraggableWord alloc] initWithFrame:draggableWord.frame andParent:self andText:wordText] autorelease];
        thisWord.label = constructedLabel;
        [thisWord addSubview:constructedLabel];
        [self.view addSubview:thisWord];
        [wordViews addObject:thisWord];
        
        [self reorderWordsWithMovedWord:thisWord];
        [self redrawWords];
    }
    
    [((DraggableWord*)draggableWord).label removeFromSuperview];
    ((DraggableWord*)draggableWord).label = nil;
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    UIButton *button = (UIButton*)context;
    [UIView beginAnimations:@"labelBlack" context:nil];
    [UIView setAnimationDuration:.2f];
    [button setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [UIView commitAnimations];
    
}

-(void)wordTapped:(id)sender
{
    if (state == kExerciseStateLocked)
        return;
    
    [draggableWord setHidden:YES];
    
    UIButton* word = (UIButton*)sender;
    
    [UIView beginAnimations:@"labelHighlight" context:word];
    [UIView setAnimationDuration:.2f];
    [word setTransform:CGAffineTransformMakeScale(1.5f, 1.5f)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
    
    float x = 60;
    if ([wordViews count] > 0)
    {
        DraggableWord *lastWord = [wordViews objectAtIndex:[wordViews count] - 1];
        x = lastWord.frame.origin.x + lastWord.frame.size.width + 5;
    }
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:25];
    CGSize textSize = [word.titleLabel.text sizeWithFont:font];
    UILabel *constructedLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)] autorelease];
    [constructedLabel setBackgroundColor:[UIColor clearColor]];
    [constructedLabel setFont:font];
    [constructedLabel setNumberOfLines:0];
    [constructedLabel setUserInteractionEnabled:YES];
    [constructedLabel setText:word.titleLabel.text];
    
    DraggableWord* thisWord = [[[DraggableWord alloc] initWithFrame:CGRectMake(x, 550, textSize.width, textSize.height) andParent:self andText:word.titleLabel.text] autorelease];
    thisWord.label = constructedLabel;
    [thisWord addSubview:constructedLabel];
    [self.view addSubview:thisWord];
    
    [wordViews addObject:thisWord];
    
    [self redrawWords];
    
    hasAnswered = YES;
}

-(void)resetTapped
{
    for (DraggableWord* word in wordViews)
        [word removeFromSuperview];
    
    [wordViews removeAllObjects];

    [feedbackLabel setHidden:YES];
    hasAnswered = NO;
}

-(void)submitTapped
{
    if (state == kExerciseStateLocked)
        return;
    
    isCorrect = [self checkCorrect];
    
    [super submitTapped];
    
    [feedbackLabel setAlpha:0];
    [UIView beginAnimations:@"resultFadeIn" context:nil];
    [UIView setAnimationDuration:.2f];
    [feedbackLabel setAlpha:1.f];
    [UIView commitAnimations];
    
    [feedbackLabel setHidden:NO];
}

@end
