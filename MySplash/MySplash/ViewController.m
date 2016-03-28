//
//  ViewController.m
//  MySplash
//
//  Created by Vasikarla, Sindhu on 3/12/16.
//  Copyright © 2016 Vasikarla. All rights reserved.
//

#import "ViewController.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import "AppDelegate.h"
@interface ViewController ()<UITextFieldDelegate, UIAlertViewDelegate>{
    AWSCognitoCredentialsProvider *credentialsProvider;

    AWSCognitoDataset *dataset;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Key.text = _UserNameKey;
    
    FBSDKProfile *profile = [FBSDKProfile currentProfile];

    NSString *strin =  [profile imagePathForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(100, 100)];
    FBSDKProfilePictureView *profilePictureview = [[FBSDKProfilePictureView alloc]initWithFrame:profilePic.frame];
    [profilePictureview setProfileID:_UserNameKey];
    [self.view addSubview:profilePictureview];

    
    [ self getDetails ];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)deleteAll{
    AWSCognito *syncClient = [AWSCognito defaultCognito];
    
    dataset = [syncClient openOrCreateDataset:Key.text];
    [dataset clear];
    [dataset synchronize];
    [self clearTxt:nil ];
    [self.navigationController popViewControllerAnimated:YES];
    
    //removeObjectForKey
}
-(void)storeDetails{
    
    // Initialize the Cognito Sync client
    AWSCognito *syncClient = [AWSCognito defaultCognito];
    // Create a record in a dataset and synchronize with the server

    dataset = [syncClient openOrCreateDataset:Key.text];
    [dataset setString:occupation.text forKey:@"occupation"];
    [dataset setString:userName.text forKey:@"name"];
    [dataset setString:location.text forKey:@"locaiton"];
    [dataset setString:diaplayName.text forKey:@"displayName"];
    
    [[dataset synchronize] continueWithBlock:^id(AWSTask *task) {
        
        // Your handler code here
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[[UIAlertView alloc]initWithTitle:@"My Splash" message:@"User details have been saved" delegate:self
                             cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
            

        });
        
        return nil;
    }];
    
    
}


- (IBAction)clearTxt:(id)sender {
    
    userName.text = @"";
    
    diaplayName.text=@"";
    location.text =@"";
    occupation.text = @"";
}
- (IBAction)deleteBtnClicked:(id)sender {
    
    [self deleteAll ];
}
- (IBAction)saveBtnClicked:(id)sender {
    
    [self.view endEditing:YES];
    [self storeDetails ];
    
   
}

- (IBAction)getBtnClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    [self getDetails];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
        [textField resignFirstResponder];
    return YES;
}


-(void)getDetails{
    AWSCognito *syncClient = [AWSCognito defaultCognito];
    
    dataset = [syncClient openOrCreateDataset:Key.text];
    NSString *nae = [dataset stringForKey:@"name"];
    
    if (nae == nil) {
        if (_isFB) {
            
            
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults]valueForKey:@"fbDetails"];
            
            userName.text = [dict valueForKey:@"first_name"];
            
            diaplayName.text=[dict valueForKey:@"name"];
            location.text =[[dict valueForKey:@"location"] valueForKey:@"name"];
            occupation.text = @"";
            [self storeDetails];
            
        }else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"MySplash"
                                      message:@"No data"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        
                                        
                                    }];
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        }
        return;
        
    }
    
    userName.text = nae;
    
    diaplayName.text=[dataset stringForKey:@"displayName"];
    location.text =[dataset stringForKey:@"locaiton"];
    occupation.text = [dataset stringForKey:@"occupation"];
    
}

@end
