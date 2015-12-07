//
//  LoopScrollManager.h
//  项目
//
//  Created by 李国灏 on 15/11/28.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoopScrollManager : NSObject


+(instancetype)shareManager;

-(void)acquireData:(NSString *)detailStr completion:(void(^)())completion;

-(NSMutableArray *)getImageArr;

-(NSMutableArray *)getTitleArr;

-(NSMutableArray *)getDetailArr;


@end
