@interface ADVersionInfo : NSObject 
@end

@implementation ADVersionInfo
+ (void)load {
    if ([[[UIDevice currentDevice] name] hasSuffix:@"DEBUG"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_displayVersionInfo:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    }
}

+ (void)_displayVersionInfo:(NSNotification *)notification {
    NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];

    NSString * bundleVersion = [infoDict objectForKey:@"CFBundleVersion"];
    NSString * gitCommit = [infoDict objectForKey:@"CFBundleGitCommit"];
    NSString * gitBranch = [infoDict objectForKey:@"CFBundleGitBranch"];
    NSString * gitStatus = [infoDict objectForKey:@"CFBundleGitStatus"];
    NSString * buildDate = [NSString stringWithFormat:@"%s", __DATE__];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Build Infos"
                                                         message:[NSString stringWithFormat:@"V. %@, built %@ | Commit %@ on %@ | Status %@", bundleVersion, buildDate, gitCommit, gitBranch, gitStatus]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}
@end
