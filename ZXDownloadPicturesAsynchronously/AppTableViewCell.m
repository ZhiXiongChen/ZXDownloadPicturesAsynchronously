//
//  AppTableViewCell.m
//  ZXDownloadPicturesAsynchronously
//
//  Created by zhixiongchen on 2017/8/11.
//  Copyright © 2017年 zhixiongchen. All rights reserved.
//

#import "AppTableViewCell.h"
#import "ZXAppInfo.h"
@interface AppTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@end
@implementation AppTableViewCell
+(instancetype)loadTableViewCell:(UITableView *)tableView
{
    //设置可使用的重用ID
    static NSString * reuseID=@"apps_cell";
    AppTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell)
    {
        cell=[[AppTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    return cell;
}
-(void)setAppInfo:(ZXAppInfo *)appInfo
{
    _appInfo=appInfo;
    //cell内部的子控件是懒加载的，在返回cell的之前调用了cell的layoutSubView方法，而我们在没有加载完网络图片的时候就已经返回cell了，所以加载完网络图片，给cell设置图片，并没有设置大小。
    //如果图片下载太慢，滑到底下的cell，图片还没下载完，我们又滑到最顶部了，最顶部的图片刚开始直接从缓存中取，之后会被换成我们下面底下cell下载的图片
    self.nameLabel.text=appInfo.name;
    self.downloadLabel.text=appInfo.download;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
