//
//  XYZUtilities.m
//  LiteList
//
//  Created by Benjamin Hancock on 9/20/14.
//  Copyright (c) 2014 Benjamin Hancock. All rights reserved.
//

#import "XYZUtilities.h"

@implementation XYZUtilities

+ (UIColor*)getCellColorFromStatus:(int) status
{
    UIColor* cellColor = [UIColor whiteColor];
    switch(status)
    {
        case 0:
            cellColor = [UIColor whiteColor];
            break;
        case 1:
            //green
            cellColor = [UIColor colorWithRed: 123.0f/255.0f green:238.0f/255.0f blue:156.0f/255.0f alpha:1];
            break;
        case 2:
            //red
            cellColor = [UIColor colorWithRed: 250.0f/255.0f green:139.0f/255.0f blue:139.0f/255.0f alpha:1];
            break;
        case 3:
            //yellow
            cellColor = [UIColor colorWithRed: 253.0f/255.0f green:253.0f/255.0f blue:141.0f/255.0f alpha:1];
            break;
        case 4:
            //blue
            cellColor = [UIColor colorWithRed: 172.0f/255.0f green:172.0f/255.0f blue:245.0f/255.0f alpha:1];
        default:
            break;
    }
    return cellColor;
}


@end
