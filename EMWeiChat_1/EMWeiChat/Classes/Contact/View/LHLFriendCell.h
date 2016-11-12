//
//  LHLFriendCell.h
//  EMWeiChat
//
//  Created by admin on 16/11/7.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHLFriendCell : UITableViewCell
/** 好友模型 */
@property (nonatomic, strong) EMBuddy *buddy;
+ (instancetype)friendCell:(UITableView *)tableView;
@end
