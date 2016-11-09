//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import "LSCollectionViewLayoutHelper.h"

@interface LSCollectionViewLayoutHelper ()

@end

@implementation LSCollectionViewLayoutHelper

- (id)initWithCollectionViewLayout:(UICollectionViewLayout<UICollectionViewLayout_Warpable>*)collectionViewLayout
{
    self = [super init];
    if (self) {
        _collectionViewLayout = collectionViewLayout;
    }
    return self;
}

- (NSArray *)modifiedLayoutAttributesForElements:(NSArray *)elements
{
    UICollectionView *collectionView = self.collectionViewLayout.collectionView;
    NSIndexPath *fromIndexPath = self.fromIndexPath;
    NSIndexPath *toIndexPath = self.toIndexPath;
    NSIndexPath *hideIndexPath = self.hideIndexPath;
    NSIndexPath *indexPathToRemove;
    
    if (toIndexPath == nil) {
        if (hideIndexPath == nil) {
            return elements;
        }
        for (UICollectionViewLayoutAttributes *layoutAttributes in elements) {
            if(layoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
                continue;
            }
            if ([layoutAttributes.indexPath isEqual:hideIndexPath]) {
                layoutAttributes.hidden = YES;
            }
        }
        return elements;
    }
    
    //    if (fromIndexPath.section != toIndexPath.section) {
    //        indexPathToRemove = [NSIndexPath indexPathForItem:[collectionView numberOfItemsInSection:fromIndexPath.section] - 1
    //                                                inSection:fromIndexPath.section];
    //    }
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in elements) {
        if(layoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        if([layoutAttributes.indexPath isEqual:indexPathToRemove]) {
            // Remove item in source section and insert item in target section
            layoutAttributes.indexPath = [NSIndexPath indexPathForItem:[collectionView numberOfItemsInSection:toIndexPath.section]
                                                             inSection:toIndexPath.section];
            if (layoutAttributes.indexPath.item != 0) {
                layoutAttributes.center = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:layoutAttributes.indexPath].center;
            }
        }
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        if ([indexPath isEqual:hideIndexPath]) {
            layoutAttributes.hidden = YES;
        }
        if([indexPath isEqual:toIndexPath]) {
            // Item's new location
            if (fromIndexPath.section == toIndexPath.section)
            {
                  layoutAttributes.indexPath = fromIndexPath;
                NSLog(@"modifiedLayoutAttributesForElements ++++%@ \n fromIndexPath----%@ \n toIndexPath ---%@\n fromIndexPath----%@ \n ",  layoutAttributes,fromIndexPath,toIndexPath,indexPath);
            }
            else
            {
                NSIndexPath *index = [NSIndexPath indexPathForItem:fromIndexPath.item
                                                     inSection:fromIndexPath.section];;
                layoutAttributes.center = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:index].center;
                layoutAttributes.hidden = (fromIndexPath.section == toIndexPath.section);
            }
        }
        else if(fromIndexPath.section != toIndexPath.section)
        {
            if(indexPath.section == fromIndexPath.section && indexPath.item == fromIndexPath.item) {
                // Change indexes in source section
                layoutAttributes.hidden = YES;
            }
        }
        else if(indexPath.section == fromIndexPath.section)
        {
             NSLog(@"------elements");
            if(indexPath.item <= fromIndexPath.item && indexPath.item > toIndexPath.item) {
                // Item moved back
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
            }
            else if(indexPath.item >= fromIndexPath.item && indexPath.item < toIndexPath.item) {
                // Item moved forward
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
            }
        }
    }
   
    return elements;
}


@end