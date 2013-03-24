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

- (BOOL)containsString:(NSString *)part inString:(NSString *)str
{
    return [str rangeOfString:part].location != NSNotFound;
}

- (NSString *)localizedStringForNumber:(NSInteger)number unit:(NSString *)unit
{
    // English language has only 2 forms: 1 year, 2 years, 5 years, 11 years, 101 years, 102 years
    // Russian language has 3 forms: 1 год, 2 года, 5 лет, 11 лет, 101 год, 102 года
    
    //try "more than 2 forms" key
    NSString *firstKey = [self keyForNumber:number unit:unit];
    NSString *localized = [self localizedStringForKey:firstKey];
    
    if (localized && [self containsString:@"%d" inString:localized])
        return [NSString stringWithFormat:localized, abs(number)];
    else if (localized)
        return localized;
    
    // if no such key - try "2 forms" key
    NSString *secondKey = [self secondKeyForNumber:number unit:unit];
    localized = [self localizedStringForKey:secondKey];
    
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

- (NSString *)localizedStringForKey:(NSString *)key fromComponents:(NSDateComponents *)components
{
    int value = [[components valueForKey:key] integerValue];
    if (value != 0)
        return [self localizedStringForNumber:value unit:key];
    else
        return nil;
}

- (NSString *) stringWithTimeDifference
{
    NSTimeInterval seconds = [self timeIntervalSinceNow];
            
    if(fabs(seconds) < 1)
        return [self localizedStringForKey:@"just now"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date] toDate:self options:0];
    
    NSArray *keys = @[@"year", @"month", @"week", @"day", @"hour", @"minute", @"second"];
    
    for (NSString *key in keys)
    {
        NSString *result = [self localizedStringForKey:key fromComponents:components];
        if (result)
            return result;
    }

    return [self description];
}

@end
