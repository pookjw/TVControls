//
//  main.m
//  MyApp
//
//  Created by Jinwoo Kim on 11/21/24.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NSObject+Foundation_IvarDescription.h"
#import <objc/message.h>
#import <objc/runtime.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSLog(@"%@", [objc_lookUpClass("UINavigationButton") _fd_shortMethodDescription]);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
