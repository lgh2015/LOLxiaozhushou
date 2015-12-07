//
//  StrategyManager.h
//  项目
//
//  Created by 李国灏 on 15/11/28.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewestModel.h"
@interface StrategyManager : NSObject
+(instancetype)shareManager;

-(void)acquireData:(NSString *)detailStr completion:(void(^)())completion;

-(NewestModel *)getModelByIndex:(NSInteger)index;

-(NSInteger)getArrCount;



@end
