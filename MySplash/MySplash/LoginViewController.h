//
//  LoginViewController.h
//  MySplash
//
//  Created by Vasikarla, Sindhu on 3/27/16.
//  Copyright © 2016 Vasikarla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginButton.h>



@interface LoginViewController : UIViewController<FBSDKLoginButtonDelegate>{
    
    IBOutlet FBSDKLoginButton *fbLoginBtn;
    NSString *FBid;
    
}


- (IBAction)GuestLoginClicked:(id)sender;

@end
