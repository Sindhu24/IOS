//
//  Guest.m
//  MySplash
//
//  Created by Vasikarla, Sindhu on 28/03/16.
//  Copyright © 2016 Vasikarla. All rights reserved.
//

#import "Guest.h"
#import "ViewController.h"
@interface Guest ()

@end

@implementation Guest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"GotoDetails"]) {
        ViewController *as = segue.destinationViewController;
        as.UserNameKey = userNameTxt.text;
        as.isFB = NO;
        
    }
}


- (IBAction)NxtBtnClicked:(id)sender {
    
    if(userNameTxt.text.length){
        [self performSegueWithIdentifier:@"GotoDetails" sender:nil];
    }
}
@end
