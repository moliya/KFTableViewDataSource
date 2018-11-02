//
//  KFTableViewDataSource.m
//  KFTableViewDataSource
//
//  Created by Carefree on 2018/11/2.
//  Copyright © 2018 carefree. All rights reserved.
//

#import "KFTableViewDataSource.h"

static NSString *const KFDefaultCellIdentifier = @"DefaultCellIdentifier";

@implementation KFTableViewDataSource

#pragma mark - Lifecycle
- (instancetype)init {
    return [self initWithItems:[NSArray array] cellConfiguration:nil];
}

- (instancetype)initWithItems:(NSArray *)items cellConfiguration:(CellConfiguration)configuration {
    return [self initWithItems:items sectionIndexTitles:nil cellConfiguration:configuration];
}

- (instancetype)initWithItems:(NSArray *)items sectionIndexTitles:(NSArray<NSString *> *)sectionIndexTitles cellConfiguration:(CellConfiguration)configuration {
    return [self initWithItems:items sectionIndexTitles:sectionIndexTitles headerTitles:nil footerTitles:nil cellConfiguration:configuration];
}

- (instancetype)initWithItems:(NSArray *)items headerTitles:(NSArray<NSString *> *)header footerTitles:(NSArray<NSString *> *)footer cellConfiguration:(CellConfiguration)configuration {
    return [self initWithItems:items sectionIndexTitles:nil headerTitles:header footerTitles:footer cellConfiguration:configuration];
}

- (instancetype)initWithItems:(NSArray *)items sectionIndexTitles:(NSArray<NSString *> *)sectionIndexTitles headerTitles:(NSArray<NSString *> *)header footerTitles:(NSArray<NSString *> *)footer cellConfiguration:(CellConfiguration)configuration {
    return [self initWithItems:items sectionIndexTitles:sectionIndexTitles headerTitles:header footerTitles:footer cellConfiguration:configuration canEditRow:nil canMoveRow:nil rowEdited:nil rowMoved:nil];
}

- (instancetype)initWithItems:(NSArray *)items sectionIndexTitles:(NSArray<NSString *> *)sectionIndexTitles cellConfiguration:(CellConfiguration)configuration canMoveRow:(CanMoveRow)canMove rowMoved:(RowMoved)rowMoved {
    return [self initWithItems:items sectionIndexTitles:sectionIndexTitles headerTitles:nil footerTitles:nil cellConfiguration:configuration canEditRow:nil canMoveRow:canMove rowEdited:nil rowMoved:rowMoved];
}

- (instancetype)initWithItems:(NSArray *)items sectionIndexTitles:(NSArray<NSString *> *)sectionIndexTitles cellConfiguration:(CellConfiguration)configuration canEditRow:(CanEditRow)canEdit rowEdited:(RowEdited)rowEdited {
    return [self initWithItems:items sectionIndexTitles:sectionIndexTitles headerTitles:nil footerTitles:nil cellConfiguration:configuration canEditRow:canEdit canMoveRow:nil rowEdited:rowEdited rowMoved:nil];
}

- (instancetype)initWithItems:(NSArray *)items sectionIndexTitles:(NSArray<NSString *> *)sectionIndexTitles cellConfiguration:(CellConfiguration)configuration canEditRow:(CanEditRow)canEdit canMoveRow:(CanMoveRow)canMove rowEdited:(RowEdited)rowEdited rowMoved:(RowMoved)rowMoved {
    return [self initWithItems:items sectionIndexTitles:sectionIndexTitles headerTitles:nil footerTitles:nil cellConfiguration:configuration canEditRow:canEdit canMoveRow:canMove rowEdited:rowEdited rowMoved:rowMoved];
}

