//
//  UITextViewWithPlaceholder.h
//  TestNativeEditText
//
//  Created by Soul on 2023/3/17.
//

#ifndef UITextViewWithPlaceholder_h
#define UITextViewWithPlaceholder_h

#import <UIKit/UIKit.h>

@interface UITextViewWithPlaceholder : UITextView

@property(nonatomic, strong) NSString *placeholder;
@property(nonatomic, strong) UIColor *realTextColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *placeholderColor UI_APPEARANCE_SELECTOR;

@end

#endif /* UITextViewWithPlaceholder_h */
