//
//  VideoManager.h
//  项目
//
//  Created by 李国灏 on 15/11/24.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoManager : NSObject

+(instancetype)shareInfoManager;

-(void)acquireData:(NSString *)str Completion:(void (^)())completion;

-(VideoManager *)getModelArr:(NSInteger)index;

-(NSUInteger)getArrCount;
@end
