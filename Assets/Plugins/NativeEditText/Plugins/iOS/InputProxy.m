//
//  InIputProxy.m
//  TestNativeEditText
//
//  Created by Soul on 2023/2/13.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "InputProxy.h"
#import "KeyboardUtil.h"
#import "UITextViewWithPlaceholder.h"

#define CREATE @"CREATE_EDIT"
#define REMOVE @"REMOVE_EDIT"
#define SET_TEXT @"SET_TEXT"
#define SET_RECT @"SET_RECT"
#define ON_FOCUS @"ON_FOCUS"
#define ON_UNFOCUS @"ON_UNFOCUS"
#define SET_FOCUS @"SET_FOCUS"
#define SET_VISIBLE @"SET_VISIBLE"
#define TEXT_CHANGE @"TEXT_CHANGE"
#define TEXT_END_EDIT @"TEXT_END_EDIT"
#define RETURN_PRESSED @"RETURN_PRESSED"
#define KEYBOARD_ACTION @"KEYBOARD_ACTION"
#define READY @"READY"
#define SET_SELECTION @"SET_SELECTION"

@interface InputProxy ()
{
    int inputId;
    int characterLimit;
    BOOL multiline;
    bool disableEmoji;
    CGRect rectKeyboardFrame;
    UIView *editView;
    UIView *parentView;
}
@end

@implementation InputProxy

- (InputProxy*) Init:(UIView*)view {
    parentView = view;
    return self;
}

