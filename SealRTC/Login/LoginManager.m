//
//  LoginManager.m
//  SealViewer
//
//  Created by LiuLinhong on 2018/08/10.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "LoginManager.h"
#import "CommonUtility.h"

static LoginManager *sharedLoginManager = nil;


@interface LoginManager ()
{
    NSUserDefaults *settingUserDefaults, *userDefaults;
}
@end


@implementation LoginManager

+ (LoginManager *)sharedInstance
{
    static dispatch_once_t once_dispatch;
    dispatch_once(&once_dispatch, ^{
        sharedLoginManager = [[LoginManager alloc] init];
    });
    return sharedLoginManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.isIMConnectionSucc = NO;
        self.isLoginTokenSucc = NO;
        self.isObserver = NO;
        self.isBackCamera = NO;
        self.isCloseCamera = NO;
        self.isSpeaker = YES;
        self.isMuteMicrophone = NO;
        self.isSwitchCamera = NO;
        self.isWhiteBoardOpen = NO;
        
        [self initUserDefaults];
    }
    
    return self;
}

- (void)initUserDefaults
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL everLaunched = [userDefaults boolForKey:kEverLaunched];
    if (everLaunched)
    {
        self.roomNumber = [userDefaults valueForKey:kDefaultRoomNumber];
        self.username = [userDefaults valueForKey:kDefaultUserName];
        self.userID = [userDefaults valueForKey:kDefaultUserID];
    } else {
        [userDefaults setBool:YES forKey:kEverLaunched];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Preferences"];
    NSString *settingUserDefaultPath = [docDir stringByAppendingPathComponent:File_SettingUserDefaults_Plist];
    settingUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"settingUserDefaults"];
    
    BOOL isPlistExist = [CommonUtility isFileExistsAtPath:settingUserDefaultPath];
    if (isPlistExist)
    {
        _isGPUFilter = [settingUserDefaults boolForKey:Key_GPUFilter];
        _isSRTPEncrypt = [settingUserDefaults boolForKey:Key_SRTPEncrypt];
        _isTinyStream = [settingUserDefaults boolForKey:Key_TinyStreamMode];
        _resolutionRatioIndex = [settingUserDefaults integerForKey:Key_ResolutionRatio];
        _frameRateIndex = [settingUserDefaults integerForKey:Key_FrameRate];
        _maxCodeRateIndex = [settingUserDefaults integerForKey:Key_MaxCodeRate];
        _minCodeRateIndex = [settingUserDefaults integerForKey:Key_MinCodeRate];
        _codingStyleIndex = [settingUserDefaults integerForKey:Key_CodingStyle];
        _isWaterMark = [settingUserDefaults boolForKey:Key_WaterMark];
        _isAutoTest = [settingUserDefaults boolForKey:Key_AutoTest];
        _phoneNumber = [settingUserDefaults valueForKey:Key_PhoneNumber];
        _countryCode = [settingUserDefaults valueForKey:Key_CountryCode];
        _regionName = [settingUserDefaults valueForKey:Key_RegionName];
        if (!_regionName || [_regionName isEqualToString:@""]) {
            _regionName = NSLocalizedString(@"login_input_region_china", nil);
        }
        _mediaServerURL = [settingUserDefaults valueForKey:Key_MediaServerURL];
        _mediaServerSelectedRow = [settingUserDefaults integerForKey:Key_MediaServerRow];
        _mediaServerArray = [settingUserDefaults valueForKey:Key_MediaServerArray];
        _privateAppServer = [settingUserDefaults valueForKey:@"privateAppServer"];
        _privateIMServer = [settingUserDefaults valueForKey:@"privateIMServer"];
        _privateNavi = [settingUserDefaults valueForKey:@"privateNavi"];
        _privateAppSecret = [settingUserDefaults valueForKey:@"privateAppSecret"];
        _privateAppKey = [settingUserDefaults valueForKey:@"privateAppKey"];
        _isPrivateEnvironment = NO;
        if ([settingUserDefaults valueForKey:@"isPrivateEnvironment"] && _privateNavi && _privateIMServer && _privateAppKey && _privateAppSecret) {
            _isPrivateEnvironment = [[settingUserDefaults valueForKey:@"isPrivateEnvironment"] boolValue];
        }
        _kickOffTime = [settingUserDefaults integerForKey:Key_KickOffTime];
        _kickOffRoomNumber = [settingUserDefaults valueForKey:Key_KickOffRoomNumber];
        _isKickOff = [settingUserDefaults boolForKey:Key_IsKickOff];
    }
    else
    {
        self.isGPUFilter = Value_Default_GPUFilter;
        self.isSRTPEncrypt = Value_Default_SRTPEncrypt;
        self.isTinyStream = Value_Default_TinyStream;
        self.resolutionRatioIndex = Value_Default_ResolutionRatio;
        self.frameRateIndex = Value_Default_FrameRate;
        self.maxCodeRateIndex = Value_Default_MaxCodeRate;
        self.minCodeRateIndex = Value_Default_MinCodeRate;
        self.codingStyleIndex = Value_Default_Coding_Style;
        self.isWaterMark = Value_Default_WaterMark;
        self.isAutoTest = Value_Default_AutoTest;
        self.phoneNumber = @"";
        self.regionName = NSLocalizedString(@"login_input_region_china", nil);
        self.mediaServerSelectedRow = Value_Default_MediaServerRow;
        self.kickOffTime = 0;
        self.kickOffRoomNumber = @"";
        self.isKickOff = NO;
    }
}

