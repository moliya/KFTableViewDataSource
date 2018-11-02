//
//  KFEditableListController.m
//  KFTableViewDataSourceDemo
//
//  Created by carefree on 2018/11/2.
//  Copyright © 2018 Carefree. All rights reserved.
//

#import "KFEditableListController.h"
#import "KFTableViewDataSource.h"

@interface KFEditableListController ()<UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray        *items; //cell显示的数据
@property (nonatomic, strong) KFTableViewDataSource *dataSource;

@end

@implementation KFEditableListController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置数据
    [self.items addObjectsFromArray:@[@"one", @"two", @"three", @"four"]];
    
    //设置数据源及代理
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 54;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
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
        UITableViewCell *cell = reusableCell(@"myCell");
        cell.textLabel.text = item;
    }];
    _dataSource.separatorInset = UIEdgeInsetsMake(0, 8, 0, 0);
    
    return _dataSource;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
