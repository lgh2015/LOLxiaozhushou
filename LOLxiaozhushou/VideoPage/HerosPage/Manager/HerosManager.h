//
//  HerosManager.h
//  项目
//
//  Created by 李国灏 on 15/11/19.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HerosModel.h"



@interface HerosManager : NSObject




-(void)acquireDataCompletion:(void (^)())completion;

+(instancetype)shareInfoManager;

-(id)getModels:(NSInteger)index;

-(NSMutableArray *)getHerosArr;

-(NSMutableArray *)getFreeArr;

-(NSMutableArray *)getNameArr;

@end
