//
//  GeneralCell.m
//  项目
//
//  Created by 李国灏 on 15/10/30.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "GeneralCell.h"
#import "UIImageView+WebCache.h"
@implementation GeneralCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(k_screenWidth*5, k_screenWidth*6, k_screenWidth*100, k_screenWidth*80)];
        [self.contentView addSubview:self.imageV];
        
        self.titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth*110, k_screenWidth*6, k_screenWidth*280, k_screenWidth*30)];
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel];
        
        self.summary =[[UILabel alloc]init];
        self.summary.numberOfLines=0;
        self.summary.font =[UIFont systemFontOfSize:14];
        self.summary.textAlignment=NSTextAlignmentLeft;
        self.summary.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:self.summary];

        
        self.timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth*280, k_screenWidth*65, k_screenWidth*85, k_screenWidth*22)];
        self.timeLabel.textAlignment=NSTextAlignmentCenter;
        self.timeLabel.textColor =[UIColor lightGrayColor];
        self.timeLabel.font =[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.timeLabel];
        
    }
    return self;
}

-(void)setModel:(NewestModel *)model
{
    _model = model;
    self.timeLabel.text = model.publication_date;
    self.titleLabel.text = model.title;
    self.summary.text = model.summary;
    
   
    //self.summary.font,要设置比下面的小1 到2号
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15]};
    CGFloat contentW =k_screenWidth* 260;
    CGSize si=CGSizeMake(contentW, 0);
    CGRect labelSize=[self.summary.text boundingRectWithSize:si options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGFloat contentH = labelSize.size.height;
    self.summary.frame=CGRectMake(k_screenWidth*110, k_screenWidth*35, contentW, contentH);
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.image_url_small]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
