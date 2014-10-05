//
//  XYZColorPickerViewController.h
//  ToDoList
//
//  Created by Benjamin Hancock on 9/18/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZToDoListViewController.h"

@class XYZColorPickerViewController;

@interface XYZColorPickerViewController : UITableViewController
@property(nonatomic, assign) XYZToDoListViewController * delegate;
@end
