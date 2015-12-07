//
//  VideoDetailInfoManager.h
//  项目
//
//  Created by 李国灏 on 15/11/26.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoDetailInfoManager : NSObject

@property(nonatomic,strong)NSString *detailStr;

@property(nonatomic,strong)NSString *videoStr;

+(instancetype)shareInfoManager;

-(void)acquireData:(NSString *)detailStr completion:(void(^)())completion;

-(NSString *)getVideoStr;

@end
