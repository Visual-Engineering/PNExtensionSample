/* Copyright 2017 Urban Airship and Contributors */

#import "UAEvent+Internal.h"
#import "UAPush.h"
#import "UAirship.h"

/*
 * Fix for CTTelephonyNetworkInfo bug where instances might receive
 * notifications after being deallocated causes EXC_BAD_ACCESS exceptions. We
 * suspect that it is an iOS6 only issue.
 *
 * http://stackoverflow.com/questions/14238586/coretelephony-crash/15510580#15510580
 */
static CTTelephonyNetworkInfo *netInfo_;
static dispatch_once_t netInfoDispatchToken_;

@implementation UAEvent

- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventID = [NSUUID UUID].UUIDString;
        self.time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        return self;
    }
    return nil;
}

- (BOOL)isValid {
    return YES;
}

- (NSString *)eventType {
    return @"base";
}

- (UAEventPriority)priority {
    return UAEventPriorityNormal;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"UAEvent ID: %@ type: %@ time: %@ data: %@",
            self.eventID, self.eventType, self.time, self.data];
}

- (NSString *)carrierName {
    dispatch_once(&netInfoDispatchToken_, ^{
        netInfo_ = [[CTTelephonyNetworkInfo alloc] init];
    });
    return netInfo_.subscriberCellularProvider.carrierName;
}

- (NSArray *)notificationTypes {
    NSMutableArray *notificationTypes = [NSMutableArray array];

    UANotificationOptions authorizedOptions = [UAirship push].authorizedNotificationOptions;

    if ((UANotificationOptionBadge & authorizedOptions) > 0) {
        [notificationTypes addObject:@"badge"];
    }

    if ((UANotificationOptionSound & authorizedOptions) > 0) {
        [notificationTypes addObject:@"sound"];
    }

    if ((UANotificationOptionAlert & authorizedOptions) > 0) {
        [notificationTypes addObject:@"alert"];
    }

    return notificationTypes;
}

- (NSUInteger)jsonEventSize {
    NSMutableDictionary *eventDictionary = [NSMutableDictionary dictionary];
    [eventDictionary setValue:self.eventType forKey:@"type"];
    [eventDictionary setValue:self.time forKey:@"time"];
    [eventDictionary setValue:self.eventID forKey:@"event_id"];
    [eventDictionary setValue:self.data forKey:@"data"];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:eventDictionary
                                                       options:0
                                                         error:nil];

    return [jsonData length];
}

- (id)debugQuickLookObject {
    return self.data.description;
}

@end
