//
//  CProgressViewWithLabelAndCancelButton.m
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 13/1/13.
//  Copyright (c) 2013 litvak.su. All rights reserved.
//

#import "CProgressViewWithLabelAndCancelButton.h"

@implementation CProgressViewWithLabelAndCancelButton

- (id)init
{
    self = [super init];
        
    if (self) {
        CGFloat progressWidth = 260.0;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 2.0, progressWidth, 16.0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor darkGrayColor];
        
        progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progressView.frame = CGRectMake(0.0, 20.0, progressWidth, 12.0);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, progressWidth, 32.0)];
        [view addSubview:label];
        [view addSubview:progressView];
        
        btnStop = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:nil action:nil];
        
        self->_barItems = @[btnStop, [[UIBarButtonItem alloc] initWithCustomView:view], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
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

-(void) setProgress: (float)progress {
    [progressView setProgress: progress animated: YES];
}

-(void) setText:(NSString *)text {
    [label setText: text];
}

-(void) setStopTarget:(id)target action:(SEL)action {
    [btnStop setTarget:target];
    [btnStop setAction:action];
}

@end
