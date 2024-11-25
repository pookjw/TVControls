//
//  ViewController.mm
//  MyApp
//
//  Created by Jinwoo Kim on 11/21/24.
//

#import "ViewController.h"
#import "TVSlider.h"
#import "TVStepper.h"
#import "TVSwitch.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "MyApp-Swift.h"

@interface ViewController ()
@property (retain, nonatomic) IBOutlet TVSwitch *_switch;
@property (retain, nonatomic) IBOutlet TVSlider *slider;
@end

@implementation ViewController

+ (void)load {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self._switch.enabled = YES;
    
    [self.slider addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        NSLog(@"%lf", self.slider.value);
    }]];
    
    TVStepper *stepper = [TVStepper new];
    stepper.minimumValue = 0.;
    stepper.maximumValue = 10.;
    stepper.stepValue = 3.;
    stepper.autorepeat = YES;
    stepper.continuous = YES;
    stepper.wraps = YES;
    
    [stepper addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        NSLog(@"%lf", stepper.value);
    }]];
    [self.view addSubview:stepper];
    stepper.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [stepper.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [stepper.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    [stepper release];
}

- (IBAction)foooo:(id)sender {
    __kindof UIViewController *hostingController = MyApp::makeContentHostingController();
    [self presentViewController:hostingController animated:YES completion:nil];
    [hostingController release];
}

- (void)dealloc {
    [_slider release];
    [super dealloc];
}

@end
