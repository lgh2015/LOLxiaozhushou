//
//  talkVideoManager.h
//  项目
//
//  Created by 李国灏 on 15/12/4.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface talkVideoManager : NSObject
+(instancetype)shareInfoManager;

-(void)acquireData:(NSString *)str Completion:(void (^)())completion;

-(talkVideoManager *)getModelArr:(NSInteger)index;

-(NSUInteger)getArrCount;
@end
