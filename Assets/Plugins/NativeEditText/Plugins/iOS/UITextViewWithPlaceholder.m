//
//  UITextViewWithPlaceholder.m
//  TestNativeEditText
//
//  Created by Soul on 2023/3/17.
//

#import <Foundation/Foundation.h>
#import "UITextViewWithPlaceholder.h"

@interface UITextViewWithPlaceholder ()

@property(unsafe_unretained, nonatomic, readonly) NSString *realText;

- (void)beginEditing:(NSNotification *)notification;
- (void)endEditing:(NSNotification *)notification;

@end

@implementation UITextViewWithPlaceholder
@synthesize realTextColor;
@synthesize placeholder;
@synthesize placeholderColor;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    self.realTextColor = self.textColor;
    self.placeholderColor = [UIColor lightGrayColor];
}

- (void)setPlaceholder:(NSString *)textPlaceholder {
    if ([self.realText isEqualToString:placeholder] && ![self isFirstResponder]) {
        self.text = textPlaceholder;
    }
    if (textPlaceholder != placeholder) {
        placeholder = textPlaceholder;
    }
    [self endEditing:nil];
}

- (void)setPlaceholderColor:(UIColor *)colorPlaceholder {
    placeholderColor = colorPlaceholder;
    if ([super.text isEqualToString:self.placeholder]) {
        self.textColor = self.placeholderColor;
    }
}

- (NSString *)text {
    NSString *text = [super text];
    return ([text isEqualToString:self.placeholder]) ? @"" : text;
}

- (void)setText:(NSString *)text {
    if (([text isEqualToString:@""] || text == nil) && ![self isFirstResponder]) {
        super.text = self.placeholder;
    } else {
        super.text = text;
    }
    if ([text isEqualToString:self.placeholder] || text == nil) {
        self.textColor = self.placeholderColor;
    } else {
        self.textColor = self.realTextColor;
    }
}

- (NSString *)realText {
    return [super text];
}

- (void)beginEditing:(NSNotification *)notification {
    if ([self.realText isEqualToString:self.placeholder]) {
        super.text = nil;
        self.textColor = self.realTextColor;
    }
}

- (void)endEditing:(NSNotification *)notification {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if ([self.realText isEqualToString:@""] || self.realText == nil) {
        super.text = self.placeholder;
        self.textColor = self.placeholderColor;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if ([self.realText isEqualToString:self.placeholder]) {
        if ([textColor isEqual:self.placeholderColor]) {
            [super setTextColor:textColor];
        } else {
            self.realTextColor = textColor;
        }
    } else {
        self.realTextColor = textColor;
        [super setTextColor:textColor];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
