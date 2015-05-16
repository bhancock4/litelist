//
//  BaseEntity.m
//  GroceryList
//
//  Created by Benjamin Hancock on 10/12/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "BaseEntity.h"

@implementation BaseEntity

@synthesize itemName;

+ (NSArray *) getEntities
{
    DataAccess* da = [DataAccess sharedDataAccess];
    return [da getEntitiesByName: NSStringFromClass([self class])];
}

+ (NSArray *) getEntitiesWithSortProperty: (NSString *) sortProperty
{
    DataAccess* da = [DataAccess sharedDataAccess];
    return [da getEntitiesByName: NSStringFromClass([self class]) WithPredicate: nil AndSortByProperty: sortProperty];
}

+ (id) getEntityByName: (NSString *) name
{
    DataAccess* da = [DataAccess sharedDataAccess];
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"(name = %@)", name];
    NSArray* objects = [da getEntitiesByName: NSStringFromClass([self class]) WithPredicate:predicate];
    return objects.count == 0 ? nil : objects[0];
}

+ (BaseEntity *) newEntity
{
    DataAccess* da = [DataAccess sharedDataAccess];
    NSString* className = NSStringFromClass([self class]);
    
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:className inManagedObjectContext:da.context];
    
    return [[BaseEntity alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:da.context];
}

+ (void) deleteEntity: (BaseEntity *) deletedEntity
{
    DataAccess* da = [DataAccess sharedDataAccess];
    [da deleteEntity:deletedEntity];
}

- (BOOL) validateEntity
{
    BOOL isSuccess = YES;
    if(0)
    {
        isSuccess = NO;
    }
    return isSuccess;
}

- (BOOL) saveEntity
{
    BOOL isSuccess = YES;
    DataAccess* da = [DataAccess sharedDataAccess];
    if([self validateEntity])
    {
        NSError* error;
        [da.context save:&error];
    }
    else
        isSuccess = NO;
    
    return isSuccess;
}

@end
