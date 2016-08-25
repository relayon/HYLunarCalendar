//
//  HYCalendarLayout.m
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/24.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "HYCalendarLayout.h"
#import "SeparatorLine.h"

#define H_TOP       @"H_TOP"
#define H_BOTTOM    @"H_BOTTOM"
#define V_LEFT      @"V_LEFT"
#define V_RIGHT     @"V_RIGHT"

@implementation HYCalendarLayout

- (instancetype) init {
    self = [super init];
    if (self) {
        self.lineWidth = 1.0f;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    NSString* name = NSStringFromClass([SeparatorLine class]);
    UINib* nib = [UINib nibWithNibName:name bundle:[NSBundle mainBundle]];
    [self registerNib:nib forDecorationViewOfKind:H_TOP];
    [self registerNib:nib forDecorationViewOfKind:H_BOTTOM];
    [self registerNib:nib forDecorationViewOfKind:V_LEFT];
    [self registerNib:nib forDecorationViewOfKind:V_RIGHT];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
    CGRect baseFrame = cellAttributes.frame;
    
    CGFloat strokeWidth = self.lineWidth;
//    CGFloat spaceToNextItem = 0;
    if ([decorationViewKind isEqualToString:H_TOP]) {
        CGFloat x = baseFrame.origin.x;
        layoutAttributes.frame = CGRectMake(x,
                                            baseFrame.origin.y,
                                            baseFrame.size.height,
                                            strokeWidth);
    } else if ([decorationViewKind isEqualToString:V_LEFT]) {
        CGFloat x = baseFrame.origin.x;
        layoutAttributes.frame = CGRectMake(x,
                                            baseFrame.origin.y,
                                            strokeWidth,
                                            baseFrame.size.width);
    }
    
#if 0
    CGFloat padding = 10;
    if ([decorationViewKind isEqualToString:SP_VERTICAL]) {
        CGFloat x = baseFrame.origin.x + baseFrame.size.width;
        layoutAttributes.frame = CGRectMake(x,
                                            baseFrame.origin.y + padding,
                                            strokeWidth,
                                            baseFrame.size.height - padding*2);
    } else if ([decorationViewKind isEqualToString:SP_HORIZONTAL]) {
        // Positions the horizontal line for this item.
        layoutAttributes.frame = CGRectMake(baseFrame.origin.x + padding,
                                            baseFrame.origin.y + baseFrame.size.height,
                                            baseFrame.size.width + spaceToNextItem - padding*2,
                                            strokeWidth);
    }
#endif
    //    layoutAttributes.zIndex = -1;
    layoutAttributes.zIndex = 100;
    return layoutAttributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *baseLayoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * layoutAttributes = [baseLayoutAttributes mutableCopy];
    
    for (UICollectionViewLayoutAttributes *thisLayoutItem in baseLayoutAttributes) {
        if (thisLayoutItem.representedElementCategory == UICollectionElementCategoryCell) {
            UICollectionViewLayoutAttributes *itemTop = [self layoutAttributesForDecorationViewOfKind:H_TOP atIndexPath:thisLayoutItem.indexPath];
            [layoutAttributes addObject:itemTop];
            
            UICollectionViewLayoutAttributes *itemLeft = [self layoutAttributesForDecorationViewOfKind:V_LEFT atIndexPath:thisLayoutItem.indexPath];
            [layoutAttributes addObject:itemLeft];
#if 0
            // Adds vertical lines when the item isn't the last in a section or in line.
            if (!([self indexPathLastInSection:thisLayoutItem.indexPath] ||
                  [self indexPathLastInLine:thisLayoutItem.indexPath])) {
                UICollectionViewLayoutAttributes *newLayoutItem = [self layoutAttributesForDecorationViewOfKind:SP_VERTICAL atIndexPath:thisLayoutItem.indexPath];
                [layoutAttributes addObject:newLayoutItem];
            }
            
            // Adds horizontal lines when the item isn't in the last line.
            if (![self indexPathInLastLine:thisLayoutItem.indexPath]) {
                UICollectionViewLayoutAttributes *newHorizontalLayoutItem = [self layoutAttributesForDecorationViewOfKind:SP_HORIZONTAL atIndexPath:thisLayoutItem.indexPath];
                [layoutAttributes addObject:newHorizontalLayoutItem];
            }
#endif
        }
    }
    
    return layoutAttributes;
}

// ---------------------------
- (BOOL)indexPathLastInSection:(NSIndexPath *)indexPath {
    NSInteger lastItem = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:indexPath.section] -1;
    return  lastItem == indexPath.row;
}

- (BOOL)indexPathInLastLine:(NSIndexPath *)indexPath {
    NSInteger lastItemRow = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:indexPath.section] -1;
    NSIndexPath *lastItem = [NSIndexPath indexPathForItem:lastItemRow inSection:indexPath.section];
    UICollectionViewLayoutAttributes *lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastItem];
    UICollectionViewLayoutAttributes *thisItemAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    
    return lastItemAttributes.frame.origin.y == thisItemAttributes.frame.origin.y;
}

- (BOOL)indexPathLastInLine:(NSIndexPath *)indexPath {
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.row+1 inSection:indexPath.section];
    
    UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *nextCellAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
    
    return !(cellAttributes.frame.origin.y == nextCellAttributes.frame.origin.y);
}

@end
