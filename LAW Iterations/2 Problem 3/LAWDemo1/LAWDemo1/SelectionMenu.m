//
//  SelectionMenu.m
//  LAWDemo1
//
//  Created by Daniel Ho on 6/19/12.
//

#import "SelectionMenu.h"
#import "AppDelegate.h"

@implementation SelectionMenu

- (id)initWithFileArray:(NSArray*)files
{
    self = [super initWithDictionary:nil];
    if (self) {
        
        [self.problemTitle setText:@"Stanford Language Arts and Writing"];
        
        [self.problemDesc setText:@"Please select an exercise"];
        [problemDesc setTextAlignment:UITextAlignmentLeft];
        
        [submitButton setTitle:@"Exit" forState:UIControlStateNormal];
        
        UIImage* icon = [UIImage imageNamed:@"LA&Wipadicon1.png"];
        UIImageView* iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(850, 20, icon.size.width, icon.size.height)] autorelease];
        [iconView setImage:icon];
        [self.view addSubview:iconView];
        
        int i = 0;
        for (NSString* fileName in files)
        {
            int x = 150 + 250*(i/6);
            int y = 220 + 70*(i%6);
            
            UIButton* fileButton = [[[UIButton alloc] initWithFrame:CGRectMake(x, y, 200, 50)] autorelease];
            [fileButton setTitle:fileName forState:UIControlStateNormal];
            [fileButton setBackgroundColor:[UIColor grayColor]];
            [fileButton.layer setCornerRadius:5.f];
            [fileButton.layer setMasksToBounds:YES];
            [fileButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:fileButton];
            
            i++;
        }
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

#pragma mark - Button Selection

-(NSMutableArray*)getFilesForButton:(NSString*)buttonText
{
    NSMutableArray* files;

    if ([buttonText isEqualToString:@"Identifying Nouns"])
    {
        files = [NSMutableArray arrayWithObjects: @"2.A.10.01.xml", @"2.A.10.02.xml", @"2.A.10.03.xml", @"2.A.10.04.xml", nil];
    }
    else if ([buttonText isEqualToString:@"Leading Sentences"])
    {
        files = [NSMutableArray arrayWithObjects:@"6.P.50.01.xml",@"6.P.50.02.xml",@"6.P.50.03.xml",@"6.P.50.04.xml", nil];
    }
    else if ([buttonText isEqualToString:@"Sentence Composition"])
    {
        files = [NSMutableArray arrayWithObjects:@"4.A.20.01.xml", @"4.A.20.02.xml", @"4.A.23.01.xml", @"4.A.23.02.xml", nil];
    }
    else if ([buttonText isEqualToString:@"In Order"])
    {
        files = [NSMutableArray arrayWithObjects:@"2.A.10.01.xml", @"2.A.10.02.xml", @"2.A.10.03.xml", @"2.A.10.04.xml", @"4.A.20.01.xml", @"4.A.20.02.xml", @"4.A.23.01.xml", @"4.A.23.02.xml", @"6.P.50.01.xml",@"6.P.50.02.xml",@"6.P.50.03.xml",@"6.P.50.04.xml", nil];
    }
    else if ([buttonText isEqualToString:@"Random"])
    {
        NSMutableArray* temp = [NSMutableArray arrayWithObjects:@"2.A.10.01.xml", @"2.A.10.02.xml", @"2.A.10.03.xml", @"2.A.10.04.xml", @"4.A.20.01.xml", @"4.A.20.02.xml", @"4.A.23.01.xml", @"4.A.23.02.xml", @"6.P.50.01.xml",@"6.P.50.02.xml",@"6.P.50.03.xml",@"6.P.50.04.xml", nil];
        
        files = [NSMutableArray arrayWithCapacity:[temp count]];
        
        for (id anObject in temp)
        {
            NSUInteger randomPos = arc4random()%([files count]+1);
            [files insertObject:anObject atIndex:randomPos];
        }
    }
    else
    {
        files = [NSMutableArray arrayWithObject:buttonText];
    }
    
    return files;
}

#pragma mark - Button Delegate

-(void)buttonTapped:(id)sender
{
    UIButton* button = (UIButton*)sender;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate loadFile:button.titleLabel.text];
    [appDelegate loadFiles:[self getFilesForButton:button.titleLabel.text]];
}

-(void)submitTapped
{
    exit(EXIT_SUCCESS);
}

@end
