//
//  AppDelegate.h
//  LAWDemo1
//
//  Created by Daniel Ho on 5/21/12.
//

#import <UIKit/UIKit.h>
#import "TemplateWindow.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableArray *filenameArray;
    UIView *maskLayer;
    TemplateWindow *currentTemplate;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSMutableArray *filenameArray;

-(void)finishedTemplate;
-(void)showNextTemplate;



@end
