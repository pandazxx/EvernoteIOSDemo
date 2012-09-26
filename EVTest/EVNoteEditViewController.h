//
//  EVNoteEditViewController.h
//  EVTest
//
//  Created by zhengxx on 12-9-26.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvernoteSDK.h"

@class EVNoteEditViewController;
@protocol EVNoteEditViewControllerDelegate <NSObject>
- (void)editViewController:(EVNoteEditViewController *)controller
                  saveNote:(EDAMNote *)note;
@end

@interface EVNoteEditViewController : UIViewController
@property (nonatomic, retain) EDAMNote *note;
@property (nonatomic, assign) id <EVNoteEditViewControllerDelegate> delegate;
@end
