//
//  XYZColorPickerViewController.m
//  ToDoList
//
//  Created by Benjamin Hancock on 9/18/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import "XYZColorPickerViewController.h"
#import "XYZUtilities.h"

@interface XYZColorPickerViewController ()

@end

@implementation XYZColorPickerViewController
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ColorPrototypeCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //only picking colors
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //5 choices right now
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ColorPrototypeCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [XYZUtilities getCellColorFromStatus: (int)indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

//hand the selected color back to the delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(selectedColorTableRow:)])
    {
        [self.delegate selectedColorTableRow:indexPath.row];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

@end
