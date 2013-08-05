//
//  TemplateControls.m
//  LAWDemo1
//
//  Created by Daniel Ho on 5/31/12.
//

#import "TemplateControls.h"
#import "TemplateWindow.h"

@implementation TemplateControls
@synthesize parent;

- (id)initWithFrame:(CGRect)frame andParent:(TemplateWindow*)parentWindow
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.parent = parentWindow;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIButton *showAnswerButton = [[[UIButton alloc] initWithFrame:CGRectMake(10, 10, 150, 30)] autorelease];
        [showAnswerButton addTarget:parent action:@selector(showAnswer) forControlEvents:UIControlEventTouchUpInside];
        [showAnswerButton setBackgroundColor:[UIColor lightGrayColor]];
        [showAnswerButton setTitle:@"Show Answer" forState:UIControlStateNormal];
        [showAnswerButton.layer setCornerRadius:5.f];
        [showAnswerButton.layer setMasksToBounds:YES];
        [self addSubview:showAnswerButton];
        
        UIButton *playButton = [[[UIButton alloc] initWithFrame:CGRectMake(200, 10, 110, 30)] autorelease];
        [playButton addTarget:parent action:@selector(playLecture) forControlEvents:UIControlEventTouchUpInside];
        [playButton setBackgroundColor:[UIColor lightGrayColor]];
        [playButton setTitle:@"Play lecture" forState:UIControlStateNormal];
        [playButton.layer setCornerRadius:5.f];
        [playButton.layer setMasksToBounds:YES];
        [self addSubview:playButton];
        
        UIButton *glossaryButton = [[[UIButton alloc] initWithFrame:CGRectMake(350, 10, 110, 30)] autorelease];
        [glossaryButton setBackgroundColor:[UIColor lightGrayColor]];
        [glossaryButton setTitle:@"Glossary" forState:UIControlStateNormal];
        [glossaryButton.layer setCornerRadius:5.f];
        [glossaryButton.layer setMasksToBounds:YES];
        [self addSubview:glossaryButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
