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
    
    __actions = [NSMutableArray new];
    
    self.continuous = YES;
    self.autorepeat = YES;
    self.wraps = NO;
    self.value = 0.;
    self.minimumValue = 0.;
    self.maximumValue = 100.;
    self.stepValue = 1.;
}

- (void)setAutorepeat:(BOOL)autorepeat {
    _autorepeat = autorepeat;
    
    if (autorepeat) {
        if (self._plusButton.isHighlighted) {
            [self _startTimerWithIncrement:YES];
        } else if (self._minusButton.isHighlighted) {
            [self _startTimerWithIncrement:NO];
        }
    } else {
        [self _invalidateTimer];
    }
}

- (void)setValue:(double)value {
    double minimumValue = self.minimumValue;
    double maximumValue = self.maximumValue;
    
    value = MAX(minimumValue, MIN(maximumValue, value));
    
    _value = value;
    
    if (value == minimumValue) {
        self._minusButton.enabled = NO;
        self._plusButton.enabled = YES;
    } else if (value == maximumValue) {
        self._minusButton.enabled = YES;
        self._plusButton.enabled = NO;
    }
}

- (void)setMinimumValue:(double)minimumValue {
    double maximumValue = self.maximumValue;
    assert(minimumValue < maximumValue);
    
    _minimumValue = minimumValue;
    
    double value = self.value;
    if (value < minimumValue) {
        self.value = minimumValue;
    }
}

- (void)setMaximumValue:(double)maximumValue {
    double minimumValue = self.minimumValue;
    assert(minimumValue < maximumValue);
    
    _maximumValue = maximumValue;
    double value = self.value;
    if (maximumValue < value) {
        self.value = maximumValue;
    }
}

- (void)setStepValue:(double)stepValue {
    _stepValue = stepValue;
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
    BOOL isHighlighted = self._plusButton.isHighlighted;
    
    if (self.autorepeat) {
        if (isHighlighted) {
            [self _startTimerWithIncrement:YES];
        } else {
            NSNumber *startedValueNumber = self._timer.userInfo[@"startedValue"];
            assert(startedValueNumber != nil);
            
            if (self.value == startedValueNumber.doubleValue) {
                [self _increment];
                [self _sendEvents];
            } else if (!self.continuous) {
                [self _sendEvents];
            }
            
            [self _invalidateTimer];
        }
    } else {
        // autorepeaat 도중 값이 증감된 상태에서 타이머가 꺼지면 값이 안 커져야함
        if (!isHighlighted) {
            [self _increment];
            [self _sendEvents];
        }
    }
}

- (void)_didMinusButtonChangeHighlighted {
    BOOL isHighlighted = self._minusButton.isHighlighted;
    
    if (self.autorepeat) {
        if (isHighlighted) {
            [self _startTimerWithIncrement:NO];
        } else {
            NSNumber *startedValueNumber = self._timer.userInfo[@"startedValue"];
            assert(startedValueNumber != nil);
            
            if (self.value == startedValueNumber.doubleValue) {
                [self _decrement];
                [self _sendEvents];
            } else if (!self.continuous) {
                [self _sendEvents];
            }
            
            [self _invalidateTimer];
        }
    } else {
        if (!isHighlighted) {
            [self _decrement];
            [self _sendEvents];
        }
    }
}

- (void)_startTimerWithIncrement:(BOOL)increment {
    assert(self._timer == nil);
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                      target:self
                                                    selector:@selector(_didTriggerTimer:)
                                                    userInfo:@{
        @"isIncrement": @(increment),
        @"startedValue": @(self.value)
    }
                                                     repeats:YES];
    
    self._timer = timer;
}

- (void)_invalidateTimer {
    NSTimer *timer = self._timer;
    if (timer == nil) return;
    
    [timer invalidate];
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
    
    if (self.continuous) {
        [self _sendEvents];
    }
}

- (void)_increment {
    double value = self.value;
    double maximumValue = self.maximumValue;
    double stepValue = self.stepValue;
    
    value += stepValue;
    
    if (maximumValue < value) {
        if (self.wraps) {
            value = self.minimumValue;
        } else {
            value = maximumValue;
        }
    }
    
    self.value = value;
}

- (void)_decrement {
    double value = self.value;
    double minimumValue = self.minimumValue;
    double stepValue = self.stepValue;
    
    value -= stepValue;
    
    if (value < minimumValue) {
        if (self.wraps) {
            value = self.maximumValue;
        } else {
            value = minimumValue;
        }
    }
    
    self.value = value;
}

- (void)_sendEvents {
    for (UIAction *action in self._actions) {
        [action performWithSender:self target:nil];
    }
}

@end
