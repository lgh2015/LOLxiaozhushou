//
//  videoCells.m
//  项目
//
//  Created by 李国灏 on 15/11/25.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "videoCells.h"
#import "UIImageView+WebCache.h"

@implementation videoCells

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor=[UIColor clearColor];
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(k_screenWidth*10, k_screenWidth*10, k_screenWidth*130, k_screenWidth*100)];
        self.imageV.backgroundColor=[UIColor purpleColor];
        [self.contentView addSubview:self.imageV];
        
        self.titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth*150, k_screenWidth*10, k_screenWidth*200, k_screenWidth*55)];
        self.titleLabel.numberOfLines=0;
        self.timelabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        
        self.dayLabel =[[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth*320, k_screenWidth*80, k_screenWidth*40, k_screenWidth*25)];
        self.dayLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.dayLabel];
        
        self.timelabel = [[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth*10, k_screenWidth*10, k_screenWidth*30, k_screenWidth*20)];
        self.timelabel.backgroundColor=[UIColor blackColor];
        self.timelabel.font=[UIFont systemFontOfSize:10];
        self.timelabel.textColor=[UIColor whiteColor];
        self.timelabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.timelabel];
    }
    return self;
}

-(void)setModel:(VideoModel *)model
{
    _model= model;
    self.titleLabel.text=model.title;
    self.timelabel.text =model.time;
    self.dayLabel.text=model.day;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.picture]];
}


- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
