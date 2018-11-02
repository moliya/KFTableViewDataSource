//
//  KFTableViewDataSource.h
//  KFTableViewDataSource
//
//  Created by Carefree on 2018/11/2.
//  Copyright © 2018 carefree. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFTableViewDataSource<__covariant ObjectType> : NSObject<UITableViewDataSource>

typedef void(^CellConfiguration)(ObjectType item, NSIndexPath *indexPath, __kindof UITableViewCell *(NS_NOESCAPE ^reusableCell)(NSString *identifier));
typedef BOOL(^CanEditRow)(ObjectType item, NSIndexPath *indexPath);
typedef BOOL(^CanMoveRow)(ObjectType item, NSIndexPath *indexPath);
typedef void(^RowMoved)(ObjectType item, NSIndexPath *source, NSIndexPath *destination);
typedef void(^RowEdited)(ObjectType item, UITableViewCellEditingStyle style, NSIndexPath *indexPath);

@property (nonatomic, strong) NSArray<ObjectType>           *items;
@property (nonatomic, strong, nullable) NSArray<NSString *> *sectionIndexTitles;
@property (nonatomic, strong, nullable) NSArray<NSString *> *headerTitles;
@property (nonatomic, strong, nullable) NSArray<NSString *> *footerTitles;
@property (nonatomic, copy, nullable) CellConfiguration     configurationBlock;
@property (nonatomic, copy, nullable) CanEditRow            canEditRowBlock;
@property (nonatomic, copy, nullable) CanMoveRow            canMoveRowBlock;
@property (nonatomic, copy, nullable) RowEdited             rowEditedBlock;
@property (nonatomic, copy, nullable) RowMoved              rowMovedBlock;
@property (nonatomic, assign) BOOL                          containsSection;
@property (nonatomic, assign) UIEdgeInsets                  separatorInset;

- (nullable ObjectType)itemAtIndexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithItems:(NSArray<ObjectType> *)items
            cellConfiguration:(nullable CellConfiguration)configuration;

- (instancetype)initWithItems:(NSArray<ObjectType> *)items
                 headerTitles:(nullable NSArray<NSString *> *)header
                 footerTitles:(nullable NSArray<NSString *> *)footer
            cellConfiguration:(nullable CellConfiguration)configuration;

- (instancetype)initWithItems:(NSArray<ObjectType> *)items
           sectionIndexTitles:(nullable NSArray<NSString *> *)sectionIndexTitles
            cellConfiguration:(nullable CellConfiguration)configuration;

- (instancetype)initWithItems:(NSArray<ObjectType> *)items
           sectionIndexTitles:(nullable NSArray<NSString *> *)sectionIndexTitles
                 headerTitles:(nullable NSArray<NSString *> *)header
                 footerTitles:(nullable NSArray<NSString *> *)footer
            cellConfiguration:(nullable CellConfiguration)configuration;

- (instancetype)initWithItems:(NSArray<ObjectType> *)items
           sectionIndexTitles:(nullable NSArray<NSString *> *)sectionIndexTitles
            cellConfiguration:(nullable CellConfiguration)configuration
                   canEditRow:(nullable CanEditRow)canEdit
                    rowEdited:(nullable RowEdited)rowEdited;

- (instancetype)initWithItems:(NSArray<ObjectType> *)items
           sectionIndexTitles:(nullable NSArray<NSString *> *)sectionIndexTitles
            cellConfiguration:(nullable CellConfiguration)configuration
                   canMoveRow:(nullable CanMoveRow)canMove
                     rowMoved:(nullable RowMoved)rowMoved;

- (instancetype)initWithItems:(NSArray<ObjectType> *)items
           sectionIndexTitles:(nullable NSArray<NSString *> *)sectionIndexTitles
            cellConfiguration:(nullable CellConfiguration)configuration
                   canEditRow:(nullable CanEditRow)canEdit
                   canMoveRow:(nullable CanMoveRow)canMove
                    rowEdited:(nullable RowEdited)rowEdited
                     rowMoved:(nullable RowMoved)rowMoved;

- (instancetype)initWithItems:(NSArray<ObjectType> *)items
           sectionIndexTitles:(nullable NSArray<NSString *> *)sectionIndexTitles
                 headerTitles:(nullable NSArray<NSString *> *)header
                 footerTitles:(nullable NSArray<NSString *> *)footer
            cellConfiguration:(nullable CellConfiguration)configuration
                   canEditRow:(nullable CanEditRow)canEdit
                   canMoveRow:(nullable CanMoveRow)canMove
                    rowEdited:(nullable RowEdited)rowEdited
                     rowMoved:(nullable RowMoved)rowMoved;


@end

NS_ASSUME_NONNULL_END
