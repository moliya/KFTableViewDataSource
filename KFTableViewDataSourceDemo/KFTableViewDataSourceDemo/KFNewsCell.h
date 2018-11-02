//
//  KFNewsCell.h
//  KFTableViewDataSourceDemo
//
//  Created by carefree on 2018/11/2.
//  Copyright © 2018 Carefree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KFNewsCell : UITableViewCell

- (void)configWithItem:(KFNewsModel *)item;

@end

NS_ASSUME_NONNULL_END
