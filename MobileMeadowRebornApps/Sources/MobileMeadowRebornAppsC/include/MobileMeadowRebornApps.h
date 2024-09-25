#import <UIKit/UIKit.h>
#import "RemoteLog.h"

@interface UIView(Private)
- (__kindof UIViewController *)_viewControllerForAncestor;
@end

@interface _UIBarBackground : UIView
- (void)createMeadowGround;
@end
