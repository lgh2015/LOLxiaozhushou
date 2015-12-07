//
//  NewestModel.h
//  项目
//
//  Created by 李国灏 on 15/11/28.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewestModel : NSObject

@property(nonatomic,strong)NSString *image_url_small;
@property(nonatomic,strong)NSString *title;
//拼接http://qt.qq.com/static/pages/news/phone/
@property(nonatomic,strong)NSString *article_url;
@property(nonatomic,strong)NSString *publication_date;
@property(nonatomic,strong)NSString *summary;

-(instancetype)initWithDictionary:(NSMutableDictionary *)dic;

@end
