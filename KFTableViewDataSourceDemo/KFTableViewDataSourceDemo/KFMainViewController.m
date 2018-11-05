//
//  KFMainViewController.m
//  KFTableViewDataSourceDemo
//
//  Created by carefree on 2018/11/2.
//  Copyright © 2018 Carefree. All rights reserved.
//

#import "KFMainViewController.h"
#import "KFTableViewDataSource.h"
#import "KFCommonListController.h"
#import "KFEditableListController.h"

@interface KFMainViewController ()<UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray        *items;
@property (nonatomic, strong) KFTableViewDataSource *dataSource;

@end

@implementation KFMainViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置数据
    [self.items addObjectsFromArray:@[
                                      @"常见列表",
                                      @"可编辑列表"
                                      ]];
    
    //设置tableView的数据源
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
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
    
    //配置数据源
    _dataSource = [[KFTableViewDataSource alloc] initWithItems:self.items cellConfiguration:^(id  _Nonnull item, NSIndexPath * _Nonnull indexPath, __kindof UITableViewCell * _Nonnull (^ _Nonnull reusableCell)(NSString * _Nonnull)) {
        //通过标识获取cell
        UITableViewCell *cell = reusableCell(@"main");
        cell.textLabel.text = item;
    }];
    _dataSource.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0); //设置分隔线的inset
    
    return _dataSource;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        KFCommonListController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"commonList"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        KFEditableListController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"editableList"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
