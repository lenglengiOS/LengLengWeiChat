//
//  LHLFriendCell.m
//  EMWeiChat
//
//  Created by admin on 16/11/7.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLFriendCell.h"

@interface LHLFriendCell ()


@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end

@implementation LHLFriendCell

+ (instancetype)friendCell:(UITableView *)tableView
{
    static NSString *cellID = @"LHLFriendCell";
    LHLFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    }
    
    return cell;
}

- (void)setBuddy:(EMBuddy *)buddy
{
    _buddy = buddy;
    self.userIcon.image = [UIImage imageNamed:@"xhr"];
    self.username.text = buddy.username;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
