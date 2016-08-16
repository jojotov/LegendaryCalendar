//
//  LCCalendarHandler.m
//  LegendaryCalendar
//
//  Created by jojoting on 16/8/14.
//  Copyright © 2016年 jojoting. All rights reserved.
//

#import "LCCalendarHandler.h"
#import "LCCalendarCellModel.h"
#import "LCCalendarCell.h"
#import "LCCalendarModel.h"
#import "NSDate+LCCalendar.h"

@implementation LCCalendarHandler{
    NSMutableArray<NSDate *>   *_allDates;
    LCCalendarModel            *_calendarModel;
}

#pragma mark - init
- (instancetype)init{
    self = [super init];
    if (self) {
        _allDates = [NSMutableArray array];
    }
    return self;
}
#pragma mark - public
- (void)updateDataWithMonthsToCurrrentMonth:(NSInteger )monthsToCurrrentMonth CompletionBlock:(LCUpdateCompletionBlock )block{
    NSDate *date = [[NSDate date] lc_dateOfMonthsToCurrentMonth:monthsToCurrrentMonth];
    [self createModelWithDate:date completionBlock:block];
}
#pragma mark - private

- (void)createModelWithDate:(NSDate *)date completionBlock:(LCUpdateCompletionBlock )block{
    LCCalendarModel *model = [[LCCalendarModel alloc] init];
    model.preMonth_days = [date lc_preMonthDates];
    model.currentMonth_days = [date lc_currentDates];
    model.nextMonth_days = [date lc_nextMonthDates];
    model.currentMonth = [date lc_currentMonth];
    model.currentYear = [date lc_year];
    
    [_allDates removeAllObjects];
    [_allDates addObjectsFromArray:model.preMonth_days];
    [_allDates addObjectsFromArray:model.currentMonth_days];
    [_allDates addObjectsFromArray:model.nextMonth_days];
    
    _calendarModel = model;
    
    if (block) {
        block(_calendarModel);
    }
}

#pragma mark - UICollectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger )section {
    return _allDates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LCCalendarCell alloc] init];
    }
    LCCalendarCellModel *cellModel = [LCCalendarCellModel cellModelWithDate:_allDates[indexPath.row] month:[_allDates[15] lc_currentMonth]];
    [cell setCellModel:cellModel];

    return cell;
}

#pragma mark - UICollectionViewFlowLayout delegate
////设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_W/7.f, 60);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0
    ;
}



@end
