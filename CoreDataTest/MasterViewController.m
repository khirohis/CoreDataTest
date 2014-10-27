//
//  MasterViewController.m
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/21.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import "MasterViewController.h"
#import "ListElement.h"
#import "List.h"
#import "ListOwner.h"
#import "CoreDataSaveOperation.h"


@interface MasterViewController ()

@property (strong, nonatomic) ListOwner *listOwner;
@property (strong, nonatomic) NSOperationQueue *operationQueue;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)elementChange:(id)sender;

- (void)reloadList;

- (ListOwner *)fetchListOwner:(NSManagedObjectContext *)context
                    groupType:(NSNumber *)groupType;


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

    NSNumber *groupType = [NSNumber numberWithInt:1];
    self.listOwner = [self fetchListOwner:self.managedObjectContext
                                groupType:groupType];

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
    if (self.listOwner != nil) {
        NSEntityDescription *entity = self.listOwner.entity;
        NSLog(@"entity name: %@", entity.name);

        List *list = [self.listOwner firstList];
        if (list != nil) {
            return list.listElements.count;
        }
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
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
    List *list = [self.listOwner firstList];
    NSArray *elements = [list sortedListElementsArray];
    ListElement *object = [elements objectAtIndex:indexPath.row];
    cell.textLabel.text = object.elementDescription;
}


- (void)reloadList
{
    NSNumber *groupType = [NSNumber numberWithInt:1];
    self.listOwner = [self fetchListOwner:self.managedObjectContext
                 groupType:groupType];

    [self.tableView reloadData];
}

- (ListOwner *)fetchListOwner:(NSManagedObjectContext *)context
                    groupType:(NSNumber *)groupType;
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([ListOwner class])
                                                         inManagedObjectContext:context];
    [fetchRequest setEntity:entityDescription];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupType = %d", 1];
    [fetchRequest setPredicate:predicate];

    NSError *error;
    NSArray *result = [context executeFetchRequest:fetchRequest
                                             error:&error];

    if (result != nil && result.count > 0) {
        return result.lastObject;
    }

    return nil;
}


@end
