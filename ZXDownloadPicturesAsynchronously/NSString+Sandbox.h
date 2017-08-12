//
//  NSString+Sandbox.h
//  获取沙盒目录
//
//  Created by zhixiongchen on 2017/8/11.
//  Copyright © 2017年 zhixiongchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Sandbox)
-(instancetype)appendCache;
-(instancetype)appendTemp;
-(instancetype)appendDocument;
@end
