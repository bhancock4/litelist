//
//  ToDoItem.m
//  LiteList
//
//  Created by Benjamin Hancock on 5/15/15.
//  Copyright (c) 2015 Benjamin Hancock. All rights reserved.
//

#import "ToDoItem.h"


@implementation ToDoItem

@dynamic completed;
@dynamic completedDate;
@dynamic itemName;
@dynamic order;
@dynamic status;

+ (ToDoItem *) insertNewItem
{
    XYZAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    NSManagedObject* newToDoItem;
    newToDoItem = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoItem" inManagedObjectContext:context];
    [newToDoItem setValue:@"" forKey:@"itemName"];
    [newToDoItem setValue: NO forKey:@"completed"];
    NSError* error;
    [context save:&error];
    return (ToDoItem *)newToDoItem;
}

@end
