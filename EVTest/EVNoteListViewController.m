//
//  EVNoteListViewController.m
//  EVTest
//
//  Created by zhengxx on 12-9-25.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import "EVNoteListViewController.h"

@interface EVNoteListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *noteTableView;

@end

@implementation EVNoteListViewController
@synthesize noteList = _noteList;
@synthesize noteTableView = _noteTableView;

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
    [_noteList release];
    [_noteTableView release];
    [super dealloc];
}

#pragma mark - Getter/Setters

- (void)setNoteList:(NSArray *)noteList
{
    [_noteList release];
    _noteList = [noteList copy];

    [self.noteTableView reloadData];
}

#pragma mark - View controller life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNoteTableView:nil];
    [super viewDidUnload];
}

#pragma mark - TableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.noteList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // FIXME:zxx 2012-9-25
    return nil;
}

@end
