//
//  EVViewController.m
//  EVTest
//
//  Created by zhengxx on 12-9-25.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import "EVViewController.h"
#import "EvernoteSDK.h"

@interface EVViewController ()

@end

@implementation EVViewController
- (IBAction)onLoginClicked:(id)sender
{
    [self login];
}

- (void)login
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    [[EvernoteSession sharedSession] authenticateWithViewController:self completionHandler:^(NSError *error) {
        if (error || !session.isAuthenticated) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" 
                                                             message:@"Could not authenticate"
                                                            delegate:nil 
                                                   cancelButtonTitle:@"OK" 
                                                   otherButtonTitles:nil] autorelease];
            [alert show];
        } else {
            NSLog(@"authenticated! noteStoreUrl:%@ webApiUrlPrefix:%@", session.noteStoreUrl, session.webApiUrlPrefix);
            [self performSegueWithIdentifier:@"loginToNotebookList" sender:self];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self login];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
