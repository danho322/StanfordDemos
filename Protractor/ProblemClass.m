//
//  ProblemClass.m
//  Protractor
//
//  Created by Daniel Ho on 4/30/12.
//

#import "ProblemClass.h"
#import "ProtractorAppDelegate.h"

@implementation DraggableImage

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self)
        self.userInteractionEnabled = YES;
    return self;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // When a touch starts, get the current location in the view
    currentPoint = [[touches anyObject] locationInView:self];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Get active location upon move
    CGPoint activePoint = [[touches anyObject] locationInView:self];
    
    // Determine new point based on where the touch is now located
    CGPoint newPoint = CGPointMake(self.center.x + (activePoint.x - currentPoint.x),
                                   self.center.y + (activePoint.y - currentPoint.y));
    
    //--------------------------------------------------------
    // Make sure we stay within the bounds of the parent view
    //--------------------------------------------------------
    float midPointX = CGRectGetMidX(self.bounds);
    // If too far right...
    if (newPoint.x > self.superview.bounds.size.width  - midPointX)
        newPoint.x = self.superview.bounds.size.width - midPointX;
    else if (newPoint.x < midPointX)  // If too far left...
        newPoint.x = midPointX;
    
    float midPointY = CGRectGetMidY(self.bounds);
    // If too far down...
    if (newPoint.y > self.superview.bounds.size.height  - midPointY)
        newPoint.y = self.superview.bounds.size.height - midPointY;
    else if (newPoint.y < midPointY)  // If too far up...
        newPoint.y = midPointY;
    
    // Set new center location
    self.center = newPoint;
}

@end


@implementation ProblemClass
@synthesize problemTitle;
@synthesize problemDesc;
@synthesize answerBox;
@synthesize answerLabel;
@synthesize problemLayer;
@synthesize submitButton;
@synthesize questionLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        CGRect window = [[UIScreen mainScreen] bounds];
        
        [self.view setFrame:window];
        
        // Create upper blue bar
        UIView* blueBar = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, window.size.height, 100.f)] autorelease];
        [blueBar setBackgroundColor:[UIColor colorWithRed:0.f/255.f green:191.f/255.f blue:255.f/255.f alpha:1.f]];
        [self.view addSubview:blueBar];
        
        self.answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(500, 50, 150, 50)];
        [answerLabel setBackgroundColor:[UIColor whiteColor]];
        [answerLabel setHidden:true];
        [answerLabel setTextColor:[UIColor colorWithRed:0 green:0 blue:160.0f/255.0f alpha:1.0f]];
        [answerLabel setFont:[UIFont systemFontOfSize:35]];
        [answerLabel setTextAlignment: UITextAlignmentCenter];
        [self.view addSubview:answerLabel];
        
        //Create the underlying problem layer view
        
        // Create the title of the problem
        self.problemTitle = [[[UILabel alloc] initWithFrame:CGRectMake(30, 30, window.size.height - 60, 50)] autorelease];
        [problemTitle setTextColor:[UIColor blueColor]];
        [problemTitle setBackgroundColor:[UIColor clearColor]];
        [problemTitle setFont:[UIFont fontWithName:@"Arial" size:40]];
        [blueBar addSubview:problemTitle];
    
        // Create the label for the problem description
        self.problemDesc = [[[UILabel alloc] initWithFrame:CGRectMake(50, blueBar.frame.origin.y + blueBar.frame.size.height + 20, window.size.height - 100, 30)] autorelease];
        [problemDesc setTextColor:[UIColor grayColor]];
        [problemDesc setBackgroundColor:[UIColor clearColor]];
        [problemDesc setFont:[UIFont fontWithName:@"Arial" size:20]];
        [problemDesc setTextAlignment:UITextAlignmentCenter];
        [self.view addSubview:problemDesc];
        
    }
    return self;
}

- (void)dealloc
{
    self.problemTitle = nil;        // This sends a release to problemTitle
    self.problemDesc = nil;
    //self.answerBox = nil;         // answerBox is no longer allocated here
    self.answerLabel = nil;

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

#pragma mark - Answer Delegate 
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Meant to be overwritten
    return NO;
}

-(void)submitTapped
{
    // Meant to be overwritten
}

#pragma mark - Result Methods

-(void)fadeDone
{
    ProtractorAppDelegate *appDelegate = (ProtractorAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.maskLayer setAlpha:0];
    [appDelegate.maskLayer setHidden:NO];
    [UIView beginAnimations:@"fadeNextProblem" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationDelegate:appDelegate];
    [UIView setAnimationDidStopSelector:@selector(showNextProblem)];
    [appDelegate.maskLayer setAlpha:1];
    [UIView commitAnimations];
}

-(void)fadeAnswer
{
    
    [UIView beginAnimations:@"resultFadeIn" context:nil];
    [UIView setAnimationDuration:.2f];
    [answerLabel setAlpha:0.f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fadeDone)];
    [UIView commitAnimations];
}

-(void)fadeAnswerIncorrect
{
    
    [UIView beginAnimations:@"resultFadeIn" context:nil];
    [UIView setAnimationDuration:.2f];
    [answerLabel setAlpha:0.f];
    [UIView commitAnimations];
}

-	(void)PlaySoundFile:(CFStringRef)sf
{
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundFileURLRef;
    soundFileURLRef = CFBundleCopyResourceURL(mainBundle, sf, CFSTR("mp3"), NULL);
    UInt32 soundID;
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
    AudioServicesPlaySystemSound(soundID);
}


-(void)answered:(BOOL)isCorrect forProblem:(ProblemClass*)problem
{
    if (isCorrect)
        [answerLabel setText:@"Correct"];
    else
        [answerLabel setText:@"Incorrect"];
    [answerLabel setHidden:false];

    [answerLabel setAlpha:0.f];
    
    [UIView beginAnimations:@"resultFadeIn" context:nil];
    [UIView setAnimationDuration:.2f];
    [answerLabel setAlpha:1.f];
    [UIView commitAnimations];
    
    if (isCorrect) {
        [self PlaySoundFile:(CFStringRef)@"Correct4"];
    } else{
        [self PlaySoundFile:(CFStringRef)@"Incorrect4"];
    }
    
    SEL callback = (isCorrect) ? @selector(fadeAnswer) : @selector(fadeAnswerIncorrect);
    [self performSelector:callback withObject:nil afterDelay:1.5f];
}

@end
