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
#import "EVTagParser.h"
#import "NSData+MD5.h"
#import "EVShowImageViewController.h"

@interface EVNoteEditViewController ()
@property (retain, nonatomic) IBOutlet UITextField *titleTextField;
@property (retain, nonatomic) IBOutlet UITextField *tagsTextField;
@property (retain, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic, retain) EDAMNote *note;
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
- (void)setNoteGUID:(NSString *)guid
{
    if (guid)
    {
        [[EvernoteNoteStore noteStore] getNoteWithGuid:guid
                                           withContent:YES
                                     withResourcesData:YES
                              withResourcesRecognition:YES
                            withResourcesAlternateData:YES
                                               success:^(EDAMNote *note) {
                                                   self.note = note;
                                                   [[EvernoteNoteStore noteStore] getNoteTagNamesWithGuid:self.note.guid
                                                                                                  success:^(NSArray *tagNames) {
                                                                                                      self.note.tagNames = tagNames;
                                                                                                      [self displayNoteInfo];
                                                                                                  }
                                                                                                  failure:^(NSError *e) {
                                                                                                      // FIXME:zxx 2012-9-27 Should notify user
                                                                                                      NSLog(@"Cannot get note tagnames:%@", e);
                                                                                                  }];
                                               }
                                               failure:^(NSError *e) {
                                                   // FIXME:zxx 2012-9-27 Should notify user
                                                   NSLog(@"Cannot get note detail:%@", e);
                                               }];
    }
    else
    {
        self.note = [[[EDAMNote alloc] init] autorelease];
        [self displayNoteInfo];
    }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![segue.destinationViewController isKindOfClass:[EVShowImageViewController class]])
    {
        return;
    }

    if ([segue.identifier isEqualToString:@"showImage"])
    {
        UIImage *ret = nil;
        for (EDAMResource *resource in self.note.resources)
        {
            if ([resource.mime isEqualToString:@"image/png"])
            {
                ret = [UIImage imageWithData:resource.data.body];
            }
        }

        [segue.destinationViewController setImage:ret];
    }
    else if ([segue.identifier isEqualToString:@"showImageViaHTTP"])
    {
        UIImage *ret = nil;

        for (EDAMResource *resource in self.note.resources)
        {
            if ([resource.mime isEqualToString:@"image/png"])
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@res/%@", [[EvernoteSession sharedSession] webApiUrlPrefix], resource.guid]];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

                request.HTTPMethod = @"POST";
                [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

                request.HTTPBody = [[[NSString stringWithFormat:@"auth=%@", [EvernoteSession sharedSession].authenticationToken] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];

                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *responseBody = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

                if (error)
                {
                    NSLog(@"Cannot get image from http:%@", error);
                }
                ret = [UIImage imageWithData:responseBody];
            }
        }
        
        [segue.destinationViewController setImage:ret];
    }
}

#pragma mark - Actions

- (IBAction)onSaveButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(editViewController:saveNote:)])
    {
        [self updateNoteInfo];
        [self.delegate editViewController:self saveNote:self.note];
    }
}

- (IBAction)onAddIconButtonClicked:(id)sender
{
    EDAMData *data = [[EDAMData alloc] init];
    data.body = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ucweb" withExtension:@"png"]];
    data.size = data.body.length;

    EDAMResource *resource = [[EDAMResource alloc] init];

    resource.data = data;
    resource.mime = @"image/png";

    self.note.resources = [NSArray arrayWithObject:resource];

    [resource release];
    [data release];

    self.contentTextView.text = [NSString stringWithFormat:@"%@ <en-media type='image/jpeg' hash='%@'/>", self.contentTextView.text, [data.body MD5Hex]];
}

#pragma mark - Private Methods
- (void)displayNoteInfo
{
    self.titleTextField.text = self.note.title;
    self.tagsTextField.text = [self.note stringPresentationFromTags];
    EVPlainENMLParser *parser = [[EVPlainENMLParser alloc] initWithXMLContent:self.note.content];
    [parser parse];
    self.contentTextView.text = parser.plainTextContent;
    [parser release];
}

- (void)updateNoteInfo
{
    self.note.title = self.titleTextField.text;
    //self.note.tagNames = [EVTagParser tagNamesFromString:self.tagsTextField.text];
    [self.note setTagsUsingStringPresentation:self.tagsTextField.text];
    [self.note setRawTextContent:self.contentTextView.text];
//    self.note.content = self.contentTextView.text;
}
@end
