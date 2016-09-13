//
//
//  PhotoFlowLayout.m
//  玩记
//
//  Created by monica on 16/6/30.
//  Copyright © 2016年 ClassroomM. All rights reserved.//

#import "PhotoFlowLayout.h"

@implementation PhotoFlowLayout


/**
 *  在实例化的时候, collectionView还没有实例化, 所以在这个方法里,实例化的时候取不到collectionView的frame
 *
 *
 */
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}


#pragma mark -
#pragma mark - 这个方法会反回所有cell的属性设置
// 反回的数组中, 是 UICollectionViewLayoutAttributes 对象, 包含了cell的属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 1. 取出所有的item 的 UICollectionViewLayoutAttributes

    NSArray *superAttributes = [super layoutAttributesForElementsInRect:rect];
    
    // 2. 计算出屏幕的中心点, 中心点必须加上 collectionView的偏移量.x
    CGFloat screenCenter = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
    
    // 通过循环遍历 可以对 item的属性进行修改
    for (UICollectionViewLayoutAttributes *itemAttributes in superAttributes) {
        
        // 3. 计算差值 ABS() 取绝对值
        CGFloat deltaMargin = ABS(screenCenter - itemAttributes.center.x);
        
        // 4. 计算一个放大比率 , cell 和中心点的距离  和 方大的比率成反比
        CGFloat scaleDelta = 1.1 - deltaMargin / (self.collectionView.frame.size.width/2 + itemAttributes.size.width);
        
        
        itemAttributes.transform = CGAffineTransformMakeScale(scaleDelta, scaleDelta);
    }
    
    return superAttributes;
}

#pragma mark -
#pragma mark -  当手指离开collectionView的时候会调用
/**
 targetContentOffset     --- > 最终停留的位置 (进行干预后停留的位置)
 
 ProposedContentOffset   --->  本应该停留的位置
 
 velocity  力度, 速度
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    // 1. 取出屏幕的中心点
    CGFloat screenCenter = proposedContentOffset.x + self.collectionView.frame.size.width/2;
    
    // 2. 取出可见范围内的cell
    CGRect visibleRect = CGRectZero;
    
    visibleRect.size = self.collectionView.frame.size;
    visibleRect.origin = proposedContentOffset;
    
    //  得到的是 可见范围内的cell属性集合  调用super 的方法, 是避免重新计算比率
    NSArray *visibleArray = [super layoutAttributesForElementsInRect:visibleRect];
    
    // 定义最小的 间距
    CGFloat minMargin = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attributes in visibleArray) {
        // 计算cell的中心点 和  屏幕中心点的差值
        CGFloat deltaMargin = attributes.center.x - screenCenter;
        
        if (ABS(minMargin) > ABS(deltaMargin)) {
            
            minMargin = deltaMargin;
        }

    }
    
    return CGPointMake(proposedContentOffset.x + minMargin, proposedContentOffset.y);
}

#pragma mark -
#pragma mark -  当屏幕的可见范围发生变化的时候, 要重新刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}


#pragma mark -
#pragma mark - 当布局刷新的时候, 就会自动调用这个方法
// 建议在这个方法里进行初始化的设置
- (void)prepareLayout {
    [super prepareLayout];
    
    // 修改滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 取出collectionView的size
    CGSize collectionViewSize = self.collectionView.frame.size;
    
    // 设置item的宽高
    CGFloat itemWidth = collectionViewSize.height * 0.6;
    
    // 设置item的高度
    CGFloat itemHeight = collectionViewSize.height * 0.8;
    
    // 修改item的size
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    // 设置头部和尾部的初始间距
    CGFloat margin = collectionViewSize.width/2 - itemWidth/2;
    
    self.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
}

@end
