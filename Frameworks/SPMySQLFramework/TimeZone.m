//
//  TimeZone.m
//  SPMySQL.framework
//
//  Created by Robin Kunde on 8/19/20.
//

#import "TimeZone.h"
#import "SPMySQLStringAdditions.h"

@implementation SPMySQLConnection (TimeZone)

#pragma mark -
#pragma mark Current connection time zone information

/**
 * Returns the time zone identifier in use by the connection.
 */
- (NSString *)timeZoneIdentifier
{
    return [NSString stringWithString:timeZoneIdentifier];
}

#pragma mark -
#pragma mark Setting connection time zone

- (BOOL)setTimeZoneIdentifier:(NSString *)newTimeZoneIdentifier
{
    if ([newTimeZoneIdentifier isEqualToString:timeZoneIdentifier]) {
        return YES;
    }

    if ([newTimeZoneIdentifier isEqualToString:@""]) {
        [self queryString:[NSString stringWithFormat:@"SET time_zone = @@GLOBAL.time_zone"]];
    } else {
        [self queryString:[NSString stringWithFormat:@"SET time_zone = %@", [newTimeZoneIdentifier mySQLTickQuotedString]]];
    }

    // If the query errored, no time zone change occurred - return failure.
    if ([self queryErrored]) {
        return NO;
    }

    [timeZoneIdentifier release];
    timeZoneIdentifier = [[NSString alloc] initWithString:newTimeZoneIdentifier];

    return YES;
}

@end
