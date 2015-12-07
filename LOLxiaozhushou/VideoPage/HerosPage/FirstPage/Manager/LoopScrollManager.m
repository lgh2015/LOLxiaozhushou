//
//  LoopScrollManager.m
//  项目
//
//  Created by 李国灏 on 15/11/28.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "LoopScrollManager.h"
#import "NewestModel.h"
#import "SDWebImageDownloader.h"
@interface LoopScrollManager ()

@property(nonatomic,strong)NSMutableArray *imageArr;

@property(nonatomic,strong)NSMutableArray *titleArr;

@property(nonatomic,strong)NSMutableArray *detailArr;

@end



@implementation LoopScrollManager

-(NSMutableArray *)imageArr
{
    if (_imageArr ==nil) {
        self.imageArr = [[NSMutableArray alloc]init];
    }
    return _imageArr;
}
-(NSMutableArray *)detailArr
{
    if (_detailArr ==nil) {
        self.detailArr = [[NSMutableArray alloc]init];
    }
    return _detailArr;
}

-(NSMutableArray *)titleArr
{
    if (_titleArr ==nil) {
        self.titleArr = [[NSMutableArray alloc]init];
    }
    return _titleArr;
}
-(void)acquireData:(NSString *)detailStr completion:(void (^)())completion
{
    NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
    //如果本地有缓存,就用缓存数据,如果没有,就进行网络请求
    config.requestCachePolicy=NSURLRequestUseProtocolCachePolicy;
    NSURLSession *session =[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask  = [session dataTaskWithURL:[NSURL URLWithString:detailStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!data) {
            return ;
        }
        
        NSMutableDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *arr = [dic objectForKey:@"list"];
        for (NSMutableDictionary *dicc in  arr) {
            [self.titleArr addObject:[dicc objectForKey:@"title"]];
            [self.detailArr addObject:[dicc objectForKey:@"article_url"]];
        }
        for (int i=0; i<4; i++) {
            if (i==0) {
                NSMutableDictionary *dic =arr[3];
                NSString *str =[dic objectForKey:@"image_url_big"];
                UIImage *imgae =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
                [self.imageArr addObject:imgae];
                NSMutableDictionary *dic2 =arr[0];
                NSString *str2 =[dic2 objectForKey:@"image_url_big"];
                UIImage *imgae2 =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str2]]];
                [self.imageArr addObject:imgae2];
            }
            else if (i==3)
            {
                NSMutableDictionary *dic =arr[3];
                NSString *str =[dic objectForKey:@"image_url_big"];
                UIImage *imgae =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
                [self.imageArr addObject:imgae];
                NSMutableDictionary *dic2 =arr[0];
                NSString *str2 =[dic2 objectForKey:@"image_url_big"];
                UIImage *imgae2 =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str2]]];
                [self.imageArr addObject:imgae2];
            }
            else
            {
                NSMutableDictionary *dic =arr[i];
                NSString *str =[dic objectForKey:@"image_url_big"];
                UIImage *imgae =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
                [self.imageArr addObject:imgae];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    }];
    [dataTask resume];
}

-(NSMutableArray *)getImageArr
{
    return self.imageArr;
}
-(NSMutableArray *)getTitleArr
{
    return self.titleArr;
}
-(NSMutableArray *)getDetailArr
{
    return self.detailArr;
}

+(instancetype)shareManager
{
    static LoopScrollManager *manager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LoopScrollManager alloc]init];
    });
    return manager;
}
@end
