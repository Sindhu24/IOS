//
//  ViewController.h
//  MySplash
//
//  Created by Vasikarla, Sindhu on 3/12/16.
//  Copyright © 2016 Vasikarla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    
    
    IBOutlet UITextField *occupation;
    
    IBOutlet UITextField *diaplayName;
    
    IBOutlet UITextField *location;

    IBOutlet UIImageView *profilePic;
    IBOutlet UITextField *userName;
    IBOutlet UITextField *Key;
}
@property(nonatomic,retain)NSString* UserNameKey;
@property(assign)BOOL isFB;


@end

