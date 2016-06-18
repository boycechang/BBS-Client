//
//  LoginViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize mDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        myBBS = appDelegate.myBBS;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [user becomeFirstResponder];
    
    keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    
    UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"上一项", @"")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(previousField:)];
    
    UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"下一项", @"")
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(nextField:)];
    
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", @"")
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(back:)];
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"登录", @"")
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(login:)];
    
    [keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, cancelBarItem, doneBarItem, nil]];
    [previousBarItem release];
    [nextBarItem release];
    [spaceBarItem release];
    [cancelBarItem release];
    [doneBarItem release];
    
    user.inputAccessoryView = keyboardToolbar;
    pass.inputAccessoryView = keyboardToolbar;
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Others
- (void)resignKeyboard:(id)sender {
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
    }
}

- (void)previousField:(id)sender {
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger previousTag = tag == 1 ? 1 : tag - 1;
        UITextField *previousField = (UITextField *)[self.view viewWithTag:previousTag];
        [previousField becomeFirstResponder];
    }
}

- (void)nextField:(id)sender {
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger nextTag = tag == 2 ? 2 : tag + 1;
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
    }
}

- (id)getFirstResponder {
    NSUInteger index = 0;
    while (index <= 2) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    return NO;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    [super dealloc];
}

- (IBAction)back:(id)sender {
    [user resignFirstResponder];
    [pass resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)login:(id)sender {
    [user resignFirstResponder];
    [pass resignFirstResponder];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.labelText = @"登录中...";
	[HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
    [HUD release];
}

- (void)firstTimeLoad {
    User * myself = [myBBS userLogin:user.text Pass:pass.text];
    [HUD removeFromSuperview];
    if (myself == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"输入的账户信息有误";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:0.8];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
            [mDelegate LoginSuccess];
        });
    }
}

#pragma mark - Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
- (BOOL)shouldAutorotate{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
@end