- (RongRTCEngine*)rongRTCEngine {
    return [RongRTCEngine sharedEngine];
}

- (void)setIsGPUFilter:(BOOL)isGPUFilter
{
    _isGPUFilter = isGPUFilter;
    [settingUserDefaults setBool:isGPUFilter forKey:Key_GPUFilter];
    [settingUserDefaults synchronize];
}

- (void)setIsWaterMark:(BOOL)isWaterMark
{
    _isWaterMark = isWaterMark;
    [settingUserDefaults setBool:isWaterMark forKey:Key_WaterMark];
    [settingUserDefaults synchronize];
}

- (void)setIsSRTPEncrypt:(BOOL)isSRTPEncrypt
{
    _isSRTPEncrypt = isSRTPEncrypt;
    [settingUserDefaults setBool:isSRTPEncrypt forKey:Key_SRTPEncrypt];
    [settingUserDefaults synchronize];
}

- (void)setIsTinyStream:(BOOL)isTinyStream
{
    _isTinyStream = isTinyStream;
    [settingUserDefaults setBool:isTinyStream forKey:Key_TinyStreamMode];
    [settingUserDefaults synchronize];
}

- (void)setResolutionRatioIndex:(NSInteger)resolutionRatioIndex
{
    _resolutionRatioIndex = resolutionRatioIndex;
    [settingUserDefaults setInteger:resolutionRatioIndex forKey:Key_ResolutionRatio];
    [settingUserDefaults synchronize];
}

- (void)setFrameRateIndex:(NSInteger)frameRateIndex
{
    _frameRateIndex = frameRateIndex;
    [settingUserDefaults setInteger:frameRateIndex forKey:Key_FrameRate];
    [settingUserDefaults synchronize];
}

- (void)setMaxCodeRateIndex:(NSInteger)maxCodeRateIndex
{
    _maxCodeRateIndex = maxCodeRateIndex;
    [settingUserDefaults setInteger:maxCodeRateIndex forKey:Key_MaxCodeRate];
    [settingUserDefaults synchronize];
}

- (void)setMinCodeRateIndex:(NSInteger)minCodeRateIndex
{
    _minCodeRateIndex = minCodeRateIndex;
    [settingUserDefaults setInteger:minCodeRateIndex forKey:Key_MinCodeRate];
    [settingUserDefaults synchronize];
}

- (void)setCodingStyleIndex:(NSInteger)codingStyleIndex
{
    _codingStyleIndex = codingStyleIndex;
    [settingUserDefaults setInteger:codingStyleIndex forKey:Key_CodingStyle];
    [settingUserDefaults synchronize];
}

- (void)setIsAutoTest:(BOOL)isAutoTest
{
    _isAutoTest = isAutoTest;
    [settingUserDefaults setBool:isAutoTest forKey:Key_AutoTest];
    [settingUserDefaults synchronize];
}

- (void)setUsername:(NSString *)username
{
    if (!username) {
        username = @"";
    }
    _username = username;
    [userDefaults setObject:username forKey:kDefaultUserName];
    [userDefaults synchronize];
}

- (void)setUserID:(NSString *)userID
{
    _userID = userID;
    [userDefaults setObject:userID forKey:kDefaultUserID];
    [userDefaults synchronize];
}

