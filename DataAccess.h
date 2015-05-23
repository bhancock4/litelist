//
//  XYZDataAccess.h
//  ToDoList
//
//  Created by Benjamin Hancock on 2/16/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYZAppDelegate.h"
#import "BaseEntity.h"

@class BaseEntity;

@interface DataAccess : NSObject

@property (nonatomic, retain) NSManagedObjectContext* context;

+ (id)sharedDataAccess;
- (NSArray *) getEntitiesByName: (NSString *) entityName;
- (NSArray *) getEntitiesByName: (NSString *) entityName WithPredicate: (NSPredicate *) predicate;
- (NSArray *) getEntitiesByName: (NSString *) entityName WithPredicate: (NSPredicate *) predicate AndSortByProperty: (NSString *) sortProperty;
- (void) deleteEntity: (BaseEntity *) deletedEntity;

@end