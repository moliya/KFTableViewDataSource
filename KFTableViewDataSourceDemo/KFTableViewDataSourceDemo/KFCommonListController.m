//
//  KFCommonListController.m
//  KFTableViewDataSourceDemo
//
//  Created by carefree on 2018/11/2.
//  Copyright © 2018 Carefree. All rights reserved.
//

#import "KFCommonListController.h"
#import "KFTableViewDataSource.h"
#import "KFNewsCell.h"
#import "KFNewsModel.h"

@interface KFCommonListController ()<UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray        *items; //cell显示的数据
@property (nonatomic, strong) KFTableViewDataSource *dataSource;

@end

@implementation KFCommonListController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置数据
    //添加menu cell
    [self.items addObject:@[@"menu cell placeholder"]];
    NSMutableArray *section = [NSMutableArray array];
    KFNewsModel *model1 = [[KFNewsModel alloc] init];
    model1.tag = @"北欧风格家具";
    model1.desc = @"北欧 抽象无框画 北欧无框画 抽象画 欧式 简约无框画 北欧风格 客厅装饰画 黑白画 无框画 极简 黑白装饰画 抽象画 抽象装饰 鹿 麋鹿 驯鹿 箭头 英文 字母 几何 北欧简约 现代简约 照片墙 现代抽象 黑白 照片 简约现代 黑白抽象 北欧现代简约 抽象简约 黑白简约";
    model1.image = [UIImage imageNamed:@"img_1"];
    KFNewsModel *model2 = [[KFNewsModel alloc] init];
    model2.tag = @"GitHub";
    model2.desc = @"GitHub is how people build software \n We’re supporting a community where more than 31 million* people learn, share, and work together to build software. ";
    model2.image = nil;
    KFNewsModel *model3 = [[KFNewsModel alloc] init];
    model3.tag = @"宠物";
    model3.desc = @"仓鼠";
    model3.image = [UIImage imageNamed:@"img_2"];
    
    
    [section addObjectsFromArray:@[model1, model2, model3]];
    //添加news cell
    [self.items addObject:section];
    //添加banner cell
    [self.items addObject:@[@"banner cell placeholder"]];
    //添加news cell
    [self.items addObject:section];
    
    //设置数据源及代理
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 44; //估算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension; //自动算高
}

#pragma mark - Lazyloading
- (NSMutableArray *)items {
    if (_items) {
        return _items;
    }
    
    _items = [NSMutableArray array];
    
    return _items;
}

- (KFTableViewDataSource *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    
    _dataSource = [[KFTableViewDataSource alloc] initWithItems:self.items cellConfiguration:^(id  _Nonnull item, NSIndexPath * _Nonnull indexPath, __kindof UITableViewCell * _Nonnull (^ _Nonnull reusableCell)(NSString * _Nonnull)) {
        
        if (indexPath.section == 0) {
            //menu类型的cell
            reusableCell(@"menu");
        } else if (indexPath.section == 1) {
            //news类型的cell
            KFNewsCell *cell = reusableCell(@"news");
            //配置cell的显示数据
            [cell configWithItem:item];
        } else if (indexPath.section == 2) {
            //banner类型的cell
            reusableCell(@"banner");
        } else if (indexPath.section == 3) {
            //news类型的cell
            KFNewsCell *cell = reusableCell(@"news");
            //配置cell的显示数据
            [cell configWithItem:item];
        }
    }];
    //表明数据源的数组中是二维数组，类似[[item], [item, item, item]]
    _dataSource.containsSection = YES;
    
    return _dataSource;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
