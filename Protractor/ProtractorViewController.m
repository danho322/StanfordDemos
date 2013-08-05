//
//  ProtractorViewController.m
//  Protractor
//
//  Created by Daniel Ho on 4/30/12.
//

#import "ProtractorViewController.h"
#import "Problem0.h"
#import "Problem1.h"
#import "Problem2.h"

@implementation ProtractorViewController

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    Problem2* problem2 = [[Problem2 alloc] initWithNibName:nil bundle:nil];
    [self.view addSubview:problem2.view];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return YES;
    return NO;
}

@end
