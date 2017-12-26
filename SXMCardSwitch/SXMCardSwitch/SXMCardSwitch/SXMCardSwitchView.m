//
//  SXMCardSwitchView.m
//  SXMCardSwitch
//
//  Created by 1 on 2017/12/26.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import "SXMCardSwitchView.h"
#import "SXMCardSwitchFlowLayout.h"
#import "SXMCardCell.h"

static NSString *kCellReuseIdentifier = @"SXMCardCell";

@interface SXMCardSwitchView() <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat dragStartX;
@property (nonatomic, assign) CGFloat dragEndX;

@end

@implementation SXMCardSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self pm_setupUI];
    }
    return self;
}

- (void)setItems:(NSArray<SXMCardItem *> *)items
{
    _items = items;
    
    [self.collectionView reloadData];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self sxm_switchToIndex:selectedIndex animated:NO];
}

- (void)sxm_switchToIndex:(NSInteger)index animated:(BOOL)animated
{
    _selectedIndex = index;
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    
    if ([_delegate respondsToSelector:@selector(SXMCardSwitchViewDidSelectItem:index:)]) {
        [_delegate SXMCardSwitchViewDidSelectItem:_items[_selectedIndex] index:_selectedIndex];
    }
}

#pragma mark - UIScrollViewDelegate

// 在不使用分页滚动的情况下需要手动计算当前选中位置 -> _selectedIndex
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_pagingEnabled) {return;}

    if (!_collectionView.visibleCells.count) {return;}

    if (!scrollView.isDragging) {return;}

    CGRect currentRect = _collectionView.bounds;
    currentRect.origin.x = _collectionView.contentOffset.x;
    for (SXMCardCell *card in _collectionView.visibleCells) {
        if (CGRectContainsRect(currentRect, card.frame)) {
            NSInteger index = [_collectionView indexPathForCell:card].row;
            if (index != _selectedIndex) {
                _selectedIndex = index;
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragStartX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!_pagingEnabled) {return;}

    _dragEndX = scrollView.contentOffset.x;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self pm_fixCellToCenter];
    });
}

#pragma mark - UICollectionViewDelegate

//点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    
    [self pm_scrollToCenter];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SXMCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.item = _items[indexPath.row];
    return cell;
}

#pragma mark - 私有方法

- (void)pm_setupUI
{
    SXMCardSwitchFlowLayout *flowLayout = [[SXMCardSwitchFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[SXMCardCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
    [self addSubview:self.collectionView];
}

- (void)pm_scrollToCenter
{
    SXMCardItem *selectItem = _items[_selectedIndex];
    if (selectItem.isSelected) {
        if ([_delegate respondsToSelector:@selector(SXMCardSwitchViewDidSelectCenterItem:index:)]) {
            [_delegate SXMCardSwitchViewDidSelectCenterItem:selectItem index:_selectedIndex];
        }
    }
    
    // 清空选中状态
    for (SXMCardItem *item in self.items) {
        item.isSelected = NO;
    }
    
    selectItem.isSelected = YES;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if ([_delegate respondsToSelector:@selector(SXMCardSwitchViewDidSelectItem:index:)]) {
        [_delegate SXMCardSwitchViewDidSelectItem:selectItem index:_selectedIndex];
    }
}

// 配置cell居中
- (void)pm_fixCellToCenter {
    
    // 最小滚动距离
    float dragMiniDistance = self.bounds.size.width / 20.0f;
    if (_dragStartX - _dragEndX >= dragMiniDistance) {
        _selectedIndex -= 1;//向右
    } else if(_dragEndX - _dragStartX >= dragMiniDistance){
        _selectedIndex += 1;//向左
    }
    NSInteger maxIndex = [_collectionView numberOfItemsInSection:0] - 1;
    _selectedIndex = _selectedIndex <= 0 ? 0 : _selectedIndex;
    _selectedIndex = _selectedIndex >= maxIndex ? maxIndex : _selectedIndex;
    
    [self pm_scrollToCenter];
}

@end
