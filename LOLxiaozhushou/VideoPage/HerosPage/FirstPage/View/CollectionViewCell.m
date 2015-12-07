//
//  CollectionViewCell.m
//  集合视图CollectionView
//
//  Created by 李国灏 on 15/10/20.
//  Copyright © 2015年 李国灏. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //imageView只在cell的初始化方法中设置过一次Frame
        self.imageView=[[UIImageView alloc]initWithFrame:self.bounds];
        self.imageView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame=self.contentView.bounds;
}


@end
