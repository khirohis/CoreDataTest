//
//  DetailViewController.m
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/21.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import "DetailViewController.h"
#import "ListElement.h"


@interface DetailViewController ()

- (void)configureView;
- (void)onDone:(id)sender;

@end


@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;

        [self configureView];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(onDone:)];

    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)configureView
{
    if (self.detailItem) {
        self.detailGroupTypeField.text = [self.detailItem.groupType stringValue];
        self.detailDescriptionField.text = self.detailItem.elementDescription;
    }
}

- (void)onDone:(id)sender
{
    self.detailItem.groupType = [NSNumber numberWithInt:[self.detailGroupTypeField.text intValue]];
    self.detailItem.elementDescription = self.detailDescriptionField.text;

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
