//
//  EVNotebookListViewController.m
//  EVTest
//
//  Created by zhengxx on 12-9-25.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import "EVNotebookListViewController.h"
#import "EvernoteSDK.h"

@interface EVNotebookListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *nbTableView;
@property (retain, nonatomic) NSArray *notebooks;
@end

@implementation EVNotebookListViewController
@synthesize nbTableView = _nbTableView;
@synthesize notebooks = _notebooks;

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

    self.nbTableView.delegate = self;
    self.nbTableView.dataSource = self;
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    [noteStore listNotebooksWithSuccess:^(NSArray *notebooks) {
        self.notebooks = notebooks;
        [self.nbTableView reloadData];
    }
                                failure:^(NSError *error) {
                                    NSLog(@"error %@", error);                                            
                                }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_nbTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNbTableView:nil];
    [super viewDidUnload];
}

#pragma mark - TableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.nbTableView dequeueReusableCellWithIdentifier:@"notebookCell"];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notebookCell"];
    }

    cell.textLabel.text = [[self.notebooks objectAtIndex:indexPath.row] name];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notebooks.count;
}


#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"noteList" sender:self];
}

@end
