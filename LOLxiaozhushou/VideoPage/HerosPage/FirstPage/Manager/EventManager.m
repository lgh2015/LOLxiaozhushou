//
//  EventManager.m
//  项目
//
//  Created by 李国灏 on 15/11/28.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "EventManager.h"


@interface EventManager ()

@property(nonatomic,strong)NSMutableArray *modelArr;

@end

@implementation EventManager

-(NSMutableArray *)modelArr
{
    if (_modelArr ==nil) {
        self.modelArr = [[NSMutableArray alloc]init];
    }
    return _modelArr;
}

-(void)acquireData:(NSString *)detailStr completion:(void (^)())completion
{
    NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
    //如果本地有缓存,就用缓存数据,如果没有,就进行网络请求
    config.requestCachePolicy=NSURLRequestUseProtocolCachePolicy;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask =[session dataTaskWithURL:[NSURL URLWithString:detailStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!data) {
            return ;
        }
            
        
        NSMutableDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *arr = [dic objectForKey:@"list"];
        
        for (NSMutableDictionary *dicc in arr) {
            NewestModel *model =[[NewestModel alloc]initWithDictionary:dicc];
            [self.modelArr addObject:model];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    }];
    [dataTask resume];
}

-(NSInteger)getArrCount
{
    return self.modelArr.count;
}
-(NewestModel *)getModelByIndex:(NSInteger)index
{
    return self.modelArr[index];
}


+(instancetype)shareManager
{
    static EventManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager =[[EventManager alloc]init];
    });
    return manager;
}


@end
