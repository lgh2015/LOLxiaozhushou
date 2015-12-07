//
//  GeneralCell.h
//  项目
//
//  Created by 李国灏 on 15/10/30.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewestModel.h"
@interface GeneralCell : UITableViewCell


@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *summary;

@property(nonatomic,strong)NewestModel *model;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
