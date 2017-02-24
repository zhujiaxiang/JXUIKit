//
//  JXSearchController.m
//  JXSearchController
//
//  Created by 朱佳翔 on 16/5/10.
//  Copyright © 2016年 朱佳翔. All rights reserved.
//

#import "JXSearchController.h"

// 3rd
#import <iflyMSC/iflyMSC.h>

static UIColor * barTintColor(CGFloat alpha)
{
    return [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:alpha];
}

static UIColor * borderColor(CGFloat alpha)
{
    return [UIColor colorWithRed:0.86f green:0.87f blue:0.85f alpha:alpha];
}


static NSTimeInterval const kSpeechTimeout = 30000;
static NSTimeInterval const kVadBos = 3000;
static NSTimeInterval const kVadEos = 3000;
static NSString *const kLanguage = @"zh_cn";
static NSString *const kAccent = @"mandarin";
static float const kSampleRate = 16000;
static BOOL kDot = NO;

@interface JXSearchController () <UISearchBarDelegate,
                                  IFlyRecognizerViewDelegate>

@property(nonatomic, strong) UIButton *voiceButton;
@property(nonatomic, strong) IFlyRecognizerView *recognizerView;

@end

@implementation JXSearchController

@synthesize delegate;

#pragma mark - Init

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController
{
    if (self = [super initWithSearchResultsController:searchResultsController]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

#pragma mark - IFlyRecognizerViewDelegate

- (void)onError:(IFlySpeechError *)errorCode
{
}

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@", key];
    }
    self.searchBar.text = [NSString stringWithFormat:@"%@%@", self.searchBar.text, result];
}

#pragma mark - Action

- (void)onClickVoiceButton:(UIButton *)sender
{
    [self.searchBar setText:@""];
    [self.searchBar resignFirstResponder];

    BOOL success = [self.recognizerView start];
    if (!success) {
        // onError
    }
}

#pragma mark - Private

- (void)commonInit
{
    self.allowVoiceSearch = YES;

    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    self.searchBar.frame = CGRectMake(0, 0, 0, 44);
    self.searchBar.barTintColor = barTintColor(1);
    self.searchBar.layer.borderWidth = 0.5f;
    self.searchBar.layer.borderColor = barTintColor(1).CGColor;

    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
    txfSearchField.clearButtonMode = UITextFieldViewModeNever;
    txfSearchField.layer.cornerRadius = 1.5;
    txfSearchField.layer.borderWidth = 1;
    txfSearchField.layer.borderColor = borderColor(1).CGColor;
    
    [self.searchBar addSubview:self.voiceButton];
    [self.voiceButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSLayoutConstraint *voiceBtn_v = [NSLayoutConstraint constraintWithItem:self.voiceButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:txfSearchField  attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *voiceBtn_h = [NSLayoutConstraint constraintWithItem:self.voiceButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:txfSearchField  attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];

    
    [self.searchBar  addConstraints:@[voiceBtn_h,voiceBtn_v]];

}



#pragma mark - Public APIs

- (void)convertIntoPinYin:(NSMutableString *)chineseString
{
    if (CFStringTransform((__bridge CFMutableStringRef)chineseString, 0, kCFStringTransformMandarinLatin, NO)) {
        if ([chineseString containsString:@"ǚ"]) {
            [chineseString
                replaceOccurrencesOfString:@"ǚ"
                                withString:@"v"
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, chineseString.length)];
        }
    }
    if (CFStringTransform((__bridge CFMutableStringRef)chineseString, 0,
                          kCFStringTransformStripDiacritics, NO)) {
    }
}

- (NSMutableString *)convertIntoPinYinWithInitial:(NSMutableString *)string
{
    NSMutableString *resultString = [[NSMutableString alloc] initWithString:@""];
    
    [self convertIntoPinYin:string];
    
    
    NSArray *array = [string componentsSeparatedByString:@" "];
    
    for (NSString *string in array) {
        [resultString appendString:[string substringToIndex:1]];
    }
    return resultString;
}

- (BOOL)containChineseCharacter:(NSString *)string
{
    NSUInteger length = [string length];
    for (int i = 0; i < length; ++i) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [string substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray *)searchWithDatasourceArray:(NSMutableArray *)datasourceArray
                                   SearchText:(NSString *)searchText
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    BOOL isString = false;
    if (datasourceArray.count <= 0) {
        return datasourceArray;
    }
    else {
        id object = datasourceArray[0];
        if ([object isKindOfClass:[NSString class]]) {
            isString = true;
        }
    }
    if (isString) {
        for (NSMutableString *name in datasourceArray) {
            BOOL contain = [name containsString:searchText];
            if (contain) {
                [resultArray addObject:name];
            }
            NSMutableString *lettero = [[NSMutableString alloc] initWithString:name];
            NSMutableString *letter =[self convertIntoPinYinWithInitial:lettero];

            if ([letter localizedCaseInsensitiveContainsString:searchText] ){
                [resultArray addObject:name];
            }
        }
    }

    return resultArray;
}

#pragma mark - Getters & Setters

- (void)setAllowVoiceSearch:(BOOL)allowVoiceSearch
{
    _allowVoiceSearch = allowVoiceSearch;
    self.voiceButton.hidden = !allowVoiceSearch;
}

- (UIButton *)voiceButton
{
    if (!_voiceButton) {
        _voiceButton = [[UIButton alloc] init];
        [_voiceButton setImage:[UIImage imageNamed:@"IconSearchBarVoice"] forState:UIControlStateNormal];
        [_voiceButton addTarget:self action:@selector(onClickVoiceButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (IFlyRecognizerView *)recognizerView
{
    if (!_recognizerView) {
        _recognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
        [_recognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];                           // 设置应用领域为普通文本听写
        [_recognizerView setParameter:@(kSpeechTimeout).stringValue forKey:[IFlySpeechConstant SPEECH_TIMEOUT]]; // 设置最长录音时间
        [_recognizerView setParameter:@(kVadBos).stringValue forKey:[IFlySpeechConstant VAD_BOS]];               // 设置前端点
        [_recognizerView setParameter:@(kVadEos).stringValue forKey:[IFlySpeechConstant VAD_EOS]];               // 设置后端点
        [_recognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];                         // 设置网络超时
        [_recognizerView setParameter:@(kSampleRate).stringValue forKey:[IFlySpeechConstant SAMPLE_RATE]];       // 设置采样率为16K
        [_recognizerView setParameter:kLanguage forKey:[IFlySpeechConstant LANGUAGE]];                           // 设置语言
        [_recognizerView setParameter:kAccent forKey:[IFlySpeechConstant ACCENT]];                               // 设置方言
        [_recognizerView setParameter:@(kDot).stringValue forKey:[IFlySpeechConstant ASR_PTT]];                  // 设置标点
        [_recognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:[IFlySpeechConstant AUDIO_SOURCE]];           // 设置音频来源为麦克风
        [_recognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];                         // 设置听写结果格式
        [_recognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];                    // 保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下

        _recognizerView.delegate = self;
    }
    return _recognizerView;
}

@end
