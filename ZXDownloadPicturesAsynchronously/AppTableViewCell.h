//
//  AppTableViewCell.h
//  ZXDownloadPicturesAsynchronously
//
//  Created by zhixiongchen on 2017/8/11.
//  Copyright © 2017年 zhixiongchen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXAppInfo;
@interface AppTableViewCell : UITableViewCell
@property (nonatomic,strong)ZXAppInfo * appInfo;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
+(instancetype)loadTableViewCell:(UITableView *)tableView;
@end
