//
//  JXDropdownMenuItem.m
//  JXDropdownMenu
//
//  Created by 朱佳翔 on 16/8/3.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import "JXDropdownMenuItem.h"


@implementation JXDropdownMenuItem

+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
                   action:(SEL) action
{
    return [[JXDropdownMenuItem alloc] init:title
                                        image:image
                                       target:target
                                       action:action];
}

- (id) init:(NSString *) title
      image:(UIImage *) image
     target:(id)target
     action:(SEL) action
{
    NSParameterAssert(title.length || image);
    
    self = [super init];
    if (self) {
        
        _title = title;
        _image = image;
        _target = target;
        _action = action;
        
        _foreColor = [UIColor colorWithRed:((float)((0x323232 & 0xFF0000) >> 16)) / 255.0
                                     green:((float)((0x323232 & 0xFF00) >> 8)) / 255.0
                                      blue:((float)(0x323232 & 0xFF)) / 255.0 alpha:1.0];

    }
    return self;
}

- (BOOL) enabled
{
    return _target != nil && _action != NULL;
}

- (void) performAction
{
    __strong id target = self.target;
    
    
    if (target && [target respondsToSelector:_action]) {
        
        [target performSelectorOnMainThread:_action withObject:self waitUntilDone:YES];
    }
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}

@end
