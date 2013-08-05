//
//  TemplateWindow.m
//  LAWDemo1
//
//  Created by Daniel Ho on 5/23/12.
//

#import "TemplateWindow.h"
#import "AppDelegate.h"

@implementation SFMovieViewController
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    // Rotate and translate our view into place for landscape mode
//    CGRect mainFrame = [[UIScreen mainScreen] bounds];
//    
//	self.view.frame = mainFrame;
//    
//    NSLog(@"my frame is %d,%d,%d,%d", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    MPMoviePlayerController* moviePlayer = [self moviePlayer];
//    if(moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
//        [[self moviePlayer] stop];
//}
@end

@implementation TemplateWindow

@synthesize problemTitle;
@synthesize problemDesc;
@synthesize submitButton;
@synthesize templateDict;

- (id)initWithDictionary:(NSMutableDictionary*)dict
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) 
    {
        self.templateDict = dict;
        hasAnswered = NO;
        isCorrect = NO;
        tries = 0;
        state = kExerciseStateOpen;
        CGRect window = [[UIScreen mainScreen] bounds];
        
        [self.view setFrame:window];
        
        // Create upper blue bar
        UIView* blueBar = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, window.size.height, 100.f)] autorelease];
        [blueBar setBackgroundColor:[UIColor colorWithRed:0.f/255.f green:191.f/255.f blue:255.f/255.f alpha:1.f]];
        [self.view addSubview:blueBar];
        
        // Create the title of the problem
        NSString *fileID = [templateDict objectForKey:@"fileID"];
        self.problemTitle = [[[UILabel alloc] initWithFrame:CGRectMake(30, 30, window.size.height - 60, 50)] autorelease];
        [problemTitle setTextColor:[UIColor blueColor]];
        [problemTitle setBackgroundColor:[UIColor clearColor]];
        [problemTitle setFont:[UIFont fontWithName:@"Arial" size:40]];
        [problemTitle setText:fileID];
        [blueBar addSubview:problemTitle];
        
        // Create the label for the problem description
        self.problemDesc = [[[UILabel alloc] initWithFrame:CGRectMake(50, blueBar.frame.origin.y + blueBar.frame.size.height + 20, window.size.height - 100, 30)] autorelease];
        [problemDesc setTextColor:[UIColor grayColor]];
        [problemDesc setBackgroundColor:[UIColor clearColor]];
        [problemDesc setFont:[UIFont fontWithName:@"Arial" size:25]];
        [problemDesc setTextAlignment:UITextAlignmentCenter];
        [self.view addSubview:problemDesc];

        // Submit Button
        self.submitButton = [[[UIButton alloc] initWithFrame:CGRectMake(900, 650, 75, 30)] autorelease];
        [submitButton setBackgroundColor:[UIColor grayColor]];
        [submitButton setTitle:@"Ok" forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(submitTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:submitButton];
    }
    return self;
}

- (void)dealloc
{
    self.problemTitle = nil;        // This sends a release to problemTitle
    self.problemDesc = nil;
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

#pragma mark - Answer delegate

-(void)submitTapped
{
    if (state == kExerciseStateLocked)
        return;
    
    state = kExerciseStateLocked;
    
    if (hasAnswered)
    {
        [self playAudio:isCorrect];
        hasAnswered = NO;
        tries += 1;
    }
}

#pragma mark - Helper methods

-(int)constrainString:(NSString*)string withFontSize:(int)fontSize toFont:(NSString*)fontName toSize:(CGSize)textSize
{
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    
    CGSize textSizeWithFont = [string sizeWithFont:font constrainedToSize:textSize];
    while (textSizeWithFont.width == textSize.width && textSizeWithFont.height == textSize.height)
    {
        fontSize = fontSize - 1;
        font = [UIFont fontWithName:fontName size:fontSize];
        textSizeWithFont = [string sizeWithFont:font];
    }
    return fontSize;
}

#pragma mark - Playing sound

-(void)playAudio:(BOOL)correct
{
    int randNum = arc4random_uniform(2);
    NSString *fileName = [NSString stringWithFormat:@"%@%d.mp3", (correct) ? @"Correct":@"Incorrect", randNum];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], fileName]];
    
	NSError *error;
	AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];    
    audioPlayer.delegate = self;
    [audioPlayer play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (tries == 2 || isCorrect)
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate finishedTemplate];
    }
    else
        state = kExerciseStateOpen;
}

#pragma mark - Control Methods

- (void)playLecture
{
    if (state == kExerciseStateLocked)
        return;
    
    if (lectureFile != nil)
    {
        [self playVideo:lectureFile];

    }
}

- (void)showAnswer
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate finishedTemplate];
}

#pragma mark - Video Playing

- (void)finishedVideo
{
    [self dismissModalViewControllerAnimated:NO];
    //[self dismissMoviePlayerViewControllerAnimated];
}

- (void)playVideo:(NSString*)videoName
{
    @try {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:videoName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:finalPath])		//Does file exist?
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
            mpviewController = [[SFMovieViewController alloc] 
                                initWithContentURL:[NSURL fileURLWithPath:finalPath]];
            MPMoviePlayerController *mp = [mpviewController moviePlayer];
            mp.scalingMode = MPMovieScalingModeAspectFit;
            mp.controlStyle = MPMovieControlStyleFullscreen;
            //[self presentMoviePlayerViewControllerAnimated:mpviewController];
            [self presentModalViewController:mpviewController animated:NO];
            return;
        }
    }
    @catch (NSException *exception) {
    }
}

- (void)moviePlaybackComplete:(NSNotification *)notification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(moviePlaybackComplete:) object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification
												  object:nil];  
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation: UIStatusBarAnimationNone];
    
    [self finishedVideo];
}

@end
