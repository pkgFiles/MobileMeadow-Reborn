#import <UIKit/UIKit.h>

@interface SpringBoard : UIApplication
- (BOOL)isLocked;
- (BOOL)isShowingHomescreen;
- (void)addActiveOrientationObserver:(id)arg1;
@end

@interface SBApplicationController : NSObject
+ (instancetype)sharedInstance;
- (id)allApplications;
@end

@interface SBApplication : NSObject
- (NSString *)displayName;
- (NSString *)bundleIdentifier;
- (id)badgeValue;
@end
