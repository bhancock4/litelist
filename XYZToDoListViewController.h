//
//  XYZToDoListViewController.h
//  ToDoList
//
//  Created by Benjamin Hancock on 2/9/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZToDoItem.h"

@interface XYZToDoListViewController : UITableViewController<UIAlertViewDelegate>

- (NSIndexPath*)getCellIndexFromGesture:(UIGestureRecognizer *) g;
- (void)selectedColorTableRow:(NSUInteger) colorTableRow;

@end
