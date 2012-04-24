//
//  NSDate+TimeDifference.m
//  SOLibrary
//
//  Created by satoshi ootake on 12/04/17.
//  Copyright (c) 2012年 satoshi ootake. All rights reserved.
//

#import "NSDate+TimeDifference.h"

//--------------------------------------------------------------//
#pragma mark -- NSDate (TimeDifference) --
//--------------------------------------------------------------//
@interface NSData (TimeDifference)

- (NSString *)localizedStringForKey:(NSString *)key;

@end

@implementation NSDate (TimeDifference)

- (NSString *)localizedStringForKey:(NSString *)key
{
    static NSBundle *bundle = nil;
    if (bundle == nil)
    {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"NSDate+TimeDifference" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath] ?: [NSBundle mainBundle];
        
        for (NSString *language in [NSLocale preferredLanguages])
        {
            if ([[bundle localizations] containsObject:language])
            {
                bundlePath = [bundle pathForResource:language ofType:@"lproj"];
                bundle = [NSBundle bundleWithPath:bundlePath];
                break;
            }
        }
    }
    
    return [bundle localizedStringForKey:key value:nil table:nil];
}

- (NSString *) stringWithTimeDifference
{
    NSTimeInterval timeInterval = [self timeIntervalSinceNow];
    
    int secondsInADay = 3600*24;
    int secondsInAYear = 3600*24*365;
    int yearsDiff = abs(timeInterval/secondsInAYear); 
    int daysDiff = abs(timeInterval/secondsInADay);
    int hoursDiff = abs((abs(timeInterval) - (daysDiff * secondsInADay)) / 3600);
    int minutesDiff = abs((abs(timeInterval) - ((daysDiff * secondsInADay) + (hoursDiff * 60))) / 60);
    int secondsDiff = (abs(timeInterval) - ((daysDiff * secondsInADay) + (hoursDiff * 3600) + (minutesDiff * 60)));
    
    if (yearsDiff > 1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"TimeDifferenceYearsKey"],yearsDiff];
    else if (yearsDiff == 1)
        return [self localizedStringForKey:@"TimeDifferenceYearKey"];
    
    if (daysDiff > 1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"TimeDifferenceDaysKey"],daysDiff];
    else if (daysDiff == 1)
        return [self localizedStringForKey:@"TimeDifferenceDayKey"];
    
    if (hoursDiff > 1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"TimeDifferenceHoursKey"],hoursDiff];
    else if (hoursDiff == 1)
        return [self localizedStringForKey:@"TimeDifferenceHourKey"];
    
    if (minutesDiff > 1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"TimeDifferenceMinutesKey"],minutesDiff];
    else if (minutesDiff == 1)
        return [self localizedStringForKey:@"TimeDifferenceMinuteKey"];
    
    if (secondsDiff > 1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"TimeDifferenceSecondsKey"],secondsDiff];
    else if (secondsDiff == 1)
        return [self localizedStringForKey:@"TimeDifferenceSecondKey"];

    return [self localizedStringForKey:@"TimeDifferenceNowKey"];
    
}

@end
