//
//  TVToolbar.h
//  MyApp
//
//  Created by Jinwoo Kim on 11/25/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(tvos(18.0))
NS_SWIFT_UI_ACTOR
@interface TVToolbar : UIView
@property (copy, nonatomic, nullable) NSArray<UIBarButtonItem *> *items;
- (void)setItems:(NSArray<UIBarButtonItem *> *)items animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
