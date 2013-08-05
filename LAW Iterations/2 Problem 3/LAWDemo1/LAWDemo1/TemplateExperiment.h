//
//  TemplateExpirement.h
//  LAWDemo1
//
//  Created by Daniel Ho on 6/4/12.
//

#import "TemplateWindow.h"
#import "DraggableView.h"

@interface TemplateExperiment : TemplateWindow
{
    NSMutableArray* wordViews;
    UILabel* feedbackLabel;
    NSMutableDictionary* correctStrings;
    NSMutableDictionary* incorrectStrings;
    
    DraggableView* draggableWord;
}

@property (nonatomic, retain) NSMutableDictionary* correctStrings;
@property (nonatomic, retain) NSMutableDictionary* incorrectStrings;

- (id)initWithDictionary:(NSMutableDictionary*)templateDict;
-(void)generateCorrectAndIncorrectListsFromString:(NSString*)parser;
-(NSMutableDictionary*)getWordListDictionaryForValue:(NSString*)wordListName;
-(void)buildWordListsWithDictionary:(NSDictionary*)wordListDict atY:(float)y;
-(float)buildListWithTitle:(NSString*)title andWords:(NSArray*)words atPoint:(CGPoint)coords;
-(BOOL)reorderWordsWithMovedWord:(DraggableView*)movedWord;
-(void)removeWord:(DraggableView*)word;
-(BOOL)wordOutOfBounds:(DraggableView*)word;
-(void)redrawWords;

@end

@interface DraggableWord : DraggableView 
{
    UILabel* label;
    NSString* text;
    CGPoint originalCenter;
    TemplateExperiment* parent;
}
@property (nonatomic, assign) UILabel* label;
@property (nonatomic, assign) NSString* text;
@end
