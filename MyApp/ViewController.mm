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
#import "UIToolbar+CP_UIToolbarTVPatch.h"

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
    
//    TVStepper *stepper = [TVStepper new];
//    stepper.minimumValue = 0.;
//    stepper.maximumValue = 10.;
//    stepper.stepValue = 3.;
//    stepper.autorepeat = YES;
//    stepper.continuous = YES;
//    stepper.wraps = YES;
//    
//    [stepper addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
//        NSLog(@"%lf", stepper.value);
//    }]];
//    [self.view addSubview:stepper];
//    stepper.translatesAutoresizingMaskIntoConstraints = NO;
//    [NSLayoutConstraint activateConstraints:@[
//        [stepper.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
//        [stepper.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
//    ]];
    
    __kindof UIView *toolbar = [objc_lookUpClass("UIToolbar") new];
    UIBarButtonItem *barButtonItem_1 = [[UIBarButtonItem alloc] initWithTitle:@"111" style:UIBarButtonItemStylePlain target:self action:@selector(didTriggerBarButtonItem:)];
    UIBarButtonItem *barButtonItem_2 = [[UIBarButtonItem alloc] initWithTitle:@"222" style:UIBarButtonItemStylePlain target:self action:@selector(didTriggerBarButtonItem:)];
    UIBarButtonItem *barButtonItem_3 = [[UIBarButtonItem alloc] initWithTitle:@"333" menu:[UIMenu menuWithChildren:@[
        [UIAction actionWithTitle:@"Foo" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}]
    ]]];
    UIBarButtonItem *barButtonItem_4 = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"eraser.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(didTriggerBarButtonItem:)];
    
    objc_setAssociatedObject(toolbar, cp_getUIToolbarTVPatchKey(), [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(toolbar, sel_registerName("setItems:"), @[
        [UIBarButtonItem flexibleSpaceItem],
        barButtonItem_1,
        barButtonItem_2,
        [UIBarButtonItem flexibleSpaceItem],
        barButtonItem_3,
        [UIBarButtonItem flexibleSpaceItem],
        barButtonItem_4
    ]);
    
    [barButtonItem_1 release];
    [barButtonItem_2 release];
    [barButtonItem_3 release];
    [barButtonItem_4 release];
    
    [self.view addSubview:toolbar];
    toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [toolbar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [toolbar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [toolbar.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    [toolbar release];
//    [stepper release];
}

- (IBAction)foooo:(id)sender {
    __kindof UIViewController *hostingController = MyApp::makeContentHostingController();
    [self presentViewController:hostingController animated:YES completion:nil];
    [hostingController release];
}

- (void)didTriggerBarButtonItem:(UIBarButtonItem *)sender {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)dealloc {
    [_slider release];
    [super dealloc];
}

@end
