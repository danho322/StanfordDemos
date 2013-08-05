//
//  Template32.h
//  LAWDemo1
//
//  Created by Daniel Ho on 5/24/12.
//

#import "TemplateWindow.h"

@interface Template32 : TemplateWindow
{
    UILabel *leadSentence;
    UILabel *feedbackLabel;
    
    NSMutableArray *sentenceLabels;
}

@property (nonatomic, retain) NSMutableArray *sentenceLabels;

- (id)initWithDictionary:(NSMutableDictionary*)templateDict;
-(CGSize)setQuestionParagraphWithSentence:(NSString*)sentence;
@end
