//
//  KeyboardUtil.m
//  TestNativeEditText
//
//  Created by Soul on 2023/3/21.
//

#import "KeyboardUtil.h"

@implementation KeyboardUtil

static NSString *object;
static NSString *receiver;

// Convert JSON string to NSDictionary
+ (NSDictionary *) JsonToDict:(NSString *)json {
    NSError *error;
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    return (error) ? NULL : [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
}

// Convert NSDictionary to JSON string
+ (NSString *) DictToJson:(NSDictionary *)dict {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    return (error) ? NULL : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

// Plugins initialize
+ (void) Initialize:(NSString *)data {
    NSDictionary *params = [self JsonToDict:data];
    object = [params valueForKey:@"object"];
    receiver = [params valueForKey:@"receiver"];
}

// Send data in JSON format to Unity
+ (void) SendData:(NSString *)plugin data:(NSString *)data {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:plugin forKey:@"name"];
    [dict setValue:data forKey:@"data"];
    NSString *result = [self DictToJson:dict];
    NSLog(@"%@ - %@", plugin, result);
    //UnitySendMessage([object cStringUsingEncoding:NSUTF8StringEncoding], [receiver cStringUsingEncoding:NSUTF8StringEncoding], [result cStringUsingEncoding:NSUTF8StringEncoding]);
}

// Send error
+ (void) SendError:(NSString *)plugin code:(NSString *)code {
    [self SendError:plugin code:code data:NULL];
}

// Send error in JSON format to Unity
+ (void) SendError:(NSString *)plugin code:(NSString *)code data:(NSString *)data {
    NSDictionary *error = [NSDictionary dictionaryWithObjectsAndKeys:code, @"code", data, @"message", nil];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:plugin forKey:@"name"];
    [dict setValue:error forKey:@"error"];
    NSString *result = [self DictToJson:dict];
    //UnitySendMessage([object cStringUsingEncoding:NSUTF8StringEncoding], [receiver cStringUsingEncoding:NSUTF8StringEncoding], [result cStringUsingEncoding:NSUTF8StringEncoding]);
}

// Init plugins system
void PluginsInit(const char *data) {
    [KeyboardUtil Initialize:[NSString stringWithUTF8String:data]];
}

@end
