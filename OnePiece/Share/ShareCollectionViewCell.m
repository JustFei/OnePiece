//
//  ShareCollectionViewCell.m
//  OnePiece
//
//  Created by Faith on 2017/3/22.
//  Copyright © 2017年 manridy. All rights reserved.
//

#import "ShareCollectionViewCell.h"

@interface ShareCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tickImageView;

@end

@implementation ShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ShareModel *)model
{
    [self.backImageView setImage:model.backImage];
    if (model.beChoose) {
        self.tickImageView.hidden = NO;
        [self.tickImageView setImage:[UIImage imageNamed:@"red_tick"]];
    }else {
        self.tickImageView.hidden = YES;
    }
}

@end
