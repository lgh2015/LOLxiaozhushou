//
//  videoCells.h
//  项目
//
//  Created by 李国灏 on 15/11/25.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "VideoModel.h"
@interface videoCells : UITableViewCell

@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *timelabel;
@property(nonatomic,strong)UILabel *dayLabel;

@property(nonatomic,strong)VideoModel *model;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
