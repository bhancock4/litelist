//
//  XYZToDoListViewController.m
//  ToDoList
//
//  Created by Benjamin Hancock on 2/9/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import "XYZAppDelegate.h"
#import "XYZToDoListViewController.h"
#import "XYZAddToDoITemViewController.h"
#import "XYZDataAccess.h"
#import "FPPopoverController.h"
#import "XYZColorPickerViewController.h"
#import "XYZUtilities.h"

@interface XYZToDoListViewController()

    @property NSMutableArray* toDoItems;
    @property NSIndexPath* swipeRIndex;
    @property NSIndexPath* longPressIndex;
    @property UIColor* preAlertCellColor;
    @property FPPopoverController* colorPickerPopover;

@end

@implementation XYZToDoListViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    XYZAddToDoItemViewController* source = [segue sourceViewController];
    XYZToDoItem* item = source.toDoItem;
    
    if(item != nil)
    {
        item.order = (int)[self.toDoItems count];
        [XYZDataAccess updateToDoListItem: item];
        self.toDoItems = [XYZDataAccess getToDoListItemByCompleted:NO];
        [self.tableView reloadData];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.toDoItems = [XYZDataAccess getToDoListItemByCompleted:NO];
    self.tableView.editing = YES;  //edit mode allows reordering
    self.tableView.allowsSelectionDuringEditing = YES;  //still allow cell selection
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//allow reordering (editing in general)
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //do not allow editing of dummy "add" row
    return indexPath.row < [self.toDoItems count];
}

//hide delete button during edit
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

//hide delete button during edit
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//allows reordering during edit
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row < [self.toDoItems count];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.toDoItems count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(indexPath.row < [self.toDoItems count])
    {
        // Configure the cell
        XYZToDoItem* toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
        cell.textLabel.text = toDoItem.itemName;
        cell.backgroundColor = [XYZUtilities getCellColorFromStatus:toDoItem.status];

        //add a right-swipe gesture to move to delete
        UISwipeGestureRecognizer* swipeR;
        swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwipedRight: )];
        swipeR.direction = UISwipeGestureRecognizerDirectionRight;
        [cell addGestureRecognizer:swipeR];
        
        //add a left-swipe gesture to move to completed
        UISwipeGestureRecognizer* swipeL;
        swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwipedLeft: )];
        swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
        [cell addGestureRecognizer:swipeL];
    
        //add a long press gesture to pick status
        UILongPressGestureRecognizer* longPress;
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasLongPressed: )];
        longPress.minimumPressDuration = 0.25;  //seconds
        [cell.contentView addGestureRecognizer:longPress];
    }
    else
    {
        cell.textLabel.text = @"";
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)cellWasSwipedRight:(UIGestureRecognizer *)g
{
    NSIndexPath* cellIndex = [self getCellIndexFromGesture: g];
    self.swipeRIndex = cellIndex;
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellIndex];
    self.preAlertCellColor = cell.backgroundColor;
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor yellowColor];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Delete?"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"OK", nil];
    
    [alert show];
}

//handle result of user interaction with delete confirm dialog
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:self.swipeRIndex];
    cell.textLabel.textColor = [UIColor blackColor];
    
    if(buttonIndex == [alertView cancelButtonIndex])
    {
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:self.swipeRIndex];
        cell.backgroundColor = self.preAlertCellColor;
    }
    else
    {
        [XYZDataAccess deleteToDoListItem: [self.toDoItems objectAtIndex:self.swipeRIndex.row]];
        [self.toDoItems removeObjectAtIndex:self.swipeRIndex.row];
        [self.tableView deleteRowsAtIndexPaths:@[self.swipeRIndex] withRowAnimation:UITableViewRowAnimationFade];
        
        if([self.toDoItems count] > 0)
        {
            for(int i = (int)self.swipeRIndex.row; i <= [self.toDoItems count] - 1; i++)
            {
                XYZToDoItem* item = [self.toDoItems objectAtIndex:i];
                item.order = i;
                [XYZDataAccess updateToDoListItem: item];
            }
        }
    }
}

- (void)cellWasSwipedLeft:(UIGestureRecognizer *)g
{
    NSIndexPath* cellIndex = [self getCellIndexFromGesture: g];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellIndex];
    
    //if (cell.backgroundColor != [UIColor whiteColor])
    if(cell.alpha >= 0.99) //hack to determine if cell is being dragged
    {
        [self.tableView deselectRowAtIndexPath:cellIndex animated:NO];
        XYZToDoItem* tappedItem = [self.toDoItems objectAtIndex:cellIndex.row];
        tappedItem.completed = YES;
        tappedItem.completedDate = [NSDate date];
        [XYZDataAccess updateToDoListItem: tappedItem];
        [self.toDoItems removeObjectAtIndex:cellIndex.row];
        [self.tableView deleteRowsAtIndexPaths:@[cellIndex] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)cellWasLongPressed:(UILongPressGestureRecognizer *) g
{
    if (g.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath* cellIndex = [self getCellIndexFromGesture: g];
        self.longPressIndex = cellIndex;
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellIndex];

        //the view controller you want to present as popover
        XYZColorPickerViewController* controller = [[XYZColorPickerViewController alloc] init];
        controller.delegate = self;
        
        //our popover
        self.colorPickerPopover = [[FPPopoverController alloc] initWithViewController:controller];
        self.colorPickerPopover.border = NO;
        
        int width = [cell systemLayoutSizeFittingSize: UILayoutFittingExpandedSize].width * 0.75;
        int height = [cell systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height * 6 - 5;
        self.colorPickerPopover.contentSize = CGSizeMake(width, height);
        
        //the popover will be presented from the cell
        [self.colorPickerPopover presentPopoverFromView:cell];
    }
}

- (NSIndexPath*)getCellIndexFromGesture:(UIGestureRecognizer *) g
{
    CGPoint p = [g locationInView:self.tableView];
    return [self.tableView indexPathForRowAtPoint:p];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [XYZDataAccess deleteToDoListItem: [self.toDoItems objectAtIndex:indexPath.row]];
        [self.toDoItems removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString* strMove = self.toDoItems[fromIndexPath.row];
    [self.toDoItems removeObjectAtIndex:fromIndexPath.row];
    [self.toDoItems insertObject:strMove atIndex:toIndexPath.row];

    for(int i = 0; i < [self.toDoItems count]; i++)
    {
        XYZToDoItem* item = [self.toDoItems objectAtIndex:i];
        item.order = i;
        [XYZDataAccess updateToDoListItem: item];
    }
}

- (NSIndexPath*)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSIndexPath* destPath = proposedDestinationIndexPath;
    if(proposedDestinationIndexPath.row >= [self.toDoItems count])
    {
        destPath = [NSIndexPath indexPathForRow:[self.toDoItems count] - 1 inSection:0];
    }
    else
    {
        destPath = proposedDestinationIndexPath;
    }
    return destPath;
}

-(void)selectedColorTableRow:(NSUInteger)colorRowNum
{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:self.longPressIndex];
    cell.backgroundColor = [XYZUtilities getCellColorFromStatus:(int)colorRowNum];

    XYZToDoItem* item = [self.toDoItems objectAtIndex:self.longPressIndex.row];
    item.status = (int)colorRowNum;
    [XYZDataAccess updateToDoListItem: item];

    [self.colorPickerPopover dismissPopoverAnimated:YES];
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [self.toDoItems count])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    else //segue to the add item view for taps on the dummy row
    {
        [self performSegueWithIdentifier:@"showAddItem" sender:self];
    }
}

@end
