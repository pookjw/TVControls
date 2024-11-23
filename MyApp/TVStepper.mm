//
//  TVStepper.mm
//  MyApp
//
//  Created by Jinwoo Kim on 11/23/24.
//

#import "TVStepper.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface TVStepper ()
@property (retain, nonatomic, readonly) UIStackView *_stackView;
@property (retain, nonatomic, readonly) UIButton *_plusButton;
@property (retain, nonatomic, readonly) UIButton *_minusButton;
@property (retain, nonatomic, readonly) NSMutableArray<UIAction *> *_actions;
@property (retain, nonatomic, nullable) NSTimer *_timer;
@end

@implementation TVStepper
@synthesize _stackView = __stackView;
@synthesize _plusButton = __plusButton;
@synthesize _minusButton = __minusButton;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _commonInit_TVStepper];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _commonInit_TVStepper];
    }
    
    return self;
}

- (void)dealloc {
    [__stackView release];
    [__plusButton removeObserver:self forKeyPath:@"highlighted"];
    [__plusButton release];
    [__minusButton removeObserver:self forKeyPath:@"highlighted"];
    [__minusButton release];
    [__actions release];
    [__timer invalidate];
    [__timer release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:UIButton.class] and [keyPath isEqualToString:@"highlighted"]) {
        if ([object isEqual:self._plusButton]) {
            [self _didPlusButtonChangeHighlighted];
            return;
        } else if ([object isEqual:self._minusButton]) {
            [self _didMinusButtonChangeHighlighted];
            return;
        }
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)_commonInit_TVStepper {
    UIStackView *stackView = self._stackView;
    [self addSubview:stackView];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("_addBoundsMatchingConstraintsForView:"), stackView);
    
}

- (void)addAction:(UIAction *)action {
    assert(![self._actions containsObject:action]);
    [self._actions addObject:action];
}

- (void)removeAction:(UIAction *)action {
    assert([self._actions containsObject:action]);
    [self._actions addObject:action];
}

- (UIStackView *)_stackView {
    if (auto stackView = __stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self._minusButton, self._plusButton]];
    
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    
    __stackView = [stackView retain];
    return [stackView autorelease];
}

- (UIButton *)_plusButton {
    if (auto plusButton = __plusButton) return plusButton;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.image = [UIImage systemImageNamed:@"plus"];
    
    UIButton *plusButton = [UIButton new];
    plusButton.configuration = configuration;
    
    [plusButton addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
    [plusButton addTarget:self action:@selector(_didMinusButtonTriggerPrimaryAction:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    __plusButton = [plusButton retain];
    return [plusButton autorelease];
}

- (UIButton *)_minusButton {
    if (auto minusButton = __minusButton) return minusButton;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.image = [UIImage systemImageNamed:@"minus"];
    
    UIButton *minusButton = [UIButton new];
    minusButton.configuration = configuration;
    
    [minusButton addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
    [minusButton addTarget:self action:@selector(_didPlusButtonTriggerPrimaryAction:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    __minusButton = [minusButton retain];
    return [minusButton autorelease];
}

- (void)_didPlusButtonTriggerPrimaryAction:(UIButton *)sender {
    
}

- (void)_didMinusButtonTriggerPrimaryAction:(UIButton *)sender {
    
}

- (void)_didPlusButtonChangeHighlighted {
    if (self.autorepeat) {
        if (self._plusButton.isHighlighted) {
            [self _startTimerWithIncrement:YES];
        } else {
            [self _invalidateTimer];
        }
    }
}

- (void)_didMinusButtonChangeHighlighted {
    if (self.autorepeat) {
        if (self._minusButton.isHighlighted) {
            [self _startTimerWithIncrement:NO];
        } else {
            [self _invalidateTimer];
        }
    }
}

- (void)_startTimerWithIncrement:(BOOL)increment {
    assert(self._timer == nil);
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                      target:self
                                                    selector:@selector(_didTriggerTimer:)
                                                    userInfo:@{
        @"isIncrement": @(increment)
    }
                                                     repeats:YES];
    
    self._timer = timer;
}

- (void)_invalidateTimer {
    assert(self._timer != nil);
    [self._timer invalidate];
    self._timer = nil;
}

- (void)_didTriggerTimer:(NSTimer *)sender {
    NSNumber *isIncrementNumber = sender.userInfo[@"isIncrement"];
    assert(isIncrementNumber != nil);
    BOOL isIncrement = isIncrementNumber.boolValue;
    
    if (isIncrement) {
        [self _increment];
    } else {
        [self _decrement];
    }
}

- (void)_increment {
    double value = self.value;
    double maximumValue = self.maximumValue;
    double minimumValue = self.minimumValue;
    
    
    BOOL wraps = self.wraps;
}

- (void)_decrement {
    
}

@end
