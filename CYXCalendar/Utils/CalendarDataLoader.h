//
//  CalendarDataLoader.h
//  CYXCalendar
//
//  Created by 晓 on 2019/7/29.
//  Copyright © 2019 陈泳晓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYXCalendarMonth.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,CYXCalendarPageLoadModel){
    CYXCalendarPageLoadCurrentPage = 0,
    CYXCalendarPageLoadLastPage = 1,
    CYXCalendarPageLoadNextPage = 2,
};

static NSInteger PageSize = 20;
@interface CalendarDataLoader : NSObject
/*加载数据*/
-(NSArray<CYXCalendarMonth *> *)loadDataWithPageLoadModel:(CYXCalendarPageLoadModel)pageLoad;
/*绑定知道月份加载数据*/
-(NSArray<CYXCalendarMonth *> *)loadDataWithPageLoadModel:(CYXCalendarPageLoadModel)pageLoad
                                                 withdate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
