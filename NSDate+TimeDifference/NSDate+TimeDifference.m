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
@implementation NSDate (TimeDifference)

- (NSString *)localizedStringForKey:(NSString *)key table:(NSString*)table
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

    return [bundle localizedStringForKey:key value:nil table:table];
}

- (BOOL)containsString:(NSString *)part inString:(NSString *)str
{
    return [str rangeOfString:part].location != NSNotFound;
}

- (NSString *)localizedStringForNumber:(NSInteger)number unit:(NSString *)unit table:(NSString*)table
{
    // English language has only 2 forms: 1 year, 2 years, 5 years, 11 years, 101 years, 102 years
    // Russian language has 3 forms: 1 год, 2 года, 5 лет, 11 лет, 101 год, 102 года
    
    //try "more than 2 forms" key
    NSString *firstKey = [self keyForNumber:number unit:unit];
    NSString *localized = [self localizedStringForKey:firstKey table:table];
    
    if (localized && [self containsString:@"%d" inString:localized])
        return [NSString stringWithFormat:localized, abs(number)];
    else if (localized)
        return localized;
    
    // if no such key - try "2 forms" key
    NSString *secondKey = [self secondKeyForNumber:number unit:unit];
    localized = [self localizedStringForKey:secondKey table:table];
    
    if (localized && [self containsString:@"%d" inString:localized])
        return [NSString stringWithFormat:localized, abs(number)];
    else
        return localized;
}

// key for languages with more than 2 forms
- (NSString *)keyForNumber:(NSInteger)number unit:(NSString *)unit
{
    NSString *lastPart = number > 0 ? @"later" : @"ago";
    number = abs(number);
    if (number == 1)
    {
        return [NSString stringWithFormat:@"1 %@ %@", unit, lastPart];
    }
    else if (number % 10 > 1 && number % 10 < 5 && (number % 100 > 20 || number % 100 < 10))
    {
        return [NSString stringWithFormat:@"2 %@s %@", unit, lastPart];
    }
    else if (number % 10 == 1 && (number % 100 > 20 || number % 100 < 10))
    {
        // in russian 11 and 21 has different forms
        return [NSString stringWithFormat:@"21 %@s %@", unit, lastPart];
    }
    else
    {
        return [NSString stringWithFormat:@"%@ %@s %@", @"%d", unit, lastPart];
    }
}

// key for languages with 2 forms
- (NSString *)secondKeyForNumber:(NSInteger)number unit:(NSString *)unit
{
    NSString *lastPart = number > 0 ? @"later" : @"ago";
    number = abs(number);
    if (number == 1)
    {
        return [NSString stringWithFormat:@"1 %@ %@", unit, lastPart];
    }
    else
    {
        return [NSString stringWithFormat:@"%@ %@s %@", @"%d", unit, lastPart];
    }
}

- (NSString *)localizedStringForKey:(NSString *)key fromComponents:(NSDateComponents *)components table:(NSString*)table
{
    int value = [[components valueForKey:key] integerValue];
    if (value != 0)
        return [self localizedStringForNumber:value unit:key table:table];
    else
        return nil;
}

- (NSString *)stringWithTimeDifferenceUsingTable:(NSString*)table
{
    for (NSString *language in [NSLocale preferredLanguages])
    {
        if([language isEqualToString:@"ru"]){
            return [self stringWithTimeDifferenceRussianInTable:table];
        }else{
            return [self stringWithTimeDifferenceEnglishInTable:table];
        }
        break;
    }
    return [self description];
}

- (NSString *)stringWithTimeDifference
{
    return [self stringWithTimeDifferenceUsingTable:nil];
}

- (NSString *)stringWithAbbreviatedTimeDifference
{
    return [self stringWithTimeDifferenceUsingTable:@"Abbreviated"];
}

- (NSString *) stringWithTimeDifferenceEnglishInTable:(NSString*)table
{
    NSTimeInterval seconds = [self timeIntervalSinceNow];
    
    if(fabs(seconds) < 1)
        return [self localizedStringForKey:@"just now" table:table];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date] toDate:self options:0];
    
    int year = [[components valueForKey:@"year"]integerValue];
    if(year > 1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d years later" table:table], abs(year)];
    if(year == 1)
        return [self localizedStringForKey:@"1 year later" table:table];
    if(year == -1)
        return [self localizedStringForKey:@"1 year ago" table:table];
    if(year < -1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d years ago" table:table], abs(year)];
    
    int month = [[components valueForKey:@"month"]integerValue];
    if(month > 1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d months later" table:table], abs(month)];
    if(month == 1)
        return [self localizedStringForKey:@"1 month later" table:table];
    if(month == -1)
        return [self localizedStringForKey:@"1 month ago" table:table];
    if(month < -1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d months ago" table:table], abs(month)];
    
    int week = [[components valueForKey:@"week"]integerValue];
    if(week > 1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d weeks later" table:table], abs(week)];
    if(week == 1)
        return [self localizedStringForKey:@"1 week later" table:table];
    if(week == -1)
        return [self localizedStringForKey:@"1 week ago" table:table];
    if(week < -1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d weeks ago" table:table], abs(week)];
    
    int day = [[components valueForKey:@"day"]integerValue];
    if(day > 1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d days later" table:table], abs(day)];
    if(day == 1)
        return [self localizedStringForKey:@"1 day later" table:table];
    if(day == -1)
        return [self localizedStringForKey:@"1 day ago" table:table];
    if(day < -1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d days ago" table:table], abs(day)];
    
    int hour = [[components valueForKey:@"hour"]integerValue];
    if(hour > 1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d hours later" table:table], abs(hour)];
    if(hour == 1)
        return [self localizedStringForKey:@"1 hour later" table:table];
    if(hour == -1)
        return [self localizedStringForKey:@"1 hour ago" table:table];
    if(hour < -1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d hours ago" table:table], abs(hour)];
    
    int minute = [[components valueForKey:@"minute"]integerValue];
    if(minute > 1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d minutes later" table:table], abs(minute)];
    if(minute == 1)
        return [self localizedStringForKey:@"1 minute later" table:table];
    if(minute == -1)
        return [self localizedStringForKey:@"1 minute ago" table:table];
    if(minute < -1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d minutes ago" table:table], abs(minute)];
    
    int second = [[components valueForKey:@"second"]integerValue];
    if(second > 1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d seconds later" table:table], abs(second)];
    if(second == 1)
        return [self localizedStringForKey:@"1 second later" table:table];
    if(second == -1)
        return [self localizedStringForKey:@"1 second ago" table:table];
    if(second < -1)
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d seconds ago" table:table], abs(second)];
    
    return [self description];
}

- (NSString *) stringWithTimeDifferenceRussianInTable:(NSString*)table
{
    NSTimeInterval seconds = [self timeIntervalSinceNow];
    
    if(fabs(seconds) < 1)
        return [self localizedStringForKey:@"just now" table:table];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date] toDate:self options:0];
    
    NSArray *keys = @[@"year", @"month", @"week", @"day", @"hour", @"minute", @"second"];
    
    for (NSString *key in keys)
    {
        NSString *result = [self localizedStringForKey:key fromComponents:components table:table];
        if (result)
            return result;
    }

    return [self description];
}

@end
