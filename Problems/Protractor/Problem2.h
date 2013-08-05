//
//  Problem2.h
//  Protractor
//
//  Created by Daniel Ho on 4/30/12.
//

#import <UIKit/UIKit.h>
#import "ProblemClass.h"

@interface SlotView : UIView {
    BOOL isOccupied;
    int index;
}
@property BOOL isOccupied;
@property int index;
@end

@interface Problem2 : ProblemClass {
    NSArray* slotArray;
    NSArray* draggableArray;
    NSMutableArray* slotContainingDraggable;
}

@property (nonatomic, retain) NSArray* slotArray;
@property (nonatomic, retain) NSArray* draggableArray;
@property (nonatomic, retain) NSMutableArray* slotContainingDraggable;

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer;

@end

@interface DraggableFraction : DraggableImage {
    Problem2 *parent;
    CGPoint originalCenter;
    int order;
    SlotView *touchedSlot;
}

@property (nonatomic, assign) Problem2 *parent;
@property CGPoint originalCenter;
@property int order;
@property (nonatomic, retain) SlotView *touchedSlot;

- (id)initWithFrame:(CGRect)frame withParent:(Problem2*)problem withOrder:(int)order;
- (SlotView*)touchedSlotPosition;
- (BOOL)isTouchingSlot:(UIView*)slot;
- (SlotView*)snapToSlot;
- (void)releaseSlot;
@end
