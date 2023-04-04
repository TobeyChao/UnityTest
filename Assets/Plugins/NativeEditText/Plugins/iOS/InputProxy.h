//
//  InputProxy.h
//  TestNativeEditText
//
//  Created by Soul on 2023/2/13.
//

#ifndef InputProxy_h
#define InputProxy_h

#import <UIKit/UIKit.h>

@interface InputProxy : NSObject <UITextFieldDelegate, UITextViewDelegate>
- (InputProxy*) Init:(UIView*)ctrl;
- (void) Create:(NSString*)data;
- (void) RemoveFromParent;
- (void) ProcessMessage:(NSString*)data;
- (void) SetFocus:(Boolean)isFocus;
- (Boolean) GetFocus;
- (void) SetVisible:(Boolean)isVisible;
- (Boolean) GetVisible;
- (NSString*) GetText;
- (void) SetText:(NSString*)str;
- (void) SetTextColor:(int)a :(int)r :(int)g :(int)b;
- (void) SetBackgroundColor:(int)a :(int)r :(int)g :(int)b0;
- (void) SetHint:(NSString*)placeHolder;
- (void) SetHintTextColor:(int)a :(int)r :(int)g :(int)b;
- (void) SetAlignment:(NSString*)alignment;
- (void) SetRect:(NSDictionary *)data;
- (void) SetRect:(int)posX :(int)posY :(int)width :(int)height;
- (void) SetImeOptions:(NSString*)returnKeyType;
- (void) ShowKeyboard:(BOOL)isShow;
@end

#endif /* InputProxy_h */
