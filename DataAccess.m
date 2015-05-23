//
//  XYZDataAccess.m
//  ToDoList
//
//  Created by Benjamin Hancock on 2/16/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import "DataAccess.h"

@implementation DataAccess

+ (id)sharedDataAccess
{
    static DataAccess* sharedMyDataAccess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyDataAccess = [[self alloc] init];
    });
    return sharedMyDataAccess;
}

- (id)init
{
    if(self = [super init])
    {
        self.context = [(XYZAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    return self;
}

- (void)dealloc
{
    //dealloc
}

- (NSArray *) getEntitiesByName: (NSString *) entityName
{
    return [self getEntitiesByName:entityName WithPredicate:nil AndSortByProperty:nil];
}

- (NSArray *) getEntitiesByName: (NSString *) entityName WithPredicate: (NSPredicate *) predicate
{
    return [self getEntitiesByName:entityName WithPredicate:predicate AndSortByProperty:nil];
}

- (NSArray*) getEntitiesByName: (NSString *) entityName WithPredicate: (NSPredicate*) predicate AndSortByProperty: (NSString *) sortProperty
{
    XYZAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName: entityName inManagedObjectContext:context];
    NSFetchRequest* request = [NSFetchRequest new];
    
    [request setEntity: entityDescription];
    [request setPredicate: predicate];
    
    NSError* error;
    NSArray* objects = [context executeFetchRequest:request error: &error];
    
    NSArray* sortDescriptors;
    if(nil != sortProperty)
    {
        sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortProperty ascending:YES]];
        objects = [objects sortedArrayUsingDescriptors:sortDescriptors];
    }
    return objects;
}

- (void) deleteEntity: (BaseEntity *) deletedEntity
{
    XYZAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    
    [context deleteObject: deletedEntity];
    NSError* error;
    [context save:&error];
}


@end
