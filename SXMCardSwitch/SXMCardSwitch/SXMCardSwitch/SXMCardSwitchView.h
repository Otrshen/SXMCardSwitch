//
//  SXMCardSwitchView.h
//  SXMCardSwitch
//
//  Created by sxm on 2017/12/26.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXMCardItem.h"

@protocol SXMCardSwitchViewDelegate <NSObject>

@optional

/**
 选中哪个item

 @param item SXMCardItem
 @param index 下标
 */
- (void)SXMCardSwitchViewDidSelectItem:(SXMCardItem *)item index:(NSInteger)index;

/**
 选中中间的item

 @param item SXMCardItem
 @param index 下标
 */
- (void)SXMCardSwitchViewDidSelectCenterItem:(SXMCardItem *)item index:(NSInteger)index;

@end

@interface SXMCardSwitchView : UIView

/** 当前选中位置 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 数据源 */
@property (nonatomic, copy) NSArray<SXMCardItem *> *items;
/** 代理 */
@property (nonatomic, weak) id<SXMCardSwitchViewDelegate> delegate;
/** 是否分页 */
@property (nonatomic, assign) BOOL pagingEnabled;


/**
 滚动到某个位置

 @param index 位置下标
 @param animated 是否需要动画
 */
- (void)sxm_switchToIndex:(NSInteger)index animated:(BOOL)animated;

@end
