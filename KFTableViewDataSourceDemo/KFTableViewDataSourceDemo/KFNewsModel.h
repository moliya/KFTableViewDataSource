//
//  KFNewsModel.h
//  KFTableViewDataSourceDemo
//
//  Created by carefree on 2018/11/2.
//  Copyright © 2018 Carefree. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFNewsModel : NSObject

@property (nonatomic, copy) NSString    *tag;
@property (nonatomic, copy) NSString    *desc;
@property (nonatomic, strong, nullable) UIImage   *image;


@end

NS_ASSUME_NONNULL_END
