//
//  XYZToDoListViewController.h
//  ToDoList
//
//  Created by Benjamin Hancock on 2/9/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"
#import "XYZListItemTableViewCell.h"
#import "FPPopoverController.h"

@interface XYZToDoListViewController : UITableViewController<UIAlertViewDelegate>

- (NSIndexPath*)getCellIndexFromGesture:(UIGestureRecognizer *) g;
- (void)selectedColorTableRow:(int) colorTableRow;
- (ToDoItem *) addListItem:(id)sender;
- (IBAction)addButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property NSMutableArray* toDoItems;
@property NSIndexPath* swipeRIndex;
@property NSIndexPath* longPressIndex;
@property UIColor* preAlertCellColor;
@property FPPopoverController* colorPickerPopover;

@end
