//
//  NSObject+NetworkHelper.h
//  iotFoundation
//
//  Created by WangAlbert on 2015/8/11.
//  Copyright © 2015年 Rab2it. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface NSObject (NetworkHelper)
- (void)getIPAddress: (NSMutableDictionary*) array;
- (NSDictionary *)fetchSSIDInfo;
- (void)sendUDPCommand: (NSString*) cmd address:(NSString*) brcast;
- (bool)isUDPCommandFinished;
@end
