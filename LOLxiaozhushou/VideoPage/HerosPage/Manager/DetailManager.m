//
//  DetailManager.m
//  项目
//
//  Created by 李国灏 on 15/11/23.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "DetailManager.h"
#import "TFHpple.h"

@interface DetailManager ()

@property(nonatomic,strong)NSString *str;

@property(nonatomic,strong)TFHpple *tfhpple;

@property(nonatomic,strong)TFHpple *tfhpple2;

@property(nonatomic,strong)NSString *SrcStr;

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSMutableArray *colorArr;

@property(nonatomic,strong)NSString *location;

@property(nonatomic,strong)NSMutableArray *skillPicArr;

@property(nonatomic,strong)NSString *skillDescribe;

@property(nonatomic,strong)NSMutableArray *skillArr;

@property(nonatomic,strong)NSString *story;

@property(nonatomic,strong)NSMutableArray *techAndStoryArr;

@end

@implementation DetailManager

-(void)acquireData:(NSString *)detailStr Completion:(void (^)())completion
{
    NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
    //如果本地有缓存,就用缓存数据,如果没有,就进行网络请求
    config.requestCachePolicy=NSURLRequestUseProtocolCachePolicy;
    config.timeoutIntervalForRequest = 15;
    config.timeoutIntervalForResource= 15;
    NSURLSession *session =[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:detailStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data) {
            return ;
        }
        self.tfhpple =[[TFHpple alloc]initWithHTMLData:data];
            
        [self ScrAndName];
        [self colorProgress];
        [self locations];
        [self skill];
        [self.techAndStoryArr removeAllObjects];
        [self storys];

        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    }];
    
    [dataTask resume];
}

-(void)acquireData:(void (^)())completion
{
    
    NSArray *arr2 =[self.tfhpple searchWithXPathQuery:@"//div"];
    self.story =[[NSString alloc]init];
    for (TFHppleElement *ele7 in arr2) {
        if ([[ele7 objectForKey:@"class"]isEqualToString:@"xx_sq"]) {
            if (ele7.content) {
                self.story = [self.story stringByAppendingString:[NSString stringWithFormat:@"%@\n\n",ele7.content]];
            }
            else
            {
                break;
            }
        }
    }
    
    NSArray *arr =[self.tfhpple searchWithXPathQuery:@"//div"];
    for (TFHppleElement *ele in arr) {
        if ([[ele objectForKey:@"class"] isEqualToString:@"hero_content_nav"]) {
            for (TFHppleElement *ele2 in ele.children) {
                if ([ele2.tagName isEqualToString:@"h5"]) {
                    for (TFHppleElement *ele3 in ele2.children) {
                        if ([ele3.tagName isEqualToString:@"a"]) {
                            NSString *url=[ele3 objectForKey:@"href"];
                            if ([url containsString:@"#js"]) {
                                NSString *str =[NSString stringWithFormat:@"http://cha.17173.com%@",url];
                                
                                NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
                                //如果本地有缓存,就用缓存数据,如果没有,就进行网络请求
                                config.requestCachePolicy=NSURLRequestUseProtocolCachePolicy;
                                config.timeoutIntervalForRequest = 15;
                                config.timeoutIntervalForResource= 15;
                                NSURLSession *session =[NSURLSession sessionWithConfiguration:config];
                                NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:str] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                    
                                    if (!data) {
                                        return ;
                                    }
                                    self.tfhpple2 =[[TFHpple alloc]initWithHTMLData:data];
                                    [self getTfhpple2];
                                    [self.techAndStoryArr addObject:self.story];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        completion();
                                    });
                                }];
                                [dataTask resume];
                                
                            }
                        }
                    }
                }
            }
        }
    }

}

-(void)ScrAndName
{
    NSArray *arr=[self.tfhpple searchWithXPathQuery:@"//div"];
    
    for (TFHppleElement *ele in arr) {
        
        if ([[ele objectForKey:@"class"] isEqualToString:@"hero_box"]) {
            for (TFHppleElement *ele2 in ele.children) {
                if ([ele2.tagName isEqualToString:@"img"]) {
                    if ([[ele2 objectForKey:@"class"]isEqualToString:@"img none"]) {
                        self.SrcStr = [ele2 objectForKey:@"src"];
                    }
                }
            }
        }
        if ([[ele objectForKey:@"class" ]isEqualToString:@"hero_parameter_tit"]) {
            for (TFHppleElement *ele2 in ele.children) {
                if ([ele2.tagName isEqualToString:@"h1"]) {
                    self.name = ele2.text;
                }
            }
        }
    }
}

-(void)colorProgress
{
    [self.colorArr removeAllObjects];
    NSArray *arr= [self.tfhpple searchWithXPathQuery:@"//li"];
    for (TFHppleElement *ele in arr) {
        for (int i=1; i<5 ; i++) {
            if ([[ele objectForKey:@"class"] isEqualToString:[NSString stringWithFormat:@"c_%d",i]]) {
                for (TFHppleElement *ele2 in ele.children) {
                    if ([ele2.tagName isEqualToString:@"em"]) {
                        NSString *str =[[NSString alloc]init];
                        str=[ele2 objectForKey:@"style"];
                        str=[str substringWithRange:NSMakeRange(6, 2)];
                        [self.colorArr addObject:str];
                    }
                }
            }
        }
    }
}

