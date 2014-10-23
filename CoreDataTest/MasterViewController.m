//
//  MasterViewController.m
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/21.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ListElement.h"
#import "CoreDataSaveOperation.h"


@interface MasterViewController ()

@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSOperationQueue *operationQueue;

- (NSArray *)fetchedResults;
- (void)onSave:(id)sender;

- (void)insertNewObject:(id)sender;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;

    self.list = [self fetchedResults];
    self.operationQueue = [[NSOperationQueue alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ListElement *object = [self.list objectAtIndex:indexPath.row];

        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.masterViewController = self;
        detailViewController.detailItem = object;
    }
}


- (void)didChangeObjectID:objectId
                groupType:groupType
       elementDescription:elementDescription
{
    CoreDataSaveOperation *operation = [[CoreDataSaveOperation alloc] initWithObjectID:objectId
                                                                             groupType:groupType
                                                                    elementDescription:elementDescription];
    operation.listener = self;

    [self.operationQueue addOperation:operation];
    NSLog(@"complete addOperation");
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
    result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];

    return result;
}

- (void)onSave:(id)sender
{
    [self reloadList];
}


- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = self.managedObjectContext;

    ListElement *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"ListElement"
                                                                  inManagedObjectContext:context];
    newManagedObject.groupType = [NSNumber numberWithInt:1];
    newManagedObject.elementDescription = @"none";

    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    [self reloadList];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ListElement *object = [self.list objectAtIndex:indexPath.row];
    cell.textLabel.text = object.elementDescription;
}


@end
