//
//  BaseEntity.h
//  GroceryList
//
//  Created by Benjamin Hancock on 10/12/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DataAccess.h"

@interface BaseEntity : NSManagedObject

+ (id) newEntity;
- (BOOL) saveEntity;
- (BOOL) validateEntity;
+ (NSArray *) getEntities;
+ (id) getEntityByName: (NSString *) name;
+ (void) deleteEntity: (BaseEntity *) deletedEntity;
+ (NSArray *) getEntitiesWithSortProperty: (NSString *) sortProperty;
+ (NSArray*) getToDoListItemByCompleted: (BOOL) completed;

@property (nonatomic, retain) NSString* itemName;

@end
