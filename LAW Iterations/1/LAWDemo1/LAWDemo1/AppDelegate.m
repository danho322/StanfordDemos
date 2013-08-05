//
//  AppDelegate.m
//  LAWDemo1
//
//  Created by Daniel Ho on 5/21/12.
//

#import "AppDelegate.h"
#import "Dispatcher.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize filenameArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    self.filenameArray = [NSMutableArray arrayWithObjects:@"2.A.10.01.xml", @"2.A.10.02.xml", @"2.A.10.03.xml", @"2.A.10.04.xml",@"6.P.50.01.xml",@"6.P.50.02.xml",@"6.P.50.03.xml",@"6.P.50.04.xml", nil];
    
    maskLayer = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [maskLayer setBackgroundColor:[UIColor blackColor]];
    [self.window addSubview:maskLayer];
    
    [self showNextTemplate];
    //[self playVideo:@"2.A.Nouns.mp4"];
    
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
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    exit(EXIT_SUCCESS);
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

#pragma mark - Managing the templates

-(void)finishedTemplate
{
    [self.window bringSubviewToFront:maskLayer];
    [UIView beginAnimations:@"fadeOut" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showNextTemplate)];
    [maskLayer setAlpha:1.f];
    [UIView commitAnimations];
}

-(void)showNextTemplate
{
    if (currentTemplate)
        [currentTemplate.view removeFromSuperview];
    
    Dispatcher *dispatcher = [Dispatcher dispatcher];
    if ([filenameArray count] > 0)
    {
        CXMLDocument *doc = [dispatcher loadFile:[filenameArray objectAtIndex:0]];
        TemplateWindow *template = [dispatcher getTemplateWindowForDocument:doc];
        currentTemplate = template;
        [self.window addSubview:template.view];
        
        [self.window bringSubviewToFront:maskLayer];
        [UIView beginAnimations:@"fadeIn" context:nil];
        [UIView setAnimationDuration:0.5f];
        [maskLayer setAlpha:0.f];
        [UIView commitAnimations];
        
        [filenameArray removeObjectAtIndex:0];
        
        UIView *viewToSpin = template.view;    
        CABasicAnimation* spinAnimation1 = [CABasicAnimation
                                           animationWithKeyPath:@"transform.rotation"];
        spinAnimation1.toValue = [NSNumber numberWithFloat:2*M_PI];
        spinAnimation1.duration = .5;
        [viewToSpin.layer addAnimation:spinAnimation1 forKey:@"spinAnimation1"];
        
    }
    else
        exit(EXIT_SUCCESS);
}

@end
