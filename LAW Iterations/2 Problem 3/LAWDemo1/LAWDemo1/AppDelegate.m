//
//  AppDelegate.m
//  LAWDemo1
//
//  Created by Daniel Ho on 5/21/12.
//

#import "AppDelegate.h"
#import "Dispatcher.h"
#import "SelectionMenu.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize filenameArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect windowRect = [[UIScreen mainScreen] bounds];
    self.window = [[[UIWindow alloc] initWithFrame:windowRect] autorelease];
    // Override point for customization after application launch.
    self.window = [[[UIWindow alloc] initWithFrame:windowRect] autorelease];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    self.filenameArray = [NSMutableArray arrayWithObjects:@"4.A.20.01.xml", @"4.A.20.02.xml", @"4.A.23.01.xml", @"4.A.23.02.xml", @"Identifying Nouns", @"Leading Sentences", @"2.A.10.01.xml", @"2.A.10.02.xml", @"2.A.10.03.xml", @"2.A.10.04.xml", @"Sentence Composition", @"In Order", @"6.P.50.01.xml",@"6.P.50.02.xml",@"6.P.50.03.xml",@"6.P.50.04.xml", @"Random", nil];
    
    maskLayer = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [maskLayer setBackgroundColor:[UIColor blackColor]];
    [self.window addSubview:maskLayer];
    
    SelectionMenu* selectionMenu = [[SelectionMenu alloc] initWithFileArray:filenameArray];
    [self.window addSubview:selectionMenu.view];
    selection = selectionMenu;
//    
//    [self showNextTemplate];
    
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

-(void)transitionToView:(UIView*)viewToSpin
{
    [maskLayer setAlpha:1.f];
    [self.window bringSubviewToFront:maskLayer];
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.5f];
    [maskLayer setAlpha:0.f];
    [UIView commitAnimations];
    
    CABasicAnimation* animation = nil;
    
    float rand = arc4random_uniform(3);
    if (rand == 0)
    {
        animation = [CABasicAnimation
                     animationWithKeyPath:@"transform.rotation"];
        animation.toValue = [NSNumber numberWithFloat:2*M_PI];
        animation.duration = .5;
        [viewToSpin.layer addAnimation:animation forKey:@"transitionAnimation"];
    }
    else if (rand == 1)
    {
        float originalX = viewToSpin.layer.position.x;
        animation = [CABasicAnimation
                     animationWithKeyPath:@"position.x"];
        animation.fromValue = [NSNumber numberWithFloat:originalX - 700];
        animation.toValue = [NSNumber numberWithFloat:originalX];
        animation.duration = .5;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [viewToSpin.layer addAnimation:animation forKey:@"transitionAnimation"];
        
    }
    else if (rand == 2)
    {
        //            viewToSpin.layer.transform = CGAffineTransformMakeScale(.5f,.5f);
        //            animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //            animation.fillMode = kCAFillModeForwards; 
        //            animation.removedOnCompletion = NO;
        //            animation.toValue = CGAffineTransformMakeScale(1,1);
        //            animation.duration = .5f;
    }
}

-(void)finishedTemplate
{
    [self.window bringSubviewToFront:maskLayer];
    [UIView beginAnimations:@"fadeOut" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showNextTemplate)];
    //[UIView setAnimationDidStopSelector:@selector(showSelectionMenu)];
    [maskLayer setAlpha:1.f];
    [UIView commitAnimations];
}

-(void)loadFile:(NSString*)fileName
{
    Dispatcher *dispatcher = [Dispatcher dispatcher];
    CXMLDocument *doc = [dispatcher loadFile:fileName];
    TemplateWindow *template = [dispatcher getTemplateWindowForDocument:doc];
    
    [selection.view removeFromSuperview];
    [self.window addSubview:template.view];
    currentTemplate = template;
    
    [self transitionToView:template.view];
}

-(void)loadFiles:(NSMutableArray*)files
{
    self.filenameArray = files;
    
    [selection.view removeFromSuperview];
    [self showNextTemplate];
}

-(void)showSelectionMenu
{
    [currentTemplate.view removeFromSuperview];
    [self.window addSubview:selection.view];
    
    [self transitionToView:selection.view];
    
    if (currentTemplate)
    {
        [currentTemplate release];
        currentTemplate = nil;
    }
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
        if (currentTemplate)
        {
            [currentTemplate release];
            currentTemplate = nil;
        }
        currentTemplate = template;
        [self.window addSubview:template.view];

        [filenameArray removeObjectAtIndex:0];

        [self transitionToView:template.view];        
    }
    else
        [self showSelectionMenu];
}

@end