- (void) Create:(NSString*)json
{
    NSDictionary *data = [KeyboardUtil JsonToDict:json];
    NSString *placeholder = [data valueForKey:@"hint"];
    float fontSize = [[data valueForKey:@"font_size"] floatValue];
    float parentWidth = parentView.bounds.size.width;
    float parentHeight = parentView.bounds.size.height;
    int x = [[data valueForKey:@"posX"] floatValue] * parentWidth;
    int y = [[data valueForKey:@"posY"] floatValue] * parentHeight;
    int width = [[data valueForKey:@"width"] floatValue] * parentWidth;
    int height = [[data valueForKey:@"height"] floatValue] * parentHeight;
    characterLimit = [[data valueForKey:@"character_limit"] intValue];
    disableEmoji = [[data valueForKey:@"disable_emoji"] boolValue];
    float textColor_r = [[data valueForKey:@"textColor_r"] floatValue];
    float textColor_g = [[data valueForKey:@"textColor_g"] floatValue];
    float textColor_b = [[data valueForKey:@"textColor_b"] floatValue];
    float textColor_a = [[data valueForKey:@"textColor_a"] floatValue];
    UIColor *textColor = [UIColor colorWithRed:textColor_r green:textColor_g blue:textColor_b alpha:textColor_a];
    float backColor_r = [[data valueForKey:@"backColor_r"] floatValue];
    float backColor_g = [[data valueForKey:@"backColor_g"] floatValue];
    float backColor_b = [[data valueForKey:@"backColor_b"] floatValue];
    float backColor_a = [[data valueForKey:@"backColor_a"] floatValue];
    UIColor *backgroundColor = [UIColor colorWithRed:backColor_r green:backColor_g blue:backColor_b alpha:backColor_a];
    float placeHolderColor_r = [[data valueForKey:@"placeholderColor_r"] floatValue];
    float placeHolderColor_g = [[data valueForKey:@"placeholderColor_g"] floatValue];
    float placeHolderColor_b = [[data valueForKey:@"placeholderColor_b"] floatValue];
    float placeHolderColor_a = [[data valueForKey:@"placeholderColor_a"] floatValue];
    UIColor *placeHolderColor = [UIColor colorWithRed:placeHolderColor_r green:placeHolderColor_g blue:placeHolderColor_b alpha:placeHolderColor_a];
    NSString *alignment = [data valueForKey:@"alignment"];
    multiline = [[data valueForKey:@"multiline"] boolValue];
    BOOL autoCorrection = NO;
    BOOL password = NO;
    UIKeyboardType keyType = UIKeyboardTypeDefault;
    UIControlContentHorizontalAlignment halign = UIControlContentHorizontalAlignmentLeft;
    UIControlContentVerticalAlignment valign = UIControlContentVerticalAlignmentCenter;
    NSTextAlignment textAlign = NSTextAlignmentCenter;
    if ([alignment isEqualToString:@"UpperLeft"]) {
        valign = UIControlContentVerticalAlignmentTop;
        halign = UIControlContentHorizontalAlignmentLeft;
        textAlign = NSTextAlignmentLeft;
    } else if ([alignment isEqualToString:@"UpperCenter"]) {
        valign = UIControlContentVerticalAlignmentTop;
        halign = UIControlContentHorizontalAlignmentCenter;
        textAlign = NSTextAlignmentCenter;
    } else if ([alignment isEqualToString:@"UpperRight"]) {
        valign = UIControlContentVerticalAlignmentTop;
        halign = UIControlContentHorizontalAlignmentRight;
        textAlign = NSTextAlignmentRight;
    } else if ([alignment isEqualToString:@"MiddleLeft"]) {
        valign = UIControlContentVerticalAlignmentCenter;
        halign = UIControlContentHorizontalAlignmentLeft;
        textAlign = NSTextAlignmentLeft;
    } else if ([alignment isEqualToString:@"MiddleCenter"]) {
        valign = UIControlContentVerticalAlignmentCenter;
        halign = UIControlContentHorizontalAlignmentCenter;
        textAlign = NSTextAlignmentCenter;
    } else if ([alignment isEqualToString:@"MiddleRight"]) {
        valign = UIControlContentVerticalAlignmentCenter;
        halign = UIControlContentHorizontalAlignmentRight;
        textAlign = NSTextAlignmentRight;
    } else if ([alignment isEqualToString:@"LowerLeft"]) {
        valign = UIControlContentVerticalAlignmentBottom;
        halign = UIControlContentHorizontalAlignmentLeft;
        textAlign = NSTextAlignmentLeft;
    } else if ([alignment isEqualToString:@"LowerCenter"]) {
        valign = UIControlContentVerticalAlignmentBottom;
        halign = UIControlContentHorizontalAlignmentCenter;
        textAlign = NSTextAlignmentCenter;
    } else if ([alignment isEqualToString:@"LowerRight"]) {
        valign = UIControlContentVerticalAlignmentBottom;
        halign = UIControlContentHorizontalAlignmentRight;
        textAlign = NSTextAlignmentRight;
    }
    
    UIReturnKeyType returnKeyType = UIReturnKeyDefault;
    NSString *returnKeyTypeString = [data valueForKey:@"return_key"];
    if ([returnKeyTypeString isEqualToString:@"Next"]) {
        returnKeyType = UIReturnKeyNext;
    } else if ([returnKeyTypeString isEqualToString:@"Done"]) {
        returnKeyType = UIReturnKeyDone;
    } else if ([returnKeyTypeString isEqualToString:@"Search"]) {
        returnKeyType = UIReturnKeySearch;
    } else if ([returnKeyTypeString isEqualToString:@"Send"]) {
        returnKeyType = UIReturnKeySend;
    } else if ([returnKeyTypeString isEqualToString:@"Go"]) {
        returnKeyType = UIReturnKeyGo;
    } else if ([returnKeyTypeString isEqualToString:@"Send"]) {
        returnKeyType = UIReturnKeySend;
    }
    fontSize = fontSize / [UIScreen mainScreen].scale;
    UIFont *uiFont = [UIFont systemFontOfSize:fontSize];
    if (multiline) {
        UITextViewWithPlaceholder *textView = [[UITextViewWithPlaceholder alloc] initWithFrame:CGRectMake(x, y, width, height)];
        textView.keyboardType = keyType;
        [textView setFont:uiFont];
        textView.scrollEnabled = TRUE;
        textView.delegate = self;
        textView.tag = inputId;
        textView.text = @"";
        textView.textColor = textColor;
        textView.backgroundColor = backgroundColor;
        textView.returnKeyType = returnKeyType;
        textView.textAlignment = textAlign;
        textView.autocorrectionType = autoCorrection ? UITextAutocorrectionTypeYes : UITextAutocorrectionTypeNo;
        textView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        textView.placeholder = placeholder;
        textView.placeholderColor = placeHolderColor;
        textView.delegate = self;
        if (keyType == UIKeyboardTypeEmailAddress) {
            textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
        [textView setSecureTextEntry:password];
        editView = textView;
    } else {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
        textField.keyboardType = keyType;
        [textField setFont:uiFont];
        textField.delegate = self;
        textField.tag = inputId;
        textField.text = @"";
        textField.textColor = textColor;
        textField.backgroundColor = backgroundColor;
        textField.returnKeyType = returnKeyType;
        textField.autocorrectionType = autoCorrection ? UITextAutocorrectionTypeYes : UITextAutocorrectionTypeNo;
        textField.contentVerticalAlignment = valign;
        textField.contentHorizontalAlignment = halign;
        textField.textAlignment = textAlign;
        NSMutableParagraphStyle *setting = [[NSMutableParagraphStyle alloc] init];
        setting.alignment = textAlign;
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor, NSParagraphStyleAttributeName : setting}];
        textField.delegate = self;
        if (keyType == UIKeyboardTypeEmailAddress) {
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [textField addTarget:self action:@selector(textFieldActive:) forControlEvents:UIControlEventEditingDidBegin];
        [textField addTarget:self action:@selector(textFieldInActive:) forControlEvents:UIControlEventEditingDidEnd];
        [textField setSecureTextEntry:password];
        editView = textField;
    }
    
    [parentView addSubview:editView];
    NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
    [msg setValue:READY forKey:@"msg"];
    [self sendData:msg];
}

