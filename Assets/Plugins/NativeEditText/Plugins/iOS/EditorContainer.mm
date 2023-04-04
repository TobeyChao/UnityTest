//
//  EditorContainer.m
//  TestNativeEditText
//
//  Created by Soul on 2023/2/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EditorContainer.h"
#import "InputProxy.h"

@interface EditorContainer ()

@end

@implementation EditorContainer
{
    UIViewController *mainViewController;
    NSMutableDictionary *mobileInputList;
    UIView* container;
}

- (EditorContainer*) Init:(UIViewController*)ctrl
{
    mainViewController = ctrl;
    container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    container.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
    [mainViewController.view addSubview: container];
    
    mobileInputList = [NSMutableDictionary dictionary];
    return self;
}

- (void) CreateInputProxy:(NSString*)name :(NSString*)data
{
    InputProxy* inputProxy = [[InputProxy alloc] Init:container];
    [inputProxy Create:data];
    [mobileInputList setObject:inputProxy forKey:name];
}

- (void) DestroyInputProxy:(NSString*)name
{
    if ([[mobileInputList allKeys] containsObject:name]) {
        InputProxy* proxyToDel = [mobileInputList objectForKey:name];
        if (proxyToDel != nil) {
            [proxyToDel RemoveFromParent];
            [mobileInputList removeObjectForKey:name];
        }
    }
}

- (void) ModifyInputProxy:(NSString*)name :(NSString*)data
{
    if ([[mobileInputList allKeys] containsObject:name]) {
        InputProxy* proxyToDel = [mobileInputList objectForKey:name];
        if (proxyToDel != nil) {
            [proxyToDel ProcessMessage:data];
        }
    }
}
@end
