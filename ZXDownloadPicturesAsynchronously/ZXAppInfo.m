//
//  ZXAppInfo.m
//  ZXDownloadPicturesAsynchronously
//
//  Created by zhixiongchen on 2017/8/11.
//  Copyright © 2017年 zhixiongchen. All rights reserved.
//

#import "ZXAppInfo.h"

@implementation ZXAppInfo
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if(self=[super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)appInfoWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
//把加载plist放在模型类中来做，简化controller中的工作
+(NSArray *)setapps
{
    NSString * path=[[NSBundle mainBundle]pathForResource:@"apps.plist" ofType:nil];
    NSArray * array=[NSArray arrayWithContentsOfFile:path];
    //调用arrayWithCapacity会先开辟多少空间，如果超出这个空间，再开辟的空间就是原来是10，如果不够用了，再开辟10个,比array效率高
    NSMutableArray * arrayM=[NSMutableArray arrayWithCapacity:10];
//    for (NSDictionary * dict in array) {
//        ZXAppInfo * model=[ZXAppInfo appInfoWithDict:dict];
//        [arrayM addObject:model];
//    }
    //遍历数组的另外一种方法,效率比for in 高
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZXAppInfo * model=[self appInfoWithDict:obj];
        [arrayM addObject:model];
    }];
    //对可变数组进行copy操作，变成不可变数组
    return arrayM.copy;
}
@end
