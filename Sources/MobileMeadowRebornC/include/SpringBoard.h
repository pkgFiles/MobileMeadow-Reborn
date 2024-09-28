#import <UIKit/UIKit.h>

@interface FBSBundleInfo : NSObject
@end

@interface FBSApplicationInfo : FBSBundleInfo
@end

@interface _UIApplicationInfo : FBSApplicationInfo
@end

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

@interface BBSectionInfoSettings : NSObject
@property BOOL allowsNotifications;
@end

@interface BBSectionInfo : NSObject
@property BBSectionInfoSettings* readableSettings;
@end

@interface BBServer : NSObject
+(NSMutableDictionary*)savedSectionInfo;
@end
