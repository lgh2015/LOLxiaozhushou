//
//  HerosCell.m
//  项目
//
//  Created by 李国灏 on 15/10/30.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "HerosCell.h"
#import "UIImageView+WebCache.h"

@interface HerosCell ()
@property(strong,nonatomic)UILabel *nameLabel;

@property(strong,nonatomic)UIImageView *imageV;

@end

@implementation HerosCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.imageV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70*k_screenWidth, 67*k_screenWidth)];
        [self.contentView addSubview:self.imageV];
        self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 67*k_screenWidth, 70*k_screenWidth, 17*k_screenWidth)];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    
}


-(void)setModel:(HerosModel *)model
{
    _model=model;
    self.nameLabel.text=_model.herosName;
    self.nameLabel.font=[UIFont systemFontOfSize:14];
    self.nameLabel.textAlignment=NSTextAlignmentCenter;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:_model.herosScr]];
    
}

@end