- (instancetype)initWithItems:(NSArray *)items sectionIndexTitles:(NSArray<NSString *> *)sectionIndexTitles headerTitles:(NSArray<NSString *> *)header footerTitles:(NSArray<NSString *> *)footer cellConfiguration:(CellConfiguration)configuration canEditRow:(CanEditRow)canEdit canMoveRow:(CanMoveRow)canMove rowEdited:(RowEdited)rowEdited rowMoved:(RowMoved)rowMoved {
    self = [super init];
    if (self) {
        [self checkArray:items];
        _items = items;
        _sectionIndexTitles = sectionIndexTitles;
        _headerTitles = header;
        _footerTitles = footer;
        _configurationBlock = configuration;
        _canEditRowBlock = canEdit;
        _canMoveRowBlock = canMove;
        _rowEditedBlock = rowEdited;
        _rowMovedBlock = rowMoved;
        _separatorInset = UIEdgeInsetsZero; //分割线默认间距
    }
    return self;
}

#pragma mark - TableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.containsSection) {
        return self.items.count;
    }
    if (self.items.count > 0) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.containsSection) {
        return [self.items[section] count];
    }
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.configurationBlock) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [self commonSetupForCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    
    __block UITableViewCell *cell;
    self.configurationBlock([self itemAtIndexPath:indexPath], indexPath, ^__kindof UITableViewCell *(NSString *identifier) {
        if (!identifier) {
            identifier = KFDefaultCellIdentifier;
        }
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        [self commonSetupForCell:cell atIndexPath:indexPath];
        
        return cell;
    });
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.headerTitles) {
        return self.headerTitles[section];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.footerTitles) {
        return self.footerTitles[section];
    }
    return nil;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (title == UITableViewIndexSearch) {
        //点击第一个索引时，空出高度显示搜索框（如果有）
        [tableView scrollRectToVisible:(CGRect){0, 0, [UIScreen mainScreen].bounds.size.width, 44} animated:NO];
        
        return -1;
    }
    return index;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.canEditRowBlock) {
        return self.canEditRowBlock([self itemAtIndexPath:indexPath], indexPath);
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.canMoveRowBlock) {
        return self.canMoveRowBlock([self itemAtIndexPath:indexPath], indexPath);
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (self.rowMovedBlock) {
        self.rowMovedBlock([self itemAtIndexPath:sourceIndexPath], sourceIndexPath, destinationIndexPath);
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.rowEditedBlock) {
        self.rowEditedBlock([self itemAtIndexPath:indexPath], editingStyle, indexPath);
    }
}

#pragma mark - Other

- (instancetype)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.containsSection) {
        NSInteger count = [self.items count];
        if (indexPath.section > count - 1) {
            return nil;
        }
        count = [self.items[indexPath.section] count];
        if (indexPath.row > count - 1) {
            return nil;
        }
        return self.items[indexPath.section][indexPath.row];
    }
    NSInteger count = [self.items count];
    if (indexPath.row > count - 1) {
        return nil;
    }
    return self.items[indexPath.row];
}

#pragma mark - Lazyloading

- (BOOL)multiSection {
    BOOL multi = NO;
    if ([self.items firstObject]) {
        id firstObj = [self.items firstObject];
        BOOL isArray = [firstObj isKindOfClass:[NSMutableArray class]] || [firstObj isKindOfClass:[NSArray class]];
        multi = isArray;
    }
    
    return multi;
}

#pragma mark - Private

- (void)checkArray:(NSArray *)array {
    NSAssert(array != nil, @"Data Array cannot be nil");
}

- (void)commonSetupForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //设置cell的分割线间距
    UIEdgeInsets inset = self.separatorInset;
    
    if (self.containsSection) {
        //cell是否为该section的最后一行
        if (indexPath.row == [self.items[indexPath.section] count] - 1) {
            
            inset = UIEdgeInsetsZero;
        }
    } else {
        //cell是否最后一行
        if (indexPath.row == [self.items count] - 1) {
            
            inset = UIEdgeInsetsZero;
        }
    }
    cell.separatorInset = inset; //设置分割线间距
    cell.layoutMargins = inset; //默认的layoutMargins为8
    cell.preservesSuperviewLayoutMargins = NO; //不使用父view的layoutMargins
}


@end
