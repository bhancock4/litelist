//
//  ToDoItem.h
//  LiteList
//
//  Created by Benjamin Hancock on 5/15/15.
//  Copyright (c) 2015 Benjamin Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@interface ToDoItem : BaseEntity

@property (nonatomic) BOOL completed;
@property (nonatomic) NSDate* completedDate;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic) int16_t order;
@property (nonatomic) int16_t status;

+ (ToDoItem *) insertNewItem;

@end