- (void)setRoomNumber:(NSString *)roomNumber
{
    _roomNumber = roomNumber;
    [userDefaults setObject:roomNumber forKey:kDefaultRoomNumber];
    [userDefaults synchronize];
}

- (void)setPhoneNumber:(NSString *)phoneNumber
{
    _phoneNumber = phoneNumber;
    [settingUserDefaults setObject:phoneNumber forKey:Key_PhoneNumber];
    [settingUserDefaults synchronize];
}

- (void)setCountryCode:(NSString *)countryCode {
    _countryCode = countryCode;
    [settingUserDefaults setObject:countryCode forKey:Key_CountryCode];
    [settingUserDefaults synchronize];
}

- (void)setRegionName:(NSString *)regionName {
    _regionName = regionName;
    [settingUserDefaults setObject:regionName forKey:Key_RegionName];
    [settingUserDefaults synchronize];
}

- (void)setKeyToken:(NSString *)keyToken
{
    [settingUserDefaults setObject:keyToken forKey:self.phoneNumber];
    [settingUserDefaults synchronize];
}

- (NSString *)keyTokenFrom:(NSString *)num
{
    return [settingUserDefaults valueForKey:num];
}

- (NSString *)keyToken
{
    if (self.phoneNumber) {
        return [settingUserDefaults valueForKey:self.phoneNumber];
    } else {
        return @"";
    }
}

- (void)setMediaServerURL:(NSString *)mediaServerURL
{
    _mediaServerURL = mediaServerURL;
    [settingUserDefaults setObject:mediaServerURL forKey:Key_MediaServerURL];
    [settingUserDefaults synchronize];
}

- (void)setMediaServerSelectedRow:(NSInteger)mediaServerSelectedRow
{
    _mediaServerSelectedRow = mediaServerSelectedRow;
    [settingUserDefaults setInteger:mediaServerSelectedRow forKey:Key_MediaServerRow];
    [settingUserDefaults synchronize];
}

-(void)setPrivateAppSecret:(NSString *)privateAppSecret{
    _privateAppSecret = privateAppSecret;
    [settingUserDefaults setObject:privateAppSecret forKey:@"privateAppSecret"];
    [settingUserDefaults synchronize];
}

-(void)setPrivateNavi:(NSString *)privateNavi{
    _privateNavi = privateNavi;
    [settingUserDefaults setObject:privateNavi forKey:@"privateNavi"];
    [settingUserDefaults synchronize];
}

-(void)setPrivateAppKey:(NSString *)privateAppKey{
    _privateAppKey = privateAppKey;
    [settingUserDefaults setObject:privateAppKey forKey:@"privateAppKey"];
    [settingUserDefaults synchronize];
}

-(void)setPrivateIMServer:(NSString *)privateIMServer{
    _privateIMServer = privateIMServer;
    [settingUserDefaults setObject:privateIMServer forKey:@"privateIMServer"];
    [settingUserDefaults synchronize];
}

-(void)setIsPrivateEnvironment:(BOOL)isPrivateEnvironment{
    _isPrivateEnvironment = isPrivateEnvironment;
    [settingUserDefaults setBool:isPrivateEnvironment forKey:@"isPrivateEnvironment"];
    [settingUserDefaults synchronize];
}

-(void)setPrivateAppServer:(NSString *)privateAppServer{
    _privateAppServer = privateAppServer;
    [settingUserDefaults setObject:privateAppServer forKey:@"privateAppServer"];
    [settingUserDefaults synchronize];
    
}

- (void)setMediaServerArray:(NSArray *)mediaServerArray
{
    _mediaServerArray = mediaServerArray;
    [settingUserDefaults setObject:mediaServerArray forKey:Key_MediaServerArray];
    [settingUserDefaults synchronize];
}

- (void)setKickOffTime:(long long)kickOffTime
{
    _kickOffTime = kickOffTime;
    [settingUserDefaults setInteger:kickOffTime forKey:Key_KickOffTime];
    [settingUserDefaults synchronize];
}

- (void)setKickOffRoomNumber:(NSString *)kickOffRoomNumber
{
    _kickOffRoomNumber = kickOffRoomNumber;
    [settingUserDefaults setObject:kickOffRoomNumber forKey:Key_KickOffRoomNumber];
    [settingUserDefaults synchronize];
}

- (void)setIsKickOff:(BOOL)isKickOff
{
    _isKickOff = isKickOff;
    [settingUserDefaults setBool:isKickOff forKey:Key_IsKickOff];
    [settingUserDefaults synchronize];
}

@end
