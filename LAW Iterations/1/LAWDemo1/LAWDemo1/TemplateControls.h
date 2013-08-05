//
//  TemplateControls.h
//  LAWDemo1
//
//  Created by Daniel Ho on 5/31/12.
//

#import <UIKit/UIKit.h>

@interface TemplateControls : UIView
{
    id parent;
}

@property (nonatomic, retain) id parent;

- (id)initWithFrame:(CGRect)frame andParent:(id)parentWindow;

@end
