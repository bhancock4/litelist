//
//  XYZAddToDoItemViewController.m
//  ToDoList
//
//  Created by Benjamin Hancock on 2/9/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import "XYZAddToDoItemViewController.h"
#import "XYZDataAccess.h"

@interface XYZAddToDoItemViewController ()

    @property (weak, nonatomic) IBOutlet UITextField *textField;
    @property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
    @property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation XYZAddToDoItemViewController

- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL shouldSegue = YES;
    if(sender == self.doneButton && self.textField.text.length > 0)
    {
        self.toDoItem = [XYZToDoItem new];
        self.toDoItem.itemName = self.textField.text;
        self.toDoItem.completed = NO;
        if(![XYZDataAccess insertToDoListItem:self.toDoItem])
        {
            shouldSegue = NO;
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle:@"Duplicate Item" message: @"A ToDoList item with that name already exists.  Please select a different name." delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    return shouldSegue;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
