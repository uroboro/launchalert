#include <objc/runtime.h>

#ifndef NSFoundationVersionNumber_iOS_6_1
#define NSFoundationVersionNumber_iOS_6_1  993.00
#endif

#define ALERT(t, m) \
	[[[[objc_getClass("UIAlertView") alloc] initWithTitle:(t) message:(m) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];

@interface SBApplicationIcon
- (NSString *)applicationBundleID;
- (void)launch; // up to iOS 6
- (void)launchFromLocation:(int)location; // iOS 7 and up
@end

%hook SBApplicationIcon

%group iOS6OrLess
- (void)launch {
	%orig();
	id s = [[objc_getClass("NSString") alloc] initWithFormat:@"Launching %@\n", [self applicationBundleID]];
	ALERT(nil, s);
	[s release];
}
%end

%group iOS7OrMore
- (void)launchFromLocation:(int)location {
	%orig();
	id s = [[objc_getClass("NSString") alloc] initWithFormat:@"Launching %@ from %d\n", [self applicationBundleID], location];
	ALERT(nil, s);
	[s release];
}
%end

%end

%ctor {
	if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1) {
		%init(iOS6OrLess);
	} else {
		%init(iOS7OrMore);
	}
}

