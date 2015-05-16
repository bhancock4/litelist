//
//  XYZToDoListViewController.h
//  ToDoList
//
//  Created by Benjamin Hancock on 2/9/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZToDoItem.h"
#import "XYZListItemTableViewCell.h"

@interface XYZToDoListViewController : UITableViewController<UIAlertViewDelegate>

- (NSIndexPath*)getCellIndexFromGesture:(UIGestureRecognizer *) g;
- (void)selectedColorTableRow:(NSUInteger) colorTableRow;
- (ToDoItem *) addListItem:(id)sender;
- (IBAction)addButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end
