//
//  ProtractorAppDelegate.h
//  Protractor
//
//  Created by Daniel Ho on 4/30/12.
//

#import <UIKit/UIKit.h>

@class ProtractorViewController;

@interface ProtractorAppDelegate : NSObject <UIApplicationDelegate> {
    ProtractorViewController *viewController;
    NSMutableArray* problemArray;
    UIView *maskLayer;
}

@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, retain) ProtractorViewController *viewController;
@property (nonatomic, retain) NSMutableArray* problemArray;
@property (nonatomic, retain) UIView *maskLayer;
- (void)showNextProblem;

@end
