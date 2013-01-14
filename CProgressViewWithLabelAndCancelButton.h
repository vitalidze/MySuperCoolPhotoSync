//
//  CProgressViewWithLabelAndCancelButton.h
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 13/1/13.
//  Copyright (c) 2013 litvak.su. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CProgressViewWithLabelAndCancelButton : NSObject {
    UIProgressView* progressView;
    UILabel* label;
    UIBarButtonItem* btnStop;
}
@property NSArray* barItems;


- (void) setProgress: (float) progress;
- (void) setText: (NSString*) text;
- (void) setStopTarget: (id) target action: (SEL) action;
@end
