//
//  CViewController.h
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 18/11/12.
//  Copyright (c) 2012 litvak.su. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *fldServer;
- (IBAction)doSync:(id)sender;

@end
