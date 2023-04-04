//
//  KeyboardUtil.h
//  TestNativeEditText
//
//  Created by Soul on 2023/3/21.
//

#ifndef KeyboardUtil_h
#define KeyboardUtil_h

#import <Foundation/Foundation.h>

extern void PluginsInit(const char *data);

@interface KeyboardUtil : NSObject

+ (NSDictionary *) JsonToDict:(NSString *)json;
+ (NSString *) DictToJson:(NSDictionary *)dict;
+ (void) Initialize:(NSString *)data;
+ (void) SendData:(NSString *)plugin data:(NSString *)data;
+ (void) SendError:(NSString *)plugin code:(NSString *)code;
+ (void) SendError:(NSString *)plugin code:(NSString *)code data:(NSString *)data;

@end

#endif /* KeyboardUtil_h */
