//
//  EVNotebookDetailViewController.h
//  EVTest
//
//  Created by zhengxx on 12-9-25.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvernoteSDK.h"

@interface EVNotebookDetailViewController : UIViewController
@property (nonatomic, retain) EDAMNotebook *notebook;
@end
