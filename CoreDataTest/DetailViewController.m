//
//  DetailViewController.m
//  CoreDataTest
//
//  Created by 小林 博久 on 2014/10/21.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import "DetailViewController.h"
#import "MasterViewController.h"
#import "ListElement.h"


@interface DetailViewController ()

- (void)configureView;
- (void)onDone:(id)sender;

@end


@implementation DetailViewController

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
    NSNumber *groupType = [NSNumber numberWithInt:[self.detailGroupTypeField.text intValue]];
    NSString *elementDescription = self.detailDescriptionField.text;
    [self.masterViewController didChangeObjectID:self.detailItem.objectID
                                       groupType:groupType
                              elementDescription:elementDescription];

    [self.navigationController popViewControllerAnimated:YES];
}


@end
