//
//  XYZToDoItem.h
//  ToDoList
//
//  Created by Benjamin Hancock on 2/9/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZToDoItem : NSObject

    @property NSString* itemName;
    @property BOOL completed;
    @property NSDate* completedDate;
    @property int status;
    @property int order;

@end
