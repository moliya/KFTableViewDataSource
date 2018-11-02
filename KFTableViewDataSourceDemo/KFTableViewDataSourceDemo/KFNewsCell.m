//
//  KFNewsCell.m
//  KFTableViewDataSourceDemo
//
//  Created by carefree on 2018/11/2.
//  Copyright © 2018 Carefree. All rights reserved.
//

#import "KFNewsCell.h"

@interface KFNewsCell()

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@end

@implementation KFNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithItem:(KFNewsModel *)item {
    self.tagLabel.text = item.tag;
    self.descLabel.text = item.desc;
    if (item.image) {
        self.imgView.image = item.image;
        self.imageHeightConstraint.constant = 180;
    } else {
        self.imgView.image = nil;
        self.imageHeightConstraint.constant = 1;
    }
}

@end
