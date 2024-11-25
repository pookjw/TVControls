//
//  TVToolbar.m
//  MyApp
//
//  Created by Jinwoo Kim on 11/25/24.
//
#import <TargetConditionals.h>

#if TARGET_OS_TV

#import "TVToolbar.h"
#import <objc/message.h>
#import <objc/runtime.h>

namespace cp_UIToolbarButton {

namespace preferredFocusEnvironments {
NSArray<id<UIFocusEnvironment>> * impl(__kindof UIControl *self, SEL _cmd) {
    __kindof UIButton *_info = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_info"));
    return @[_info];
}
void addImpl() {
    assert(class_addMethod(objc_lookUpClass("UIToolbarButton"), @selector(preferredFocusEnvironments), reinterpret_cast<IMP>(impl), NULL));
}
}



}

/*
 -[UIToolbarTextButton initWithTitle:pressedTitle:withFont:withBarStyle:withStyle:withTitleWidth:possibleTitles:withToolbarTintColor:]
 _buttonBarHitRect
 
 UIBarButtonItem에 padding 같은거? -[UIToolbarButton alignmentRectInsets] _additionalSelectionInsets
 */

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface TVToolbar ()

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation TVToolbar
#pragma clang diagnostic pop

+ (void)load {
    cp_UIToolbarButton::preferredFocusEnvironments::addImpl();
    [self class];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] allocWithZone:zone];
}

+ (Class)class {
    static Class isa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _isa = objc_allocateClassPair(objc_lookUpClass("UIToolbar"), "_TVToolbar", 0);
        
        objc_registerClassPair(_isa);
        isa = _isa;
    });
    
    return isa;
}

@end

#endif
