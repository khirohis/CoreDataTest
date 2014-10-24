//
//  MasterViewController.m
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/21.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import "MasterViewController.h"
#import "ListElement.h"
#import "CoreDataSaveOperation.h"


@interface MasterViewController ()

@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSOperationQueue *operationQueue;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)elementChange:(id)sender;

- (void)reloadList;
- (NSArray *)fetchedResults;


@end


@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                  target:self
                                                                                  action:@selector(elementChange:)];
    self.navigationItem.rightBarButtonItem = actionButton;

    self.list = [self fetchedResults];

    self.operationQueue = [[NSOperationQueue alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)onSave:(id)sender
{
//    [self reloadList];
    [self.tableView reloadData];
}


- (void)elementChange:(id)sender
{
    CoreDataSaveOperation *operation = [[CoreDataSaveOperation alloc] initWithListener:self];
    [self.operationQueue addOperation:operation];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ListElement *object = [self.list objectAtIndex:indexPath.row];
    cell.textLabel.text = object.elementDescription;
}


- (void)reloadList
{
    self.list = [self fetchedResults];
    [self.tableView reloadData];
}

- (NSArray *)fetchedResults
{
    NSArray *result = nil;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ListElement"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    result = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                      error:nil];

    return result;
}


@end
