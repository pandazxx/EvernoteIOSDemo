//
//  EVNoteEditViewController.m
//  EVTest
//
//  Created by zhengxx on 12-9-26.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import "EVNoteEditViewController.h"
#import "EvernoteSDK.h"
#import "EDAMNote+RawTextContent.h"
#import "EVPlainENMLParser.h"

@interface EVNoteEditViewController ()
@property (retain, nonatomic) IBOutlet UITextField *titleTextField;
@property (retain, nonatomic) IBOutlet UITextField *tagsTextField;
@property (retain, nonatomic) IBOutlet UITextView *contentTextView;
@end

@implementation EVNoteEditViewController
@synthesize note = _note;
@synthesize titleTextField = _titleTextField;
@synthesize tagsTextField = _tagsTextField;
@synthesize contentTextView = _contentTextView;

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_titleTextField release];
    [_tagsTextField release];
    [_contentTextView release];
    [_note release];
    [super dealloc];
}

#pragma mark - Getter/Setter


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self displayNoteInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleTextField:nil];
    [self setTagsTextField:nil];
    [self setContentTextView:nil];
    [super viewDidUnload];
}


- (IBAction)onSaveButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(editViewController:saveNote:)])
    {
        [self updateNoteInfo];
        [self.delegate editViewController:self saveNote:self.note];
    }
}

#pragma mark - Private Methods
- (void)displayNoteInfo
{
    self.titleTextField.text = self.note.title;
    EVPlainENMLParser *parser = [[EVPlainENMLParser alloc] initWithXMLContent:self.note.content];
    [parser parse];
    self.contentTextView.text = parser.plainTextContent;
    [parser release];
}

- (void)updateNoteInfo
{
    self.note.title = self.titleTextField.text;
    [self.note setRawTextContent:self.contentTextView.text];
//    self.note.content = self.contentTextView.text;
}
@end
