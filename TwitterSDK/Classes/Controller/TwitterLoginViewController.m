//
//  TwitterLoginViewController.m
//  TwitterSDK
//
//  Created by pisces on 4/16/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import "TwitterLoginViewController.h"
#import "TwitterOAuth.h"

@interface TwitterLoginViewController ()
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, readonly) UIViewController *topViewController;
@end

@implementation TwitterLoginViewController
{
@private
    __weak IBOutlet UIActivityIndicatorView *indicatorView;
    
    NSString *_callbackURLString;
    NSString *_redirectURLString;
    OAToken *_token;
}

// ================================================================================================
//  Overridden: UIViewController
// ================================================================================================

#pragma mark - Overridden: UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Twitter - Sign in";
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_firstViewAppearence) {
        indicatorView.hidden = NO;
        
        NSString *URLString = [twitterApiURLOfAuthrize stringByAppendingString:[NSString stringWithFormat:@"?oauth_token=%@", _token.key]];
        NSURL *URL = [NSURL URLWithString:URLString];
        
        [indicatorView startAnimating];
        [_webView loadRequest:[NSURLRequest requestWithURL:URL]];
    }
    
    _firstViewAppearence = NO;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public methods

- (instancetype)initWithToken:(OAToken *)token
            callbackURLString:(NSString *)callbackURLString
            redirectURLString:(NSString *)redirectURLString {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"TwitterSDK" ofType:@"bundle"]];
    self = [super initWithNibName:@"TwitterLoginView" bundle:bundle];
    
    if (self) {
        _firstViewAppearence = YES;
        _callbackURLString = callbackURLString;
        _redirectURLString = redirectURLString;
        _token = token;
    }
    
    return self;
}

- (void)present {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    
    [self.topViewController presentViewController:navigationController animated:YES completion:nil];
}

// ================================================================================================
//  Protocol Implementation
// ================================================================================================

#pragma mark - UIWebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *absoluteString = request.URL.absoluteString;
    
    if ([absoluteString hasPrefix:_callbackURLString]) {
        NSString *URLString = [NSString stringWithFormat:@"%@?%@", _redirectURLString, request.URL.query];
        NSURL *URL = [NSURL URLWithString:URLString];
        
        [[UIApplication sharedApplication] openURL:URL];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [indicatorView stopAnimating];
    
    indicatorView.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [self webViewDidFinishLoad:webView];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private getter/setter

- (UIViewController *)topViewController {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
    
    return controller;
}

#pragma mark - UIBarButtonItem selector

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