-(void)locations
{
    NSArray *arr= [self.tfhpple searchWithXPathQuery:@"//ul"];
    for (TFHppleElement *ele in arr) {
        if ([[ele objectForKey:@"class"] isEqualToString:@"info_li"]) {
            for (TFHppleElement *ele2 in ele.children) {
                if ([ele2.tagName isEqualToString:@"li"]) {
                    for (TFHppleElement *ele3 in ele2.children) {
                        if (self.location==nil) {
                            if ([ele3.tagName isEqualToString:@"span"]) {
                                self.location =ele3.text;
                            }
                        }
                    }
                }
            }
        }
    }
}

-(void)skill
{
    [self.skillArr removeAllObjects];
    [self.skillPicArr removeAllObjects];
    NSInteger k=0;
    NSArray *arr= [self.tfhpple searchWithXPathQuery:@"//ul"];
    for (TFHppleElement *ele in  arr) {
        if ([[ele objectForKey:@"class"] isEqualToString:@"content_li"]) {
            for (TFHppleElement *ele2 in ele.children) {
                if ([ele2.tagName isEqualToString:@"li"]) {
                    for (TFHppleElement *ele3 in ele2.children) {
                        if ([ele3.tagName isEqualToString:@"a"]) {
                            for (TFHppleElement *ele4 in ele3.children) {
                                if ([ele4.tagName isEqualToString:@"img"]) {
                                    [self.skillPicArr addObject:[ele4 objectForKey:@"src"]];
                                }
                            }
                        }
                        
                        if ([ele3.tagName isEqualToString:@"ul"]) {
                            self.skillDescribe=@"";
                            for (TFHppleElement *ele4 in ele3.children) {
                                if ([ele4.tagName isEqualToString:@"li"]) {

                                    for (TFHppleElement *ele5 in ele4.children) {
                                        if (ele5.text!=nil) {
                                            if (![ele5.content containsString:@"【快捷键"]) {
                                                if (k==0) {
                                            self.skillDescribe = [self.skillDescribe stringByAppendingString:[NSString stringWithFormat:@"%@(被动)\n",ele5.content]];
                                                k++;
                                                }
                                                else
                                                {
                                                   self.skillDescribe = [self.skillDescribe stringByAppendingString:ele5.content];
                                                }
                                            }
                                            else
                                            {
                                                self.skillDescribe = [self.skillDescribe stringByAppendingString:[NSString stringWithFormat:@"%@\n",ele5.content]];
                                            }
                                        }
                                    }
                                    self.skillDescribe =[self.skillDescribe stringByAppendingString:@"\n"];
                                }
                            }
                           [self.skillArr addObject:self.skillDescribe];
                        }
                    }
                }
            }
        }
    }
}

-(void)storys
{
    
}

-(void)tech
{
    
}



-(void)getTfhpple2
{
    NSArray *arr3 =[self.tfhpple2 searchWithXPathQuery:@"//ul"];
    for (TFHppleElement *ele in arr3) {
        if ([[ele objectForKey:@"class"]isEqualToString:@"hero_word"]) {
            for (TFHppleElement *ele2 in ele.children) {
                if ([ele2.tagName isEqualToString:@"li"]) {
                    for (TFHppleElement *ele3 in ele2.children) {
                        if ([ele3.tagName isEqualToString:@"p"]){
                            [self.techAndStoryArr addObject:ele3.content];
                        }
                    }
                }
            }
        }
    }
}







-(NSString *)getSrcStr
{
    return self.SrcStr;
}
-(NSString *)getName
{
    return self.name;
}
-(NSString *)getLocation
{
    return self.location;
}
-(NSMutableArray *)getColorArr
{
    return self.colorArr;
}
-(NSMutableArray *)getSkillArr
{
    return self.skillArr;
}
-(NSMutableArray *)getSkillPicArr
{
    return self.skillPicArr;
}
-(NSMutableArray *)getTechAndStoryArr
{
    return self.techAndStoryArr;
}


+(instancetype)shareInfoManager
{
    static DetailManager *manager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DetailManager alloc]init];
    });
    return manager;
}

-(NSMutableArray *)colorArr
{
    if (!_colorArr) {
        self.colorArr =[[NSMutableArray alloc]init];
    }
    return _colorArr;
}
-(NSMutableArray *)skillPicArr
{
    if (!_skillPicArr) {
        self.skillPicArr = [[NSMutableArray alloc]init];
    }
    return _skillPicArr;
}
-(NSMutableArray *)skillArr
{
    if (!_skillArr) {
        self.skillArr = [[NSMutableArray alloc]init];
    }
    return _skillArr;
}
-(NSMutableArray *)techAndStoryArr
{
    if (!_techAndStoryArr) {
        self.techAndStoryArr = [[NSMutableArray alloc]init];
    }
    return _techAndStoryArr;
}

@end
