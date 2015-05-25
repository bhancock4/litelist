//
//  MyNavigationBar.m
//  LiteList
//
//  Created by Benjamin Hancock on 5/25/15.
//  Copyright (c) 2015 Benjamin Hancock. All rights reserved.
//

#import "MyNavigationBar.h"

@implementation MyNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGSize)sizeThatFits:(CGSize)size
{
    NSLog(@"frame: %@", NSStringFromCGRect(self.frame));
    return CGSizeMake(self.frame.size.width, 66);
}

@end
