#import <UIKit/UIKit.h>

// Installer

@interface UIViewController (DepictionViewController)
@property (nonatomic, strong, readwrite) NSMutableDictionary *packageDictionary;
@property (nonatomic, strong, readwrite) UIImageView *topTweakIcon;
@end

// Zebra

@interface ZBPackage : NSObject
@property (nonatomic, strong, readwrite) NSString *identifier;
@property (nonatomic, strong, readwrite) NSString *version;
@end

@interface UIViewController (ZBPackageViewController)
@property (nonatomic, strong, readwrite) ZBPackage *package;
@property (nonatomic, strong, readwrite) UIImageView *packageIcon;
@end