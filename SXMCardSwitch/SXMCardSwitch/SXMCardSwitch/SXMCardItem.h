//
//  SXMCardItem.h
//  SXMCardSwitch
//
//  Created by 1 on 2017/12/26.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXMCardItem : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;

@end
