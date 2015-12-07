//
//  DIYLayout.h
//  集合视图CollectionView
//
//  Created by 李国灏 on 15/10/20.
//  Copyright © 2015年 李国灏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DIYLayoutDelegate <UICollectionViewDelegate>

-(CGFloat)heightForItemWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface DIYLayout : UICollectionViewLayout
//Item的大小  实际上只要宽度
@property(nonatomic,assign)CGSize itemSize;

@property(nonatomic,assign)NSInteger numberOfList;

@property(nonatomic,assign)CGFloat itemSpacing;

@property(nonatomic,assign)UIEdgeInsets sectionInsets;

@property(nonatomic,retain)id<DIYLayoutDelegate>delegate;

@end
