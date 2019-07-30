//
//  CYXCalendarView.m
//  CYXCalendar
//
//  Created by 晓 on 2019/7/29.
//  Copyright © 2019 陈泳晓. All rights reserved.
//
#pragma mark ---View
#import "CYXCalendarView.h"
#import "CYXCalendarMonthTableViewCell.h"
#pragma mark ---Utils
#import "UIView+Size.h"
#import "CalendarDataLoader.h"
#pragma mark ---Model
#import "CYXCalendarMonth.h"

@interface CYXCalendarView ()<UITableViewDelegate,UITableViewDataSource>
/*取消*/
@property (nonatomic,strong) UIButton *cancalButton;
/*确认*/
@property (nonatomic,strong) UIButton *confirmButton;
/*列表*/
@property (nonatomic,strong) UITableView *tableView;

/*数据源*/
@property (nonatomic,strong) NSMutableArray<CYXCalendarMonth *> *dataArray;
/*数据加载*/
@property (nonatomic,strong) CalendarDataLoader *dataLoader;
/*选择的日期*/
@property (nonatomic,strong) CYXCalendarDay *selectDay;
@end
@implementation CYXCalendarView{
    BOOL isLoading;
}
#pragma mark ---init
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tableView];
        [self createWeeksDaysLabel];
        [self createBottomButton];
    }
    return self;
}
/*星期列表*/
-(void)createWeeksDaysLabel{
    CGFloat itemWidth = screenWidth/7.0;
    NSArray * dataArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (int i =0; i<[dataArray count]; i++) {
        UILabel * label = [[UILabel alloc] init];
        label.frame = CGRectMake(i*itemWidth,0 , itemWidth, itemWidth);
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = dataArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
}
/*取消确认*/
-(void)createBottomButton{
    [self addSubview:self.cancalButton];
    [self addSubview:self.confirmButton];
}
#pragma mark ---Action
/*取消*/
-(void)cancal{
    [self dismiss];
}
/*确认*/
-(void)confirm{
    if (self.selectDateBlock) {
        self.selectDateBlock(self.selectDay);
    }
    [self dismiss];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CYXCalendarMonthTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CYXCalendarMonthTableViewCell"];
    if (cell == nil) {
        cell = [[CYXCalendarMonthTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReturnListTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        WS(_self);
        cell.selectCalendarDay = ^(CYXCalendarDay * _Nonnull calendarDay) {
            _self.selectDay = calendarDay;
            for (CYXCalendarMonth * month in _self.dataArray) {
                for (CYXCalendarDay * day in month.dayList) {
                    day.selected = day==calendarDay;
                }
            }
            [_self.tableView reloadData];
        };
    };
    cell.calendarMonth = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat scrollHeight = scrollView.frame.size.height;
    if (contentHeight < scrollHeight) {
        return;
    }
    NSLog(@"contentOffsetY:%f contentHeight:%f scrollHeight:%f",contentOffsetY,contentHeight,scrollHeight);
    if ((contentOffsetY >= (contentHeight - scrollHeight*2))&&!isLoading) {//下一页
        //[self getCustomersListWithPage:++currentPage];
        [self loadDataWithCYXCalendarPageLoad:CYXCalendarPageLoadNextPage];
    }else if ((contentOffsetY <= scrollHeight)&&!isLoading){//上一页
        [self loadDataWithCYXCalendarPageLoad:CYXCalendarPageLoadLastPage];
    }
}
-(void)loadData{//第一页
    [self loadDataWithCYXCalendarPageLoad:CYXCalendarPageLoadCurrentPage];
}
/*获取数据*/
-(void)loadDataWithCYXCalendarPageLoad:(CYXCalendarPageLoadModel )pageLoad{
    isLoading = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray<CYXCalendarMonth *> * temp = [NSArray new];
        switch (pageLoad) {
            case CYXCalendarPageLoadCurrentPage:
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString * dateString = [formatter stringFromDate:[NSDate date]];
                temp = [self.dataLoader loadDataWithPageLoadModel:pageLoad];
                for (CYXCalendarMonth * month in temp) {//设置默认选择当前日期
                    for (CYXCalendarDay *day in month.dayList) {
                        if ([day.dateString isEqualToString:dateString]) {
                            day.selected = YES;
                            break;
                        }
                    }
                }
                self.dataArray =[NSMutableArray arrayWithArray:temp];
            }
                break;
            case CYXCalendarPageLoadLastPage:
            {
                CYXCalendarMonth * month = [self.dataArray firstObject];
                temp = [self.dataLoader loadDataWithPageLoadModel:pageLoad withdate:month.date];
                [self.dataArray insertObjects:temp atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, temp.count)]];
            }
                break;
            case CYXCalendarPageLoadNextPage:
            {
                CYXCalendarMonth * month = [self.dataArray lastObject];
                temp = [self.dataLoader loadDataWithPageLoadModel:pageLoad withdate:month.date];
                [self.dataArray addObjectsFromArray:temp];
            }
                break;
                
            default:
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新完成
                if (pageLoad == CYXCalendarPageLoadCurrentPage) {
                    [self.tableView setContentOffset:CGPointMake(0, ([self.dataArray count]/2-1)*self.tableView.height)];
                }else if (pageLoad == CYXCalendarPageLoadLastPage){
                    [self.tableView setContentOffset:CGPointMake(0, [temp count]*self.tableView.height)];
                }
                self->isLoading = NO;
            });
        });
    });
}
#pragma mark ---layout
-(void)layoutSubviews{
    [super layoutSubviews];
    self.cancalButton.bottom = self.height;
    self.confirmButton.right = self.width;
    self.confirmButton.bottom = self.height;
}
#pragma mark ---public
-(void)showInView:(UIView *)view{
    CGFloat itemWidth = screenWidth/7.0;
    self.frame = CGRectMake(0, 0, screenWidth, itemWidth*7+48);
    NSLog(@"itemWidth:%f screenWidth: %f  height:%f",itemWidth,screenWidth,self.height);
    self.centerY = view.height/2.0;
    [view addSubview:self];
    
    [self loadData];
    
}
-(void)dismiss{
    [self removeFromSuperview];
}
#pragma mark ---G
-(UIButton*)cancalButton{
    if(!_cancalButton){
        _cancalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancalButton.frame =CGRectMake(0, 0, 62, 48);
        [_cancalButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancalButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _cancalButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancalButton addTarget:self action:@selector(cancal) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancalButton;
}
-(UIButton*)confirmButton{
    if(!_confirmButton){
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(0, 0, 62, 48);
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
-(UITableView*)tableView{
    if(!_tableView){
        CGFloat itemWidth = screenWidth/7.0;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0, itemWidth, screenWidth, itemWidth*6);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.pagingEnabled = YES;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delaysContentTouches = false;
        _tableView.scrollsToTop = true;
        _tableView.dataSource =self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}
-(CalendarDataLoader*)dataLoader{
    if(!_dataLoader){
        _dataLoader = [[CalendarDataLoader alloc] init];
    }
    return _dataLoader;
}
@end
