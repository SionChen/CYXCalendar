//
//  CalendarDataLoader.m
//  CYXCalendar
//
//  Created by 晓 on 2019/7/29.
//  Copyright © 2019 陈泳晓. All rights reserved.
//

#import "CalendarDataLoader.h"
#import "CYXCalendarDay.h"
@implementation CalendarDataLoader

/*加载数据*/
-(NSArray<CYXCalendarMonth *> *)loadDataWithPageLoadModel:(CYXCalendarPageLoadModel)pageLoad{
    return [self loadDataWithPageLoadModel:pageLoad withdate:[NSDate date]];
}
/*绑定知道月份加载数据*/
-(NSArray<CYXCalendarMonth *> *)loadDataWithPageLoadModel:(CYXCalendarPageLoadModel)pageLoad
                                                 withdate:(NSDate *)date{
    NSMutableArray<CYXCalendarMonth *> * monthList = [NSMutableArray new];
    NSMutableArray<NSDate *> * resultDateList = [NSMutableArray new];
    switch (pageLoad) {
        case CYXCalendarPageLoadCurrentPage://获取第一页.
        {
            NSInteger  halfPageSize = PageSize/2;
            for (int i = 0; i<PageSize; i++) {
                [resultDateList addObject:[self getDateFrom:date offsetMonths:-halfPageSize+i+1]];
            }
        }
            break;
        case CYXCalendarPageLoadLastPage://上一页.
        {
            for (int i = 0; i<PageSize; i++) {
                [resultDateList addObject:[self getDateFrom:date offsetMonths:-PageSize+i]];
            }
        }
            break;
        case CYXCalendarPageLoadNextPage://下一页.
        {
            for (int i = 0; i<PageSize; i++) {
                [resultDateList addObject:[self getDateFrom:date offsetMonths:i+1]];
            }
        }
            break;
            
        default:
            break;
    }
    for (NSDate * date in resultDateList) {//获取每个月份的日数据.
        [monthList addObject:[self getMonthModelWithDate:date]];
    }
    return monthList;
}
/*获取月份信息*/
-(CYXCalendarMonth *)getMonthModelWithDate:(NSDate *)date{
    CYXCalendarMonth * calendarMonth = [[CYXCalendarMonth alloc] init];
    NSMutableArray<CYXCalendarDay *> * dayList = [NSMutableArray new];
    
    NSInteger year = [self convertDateToYear:date];
    NSInteger month = [self convertDateToMonth:date];
    //NSInteger day = [self convertDateToDay:date];
    NSInteger firstWeekDay = [self convertDateToFirstWeekDay:date];
    NSInteger totalDays = [self convertDateToTotalDays:date];
    
    printf("第%ld月\n",month);
    
    //NSInteger line = totalDays <= 28 ? 4 : 5;
    NSInteger line = 6;
    NSInteger column = 7;
    
    NSInteger available = 1;    //超过总天数后为下月
    NSInteger nextMonthDay = 1; //下月天数开始计数
    
    NSDate *lastMonthDate = [self getDateFrom:date offsetMonths:-1];    //上月月数
    NSInteger lastMonthTotalDays = [self convertDateToTotalDays:lastMonthDate]; //上月天数计数
    
    for (int i = 0; i < line; i++) {
        for (int j = 0; j < column; j++) {
            CYXCalendarDay * dayModel = [[CYXCalendarDay alloc] init];
            dayModel.currentYear = year;
            dayModel.currentMonth = month;
            if (available > totalDays) {
                printf("\t%ld ",nextMonthDay++);
                dayModel.currentDay = nextMonthDay-1;
                dayModel.calendarMonth = CalendarMonthNext;
                if (month==12) {
                    dayModel.currentMonth = 1;
                    dayModel.currentYear = year+1;
                }else{
                   dayModel.currentMonth++;
                }
                //continue;
            }else if (i == 0 && j < firstWeekDay) {
                NSInteger lastMonthDay = lastMonthTotalDays - firstWeekDay + j + 1; //j从0开始，所以这里+1
                printf("\t%ld ",lastMonthDay);
                dayModel.currentDay = lastMonthDay;
                dayModel.calendarMonth = CalendarMonthLast;
                if (month==1) {
                    dayModel.currentMonth = 12;
                    dayModel.currentYear = year-1;
                }else{
                    dayModel.currentMonth--;
                }
            }else {
                printf("\t%ld",available++);
                dayModel.currentDay = available-1;
                dayModel.calendarMonth = CalendarMonthCurrent;
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-M-d"];
            NSString * str = [NSString stringWithFormat:@"%ld-%ld-%ld",dayModel.currentYear,dayModel.currentMonth,dayModel.currentDay];
            dayModel.date = [formatter dateFromString:str];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            dayModel.dateString = [formatter stringFromDate:dayModel.date];
            [dayList addObject:dayModel];
        }
        printf("\n");
    }
    printf("\n");
    printf("\n");
    calendarMonth.currentYear = year;
    calendarMonth.currentMonth = month;
    calendarMonth.date =date;
    calendarMonth.dayList = dayList;
    return calendarMonth;
}
#pragma mark ---private
//根据date获取日
- (NSInteger)convertDateToDay:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    return [components day];
}

//根据date获取月
- (NSInteger)convertDateToMonth:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    return [components month];
}

//根据date获取年
- (NSInteger)convertDateToYear:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    return [components year];
}

//根据date获取当月周几 (美国时间周日-周六为 1-7,改为0-6方便计算)
- (NSInteger)convertDateToWeekDay:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:date];
    NSInteger weekDay = [components weekday] - 1;
    weekDay = MAX(weekDay, 0);
    return weekDay;
}

//根据date获取当月周几
- (NSInteger)convertDateToFirstWeekDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;  //美国时间周日为星期的第一天，所以周日-周六为1-7，改为0-6方便计算
}

//根据date获取当月总天数
- (NSInteger)convertDateToTotalDays:(NSDate *)date {
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}
//根据date获取偏移指定天数的date
- (NSDate *)getDateFrom:(NSDate *)date offsetDays:(NSInteger)offsetDays {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setDay:offsetDays];  //year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    return newdate;
}

//根据date获取偏移指定月数的date
- (NSDate *)getDateFrom:(NSDate *)date offsetMonths:(NSInteger)offsetMonths {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setMonth:offsetMonths];  //year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    return newdate;
}

//根据date获取偏移指定年数的date
- (NSDate *)getDateFrom:(NSDate *)date offsetYears:(NSInteger)offsetYears {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setYear:offsetYears];  //year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    return newdate;
}
@end
