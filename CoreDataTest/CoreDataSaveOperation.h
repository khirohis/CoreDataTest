//
//  CoreDataSaveOperation.h
//  CoreDataTest
//
//  Created by 小林博久 on 2014/10/22.
//  Copyright (c) 2014年 Hirohisa Kobayasi. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CoreDataSaveListener <NSObject>

- (void)onSave:(id)sender;

@end


@interface CoreDataSaveOperation : NSOperation

- (instancetype)initWithListener:(id<CoreDataSaveListener>)listener;

@property (strong, nonatomic) id<CoreDataSaveListener> listener;

@end
