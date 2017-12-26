//
//  SXMCardSwitchFlowLayout.m
//  SXMCardSwitch
//
//  Created by 1 on 2017/12/26.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import "SXMCardSwitchFlowLayout.h"

// 居中卡片宽度与据屏幕宽度比例
static float CardWidthScale = 0.7f;
static float CardHeightScale = 0.8f;

@implementation SXMCardSwitchFlowLayout

// 初始化方法
- (void)prepareLayout {
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, [self pm_collectionInset], 0, [self pm_collectionInset]);
}

// 设置缩放动画
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 扩大控制范围，防止出现闪屏现象
    CGRect bigRect = rect;
    bigRect.size.width = rect.size.width + 2 * [self pm_cellWidth];
    bigRect.origin.x = rect.origin.x - [self pm_cellWidth];
    
    NSArray *arr = [super layoutAttributesForElementsInRect:bigRect];
    //屏幕中线
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.0f;
    //刷新cell缩放
    for (UICollectionViewLayoutAttributes *attributes in arr) {
        CGFloat distance = fabs(attributes.center.x - centerX);
        //移动的距离和屏幕宽度的的比例
        CGFloat apartScale = distance / self.collectionView.bounds.size.width;
        //把卡片移动范围固定到 -π/4到 +π/4这一个范围内
        CGFloat scale = fabs(cos(apartScale * M_PI/4));
        //设置cell的缩放 按照余弦函数曲线 越居中越趋近于1
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return arr;
}

// 卡片宽度
- (CGFloat)pm_cellWidth {
    return self.collectionView.bounds.size.width * CardWidthScale;
}

// 卡片间隔
- (float)pm_cellMargin {
    return 5;
}

// 设置左右缩进
- (CGFloat)pm_collectionInset {
//    return self.collectionView.bounds.size.width / 2.0f - [self pm_cellWidth] / 2.0f;
    return (self.collectionView.bounds.size.width - [self pm_cellWidth]) / 2.0f;
}

// 最小纵向间距
- (CGFloat)minimumLineSpacing {
    return [self pm_cellMargin];
}
// cell大小
- (CGSize)itemSize {
    return CGSizeMake([self pm_cellWidth], self.collectionView.bounds.size.height * CardHeightScale);
}

// 是否实时刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
}

@end
