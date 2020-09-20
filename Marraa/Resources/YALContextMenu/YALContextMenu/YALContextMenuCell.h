//
//  YALContextMenuCell.h
//  ContextMenu
//
//  Created by Khaled Ghoniem on 12/17/19.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YALContextMenuCell <NSObject>

/*!
 @abstract
 Following methods called for cell when animation to be processed
 */
- (UIView *)animatedIcon;
- (UIView *)animatedContent;

@end
