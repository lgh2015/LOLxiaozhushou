//
//  DIYLayout.m
//  集合视图CollectionView
//
//  Created by 李国灏 on 15/10/20.
//  Copyright © 2015年 李国灏. All rights reserved.
//

#import "DIYLayout.h"

@interface DIYLayout ()

//每一列的高度都存到本数组中
@property(nonatomic,strong)NSMutableArray *heightOfList;
//item的个数
@property(nonatomic,assign)NSInteger numberOfItem;
//存所有item的布局信息都存在本数组中
@property(nonatomic,strong)NSMutableArray *itemFrameArr;

@property(nonatomic,assign)CGFloat heightestList;
@end

@implementation DIYLayout

-(NSMutableArray *)heightOfList{
    if (_heightOfList==nil) {
        _heightOfList=[NSMutableArray array];
    }
    return _heightOfList;
}
-(NSMutableArray *)itemFrameArr{
    if (_itemFrameArr ==nil) {
        _itemFrameArr=[NSMutableArray array];
    }
    return _itemFrameArr;
}
-(void)prepareLayout{
    [super prepareLayout];
    for (int i=0; i<self.numberOfList; i++) {
        self.heightOfList[i]=@(self.sectionInsets.top);
    }
    
    //计算每一个item的布局信息
    
    //使用本布局对象的collectionView
    self.numberOfItem=[self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<self.numberOfItem; i++) {
        
        //最短列的下标
        NSInteger shorttestListIndex=[self shortestListIndex];
        //计算本item的X
        CGFloat x=self.sectionInsets.left+(self.itemSize.width+self.itemSpacing)*shorttestListIndex;
        //计算y
        CGFloat y= [self.heightOfList[shorttestListIndex] floatValue]+self.itemSpacing;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i  inSection:0];
        //将indexpath处的cell的布局信息存到attributes对象中
        UICollectionViewLayoutAttributes *attributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(heightForItemWithIndexPath:)]) {
            CGFloat itemheight=[self.delegate heightForItemWithIndexPath:indexPath];
            
            attributes.frame=CGRectMake(k_screenWidth* x,k_screenWidth* y, k_screenWidth*self.itemSize.width, k_screenWidth* itemheight);
            
            [self.itemFrameArr addObject:attributes];
            
            self.heightOfList[shorttestListIndex]=@(y+itemheight);
        }
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.itemFrameArr;
}


// 设置collection的滚动范围
- (CGSize)collectionViewContentSize
{
    CGSize contentSize = self.collectionView.frame.size;
    
    // y方向上的滚动范围应该是最长列的高度 + 下边距
    contentSize.height = [self longestListIndex] + self.sectionInsets.bottom;
    
    return contentSize;
}
-(NSInteger)shortestListIndex
{
    
    NSInteger index = 0;
    
    for (int i = 0; i < self.numberOfList; i++) {
        
        index = [self.heightOfList[index] floatValue] > [self.heightOfList[i] floatValue] ? i : index;
    }
    return index;
}

-(NSInteger)longestListIndex
{NSInteger index = 0;
    
    for (int i = 0; i < self.numberOfList; i++) {
        
        index = self.heightOfList[index] < self.heightOfList[i] ? i : index;
    }
    
    return [self.heightOfList[index] floatValue];
    
}














@end
