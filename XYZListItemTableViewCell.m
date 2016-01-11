//
//  XYZListItemTableViewCell.m
//  LiteList
//
//  Created by Benjamin Hancock on 4/24/15.
//  Copyright (c) 2015 Benjamin Hancock. All rights reserved.
//

#import "XYZListItemTableViewCell.h"
#import "DataAccess.h"

@implementation XYZListItemTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    //set the delegate/datasource for the fields on the UITableViewCell
    self.listItemTextField.delegate = self;
    
    //add listeners to the textChanged events on both text fields
    [self.listItemTextField addTarget:self
                                         action:@selector(textFieldInputDidChange:)
                               forControlEvents:UIControlEventEditingChanged];
    
    //allow keyboard to be dismissed with a "Done" button
    [self addDoneToolBarToTextFieldKeyboard: self.listItemTextField];
}

- (UIToolbar *) getDoneKeyboardToolbar
{
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                         nil];
    [doneToolbar sizeToFit];
    return doneToolbar;
}

-(void)addDoneToolBarToTextFieldKeyboard:(UITextField *) textField
{
    UIToolbar* doneToolbar = [self getDoneKeyboardToolbar];
    textField.inputAccessoryView = doneToolbar;
}

-(void)doneButtonClickedDismissKeyboard
{
    [self.listItemTextField resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    [self setEntityValueFromTextField:textField];
}

- (void) textFieldInputDidChange:(UITextField *) textField
{
    [self setEntityValueFromTextField:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void) setEntityValueFromTextField:(UITextField *) textField
{
    self.item.order = self.item.order;
    self.item.itemName = textField.text;
    if([textField.text isEqualToString:@"REMOVE_ADS_PERMANENT"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"removeAds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


@end
