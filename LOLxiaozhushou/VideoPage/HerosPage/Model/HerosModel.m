//
//  HerosModel.m
//  项目
//
//  Created by 李国灏 on 15/11/19.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "HerosModel.h"

@implementation HerosModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.herosName forKey:@"herosName"];
    [aCoder encodeObject:self.herosScr forKey:@"herosScr"];
    [aCoder encodeObject:self.herosDetail forKey:@"herosDetail"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.herosName = [aDecoder decodeObjectForKey:@"herosName"];
        self.herosScr = [aDecoder decodeObjectForKey:@"herosScr"];
        self.herosDetail = [aDecoder decodeObjectForKey:@"herosDetail"];
    }
    return self;
}





@end
