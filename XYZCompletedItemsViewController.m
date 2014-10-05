//
//  XYZCompletedItemsViewController.m
//  ToDoList
//
//  Created by Benjamin Hancock on 2/9/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import "XYZCompletedItemsViewController.h"
#import "XYZAppDelegate.h"
#import "XYZToDoItem.h"

@interface XYZCompletedItemsViewController ()

    @property NSMutableArray* toDoItems;

@end

@implementation XYZCompletedItemsViewController

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
    
    self.toDoItems = [XYZDataAccess getToDoListItemByCompleted: YES];
    [self.tableView reloadData];

    self.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.toDoItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CompletedItemPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    XYZToDoItem* toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    
    //get the toDo item name
    NSString* completedItemName = toDoItem.itemName;
    
    //format the current time
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    NSString* completedDateString = [@"Completed on " stringByAppendingString:[dateFormatter stringFromDate:toDoItem.completedDate]];
    
    //set the cell text
    NSMutableString* msCellText = [NSMutableString new];
    [msCellText appendString:completedItemName];
    cell.textLabel.text = msCellText;
    cell.detailTextLabel.text = completedDateString;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
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

#pragma mark - Table view delegate

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
