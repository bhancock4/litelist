//
//  XYZListItemTableViewCell.h
//  LiteList
//
//  Created by Benjamin Hancock on 4/24/15.
//  Copyright (c) 2015 Benjamin Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"
#import "ToDoItem.h"

@interface XYZListItemTableViewCell : MCSwipeTableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *listItemTextField;
@property ToDoItem *item;

@end
