//
//  VideoDetailInfoManager.m
//  项目
//
//  Created by 李国灏 on 15/11/26.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "VideoDetailInfoManager.h"
#import "TFHpple.h"

@implementation VideoDetailInfoManager

-(void)acquireData:(NSString *)detailStr  completion:(void (^)())completion
{
    NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:detailStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        TFHpple *tfhpple = [[TFHpple alloc]initWithHTMLData:data];
        
        NSArray *arr =[tfhpple searchWithXPathQuery:@"//div"];
        for (TFHppleElement *ele in arr) {
            if ([[ele objectForKey:@"class"]isEqualToString:@"box-sp5"]) {
                for (TFHppleElement *ele2 in ele.children) {
                    if ([ele2.tagName isEqualToString:@"iframe"]) {
                        self.videoStr = [ele2 objectForKey:@"src"];
                    }
                    if (self.videoStr==nil) {
                        if ([ele2.tagName isEqualToString:@"embed"]) {
                            self.videoStr = [ele2 objectForKey:@"src"];
                        }
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    }];
    [dataTask resume];
}
-(NSString *)getVideoStr
{
    return self.videoStr;
}

+(instancetype)shareInfoManager
{
    static VideoDetailInfoManager *videoDetailManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoDetailManager = [[VideoDetailInfoManager alloc]init];
    });
    return videoDetailManager;
}



@end
