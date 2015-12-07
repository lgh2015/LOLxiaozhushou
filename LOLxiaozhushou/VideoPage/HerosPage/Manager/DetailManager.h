//
//  DetailManager.h
//  项目
//
//  Created by 李国灏 on 15/11/23.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DetailManager : NSObject

+(instancetype)shareInfoManager;

-(void)acquireData:(NSString *)detailStr Completion:(void (^)())completion;

-(void)acquireData:(void(^)())completion;

-(NSString *)getName;

-(NSString *)getSrcStr;

-(NSString *)getLocation;

-(NSMutableArray *)getColorArr;

-(NSMutableArray *)getSkillArr;

-(NSMutableArray *)getSkillPicArr;

-(NSMutableArray *)getTechAndStoryArr;



@end
