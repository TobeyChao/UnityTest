//
//  EditorContainer.h
//  TestNativeEditText
//
//  Created by Soul on 2023/2/13.
//

#ifndef EditorContainer_h
#define EditorContainer_h

@interface EditorContainer : NSObject
- (EditorContainer*) Init:(UIViewController*)ctrl;
- (void) CreateInputProxy:(NSString*)name :(NSString*)data;
- (void) DestroyInputProxy:(NSString*)namep;
- (void) ModifyInputProxy:(NSString*)name :(NSString*)data;
@end

#endif /* EditorContainer_h */
