//
//  HerosDetailViewController.h
//  项目
//
//  Created by 李国灏 on 15/11/2.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HerosModel.h"

@interface HerosDetailViewController : UIViewController

@property(nonatomic,strong)NSString *detailStr;

@property(nonatomic,strong)HerosModel *model;

@property(nonatomic,strong)NSString *modelname;

@property(nonatomic,strong)NSMutableArray *collectionArr;

@end
