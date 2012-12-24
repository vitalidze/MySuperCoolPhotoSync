//
//  IProgressListener.h
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 25/12/12.
//  Copyright (c) 2012 litvak.su. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IProgressListener <NSObject>
- (void) progressChanged: (NSNumber*) progress;
@end
