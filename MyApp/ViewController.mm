//
//  ViewController.mm
//  MyApp
//
//  Created by Jinwoo Kim on 11/21/24.
//

#import "ViewController.h"
#import "TVSlider.h"
#import "TVStepper.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface ViewController ()
@property (retain, nonatomic) IBOutlet TVSlider *slider;
@end

@implementation ViewController

+ (void)load {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.slider addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        NSLog(@"%lf", self.slider.value);
    }]];
    
    TVStepper *stepper = [TVStepper new];
    stepper.minimumValue = 0.;
    stepper.maximumValue = 10.;
    stepper.stepValue = 3.;
    stepper.autorepeat = YES;
    stepper.continuous = YES;
    stepper.wraps = NO;
    
    [stepper addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        NSLog(@"%lf", stepper.value);
    }]];
    [self.view addSubview:stepper];
    stepper.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [stepper.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [stepper.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
//    reinterpret_cast<void (*)(id, SEL, double)>(objc_msgSend)(stepper, sel_registerName("setMinimumValue:"), 0.);
//    reinterpret_cast<void (*)(id, SEL, double)>(objc_msgSend)(stepper, sel_registerName("setMaximumValue:"), 100.);
//    reinterpret_cast<void (*)(id, SEL, double)>(objc_msgSend)(stepper, sel_registerName("setStepValue:"), 1.);
    
//    [stepper addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
//        NSLog(@"%d", stepper.isTracking);
//    }] forControlEvents:UIControlEventValueChanged];
    [stepper release];
    
    NSLog(@"%@", [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]);
}

- (IBAction)foooo:(id)sender {
}

- (void)dealloc {
    [_slider release];
    [super dealloc];
}
@end
