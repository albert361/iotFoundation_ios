//
//  NSObject+NetworkHelper.m
//  iotFoundation
//
//  Created by WangAlbert on 2015/8/11.
//  Copyright © 2015年 Rab2it. All rights reserved.
//

#import "NSObject+NetworkHelper.h"
#import "GCDAsyncUdpSocket.h"
@import SystemConfiguration.CaptiveNetwork;

@implementation NSObject (NetworkHelper)

- (void)getIPAddress: (NSMutableDictionary*) array
{
    NSString *address = @"error";
    NSString *netmask = @"error";
    NSString *dest = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                    dest = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    [array setValue:address forKey:@"ip"];
    [array setValue:netmask forKey:@"mask"];
    [array setValue:dest forKey:@"brcast"];
    
}

/** Returns first non-empty SSID network info dictionary.
 *  @see CNCopyCurrentNetworkInfo */
- (NSDictionary *)fetchSSIDInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

GCDAsyncUdpSocket *udpSocket;
bool isWaitingOK;

- (void)sendUDPCommand: (NSString*) cmd address:(NSString*) brcast
{
    isWaitingOK = TRUE;
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    
    if (![udpSocket bindToPort:0 error:&error])
    {;
        return;
    }
    if (![udpSocket beginReceiving:&error])
    {
        return;
    }

    NSData* data = [cmd dataUsingEncoding:NSUTF8StringEncoding];
    
    [udpSocket enableBroadcast:true error:&error];
    [udpSocket sendData:data toHost:brcast port:6024 withTimeout:-1 tag:0];
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (msg)
    {
        NSLog(@"RECV: %@", msg);
        if ([msg isEqualToString:@"ok"]) {
            isWaitingOK = FALSE;
        }
    }
    else
    {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        
        NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
    }
}

- (bool)isUDPCommandFinished
{
    return !isWaitingOK;
}
@end
