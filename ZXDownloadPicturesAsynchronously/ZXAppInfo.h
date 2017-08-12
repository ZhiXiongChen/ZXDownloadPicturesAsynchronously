//
//  ZXAppInfo.h
//  ZXDownloadPicturesAsynchronously
//
//  Created by zhixiongchen on 2017/8/11.
//  Copyright © 2017年 zhixiongchen. All rights reserved.
//
//UIkit依赖与于foundation框架，所以导入了UIKit框架会自动导入
#import <UIKit/UIKit.h>
@interface ZXAppInfo : NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * icon;
@property(nonatomic,copy)NSString * download;
//添加image属性用来缓存图片，这样每次滑动tableView的时候就不用再去网上下载了,然后我们为了有内存警告的时候清空图片方便，所以我们定义了一个图片缓存池所以我们就不用在这里定义属性去缓存图片了
//@property (nonatomic ,strong)UIImage * image;
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)appInfoWithDict:(NSDictionary *)dict;
+(NSArray *)setapps;
@end
