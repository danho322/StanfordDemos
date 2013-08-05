//
//  Problem1.m
//  Protractor
//
//  Created by Daniel Ho on 4/30/12.
//

#import "Problem1.h"

@implementation DrawableView

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0f);
    UIColor *color = [UIColor blueColor];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextMoveToPoint(context, 140.f, 0.f);
    CGContextAddLineToPoint(context, 91.f, 170.f);  // was 100, 150
    CGContextAddLineToPoint(context, 280.f, 170.f);
    CGContextStrokePath(context);
    [color release];
}

@end


@implementation Problem1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.problemTitle setText:@"Measuring Angles 9"];
        [self.problemDesc setText:@"Move the protractor to measure the angle to the nearest 5 degrees."];
        
        DrawableView* angleView = [[[DrawableView alloc] initWithFrame:CGRectMake(400, 200, 400, 230)] autorelease];
        [angleView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:angleView];
        
        DraggableImage* protractor = [[[DraggableImage alloc] initWithImage:[UIImage imageNamed:@"protractor.png"]] autorelease];
        protractor.center = CGPointMake(250, 400);
        protractor.userInteractionEnabled = TRUE;
        [self.view addSubview:protractor];
        
        
        self.answerBox = [[[UITextField alloc] initWithFrame:CGRectMake(750, 350, 60, 40)] autorelease];
        [answerBox setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
        [answerBox setKeyboardType:UIKeyboardTypeNumberPad];
        [answerBox setBorderStyle:UITextBorderStyleLine];
        [answerBox setFont:[UIFont systemFontOfSize:32]];
        [answerBox setTextAlignment:UITextAlignmentCenter];
        [answerBox setDelegate:self];
        [self.view addSubview:answerBox];
        
        /*
        // Answer label
        self.answerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(675, 460, 300, 50)] autorelease];
        [answerLabel setTextColor:[UIColor grayColor]];
        [answerLabel setBackgroundColor:[UIColor clearColor]];
        [answerLabel setFont:[UIFont fontWithName:@"Arial" size:50]];
        [answerLabel setTextAlignment:UITextAlignmentCenter];
        [self.view addSubview:answerLabel];
        */

        /*
        // Submit Button
        self.submitButton = [[[UIButton alloc] initWithFrame:CGRectMake(800, 480, 75, 30)] autorelease];
        [submitButton setBackgroundColor:[UIColor grayColor]];
        [submitButton setTitle:@"Ok" forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(submitTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:submitButton];
        */
    }
    return self;
}

- (void)dealloc
{
    
    self.answerBox = nil;
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

-(BOOL)checkAnswer
{
    BOOL ret = [answerBox.text isEqualToString:@"75"];
    
    return ret;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self answered:[self checkAnswer] forProblem:self];
    return YES;
}

-(void)submitTapped
{   
    [self answered:[self checkAnswer] forProblem:self];
}

@end
