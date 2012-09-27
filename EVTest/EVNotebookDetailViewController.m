//
//  EVNotebookDetailViewController.m
//  EVTest
//
//  Created by zhengxx on 12-9-25.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import "EVNotebookDetailViewController.h"

@interface EVNotebookDetailViewController ()
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation EVNotebookDetailViewController
@synthesize notebook = _notebook;
@synthesize nameTextField = _nameTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.nameTextField.text = self.notebook.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_nameTextField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNameTextField:nil];
    [super viewDidUnload];
}
- (IBAction)onSaveClicked:(id)sender
{
    self.notebook.name = self.nameTextField.text;
    [[EvernoteNoteStore noteStore] updateNotebook:self.notebook success:^(int32_t ret) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *e) {
        // FIXME:zxx 2012-9-27 Should notify user
        NSLog(@"Cannot save notebook: %@", e);
    }];
}
@end
