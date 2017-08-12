//
//  NSString+Sandbox.m
//  获取沙盒目录
//
//  Created by zhixiongchen on 2017/8/11.
//  Copyright © 2017年 zhixiongchen. All rights reserved.
//

#import "NSString+Sandbox.h"

@implementation NSString (Sandbox)
-(instancetype)appendCache
{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:[self lastPathComponent]];
}
-(instancetype)appendTemp
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[self lastPathComponent]];
}
-(instancetype)appendDocument
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:[self lastPathComponent]];
}

@end
