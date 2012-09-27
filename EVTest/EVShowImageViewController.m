//
//  EVShowImageViewController.m
//  EVTest
//
//  Created by zhengxx on 12-9-27.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import "EVShowImageViewController.h"

@interface EVShowImageViewController ()
@property (retain, nonatomic) IBOutlet UIImageView *mainImageView;

@end

@implementation EVShowImageViewController
@synthesize image = _image;
@synthesize mainImageView = _mainImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_image release];

    [_mainImageView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mainImageView.image = self.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMainImageView:nil];
    [super viewDidUnload];
}
@end
