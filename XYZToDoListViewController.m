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

/*- (IBAction)unwindToList:(UIStoryboardSegue *)segue
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
}*/

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(cellTextFieldEndedEditing)
                                                 name: UITextFieldTextDidEndEditingNotification
                                               object: nil];
    
    /*[[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(cellTextFieldEndedEditing)
                                                 name: UITextFieldTextDidEndEditingNotification
                                               object: nil];
    
    ShoppingList* shoppingList = [ShoppingList getEntityByName:@"ShoppingList"];
    if(shoppingList == nil)
    {
        shoppingList = [ShoppingList newEntity];
        shoppingList.name = @"ShoppingList";
        [shoppingList saveEntity];
    }
    self.shoppingList = shoppingList;*/
    
    /*if(nil == self.shoppingList.shoppingListIngredients)
        self.shoppingList.shoppingListIngredients = [NSOrderedSet new];
    
    self.shoppingListIngredients = [NSMutableArray arrayWithArray: [self.shoppingList.shoppingListIngredients array]];*/
    
    self.toDoItems = [NSMutableArray arrayWithArray:[ToDoItem getEntities]];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName: @"XYZListItemTableViewCell"
                                               bundle: [NSBundle mainBundle]]
         forCellReuseIdentifier: @"XYZListItemTableViewCell"];
    
    //self.toDoItems = [XYZDataAccess getToDoListItemByCompleted:NO];
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
    return [self.toDoItems count]; // + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"XYZListItemTableViewCell";
    XYZListItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(indexPath.row < [self.toDoItems count])
    {
        // Configure the cell
        ToDoItem* toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
        cell.item = toDoItem;
        
        //this somehow forces the entity to retrieve its values...dumb
        toDoItem.order;
        cell.listItemTextField.text = toDoItem.itemName;
        //cell.textLabel.text = toDoItem.itemName;
        cell.backgroundColor = [XYZUtilities getCellColorFromStatus:toDoItem.status];

        //add a right-swipe gesture to move to delete
        UISwipeGestureRecognizer* swipeR;
        swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwipedRight: )];
        swipeR.direction = UISwipeGestureRecognizerDirectionRight;
        [cell addGestureRecognizer:swipeR];
        
        //add a left-swipe gesture to move to completed
        /*UISwipeGestureRecognizer* swipeL;
        swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwipedLeft: )];
        swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
        [cell addGestureRecognizer:swipeL];*/
    
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
    
    UIView *crossView = [self viewWithImageName:@"RedXDelete"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    [cell setSwipeGestureWithView:crossView
                            color:redColor
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState3
                  completionBlock:^(MCSwipeTableViewCell* cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode)
     {
         [self deleteItemForCell:(XYZListItemTableViewCell *)cell];
     }];
    
    cell.firstTrigger = 0.35;
    cell.secondTrigger = 0.65;
    
    return cell;
}

- (void) deleteItemForCell: (XYZListItemTableViewCell *) cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //[XYZDataAccess deleteToDoListItem: [self.toDoItems objectAtIndex:indexPath.row]];
    //[self.toDoItems removeObjectAtIndex:indexPath.row];
    // Delete the row from the data source
    //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    ToDoItem* toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    [ToDoItem deleteEntity:toDoItem];
    [self.toDoItems removeObjectAtIndex:indexPath.row];
    // Delete the row from the data source
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

/*- (void)cellWasSwipedRight:(UIGestureRecognizer *)g
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
}*/

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

- (void)cellWasSwipedRight:(UIGestureRecognizer *)g
{
    NSIndexPath* cellIndex = [self getCellIndexFromGesture: g];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellIndex];
    
    //if (cell.backgroundColor != [UIColor whiteColor])
    if(cell.alpha >= 0.99) //hack to determine if cell is being dragged
    {
        [self.tableView deselectRowAtIndexPath:cellIndex animated:NO];
        XYZToDoItem* tappedItem = [self.toDoItems objectAtIndex:cellIndex.row];
        tappedItem.completed = [NSNumber numberWithBool:YES];
        //tappedItem.completedDate = [NSDate date];
        [tappedItem saveEntity];
        //[XYZDataAccess updateToDoListItem: tappedItem];
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
        ToDoItem* toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
        [ToDoItem deleteEntity:toDoItem];
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
        [item saveEntity];
       // [XYZDataAccess updateToDoListItem: item];
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
    item.status = [NSNumber numberWithInt:colorRowNum];
    [item saveEntity];
  //  [XYZDataAccess updateToDoListItem: item];

    [self.colorPickerPopover dismissPopoverAnimated:YES];
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [self.toDoItems count])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    else
    {
        //XYZToDoItem* item = [self addListItem:self];
        //[self.tableView insertObject:item atIndex:0];
        //((XYZListItemTableViewCell *)([self.tableView cellForRowAtIndexPath:indexPath])).item = item;
    }
}
- (IBAction)addButtonClicked2:(id)sender
{
    XYZToDoItem *item = [self addListItem:self];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.toDoItems indexOfObject:item] inSection:0];
    self.toDoItems = [XYZDataAccess getToDoListItemByCompleted:NO];
    [self.tableView reloadData];
    //XYZListItemTableViewCell * cell = (XYZListItemTableViewCell *)[self.tableView cellForRowAtIndex:indexPath];
    //cell.item = item;
    
}

- (IBAction)addButtonClicked:(id)sender
{
    //instantiate a new ingredient entity
    ToDoItem* toDoItem = [ToDoItem newEntity];
    
    toDoItem.order = 0;
    for(int i = 0; i < self.toDoItems.count; i++)
    {
        ++((ToDoItem *)self.toDoItems[i]).order;
        //++((ToDoItem *)self.toDoItems[i]).order;
    }
    
    //insert the new ingredient at the TOP of the table by putting it at the beginning of our local array
    [self.toDoItems insertObject:toDoItem atIndex:0];
    
    //create in indexpath from the local array and use that to insert into the table
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.toDoItems indexOfObject:toDoItem] inSection:0];
    [self.tableView
     insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

- (ToDoItem *) addListItem:(id)sender
{
    XYZToDoItem* item = [XYZDataAccess insertNewItem];
    //item.itemName = @"";
    item.order = [self.toDoItems count];
    [XYZDataAccess updateToDoListItem:item];
    [self.toDoItems addObject:item];
    /*if(![XYZDataAccess insertToDoListItem:item])
    {
        UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle:@"Duplicate Item" message: @"A ToDoList item with that name already exists.  Please select a different name." delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
        [alert show];
    }*/
    return item;
}

//save state of shoppig list whenever a cell is edited
- (void)cellTextFieldEndedEditing
{
    //begin weird hack -> last ingredient name not persisting so we add/delete a bogus entry to force save
    //[self addButtonClicked: self.addButton];
    //[self.toDoItems removeObjectAtIndex: 0];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow: 0 inSection:0];
    //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //...end weird hack
    
    //self.shoppingList.shoppingListIngredients = [NSOrderedSet orderedSetWithArray: self.shoppingListIngredients];
    //[self.shoppingList saveEntity];
    for(ToDoItem* toDoItem in self.toDoItems)
    {
        [toDoItem saveEntity];
    }
}

@end
