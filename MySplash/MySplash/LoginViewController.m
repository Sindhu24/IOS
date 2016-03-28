//
//  LoginViewController.m
//  MySplash
//
//  Created by Vasikarla, Sindhu on 3/27/16.
//  Copyright © 2016 Vasikarla. All rights reserved.
//

#import "LoginViewController.h"
#import <AWSCore/AWSCore.h>
#import "ViewController.h"
@interface LoginViewController ()
{
    AWSCognitoCredentialsProvider *credentialsProvider;
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionUSEast1
                                                          identityPoolId:@"us-east-1:6a1304b9-7335-4b1e-8d33-91fa02161f8b"];
    
    fbLoginBtn.delegate = self;
    fbLoginBtn.readPermissions = @[@"public_profile", @"email",@"user_photos",@"user_location",@"user_birthday",@"user_hometown"];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCurrentProfileDetails) name:FBSDKProfileDidChangeNotification object:nil];
    
    // Do any additional setup after loading the view.
}
-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}
-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    if(!error){
        [self getdetails ];
    }
    
}
-(void)getdetails{
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);

        NSString *token = [FBSDKAccessToken currentAccessToken].tokenString;
        credentialsProvider.logins = @{ @(AWSCognitoLoginProviderKeyFacebook): token };
        AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                                                             credentialsProvider:credentialsProvider];
        
        AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
      

        FBSDKGraphRequest *request =[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:nil];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error)
         {
             // Handle the result
             NSLog(@"%@",result);
         }];
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"id,name,first_name,last_name,gender,birthday,email,location,hometown,bio" forKey:@"fields"];

        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                      id result, NSError *error) {
             NSLog(@"%@",result);
             NSDictionary *dict  = [[NSDictionary alloc]initWithDictionary:(NSDictionary*)result];
             FBid = [dict valueForKey:@"id"];
             [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"fbDetails"];
             
             [self performSegueWithIdentifier:@"GotoFBDetails" sender:nil];
             
             
             
         }];
        
    }

}


-(void)getCurrentProfileDetails{
    FBSDKProfile *profile = [FBSDKProfile currentProfile];
    NSLog(@"%@",profile.name);
    NSLog(@"%@",profile.lastName);
    NSLog(@"%@",profile.middleName);
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
    
    if ([segue.identifier isEqualToString:@"GotoFBDetails"]) {
        ViewController *as = segue.destinationViewController;
        as.UserNameKey = FBid;
        as.isFB = YES;
        
    }
}

-(IBAction)clear:(id)sender{
    
    [credentialsProvider clearCredentials];
    [credentialsProvider clearKeychain];

}

- (IBAction)GuestLoginClicked:(id)sender {
    credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                           initWithRegionType:AWSRegionUSEast1
                           identityPoolId:@"us-east-1:6a1304b9-7335-4b1e-8d33-91fa02161f8b"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                                                         credentialsProvider:credentialsProvider];
    
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    
    
    [[credentialsProvider getIdentityId] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        else {
            // the task result will contain the identity id
            NSString *cognitoId = task.result;
        }
        return nil;
    }];
    [self performSegueWithIdentifier:@"GotoGuest" sender:nil];
}
@end
