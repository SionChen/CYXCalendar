//
//  CYXCalendarMonthTableViewCell.m
//  CYXCalendar
//
//  Created by 晓 on 2019/7/29.
//  Copyright © 2019 陈泳晓. All rights reserved.
//

#import "CYXCalendarMonthTableViewCell.h"
#import "CYXCalendarMonth.h"
#import "CYXCalendarDay.h"
#import "CYXCalendarDayCollectionViewCell.h"
@interface CYXCalendarMonthTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
/*列表*/
@property (nonatomic,strong) UICollectionView *collectionView;
/*布局*/
@property (nonatomic,strong)UICollectionViewFlowLayout  * flowLayout;

@end
@implementation CYXCalendarMonthTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.collectionView];
    }
    
    return self;
}
-(void)setCalendarMonth:(CYXCalendarMonth *)calendarMonth{
    _calendarMonth =calendarMonth;
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource
// 返回collection view里区(section)的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 返回指定区(section)包含的数据源条目数(number of items)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.calendarMonth.dayList.count;
}
// 返回某个indexPath对应的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CYXCalendarDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CYXCalendarDayCollectionViewCell class]) forIndexPath:indexPath];
    cell.calendarDay = self.calendarMonth.dayList[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CYXCalendarDay * calendarDay = self.calendarMonth.dayList[indexPath.row];
    if (self.selectCalendarDay&&calendarDay.calendarMonth == CalendarMonthCurrent) {
        self.selectCalendarDay(calendarDay);
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}
#pragma mark ---G
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.showsVerticalScrollIndicator = true;
        _collectionView.delaysContentTouches = false;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.scrollsToTop = false;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[CYXCalendarDayCollectionViewCell class] forCellWithReuseIdentifier:@"CYXCalendarDayCollectionViewCell"];
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        CGFloat itemWidth = screenWidth/7.0;
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; //设定滚动方向
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0); //设定全局的区内边距
        _flowLayout.minimumInteritemSpacing = 0; //设定全局的Cell间距
        _flowLayout.minimumLineSpacing = 0; //设定全局的行间距
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    }
    return _flowLayout;
}
@end
