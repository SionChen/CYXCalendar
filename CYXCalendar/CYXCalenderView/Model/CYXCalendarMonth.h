//
//  CYXCalendarMonth.h
//  CYXCalendar
//
//  Created by 晓 on 2019/7/29.
//  Copyright © 2019 陈泳晓. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CYXCalendarDay;
@interface CYXCalendarMonth : NSObject
/*当前日期*/
@property (nonatomic,strong) NSDate *date;
/*当前月 */
@property (nonatomic,assign) NSInteger currentMonth;
/*当前年*/
@property (nonatomic,assign) NSInteger currentYear;


/*日子列表*/
@property (nonatomic,strong) NSArray<CYXCalendarDay *> *dayList;
@end

NS_ASSUME_NONNULL_END
