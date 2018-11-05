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
@property (nonatomic, strong) UISegmentedControl    *segment;
@property (nonatomic, assign) BOOL                  isEditing; //是否编辑状态

@end

@implementation KFEditableListController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //在导航栏添加分段选择器，用于删除模式和插入模式的切换
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"delete", @"insert"]];
    [self.segment addTarget:self action:@selector(switchEditingStyle) forControlEvents:UIControlEventValueChanged];
    self.segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segment;
    
    //在导航栏添加编辑按钮，点击可进入tableView的编辑模式
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //配置数据
    [self.items addObjectsFromArray:@[@"one", @"two", @"three", @"four"]];
    
    //设置数据源及代理
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 54;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
}

#pragma mark -
//系统提供的编辑按钮的回调方法，在这里进行tableView的编辑切换
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    self.isEditing = !self.isEditing;
    [self.tableView setEditing:self.isEditing animated:YES];
}

//segment切换
- (void)switchEditingStyle {
    //刷新tableView，改变编辑样式
    [self.tableView reloadData];
}

//删除行
- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    //更新数据源
    [self.items removeObjectAtIndex:indexPath.row];
    //tableView删除指定的row
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//插入行
- (void)insertItemAtIndexPath:(NSIndexPath *)indexPath {
    //更新数据源
    [self.items insertObject:@"new item" atIndex:indexPath.row];
    //tableView插入新的row
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)alertMessageAtIndexPath:(NSIndexPath *)indexPath {
    NSString *message = [NSString stringWithFormat:@"row %@ clicked", @(indexPath.row + 1)];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
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
    _dataSource = [[KFTableViewDataSource alloc] initWithItems:self.items sectionIndexTitles:nil cellConfiguration:^(id  _Nonnull item, NSIndexPath * _Nonnull indexPath, __kindof UITableViewCell * _Nonnull (^ _Nonnull reusableCell)(NSString * _Nonnull)) {
        //设置重用标识及cell的展示数据
        UITableViewCell *cell = reusableCell(@"myCell");
        cell.textLabel.text = item;
    } canEditRow:^BOOL(id  _Nonnull item, NSIndexPath * _Nonnull indexPath) {
        //设置row为可以编辑
        return YES;
    } canMoveRow:^BOOL(id  _Nonnull item, NSIndexPath * _Nonnull indexPath) {
        //设置row为可以移动
        return YES;
    } rowEdited:^(id  _Nonnull item, UITableViewCellEditingStyle style, NSIndexPath * _Nonnull indexPath) {
        //编辑row的回调
        if (style == UITableViewCellEditingStyleDelete) {
            [self deleteItemAtIndexPath:indexPath];
        }
        if (style == UITableViewCellEditingStyleInsert) {
            [self insertItemAtIndexPath:indexPath];
        }
    } rowMoved:^(id  _Nonnull item, NSIndexPath * _Nonnull source, NSIndexPath * _Nonnull destination) {
        //移动row的回调
        //这里更新数据源就行了
        id data = self.items[source.row];
        [self.items removeObjectAtIndex:source.row];
        [self.items insertObject:data atIndex:destination.row];
    }];
    _dataSource.separatorInset = UIEdgeInsetsMake(0, 8, 0, 0);
    
    return _dataSource;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  tableView编辑模式的回调代理在不同版本的系统有不同的代理方法
 *  如果系统符合要求，最新的代理方法会覆盖之前的代理方法
 */
// iOS7 以下的代理方法，可以配置tableView的编辑模式，不实现默认为删除模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //根据选择模式来决定编辑模式
    return self.segment.selectedSegmentIndex == 0 ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleInsert;
}

// iOS7 以下的代理方法，可以设置删除的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete";
}

// iOS8以上 iOS10以下的代理方法，可以设置左滑操作的项目，包括标题、背景色、点击回调事件等
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteItemAtIndexPath:indexPath];
    }];
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Alert" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self alertMessageAtIndexPath:indexPath];
    }];
    action2.backgroundColor = [UIColor orangeColor];

    return @[action1, action2];
}

// iOS11 以上的代理方法，可以设置左滑操作的项目，包括标题、背景色、图标、点击回调事件等
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)) {
    UIContextualAction *action1 = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self deleteItemAtIndexPath:indexPath];
        completionHandler(YES);
    }];
    action1.backgroundColor = [UIColor brownColor];
    UIContextualAction *action2 = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"action2" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self alertMessageAtIndexPath:indexPath];
        completionHandler(YES);
    }];
    action2.backgroundColor = [UIColor lightGrayColor];
    action2.image = [UIImage imageNamed:@"icon_ham"];
    
    return [UISwipeActionsConfiguration configurationWithActions:@[action1, action2]];
}

@end
