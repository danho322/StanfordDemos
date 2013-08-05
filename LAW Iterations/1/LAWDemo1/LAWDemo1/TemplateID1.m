//
//  TemplateID1.m
//  LAWDemo1
//
//  Created by Daniel Ho on 5/23/12.
//

#import "TemplateID1.h"

@implementation TemplateID1
@synthesize nounLabels;

- (id)initWithDictionary:(NSMutableDictionary*)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        lectureFile = @"2.A.Nouns.mp4";
        // Dictionary format
        /*dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:instruction, @"instruction",
                 stringArray, @"questions",
                 feedback, @"feedback",
                 answer, @"answer", 
                 fileID, @"fileID", nil] autorelease];
        */
        
        //instruction
        NSString *prompt = [dict objectForKey:@"instruction"];
        [self.problemDesc setText:prompt];
        [problemDesc setTextAlignment:UITextAlignmentLeft];
        
        //all questions
        NSArray *nounArray = [dict objectForKey:@"questions"];
        self.nounLabels = [[[NSMutableArray alloc] initWithCapacity:[nounArray count]] autorelease];
        
        //create a sentence of buttons
        UIFont *font = [UIFont fontWithName:@"Arial" size:25];
        int i = 0;
        int x = 100;
        int y = 300;
        for (i = 0; i < [nounArray count]; i++)
        {
            NSString *noun = [nounArray objectAtIndex:i];
            CGSize textSize = [noun sizeWithFont:font];
            UILabel *nounLabel = [[[UILabel alloc] initWithFrame:CGRectMake(x, y, textSize.width, textSize.height)] autorelease];
            [nounLabel setBackgroundColor:[UIColor clearColor]];
            [nounLabel setText:noun];
            [nounLabel setFont:font];
            [nounLabel setUserInteractionEnabled:YES];
            [self.view addSubview:nounLabel];
            [nounLabels addObject:nounLabel];
            
            if (![noun isEqualToString:@" "])
            {
                //Add gesture recognize to the label so we can click it
                UITapGestureRecognizer *gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClicked:)] autorelease];
                [nounLabel addGestureRecognizer:gesture];
            }
            
            x = x + textSize.width;
            if (y > 600)
            {
                x = 100;
                y += textSize.height + 10;
            }
        }
        
        NSString *feedback = [templateDict objectForKey:@"feedback"];
        CGSize textSize = [feedback sizeWithFont:font];
        feedbackLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100, 650, textSize.width, textSize.height)] autorelease];
        [feedbackLabel setBackgroundColor:[UIColor redColor]];
        [feedbackLabel setText: feedback];
        [feedbackLabel setTextColor:[UIColor blackColor]];
        [feedbackLabel setFont:font];
        [feedbackLabel setHidden:YES];
        [self.view addSubview:feedbackLabel];
        
        TemplateControls *control = [[TemplateControls alloc] initWithFrame:CGRectMake(0, 700, 1024, 68) andParent:self];
        [self.view addSubview:control];
        
    }
    return self;
}

- (void)dealloc
{
    [lectureFile release];
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

#pragma mark - Touch Delegate

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    UILabel *label = (UILabel*)context;
    [UIView beginAnimations:@"labelBlack" context:nil];
    [UIView setAnimationDuration:.2f];
    [label setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [UIView commitAnimations];

}

-(void)labelClicked:(UITapGestureRecognizer*)gesture
{
    if (state == kExerciseStateLocked)
        return;
    
    UILabel *label = (UILabel*)gesture.view;
    
    for (UILabel *noun in nounLabels)
    {
        [noun setTextColor:[UIColor blackColor]];
    }
    [label setTextColor:[UIColor purpleColor]];
    
    [UIView beginAnimations:@"labelHighlight" context:label];
    [UIView setAnimationDuration:.2f];
    [label setTransform:CGAffineTransformMakeScale(1.5f, 1.5f)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
    
    NSString *answer = [templateDict objectForKey:@"answer"];
    isCorrect = [answer isEqualToString:label.text];

    UIColor *textColor;
    NSString *text;
    if (isCorrect)
    {
        textColor = [UIColor greenColor];
        text = @"Correct!";
    }
    else
    {
        textColor = [UIColor redColor];
        text = [templateDict objectForKey:@"feedback"];
    }
    UIFont *font = [UIFont fontWithName:@"Arial" size:25];
    CGSize textSize = [text sizeWithFont:font];
    [feedbackLabel setFrame:CGRectMake(feedbackLabel.frame.origin.x, feedbackLabel.frame.origin.y, textSize.width, textSize.height)];
    [feedbackLabel setBackgroundColor:textColor];
    [feedbackLabel setText:text];
    [feedbackLabel setHidden:YES];
    
    hasAnswered = YES;
}

-(void)submitTapped
{
    if (state == kExerciseStateLocked)
        return;
    
    [super submitTapped];
    
    [feedbackLabel setHidden:NO];
    
    [feedbackLabel setAlpha:0];
    [UIView beginAnimations:@"resultFadeIn" context:nil];
    [UIView setAnimationDuration:.2f];
    [feedbackLabel setAlpha:1.f];
    [UIView commitAnimations];
}

@end
