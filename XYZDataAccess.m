//
//  XYZDataAccess.m
//  ToDoList
//
//  Created by Benjamin Hancock on 2/16/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import "XYZDataAccess.h"
#import "XYZToDoItem.h"
#import "XYZAppDelegate.h"

@implementation XYZDataAccess

+ (XYZToDoItem *) insertNewItem
{
    XYZAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    NSManagedObject* newToDoItem;
    newToDoItem = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoItem" inManagedObjectContext:context];
    [newToDoItem setValue:@"" forKey:@"itemName"];
    [newToDoItem setValue: NO forKey:@"completed"];
    NSError* error;
    [context save:&error];
    return (XYZToDoItem *)newToDoItem;
}

+ (BOOL) insertToDoListItem: (XYZToDoItem*) item
{
    BOOL success = YES;
    if([XYZDataAccess isDuplicateEntry: item])
        success = NO;
    else
    {
        XYZAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = [appDelegate managedObjectContext];
        NSManagedObject* newToDoItem;
        newToDoItem = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoItem" inManagedObjectContext:context];
        [newToDoItem setValue: item.itemName forKey:@"itemName"];
        [newToDoItem setValue: [NSNumber numberWithBool:item.completed] forKey:@"completed"];
        [newToDoItem setValue: item.completedDate forKey:@"completedDate"];
        [newToDoItem setValue: [NSNumber numberWithInt:item.status] forKey:@"status"];
        [newToDoItem setValue: [NSNumber numberWithInt:item.order] forKey:@"order"];
        NSError* error;
        [context save:&error];
    }
    return success;
}

+ (void) updateToDoListItem: (XYZToDoItem*) updatedItem
{
    XYZAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"(SELF = %@)", updatedItem.objectID];
    NSArray* objects = [XYZDataAccess fetchObjects: predicate];
    if(objects.count == 1)
    {
        BOOL completed = updatedItem.completed;
        [objects[0] setValue: updatedItem.itemName forKey:@"itemName"];
        [objects[0] setValue: [NSNumber numberWithBool:completed] forKey:@"completed"];
        [objects[0] setValue: updatedItem.completedDate forKey:@"completedDate"];
        [objects[0] setValue: [NSNumber numberWithInt:updatedItem.status] forKey:@"status"];
        [objects[0] setValue: [NSNumber numberWithInt:updatedItem.order] forKey:@"order"];
    }
    NSError* error;
    [context save: &error];
}

+ (void) updateToDoListItem2: (XYZToDoItem*) updatedItem
{
    XYZAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"(SELF = %@)", updatedItem.objectID];
    NSArray* objects = [XYZDataAccess fetchObjects: predicate];
    if(objects.count == 1)
    {
        BOOL completed = updatedItem.completed;
        [objects[0] setValue: updatedItem.itemName forKey:@"itemName"];
        //[objects[0] setValue: [NSNumber numberWithBool:completed] forKey:@"completed"];
        [objects[0] setValue: updatedItem.completedDate forKey:@"completedDate"];
        [objects[0] setValue: [NSNumber numberWithInt:updatedItem.status] forKey:@"status"];
        [objects[0] setValue: [NSNumber numberWithInt:updatedItem.order] forKey:@"order"];
    }
    NSError* error;
    [context save: &error];
}

+ (void) deleteToDoListItem: (XYZToDoItem*) deletedItem
{
    XYZAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    NSArray* deletedToDoItemArray = [XYZDataAccess fetchObjects: [NSPredicate predicateWithFormat: @"(itemName = %@ and completed = %@)", deletedItem.itemName, [NSNumber numberWithBool:NO]]];
    if(deletedToDoItemArray.count == 1)
    {
        [context deleteObject: deletedToDoItemArray[0]];
        NSError* error;
        [context save:&error];
    }
}

+ (BOOL) isDuplicateEntry: (XYZToDoItem*) testItem
{
    return [XYZDataAccess fetchObjects: [NSPredicate predicateWithFormat: @"(itemName = %@ and completed = %@)", testItem.itemName, [NSNumber numberWithBool:NO]]].count > 0;
}

+ (NSArray*) fetchObjects: (NSPredicate*) predicate
{
    XYZAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName: @"ToDoItem" inManagedObjectContext:context];
    NSFetchRequest* request = [NSFetchRequest new];
    [request setEntity: entityDescription];
    [request setPredicate: predicate];
    
    NSArray* sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]];
    
    NSError* error;
    NSArray* objects = [context executeFetchRequest:request error: &error];
    objects = [objects sortedArrayUsingDescriptors:sortDescriptors];
    return objects;
}

+ (NSMutableArray*) getToDoListItems: (NSPredicate*) predicate
{
    NSArray* objects = [XYZDataAccess fetchObjects: predicate];
    NSMutableArray* toDoItems = [NSMutableArray new];
    for(int i = 0; i < objects.count; i++)
    {
        NSManagedObject* managedObject = objects[i];
        //XYZToDoItem* toDoItem = [XYZToDoItem new];
        ((XYZToDoItem *)objects[i]).itemName = [managedObject valueForKey: @"itemName"];
        ((XYZToDoItem *)objects[i]).completed = ((ToDoItem *)objects[i]).completed; // [[managedObject valueForKey: @"completed"] boolValue];
        ((XYZToDoItem *)objects[i]).completedDate = [managedObject valueForKey: @"completedDate"];
        ((XYZToDoItem *)objects[i]).status = ((ToDoItem *)objects[i]).status; //[[managedObject valueForKey: @"status"] intValue];
        ((XYZToDoItem *)objects[i]).order = ((ToDoItem *)objects[i]).order; //[[managedObject valueForKey: @"order"] intValue];
        [toDoItems addObject: ((XYZToDoItem *)objects[i])];
    }
    return toDoItems;
}

+ (XYZToDoItem*) getToDoListItemByItemName: (NSString*) itemName
{
    XYZToDoItem* toDoItem;
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"(itemName = %@)", itemName];
    NSMutableArray* toDoItems = [XYZDataAccess getToDoListItems: predicate];
    if(toDoItems.count == 1)
        toDoItem = toDoItems[0];
    return toDoItem;
}

+ (NSMutableArray*) getToDoListItemByCompleted: (BOOL) completed
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"(completed = %@)", [NSNumber numberWithBool:completed]];
    return [XYZDataAccess getToDoListItems: predicate];
}

@end
