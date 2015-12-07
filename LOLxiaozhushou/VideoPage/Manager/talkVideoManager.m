//
//  talkVideoManager.m
//  项目
//
//  Created by 李国灏 on 15/12/4.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "talkVideoManager.h"

#import "TFHpple.h"
#import "VideoModel.h"

@interface talkVideoManager ()

@property(nonatomic,strong)TFHpple *tfhpple;

@property(nonatomic,strong)VideoModel *videoModel;

@property(nonatomic,strong)NSMutableArray *videoModelArr;

@end

@implementation talkVideoManager

-(void)acquireData:(NSString *)str Completion:(void (^)())completion
{
    NSURL *url =[NSURL URLWithString:str];
    NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *DataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!data) {
            return ;
        }
        self.tfhpple =[[TFHpple alloc]initWithHTMLData:data];
        [self title];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    }];
    [DataTask resume];
}

-(void)title
{
    NSArray *arr =[self.tfhpple searchWithXPathQuery:@"//div"];
    for (TFHppleElement *ele in arr) {
        if ([[ele objectForKey:@"class"] isEqualToString:@"newly newly87 newly86 clearfix"]) {
            for (TFHppleElement *lee in ele.children) {
                if ([lee.tagName isEqualToString:@"dl"]) {
                    for (TFHppleElement *lee2 in lee.children) {
                        if ([lee2.tagName isEqualToString:@"dt"]) {
                            VideoModel *VModel =[[VideoModel alloc]init];
                            for (TFHppleElement *ele2 in lee2.children) {
                                if ([ele2.tagName isEqualToString:@"a"]) {
                                    VModel.title =[ele2 objectForKey:@"title"];
                                    VModel.detail =[ele2 objectForKey:@"href"];
                                    for (TFHppleElement *ele3 in ele2.children) {
                                        if ([ele3.tagName isEqualToString:@"b"]) {
                                            NSString *day =[ele3.content substringFromIndex:3];
                                            VModel.day = day;
                                        }
                                        if ([ele3.tagName isEqualToString:@"p"]) {
                                            NSString *jpg =[[ele3 objectForKey:@"style"]  substringWithRange:NSMakeRange(22, [ele3 objectForKey:@"style"].length-24)];
                                            VModel.picture = jpg;
                                            for (TFHppleElement *ele4 in ele3.children) {
                                                if ([ele4.tagName isEqualToString:@"strong"]) {
                                                    VModel.time = ele4.content;
                                                }
                                            }
                                        }
                                    }
                                    [self.videoModelArr addObject:VModel];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

-(VideoModel *)getModelArr:(NSInteger)index
{
    return self.videoModelArr[index];
}
-(NSUInteger)getArrCount
{
    return self.videoModelArr.count;
}

+(instancetype)shareInfoManager
{
    static talkVideoManager *videoManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoManger = [[talkVideoManager alloc]init];
    });
    return  videoManger;
}

#pragma mark--懒加载

-(NSMutableArray *)videoModelArr
{
    if (_videoModelArr==nil) {
        self.videoModelArr=[[NSMutableArray alloc]init];
    }
    return _videoModelArr;
}
@end
