//
//  Problem2.m
//  Protractor
//
//  Created by Daniel Ho on 4/30/12.
//

#import "Problem2.h"

@implementation SlotView
@synthesize isOccupied;
@synthesize index;
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        self.isOccupied = NO;
    return self;
}
@end

@implementation Problem2
@synthesize slotArray;
@synthesize draggableArray;
@synthesize slotContainingDraggable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.problemTitle setText:@"Ordering Fractions"];
        [self.problemDesc setText:@"Put the fractions in order by dragging them to the red boxes, then click \"ok\"."];
        [self.answerBox setHidden:YES];
        
        /*
        self.answerBox = [[[UITextField alloc] initWithFrame:CGRectMake(800, 400, 75, 30)] autorelease];
        [answerBox setBackgroundColor:[UIColor whiteColor]];
        [answerBox setKeyboardType:UIKeyboardTypeNumberPad];
        [answerBox setBorderStyle:UITextBorderStyleLine];
        [answerBox setTextAlignment:UITextAlignmentCenter];
        [answerBox setDelegate:self];
        [self.view addSubview:answerBox];
        
        // Answer label
        self.answerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(675, 460, 300, 50)] autorelease];
        [answerLabel setTextColor:[UIColor grayColor]];
        [answerLabel setBackgroundColor:[UIColor clearColor]];
        [answerLabel setFont:[UIFont fontWithName:@"Arial" size:50]];
        [answerLabel setTextAlignment:UITextAlignmentCenter];
        [self.view addSubview:answerLabel];
        */
        
        // Submit Button
        self.submitButton = [[[UIButton alloc] initWithFrame:CGRectMake(500, 480, 75, 30)] autorelease];
        [submitButton setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
        [submitButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [submitButton setTitle:@"Ok" forState:UIControlStateNormal];
        [submitButton setAdjustsImageWhenHighlighted:true];
        [submitButton addTarget:self action:@selector(submitTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:submitButton];

        
        SlotView *slot1 = [[[SlotView alloc] initWithFrame:CGRectMake(250, 350, 100, 100)] autorelease];
        [slot1 setBackgroundColor:[UIColor redColor]];
        [slot1 setIndex:0];
        [self.view addSubview:slot1];
        
        SlotView *slot2 = [[[SlotView alloc] initWithFrame:CGRectMake(400, 350, 100, 100)] autorelease];
        [slot2 setBackgroundColor:[UIColor redColor]];
        [slot2 setIndex:1];
        [self.view addSubview:slot2];
        
        SlotView *slot3 = [[[SlotView alloc] initWithFrame:CGRectMake(550, 350, 100, 100)] autorelease];
        [slot3 setBackgroundColor:[UIColor redColor]];
        [slot3 setIndex:2];
        [self.view addSubview:slot3];
        
        SlotView *slot4 = [[[SlotView alloc] initWithFrame:CGRectMake(700, 350, 100, 100)] autorelease];
        [slot4 setBackgroundColor:[UIColor redColor]];
        [slot4 setIndex:3];
        [self.view addSubview:slot4];
        
        DraggableFraction* draggable1 = [[[DraggableFraction alloc] initWithFrame:CGRectMake(400, 200, 100, 100) withParent:self withOrder:0] autorelease];
        [self.view addSubview:draggable1];
        
        DraggableFraction* draggable2 = [[[DraggableFraction alloc] initWithFrame:CGRectMake(550, 200, 100, 100) withParent:self withOrder:1] autorelease];
        [self.view addSubview:draggable2];
        
        DraggableFraction* draggable3 = [[[DraggableFraction alloc] initWithFrame:CGRectMake(250, 200, 100, 100) withParent:self withOrder:2] autorelease];
        [self.view addSubview:draggable3];
        
        DraggableFraction* draggable4 = [[[DraggableFraction alloc] initWithFrame:CGRectMake(700, 200, 100, 100) withParent:self withOrder:3] autorelease];
        [self.view addSubview:draggable4];
        
        UILongPressGestureRecognizer *longPress1 = [[[UILongPressGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(handleLongPress:)] autorelease];
        longPress1.numberOfTapsRequired = 0;
        longPress1.numberOfTouchesRequired = 1;
        longPress1.minimumPressDuration = 0.05;
        [draggable1 addGestureRecognizer:longPress1];
        UILongPressGestureRecognizer *longPress2 = [[[UILongPressGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(handleLongPress:)] autorelease];
        longPress2.numberOfTapsRequired = 0;
        longPress2.numberOfTouchesRequired = 1;
        longPress2.minimumPressDuration = 0.05;
        [draggable2 addGestureRecognizer:longPress2];
        UILongPressGestureRecognizer *longPress3 = [[[UILongPressGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(handleLongPress:)] autorelease];
        longPress3.numberOfTapsRequired = 0;
        longPress3.numberOfTouchesRequired = 1;
        longPress3.minimumPressDuration = 0.05;
        [draggable3 addGestureRecognizer:longPress3];
        UILongPressGestureRecognizer *longPress4 = [[[UILongPressGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(handleLongPress:)] autorelease];
        longPress4.numberOfTapsRequired = 0;
        longPress4.numberOfTouchesRequired = 1;
        longPress4.minimumPressDuration = 0.05;
        [draggable4 addGestureRecognizer:longPress4];
        
        self.slotArray = [NSArray arrayWithObjects:slot1, slot2, slot3, slot4, nil];
        self.draggableArray = [NSArray arrayWithObjects:draggable1, draggable2, draggable3, draggable4, nil];
        self.slotContainingDraggable = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Dealing with Long Gesture

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{    
    DraggableFraction *fraction = (DraggableFraction*)recognizer.view;
    
    fraction.center = [recognizer locationInView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        SlotView* touchedSlot = [fraction snapToSlot];
        DraggableFraction *temp = [slotContainingDraggable objectAtIndex:touchedSlot.index];    // is this the slot we're already in
        if (touchedSlot && ([temp isKindOfClass:[NSNull class]] || temp == fraction))   // touching a new slot or touching existing slot
        {
            fraction.touchedSlot = touchedSlot;
            touchedSlot.isOccupied = YES;
            [slotContainingDraggable replaceObjectAtIndex:touchedSlot.index withObject:fraction];
        }
        else    // release any slot associated with this draggableFraction
        {
            [fraction releaseSlot];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (![fraction snapToSlot])
        {
            [UIView animateWithDuration:0.2     // slide back to original position
                             animations:^{
                                 fraction.center = fraction.originalCenter;
                             }];
            [fraction releaseSlot];
        }
    }
}

#pragma mark - Answer delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    BOOL ret = [answerBox.text isEqualToString:@"75"];
    
    [self answered:ret forProblem:self];
    
    return YES;
}

-(void)submitTapped
{
    BOOL isCorrect = YES;
    for (UIView *slot in slotArray)
    {
        DraggableFraction* draggable = [draggableArray objectAtIndex:[slotArray indexOfObject:slot]];
        if (![draggable isTouchingSlot:slot])
        {
            isCorrect = NO;
            break;
        }
    }
    [self answered:isCorrect forProblem:self];
}

@end

@implementation DraggableFraction
@synthesize parent;
@synthesize originalCenter;
@synthesize order;
@synthesize touchedSlot;

- (id)initWithFrame:(CGRect)frame withParent:(Problem2*)problem withOrder:(int)orderPos
{
    self = [super init];
    if (self)
    {
        [self setFrame:frame];
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self setUserInteractionEnabled:YES];
        self.parent = problem;
        self.originalCenter = self.center;
        order = orderPos;
        
        // 10,10,50,30
        UILabel* orderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(25, 25, 50, 50)] autorelease];
        
        [orderLabel setFont:[UIFont fontWithName:@"Arial" size:32.0f]];
        [orderLabel setTextAlignment: UITextAlignmentCenter];
        [orderLabel setText:[NSString stringWithFormat:@"%d/4", orderPos]];
        [orderLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:orderLabel];
    }
    return self;
}

#pragma mark - Slot Handling

- (SlotView*)touchedSlotPosition
{
    for (SlotView* slot in self.parent.slotArray)
    {
        DraggableFraction *temp = [parent.slotContainingDraggable objectAtIndex:slot.index];
        
        if (temp == self || !slot.isOccupied)
        {
            CGRect imageRect = [self convertRect:self.frame toView:[self superview]];
            CGRect targetRect = [slot convertRect:slot.frame toView:[self superview]];
            if (CGRectIntersectsRect(imageRect, targetRect))
                return slot;
        }
    }
    return nil;
}

- (BOOL)isTouchingSlot:(UIView*)slot
{
    CGRect imageRect = [self convertRect:self.frame toView:[self superview]];
    CGRect targetRect = [slot convertRect:slot.frame toView:[self superview]];
    return CGRectIntersectsRect(imageRect, targetRect);
}

-(SlotView*)snapToSlot
{
    SlotView* slot = [self touchedSlotPosition];
    if (slot)
    {
        self.center = slot.center;
        return slot;
    }
    return nil;
}

- (void)releaseSlot
{
    if (self.touchedSlot)
    {
        touchedSlot.isOccupied = NO;
        [parent.slotContainingDraggable replaceObjectAtIndex:touchedSlot.index withObject:[NSNull null]];
        self.touchedSlot = nil;
    }
}

#pragma mark - Touch Delegate

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
}

@end