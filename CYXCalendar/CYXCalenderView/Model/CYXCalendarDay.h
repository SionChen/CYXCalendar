//
//  CYXCalendarDay.h
//  CYXCalendar
//
//  Created by 晓 on 2019/7/29.
//  Copyright © 2019 陈泳晓. All rights reserved.
//

#import "CYXCalendarMonth.h"

typedef NS_ENUM(NSInteger,CYXCalendarMonthEnum){
    CalendarMonthCurrent = 0,//当前月份
    CalendarMonthLast = 1,//上月份
    CalendarMonthNext = 2,//下月份
};
@interface CYXCalendarDay : CYXCalendarMonth
/*日期字符串 yyyy-MM-DD*/
@property (nonatomic,copy) NSString *dateString;
/*当前日*/
@property (nonatomic,assign) NSInteger currentDay;
/*和当前月份的关系*/
@property (nonatomic,assign) CYXCalendarMonthEnum calendarMonth;
/*选择*/
@property (nonatomic,assign) BOOL selected;
@end

