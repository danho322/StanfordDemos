//
//  TemplateID1.h
//  LAWDemo1
//
//  Created by Daniel Ho on 5/23/12.
//

#import "TemplateWindow.h"

@interface TemplateID1 : TemplateWindow
{
    UILabel *feedbackLabel;
    NSMutableArray *nounLabels;
}

@property (nonatomic, retain) NSMutableArray *nounLabels;

- (id)initWithDictionary:(NSMutableDictionary*)templateDict;
@end
