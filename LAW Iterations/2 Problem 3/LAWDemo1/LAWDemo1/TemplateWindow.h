//
//  TemplateWindow.h
//  LAWDemo1
//
//  Created by Daniel Ho on 5/23/12.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TemplateControls.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SFMovieViewController : MPMoviePlayerViewController {}
@end

enum kExerciseState
{
    kExerciseStateOpen = 0,
    kExerciseStateLocked,
} kExerciseState;
 
@interface TemplateWindow : UIViewController <AVAudioPlayerDelegate>
{
    NSString* lectureFile;
    UILabel* problemID;
    UILabel* problemTitle;
    UILabel* problemDesc;
    UIButton* submitButton;
    NSDictionary* templateDict;
    
    BOOL hasAnswered;
    BOOL isCorrect;
    int tries;
    int state;
    
    MPMoviePlayerViewController* mpviewController;
}

@property (nonatomic, retain) UILabel* problemID;
@property (nonatomic, retain) UILabel* problemTitle;
@property (nonatomic, retain) UILabel* problemDesc;
@property (nonatomic, retain) UIButton* submitButton;
@property (nonatomic, retain) NSDictionary* templateDict;

- (id)initWithDictionary:(NSMutableDictionary*)templateDict;
-(void)submitTapped;
-(NSString*)getContentsOfFile:(NSString*)fileName;
-(int)constrainString:(NSString*)string withFontSize:(int)fontSize toFont:(NSString*)fontName toSize:(CGSize)textSize;
-(void)playAudio:(BOOL)correct;

- (void)playVideo:(NSString*)videoName;
@end
