//
//  ProblemClass.h
//  Protractor
//
//  Created by Daniel Ho on 4/30/12.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface DraggableImage : UIImageView {
    CGPoint currentPoint;
}
@end

@interface ProblemClass : UIViewController <UITextFieldDelegate> {
    UILabel* problemTitle;
    UILabel* problemDesc;
    UITextField* answerBox;
    UILabel* answerLabel;
    UIButton* submitButton;
    UILabel* questionLabel;
    
    UIView* problemLayer;
}

@property (nonatomic, retain) UILabel* problemTitle;
@property (nonatomic, retain) UILabel* problemDesc;
@property (nonatomic, retain) UITextField* answerBox;
@property (nonatomic, retain) UILabel* answerLabel;
@property (nonatomic, retain) UIView* problemLayer;
@property (nonatomic, retain) UIButton* submitButton;
@property (nonatomic, retain) UILabel* questionLabel;

-(void)answered:(BOOL)isCorrect forProblem:(ProblemClass*)problem;
-(void)submitTapped;
@end
