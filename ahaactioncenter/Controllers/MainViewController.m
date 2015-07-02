//
//  MainViewController.m
//  ahaactioncenter
//
//  Created by Server on 4/5/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "FontAwesomeKit.h"
#import "ActionCenterManager.h"
#import "ProgressHUD.h"
#import "CMPopTipView.h"
#import "Constants.h"
#import "UpdateUserViewController.h"
#import "PDFKBasicPDFViewer.h"
#import "PDFKDocument.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "ReaderFileViewController.h"

@interface MainViewController ()<CMPopTipViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"WELCOME";
    _mainLabel.textColor = kAHABlue;
    _bgImage.image = [UIImage imageNamed:@"capital_white_fade_bg.jpg"];
    [self.view sendSubviewToBack:_bgImage];
    //UIImageView *iv = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //iv.image = [UIImage imageNamed:@"capital_white_fade_bg"];
    //iv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //[self.view addSubview:iv];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
    }
    else {
        self.navigationItem.leftBarButtonItem = [ActionCenterManager splitButton];
    }
    FAKFontAwesome *question = [FAKFontAwesome iconWithCode:@"\uf059" size:30];
    [question addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIBarButtonItem *questionBtn = [[UIBarButtonItem alloc] initWithImage:[question imageWithSize:CGSizeMake(30, 30)]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(showTutorial:)];
    
    FAKIonIcons *refresh = [FAKIonIcons iconWithCode:@"\uf49a" size:30];
    [refresh addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithImage:[refresh imageWithSize:CGSizeMake(30, 30)]
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(refresh:)];
    
    self.navigationItem.rightBarButtonItems = @[questionBtn, refreshBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if (![prefs boolForKey:@"isLoggedIn"])
    {
        LoginViewController *vc = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {
        //OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
        //NSLog(@"oam %@", oam.first_name);
    }
    
    if ([prefs boolForKey:@"showTip"] && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CMPopTipView *tipView = [[CMPopTipView alloc] initWithMessage:@"Tap here to see menu items"];
        tipView.delegate = self;
        tipView.backgroundColor = kAHABlue;
        tipView.tintColor = kAHARed;
        [tipView presentPointingAtBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
        [prefs setBool:NO forKey:@"showTip"];
        [prefs synchronize];
    }
    
    
}

- (void)showTutorial:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"View Tutorial"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"NO"
                                              style:UIAlertActionStyleCancel
                                            handler:^void (UIAlertAction *action)
                      {

                      }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"YES"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action)
                      {
                          NSURL *url = [NSURL URLWithString:
                                        @"https://aha.box.com/shared/static/1riee2bbvgsr6iox003xv4l9b5546275.mp4"];
                          MPMoviePlayerViewController *c = [[MPMoviePlayerViewController alloc]
                                                            initWithContentURL:url];
                          
                          [self.navigationController presentMoviePlayerViewControllerAnimated:c];
                          
                      }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)refresh:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Refresh Content"
                                                                   message:@"Are you sure?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"NO"
                                              style:UIAlertActionStyleCancel
                                            handler:^void (UIAlertAction *action)
                      {
                          /*
                           UpdateUserViewController *update = [[UpdateUserViewController alloc] initWithStyle:UITableViewStyleGrouped];
                           UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:update];
                           nav.modalPresentationStyle = UIModalPresentationFormSheet;
                           [self.navigationController presentViewController:nav animated:YES completion:nil];
                           */
                           /*
                          //Load the document
                          dispatch_async(dispatch_get_main_queue(), ^{
                              PDFKBasicPDFViewer *viewer = [[PDFKBasicPDFViewer alloc] init];
                              NSString *path = [[NSBundle mainBundle] pathForResource:@"Wikipedia" ofType:@"pdf"];
                              PDFKDocument *document = [PDFKDocument documentWithContentsOfFile:path password:@""];
                              NSLog(@"path %@", path);
                              [self.navigationController pushViewController:viewer animated:YES];
                              //[viewer loadDocument:document];
                              [viewer performSelector:@selector(loadDocument:) withObject:document afterDelay:3];
                            
                          });*/
                      }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"YES"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action)
                      {
                          ProgressHUD *hud = [ProgressHUD sharedInstance];
                          [hud showHUDWithMessage:@"Refreshing Content"];
                          ActionCenterManager *action2 = [ActionCenterManager sharedInstance];
                          [action2 getAHAFeed:^(NSArray *feeds, NSArray *alerts, NSError *error){
                              //NSLog(@"Feed %@", feeds);
                              [hud showHUDSucces:YES withMessage:@"Content Refreshed"];
                          }];
                          
                      }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - CMPopTipViewDelegate methods
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
