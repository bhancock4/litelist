//
//  ToDoItem.h
//  LiteList
//
//  Created by Benjamin Hancock on 5/1/15.
//  Copyright (c) 2015 Benjamin Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ToDoItem : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSDate * completedDate;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * status;

@end
