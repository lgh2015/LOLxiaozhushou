//
//  NewestModel.m
//  项目
//
//  Created by 李国灏 on 15/11/28.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "NewestModel.h"

@implementation NewestModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(instancetype)initWithDictionary:(NSMutableDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}


@end
