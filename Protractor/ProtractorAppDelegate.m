//
//  ProtractorAppDelegate.m
//  Protractor
//
//  Created by Daniel Ho on 4/30/12.
//

#import "ProtractorAppDelegate.h"
#import "ProtractorViewController.h"
#import "Problem0.h"
#import "Problem1.h"
#import "Problem2.h"


#define problemViewTag 20
@implementation ProtractorAppDelegate


@synthesize window=_window;
@synthesize viewController;
@synthesize problemArray;
@synthesize maskLayer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup the array of problems
    
    Problem0* problem0 = [[Problem0 alloc] initWithNibName:nil bundle:nil];
    Problem1* problem1 = [[Problem1 alloc] initWithNibName:nil bundle:nil];
    Problem2* problem2 = [[Problem2 alloc] initWithNibName:nil bundle:nil];
    self.problemArray = [[[NSMutableArray alloc] initWithObjects: problem1, problem2, nil] autorelease];  //problem0 at the first would add that exercise but difficulties ensue
    
    // Override point for customization after application launch.
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    self.maskLayer = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [maskLayer setBackgroundColor:[UIColor blackColor]];
    
    [self.window addSubview:((UIViewController*)[problemArray objectAtIndex:0]).view];
    [((UIViewController*)[problemArray objectAtIndex:0]).view setTag:problemViewTag];
    
    [self.window addSubview:self.maskLayer];
    
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.5f];
    [self.maskLayer setAlpha:0.f];
    [UIView commitAnimations];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Restart the demo when reopening - so kill the app
    exit(0);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    self.problemArray = nil;
    self.maskLayer = nil;
    [super dealloc];
}

#pragma mark - 
#pragma mark Managing the problems

- (void)showNextProblem
{
    [self.window bringSubviewToFront:maskLayer];
    [UIView beginAnimations:@"fadeOut" context:nil];
    [UIView setAnimationDuration:0.5f];
    [self.maskLayer setAlpha:1.f];
    [UIView commitAnimations];
    
    if ([self.problemArray count] > 1)
    {
        [problemArray removeObjectAtIndex:0];
    
        UIView *view = [self.window viewWithTag:problemViewTag];
        
        [UIView animateWithDuration:0.5
                              delay:0.0 
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                                     [view removeFromSuperview];
                                 
                                 [self.window addSubview:((UIViewController*)[problemArray objectAtIndex:0]).view];
                                 [self.window bringSubviewToFront:maskLayer];
                                [maskLayer setAlpha:0];
                             }
                         completion:NULL];
        

    }
    else
        exit(0);
}

@end
