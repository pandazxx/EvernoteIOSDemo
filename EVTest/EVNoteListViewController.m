//
//  EVNoteListViewController.m
//  EVTest
//
//  Created by zhengxx on 12-9-25.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import "EVNoteListViewController.h"
#import "EVNoteEditViewController.h"

const NSInteger NOTE_BUFFER_SIZE = 10;

@interface EVNoteListViewController () <UITableViewDataSource, UITableViewDelegate, EVNoteEditViewControllerDelegate>
@property (retain, nonatomic) IBOutlet UIBarButtonItem *buttonNew;
@property (retain, nonatomic) IBOutlet UITableView *noteTableView;
@property (retain, nonatomic) EDAMNoteList *noteList;
@end

@implementation EVNoteListViewController
@synthesize noteTableView = _noteTableView;
@synthesize notebook = _notebook;
@synthesize noteList = _noteList;
@synthesize buttonNew = _buttonNew;

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
    [_notebook release];
    [_noteTableView release];
    [_buttonNew release];
    [super dealloc];
}

#pragma mark - Getter/Setters

- (void)setNotebook:(EDAMNotebook *)notebook
{
    [notebook retain];
    [_notebook release];
    _notebook = notebook;

    [self updateNotesWithIndex:0];
}

#pragma mark - View controller life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.noteTableView.delegate = self;
    self.noteTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNoteTableView:nil];
    [self setButtonNew:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editNote"])
    {
        if ([segue.destinationViewController isKindOfClass:[EVNoteEditViewController class]])
        {
            EVNoteEditViewController *destVC = segue.destinationViewController;
            destVC.delegate = self;

            if (sender == self.buttonNew)
            {
                [destVC setNoteGUID:nil];
            }
            else
            {
                NSIndexPath *indexPath = [self.noteTableView indexPathForCell:sender];

                [destVC setNoteGUID:[self getNoteWithIndex:indexPath.row].guid];
            }
        }
    }
}

#pragma mark - EVNoteEditViewControllerDelegate

- (void)editViewController:(EVNoteEditViewController *)controller saveNote:(EDAMNote *)note
{
    NSLog(@"Saving note: %@", note);
    if ([note guidIsSet])
    {
        [[EvernoteNoteStore noteStore] updateNote:note success:^(EDAMNote *note) {
            [self.noteTableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *e) {
            // FIXME:zxx 2012-9-26 Should notify user error occurs
            NSLog(@"Error in saving notes:%@", e);
        }];
    }
    else
    {
        [[EvernoteNoteStore noteStore] createNote:note success:^(EDAMNote *note) {
            [self.noteTableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }failure:^(NSError *e) {
            NSLog(@"Error in creating note: %@", e);
        }];
    }
}

#pragma mark - TableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.noteList.totalNotes;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noteCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noteCell"];
    }

    EDAMNote *note = [self getNoteWithIndex:indexPath.row];

    cell.textLabel.text = note.title;
    cell.detailTextLabel.text = [self getFormattedTagStringFromNote:note];

    return cell;
}

#pragma mark - Private Functions

- (NSString *)getFormattedTagStringFromNote:(EDAMNote *)note
{
    NSMutableString *ret = [[[NSMutableString alloc] init] autorelease];

    for (NSString *tagName in note.tagNames)
    {
        [ret appendFormat:@"%@ ", tagName];
    }

    return ret;
}

- (void)updateNotesWithIndex:(NSInteger)index
{
    if (self.notebook.guid)
    {
        NSInteger beginIndex = (NSInteger)(index / NOTE_BUFFER_SIZE) * NOTE_BUFFER_SIZE;
        EDAMNoteFilter *filter = [[EDAMNoteFilter alloc] init];

        filter.notebookGuid = self.notebook.guid;
        [[EvernoteNoteStore noteStore] findNotesWithFilter:filter
                                                    offset:beginIndex
                                                  maxNotes:NOTE_BUFFER_SIZE
                                                   success:^(EDAMNoteList *result) {
                                                       self.noteList = result;
                                                       [self.noteTableView reloadData];
                                                   }
                                                   failure:^(NSError *error) {
                                                       self.noteList = nil;
                                                       // FIXME:zxx 2012-9-26 Alert user error occurs
                                                       NSLog(@"Error occurs when retreiving notes: %@", error);
                                                   }];
    }
}

- (EDAMNote *)getNoteWithIndex:(NSInteger)index
{
    if (index >= self.noteList.totalNotes)
    {
        return nil;
    }

    if (index < self.noteList.startIndex && index >= self.noteList.notes.count + self.noteList.startIndex)
    {
        [self updateNotesWithIndex:index];
    }

    return [self.noteList.notes objectAtIndex:(index - self.noteList.startIndex)];
}

@end
