#import <UIKit/UIKit.h>
#import "SpringBoard.h"
#import "RemoteLog.h"

@interface UIView(Private)
- (__kindof UIViewController *)_viewControllerForAncestor;
@end

@interface UIImage (Private)
+ (id)_applicationIconImageForBundleIdentifier:(id)identifier format:(int)format scale:(double)scale;
@end

@interface SBDockIconListView : UIView
- (void)createMeadowDockGround;
@end

@interface SBNestingViewController : UIViewController
@end

@interface SBFolderController : SBNestingViewController
@end

@interface SBRootFolderController : SBFolderController
@end

@interface NCNotificationViewController : UIViewController
@end

@interface NCNotificationShortLookViewController : NCNotificationViewController
@end