- (void) RemoveFromParent
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [editView resignFirstResponder];
    [editView removeFromSuperview];
}

- (void) ProcessMessage:(NSString*)data
{
    
}

- (void) SetFocus:(Boolean) isFocus
{
    if (isFocus) {
        [editView becomeFirstResponder];
    } else {
        [editView resignFirstResponder];
    }
}

- (Boolean) GetFocus
{
    return editView.isFirstResponder;
}

- (void) SetVisible:(Boolean)isVisible
{
    editView.hidden = !isVisible;
}

- (Boolean) GetVisible
{
    return editView.isHidden;
}

- (void) SetSelection:(int)pos
{
    if ([editView isKindOfClass:[UITextField class]]) {
        [self selectTextForTextField:((UITextField *) editView) atRange:NSMakeRange(pos, 0)];
    } else if ([editView isKindOfClass:[UITextView class]]) {
        [self selectTextForTextView:((UITextView *) editView) atRange:NSMakeRange(pos, 0)];
    } else {
    }
}

- (NSString*) GetText
{
    if ([editView isKindOfClass:[UITextField class]]) {
        return [((UITextField *) editView) text];
    } else if ([editView isKindOfClass:[UITextView class]]) {
        return [((UITextView *) editView) text];
    } else {
        return @"";
    }
}

- (void) SetText:(NSString*)str
{
    if ([editView isKindOfClass:[UITextField class]]) {
        return [((UITextField *) editView) setText:str];
    } else if ([editView isKindOfClass:[UITextView class]]) {
        return [((UITextView *) editView) setText:str];
    }
}

- (void) SetTextColor:(int)a :(int)r :(int)g :(int)b
{
    
}

- (void) SetBackgroundColor:(int)a :(int)r :(int)g :(int)b
{
    
}

- (void) SetHint:(NSString*)placeHolder
{
    
}

- (void) SetHintTextColor:(int)a :(int)r :(int)g :(int)b
{
    
}

- (void) SetAlignment:(NSString*)alignment
{
    
}

- (void) SetRect:(NSDictionary *)data
{
    int x = [[data valueForKey:@"posX"] intValue] * parentView.bounds.size.width;
    int y = [[data valueForKey:@"posY"] intValue] * parentView.bounds.size.height;
    int width = [[data valueForKey:@"width"] intValue] * parentView.bounds.size.width;
    int height = [[data valueForKey:@"height"] intValue] * parentView.bounds.size.height;
    x -= editView.superview.frame.origin.x;
    y -= editView.superview.frame.origin.y;
    [self SetRect:x :y :width :height];
}

- (void) SetRect:(int)posX :(int)posY :(int)width :(int)height
{
    editView.frame = CGRectMake(posX, posY, width, height);
}

- (void) SetImeOptions:(NSString*)returnKeyType
{
    
}

- (void) ShowKeyboard:(BOOL)isShow
{
    [editView endEditing:isShow];
}

- (void)setText:(NSString *)text {
    if ([editView isKindOfClass:[UITextField class]]) {
        [((UITextField *) editView) setText:text];
    } else if ([editView isKindOfClass:[UITextView class]]) {
        [((UITextView *) editView) setText:text];
    }
}

- (IBAction) doneClicked:(id)sender {
    [self ShowKeyboard:false];
}

// 文本发生改变
- (void)onTextChange:(NSString *)text {
    NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
    [msg setValue:TEXT_CHANGE forKey:@"msg"];
    [msg setValue:text forKey:@"text"];
    [self sendData:msg];
}

- (void)onTextEditEnd:(NSString *)text {
    NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
    [msg setValue:TEXT_END_EDIT forKey:@"msg"];
    [msg setValue:text forKey:@"text"];
    [self sendData:msg];
}

// TextView内容完成改变
- (void)textViewDidChange:(UITextView *)textView {
    [self onTextChange:textView.text];
}

// TextView开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (multiline) {
        NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
        [msg setValue:ON_FOCUS forKey:@"msg"];
        [self sendData:msg];
    }
}

// TextView完成编辑
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (multiline) {
        NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
        [msg setValue:ON_UNFOCUS forKey:@"msg"];
        [self sendData:msg];
    }
    [self onTextEditEnd:textView.text];
}

// TextView将要改变内容
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (disableEmoji) {
        // 不让输入表情
        if ([textView isFirstResponder]) {
            if ([self isUsingEmoji])
            {
                return NO;
            }
        }
        
        if ([textView isFirstResponder]) {
            if ([self isEmoji:text]) {
                return NO;
            }
        }
    }
    
    return YES;
}

