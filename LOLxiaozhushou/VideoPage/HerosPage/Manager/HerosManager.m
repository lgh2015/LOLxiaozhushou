//
//  HerosManager.m
//  项目
//
//  Created by 李国灏 on 15/11/19.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "HerosManager.h"
#import "TFHpple.h"

@interface HerosManager ()

@property(nonatomic,strong)NSMutableArray *herosListArr;

@property(nonatomic,strong)NSMutableArray *freeArr;

@property(nonatomic,strong)NSMutableArray *nameArr;
@end


@implementation HerosManager


+(instancetype)shareInfoManager
{
    static HerosManager *herosManager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        herosManager =[[HerosManager alloc]init];
    });
    return herosManager;
}



-(NSMutableArray *)herosListArr
{
    if (!_herosListArr) {
         self.herosListArr =[[NSMutableArray alloc]init];
    }
    return _herosListArr;
}
-(NSMutableArray *)freeArr
{
    if (!_freeArr ) {
        self.freeArr =[[NSMutableArray alloc]init];
    }
    return _freeArr;
}
-(NSMutableArray *)nameArr
{
    if (!_nameArr) {
        self.nameArr =[[NSMutableArray alloc]init];
    }
    return _nameArr;
}

-(void)acquireDataCompletion:(void (^)())completion
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //如果本地有缓存,就用缓存数据,如果没有,就进行网络请求
    config.requestCachePolicy=NSURLRequestUseProtocolCachePolicy;
    config.timeoutIntervalForRequest = 15;
    config.timeoutIntervalForResource= 15;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURL *URL=[NSURL URLWithString:@"http://cha.17173.com/lol/"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!data) {
            return ;
        }
        TFHpple *hpple=[[TFHpple alloc]initWithHTMLData:data];
        NSArray *Arr=[hpple searchWithXPathQuery:@"//ul"];
        for (TFHppleElement *ele in Arr) {
            if ([[ele objectForKey:@"class"] isEqualToString:@"games_list"]) {
                for (TFHppleElement *ELE in ele.children) {
                    if ([ELE.tagName isEqualToString:@"li"]) {
                        HerosModel *Hmodel = [[HerosModel alloc]init];
                        for (TFHppleElement *hppleElement in ELE.children) {
                            if ([hppleElement.tagName isEqualToString:@"a"]) {
                                Hmodel.herosName=[hppleElement objectForKey:@"title"];
                                Hmodel.herosDetail=[hppleElement objectForKey:@"href"];
                                for (TFHppleElement *ele2 in hppleElement.children) {
                                    if ([ele2.tagName isEqualToString:@"img"]) {
                                        Hmodel.herosScr=[ele2 objectForKey:@"src"];
                                    }
                                }
                                [self.nameArr addObject:[hppleElement objectForKey:@"title"]];
                            }
                        }
                        [self.herosListArr addObject:Hmodel];
                    }
                }
            }
        }
        [self.freeArr addObject:self.herosListArr[51]];
        [self.freeArr addObject:self.herosListArr[106]];
        [self.freeArr addObject:self.herosListArr[115]];
        for (int i=1; i<11; i++) {
            [self.freeArr addObject:self.herosListArr[i*3+11]];
        }
        //在主线程里面刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    }];
    [dataTask resume];
}

-(id)getModels:(NSInteger)index
{
    return self.herosListArr[index];
}

-(NSMutableArray *)getHerosArr
{
    return self.herosListArr;
}
-(NSMutableArray *)getFreeArr
{
    return self.freeArr;
}
-(NSMutableArray *)getNameArr
{
    return self.nameArr;
}

@end
