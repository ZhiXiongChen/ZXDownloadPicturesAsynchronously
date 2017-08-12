//
//  ViewController.m
//  ZXDownloadPicturesAsynchronously
//
//  Created by zhixiongchen on 2017/8/11.
//  Copyright © 2017年 zhixiongchen. All rights reserved.
//

#import "ViewController.h"
#import "ZXAppInfo.h"
#import "AppTableViewCell.h"
#import "NSString+Sandbox.h"
@interface ViewController ()
//模型数组
@property(nonatomic,strong)NSArray * apps;
//全局队列
@property(nonatomic,strong)NSOperationQueue * queue;
//图片缓存池
@property (nonatomic,strong)NSMutableDictionary * imageCache;
//下载操作缓存池
@property(nonatomic,strong)NSMutableDictionary * downloadCache;
//如果在tableView屏幕图片下载的慢，我们滚动tableView从上到下滚动的话会给下面下载图片添加了多个操作，所以我们就需要判断下操作数是不是1如果是1就不用再去添加了
@end

@implementation ViewController
//懒加载数据
-(NSArray *)apps
{
    if(!_apps)
    {
    _apps=[ZXAppInfo setapps];
    }
    return _apps;
}
//懒加载全局队列
-(NSOperationQueue *)queue
{
    if(!_queue)
    {
        _queue=[[NSOperationQueue alloc]init];
    }
    return _queue;
}
//懒加载图片缓存池
-(NSMutableDictionary *)imageCache
{
    if(!_imageCache)
    {
        _imageCache=[NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _imageCache;
}
//懒加载操作缓存池
-(NSMutableDictionary *)downloadCache
{
    if(!_downloadCache)
    {
        _downloadCache=[NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _downloadCache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight=80;
}
#pragma mark - 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.apps.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppTableViewCell * cell=[AppTableViewCell loadTableViewCell:tableView];
    //设置数据
    ZXAppInfo * model=self.apps[indexPath.row];
    cell.appInfo=model;
    //如果cell的appInfo属性中有image的话就不用去下载图片了，先去加载缓存中的图片
    if(self.imageCache[model.icon])
    {
        cell.iconView.image=self.imageCache[model.icon];
        NSLog(@"从缓存中加载图片");
        return cell;
    }
    //使用占位图片来解决下面设置cell的imageView的时候无效果只有点击cell和滚动tableView才有效果
    cell.iconView.image=[UIImage imageNamed:@"user_default"];
    //检查沙盒中有没有图片
    NSData * data=[NSData dataWithContentsOfFile:[model.icon appendCache]];
    if(data)
    {
        //从沙盒中获取图片
        UIImage * image=[UIImage imageWithData:data];
        //把图片保存到缓存中
        self.imageCache[model.icon]=image;
        //把image显示到Cell上
        NSLog(@"从沙盒中加载图片");
        cell.iconView.image=image;
        return cell;
    }
    [self downloadImage:indexPath];
    //同步下载网络图片，耗时操作界面会卡顿
    //    NSURL * url=[NSURL URLWithString:appInfo.icon];
    //    NSData * data=[NSData dataWithContentsOfURL:url];
    //    UIImage * image=[UIImage imageWithData:data];
    //设置图片
    //    cell.imageView.image=image;
    return cell;
}
-(void)downloadImage:(NSIndexPath *)indexPath
{
    ZXAppInfo * model=self.apps[indexPath.row];
    //判断下载操作有没有，这里一定要放在占位图片的后面，不然的话它又会去缓存池中cell,相应的cell是有图片的，显示的就是我们上面已经加载好的图片了
    if(self.downloadCache[model.icon])
    {
        return;
    }
    //创建下载操作
    NSBlockOperation * operation=[NSBlockOperation blockOperationWithBlock:^{
        if(indexPath.row>12)
        {
            [NSThread sleepForTimeInterval:5];
        }
        NSLog(@"从网络上加载图片");
        NSURL * url=[NSURL URLWithString:model.icon];
        NSData * data=[NSData dataWithContentsOfURL:url];
        UIImage * image=[UIImage imageWithData:data];
        //写入图片
        if(image)
        {
            [data writeToFile:[model.icon appendCache] atomically:YES];
        }
        //        __weak ViewController * weakSelf=self;
        //        __weak typeof(self) weakSelf = self;
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            //如果把下面两句放在上面是会出问题的因为mutable类如果在子线程中操作是会出问题的。mutable是线程不安全的
            //如果图片不为空，才去执行，不然的话会不停的返回Cell因为不停的去调用Reload方法
            if(image)
            {
                //缓存图片
                self.imageCache[model.icon]=image;
                //下载完图片之后，移除下载缓存池中对应的操作
                [self.downloadCache removeObjectForKey:model.icon];
                
                //设置图片,当网络速度比较慢的时候会造成错行的情况，因为当我们往下拉的时候,下面的cell的图片还没加载完，我们再往上拉的时候，下面cell的图片就会显示在我们上面cell中，因为单元格重用了，下面的cell正好重用了上面的cell而且图片下载的慢，所以当我们滑到上面的时候，才加载完毕。所以图片就更新了。所以我们要做的就是去刷新相应的行其实就可以了，因为model.image已经保存了图片了，刷新就会调用cell的cellForRowAtIndexPath方法
                //cell.imageView.image=image;
                //刷新相应行的数据,会去调用cellForRowAtIndexPath的方法，然后创建个cell
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }];
    //把操作下载到下载操作的缓存池里面
    self.downloadCache[model.icon]=operation;
    //把操作添加到队列中
    [self.queue addOperation:operation];
}
//当收到内存警告的时候都去清空缓存池
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.imageCache removeAllObjects];
    [self.downloadCache removeAllObjects];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%zd",self.queue.operationCount);
}
@end