// TextField返回一个BOOL值，指明是否允许在按下回车键时结束编辑
// 如果允许要调用resignFirstResponder方法，这回导致结束编辑，而键盘会被收起
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![editView isFirstResponder]) {
        return YES;
    }
    NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
    [msg setValue:RETURN_PRESSED forKey:@"msg"];
    [self sendData:msg];
    return YES;
}

// TextField将要改变内容
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [text length] - range.length;
    if (characterLimit > 0) {
        return newLength <= characterLimit;
    }
    
    if (disableEmoji) {
        // 不让输入表情
        if ([textField isFirstResponder]) {
            if ([self isUsingEmoji])
            {
                return NO;
            }
        }
        
        if ([textField isFirstResponder]) {
            if ([self isEmoji:text]) {
                return NO;
            }
        }
    }
    
    return YES;
}

// TextField获得焦点
- (void)textFieldActive:(UITextField *)theTextField {
    NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
    [msg setValue:ON_FOCUS forKey:@"msg"];
    [self sendData:msg];
}

// TextField失去焦点
- (void)textFieldInActive:(UITextField *)theTextField {
    NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
    [msg setValue:ON_UNFOCUS forKey:@"msg"];
    [self sendData:msg];
}

// TextField的文字变化
- (void)textFieldDidChange:(UITextField *)theTextField {
    [self onTextChange:theTextField.text];
}

// 键盘即将出现
- (void)keyboardWillShow:(NSNotification *)notification {
    if (![editView isFirstResponder]) {
        return;
    }
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    rectKeyboardFrame = [keyboardFrameBegin CGRectValue];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGFloat height = screenScale * rectKeyboardFrame.size.height;
    NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
    [msg setValue:KEYBOARD_ACTION forKey:@"msg"];
    [msg setValue:[NSNumber numberWithBool:YES] forKey:@"show"];
    [msg setValue:[NSNumber numberWithFloat:height] forKey:@"height"];
    [self sendData:msg];
}

// 键盘即将关闭
- (void)keyboardWillHide:(NSNotification *)notification {
    NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
    [msg setValue:KEYBOARD_ACTION forKey:@"msg"];
    [msg setValue:[NSNumber numberWithBool:NO] forKey:@"show"];
    [msg setValue:[NSNumber numberWithFloat:0] forKey:@"height"];
    [self sendData:msg];
}

-(BOOL)isUsingEmoji{
    UITextInputMode* inputMode = [[[UITextInputMode activeInputModes] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isDisplayed = YES"]] lastObject];
    NSString* lan =[inputMode primaryLanguage];
    return [lan isEqualToString:@"emoji"];
}

-(BOOL)isEmoji:(NSString *)character {
    
    UILabel *characterRender = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    characterRender.text = character;
    characterRender.backgroundColor = [UIColor blackColor];//needed to remove subpixel rendering colors
    [characterRender sizeToFit];
    
    CGRect rect = [characterRender bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef contextSnap = UIGraphicsGetCurrentContext();
    [characterRender.layer renderInContext:contextSnap];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = [capturedImage CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    BOOL colorPixelFound = NO;
    
    int x = 0;
    int y = 0;
    while (y < height && !colorPixelFound) {
        while (x < width && !colorPixelFound) {
            
            NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
            
            CGFloat red = (CGFloat)rawData[byteIndex];
            CGFloat green = (CGFloat)rawData[byteIndex+1];
            CGFloat blue = (CGFloat)rawData[byteIndex+2];
            
            CGFloat h, s, b, a;
            UIColor *c = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
            [c getHue:&h saturation:&s brightness:&b alpha:&a];
            
            b /= 255.0f;
            
            if (b > 0) {
                colorPixelFound = YES;
            }
            
            x++;
        }
        x=0;
        y++;
    }
    return colorPixelFound;
}

- (void)sendData:(NSMutableDictionary *)data {
    [data setValue:[NSNumber numberWithInt:inputId] forKey:@"id"];
    NSString *result = [KeyboardUtil DictToJson:data];
    [KeyboardUtil SendData:@"NativeEditText" data:result];
}

- (void)selectTextForTextField:(UITextField *)textField atRange:(NSRange)range {
    UITextPosition *start = [textField positionFromPosition:[textField beginningOfDocument] offset:range.location];
    UITextPosition *end = [textField positionFromPosition:start offset:range.length];
    [textField setSelectedTextRange:[textField textRangeFromPosition:start toPosition:end]];
}

- (void)selectTextForTextView:(UITextView *)textView atRange:(NSRange)range {
    UITextPosition *start = [textView positionFromPosition:[textView beginningOfDocument] offset:range.location];
    UITextPosition *end = [textView positionFromPosition:start offset:range.length];
    [textView setSelectedTextRange:[textView textRangeFromPosition:start toPosition:end]];
}
@end
