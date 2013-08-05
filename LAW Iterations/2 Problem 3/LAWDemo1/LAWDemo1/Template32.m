//
//  Template32.m
//  LAWDemo1
//
//  Created by Daniel Ho on 5/24/12.
//

#import "Template32.h"

@implementation Template32
@synthesize sentenceLabels;

- (id)initWithDictionary:(NSMutableDictionary*)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        lectureFile = @"5-102.mp4";
        
        [self.problemTitle setText:@"Lead Sentences for Narrative Paragraphs"];
        
        //instruction
        NSArray *instructionArray = [dict objectForKey:@"instructions"];
        
        //create the instructions
        UIFont *font = [UIFont fontWithName:@"Arial" size:25];
        int i = 0;
        int x = 60;
        int y = 120;
        for (i = 0; i < [instructionArray count]; i++)
        {
            NSString *instruction = [instructionArray objectAtIndex:i];
            CGSize textSize = [instruction sizeWithFont:font];
            UILabel *instructionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(x, y, textSize.width, textSize.height)] autorelease];
            [instructionLabel setBackgroundColor:[UIColor clearColor]];
            [instructionLabel setText:instruction];
            [instructionLabel setFont:font];
            [instructionLabel setUserInteractionEnabled:YES];
            [self.view addSubview:instructionLabel];
            
            x = x + textSize.width;
            if (x > 800)
            {
                x = 60;
                y += textSize.height + 10;
            }
        }
        
        x = 100;
        y = 180;
        
        UILabel *sentenceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(x, y, 100, 100)] autorelease];
        [sentenceLabel setBackgroundColor:[UIColor clearColor]];
        [sentenceLabel setFont:font];
        [sentenceLabel setNumberOfLines:0];
        [sentenceLabel setUserInteractionEnabled:YES];
        [self.view addSubview:sentenceLabel];
        leadSentence = sentenceLabel;
        [self setQuestionParagraphWithSentence:@"_"];
        
        //create the buttons for the lead sentences
        NSArray *choiceArray = [dict objectForKey:@"choices"];
        self.sentenceLabels = [[[NSMutableArray alloc] initWithCapacity:[choiceArray count]] autorelease];
        x = 100;
        y = 500;
        for (i = 0; i < [choiceArray count]; i++)
        {
            //get size of label
            NSString *choice = [choiceArray objectAtIndex:i];
            CGSize maxSize = CGSizeMake(900, 50);
            int fontSize = [self constrainString:choice withFontSize:20 toFont:@"Arial" toSize:maxSize];
            font = [UIFont fontWithName:@"Arial" size:fontSize];
            CGSize textSize = [choice sizeWithFont:font constrainedToSize:maxSize];
            
            UIButton *choiceButton = [[[UIButton alloc] initWithFrame:CGRectMake(x, y, textSize.width, textSize.height)] autorelease];
            [choiceButton setTag:i];
            [choiceButton setBackgroundColor:[UIColor clearColor]];
            [choiceButton addTarget:self action:@selector(choiceSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *choiceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)] autorelease];
            [choiceLabel setBackgroundColor:[UIColor clearColor]];
            [choiceLabel setTextColor:[UIColor blackColor]];
            [choiceLabel setFont:font];
            [choiceLabel setText:choice];
            [choiceLabel setTextAlignment:UITextAlignmentLeft];
            [choiceButton addSubview:choiceLabel];
            
            [self.view addSubview:choiceButton];
            
            [sentenceLabels addObject:choiceButton];
            
            y += textSize.height + 10;
        }
        
        TemplateControls *control = [[[TemplateControls alloc] initWithFrame:CGRectMake(0, 700, 1024, 68) andParent:self] autorelease];
        [self.view addSubview:control];
        
        feedbackLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100, 550, 500, 200)] autorelease];
        [feedbackLabel setBackgroundColor:[UIColor redColor]];
        [feedbackLabel setTextColor:[UIColor blackColor]];
        [feedbackLabel setFont:font];
        [feedbackLabel setNumberOfLines:0];
        [feedbackLabel setHidden:YES];
        [self.view addSubview:feedbackLabel];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Creating Paragraph

-(CGSize)setQuestionParagraphWithSentence:(NSString*)sentence
{
    NSArray *questionArray = [templateDict objectForKey:@"questions"];
    UIFont *font = [UIFont fontWithName:@"Arial" size:22];
    int i = 0;
    int x = 100;
    int y = 180;
    CGSize textSize;
    NSString *question = @"";
    for (i = 0; i < [questionArray count]; i++)
    {
        NSString *string = [questionArray objectAtIndex:i];
        if ([string isEqualToString:@"_"])
            string = sentence;
        
        question = [question stringByAppendingFormat:@"%@", string];
    }
    
    textSize = [question sizeWithFont:font constrainedToSize:CGSizeMake(750, 500)];
    [leadSentence setFrame:CGRectMake(x, y, textSize.width, textSize.height)];
    [leadSentence setFont:font];
    [leadSentence setText:question];
    
    return textSize;
}

#pragma mark - Answer delegate

-(void)choiceSelected:(id)sender
{   
    if (state == kExerciseStateLocked)
    return;
    
    UIButton *choiceButton = (UIButton*)sender;
    int index = choiceButton.tag;
    
    for (UIButton *sentence in sentenceLabels)
    {
        [sentence setBackgroundColor:[UIColor clearColor]];
    }
    [choiceButton setBackgroundColor:[UIColor lightGrayColor]];
    
    NSArray *choiceArray = [templateDict objectForKey:@"choices"];
    NSString *choice = [choiceArray objectAtIndex:index];
    [self setQuestionParagraphWithSentence:choice];
    
    NSArray *messageArray = [templateDict objectForKey:@"messages"];
    NSString *message = [messageArray objectAtIndex:index];
    isCorrect = [message isEqualToString:@"answer"];
    UIColor *textColor = nil;
    if (!isCorrect)
    {
        textColor = [UIColor redColor];
    }
    else
    {
        message = @"Correct!";
        textColor = [UIColor greenColor];
    }
    CGSize constrainSize = CGSizeMake(800, 60);
    NSString *fontName = @"Arial";
    int fontSize = [self constrainString:message withFontSize:15 toFont:fontName toSize:constrainSize];
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    CGSize textSize = [message sizeWithFont:font constrainedToSize:constrainSize];
    float yPos = self.view.frame.size.width - textSize.height - 55;
    [feedbackLabel setFrame:CGRectMake(feedbackLabel.frame.origin.x, yPos, textSize.width, textSize.height)];
    [feedbackLabel setText:message];
    [feedbackLabel setFont:font];
    [feedbackLabel setBackgroundColor:textColor];
    [feedbackLabel setHidden:YES];

    hasAnswered = YES;
}

-(void)submitTapped
{
    if (state == kExerciseStateLocked || !hasAnswered)
        return;

    [super submitTapped];
    
    [feedbackLabel setAlpha:0];
    [UIView beginAnimations:@"resultFadeIn" context:nil];
    [UIView setAnimationDuration:.2f];
    [feedbackLabel setAlpha:1.f];
    [UIView commitAnimations];
    
    [feedbackLabel setHidden:NO];
}

@end
