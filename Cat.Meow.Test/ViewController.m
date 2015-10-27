//
//  ViewController.m
//  Cat.Meow.Test
//
//  Created by Vladyslav on 26.10.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "ViewController.h"
#import "VGServManager.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *catImageView;
@property (weak, nonatomic) IBOutlet UILabel *catLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *smallActivityIndicator;


@property(strong,nonatomic) NSURL* catURL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Action Buttons


- (IBAction)catAction:(UIButton *)sender {
    
  [self getCatFromServer];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self.smallActivityIndicator startAnimating];
    [self.activityIndicator startAnimating];
    [sender setEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self.smallActivityIndicator stopAnimating];
        [sender setEnabled:YES];
        [self.activityIndicator stopAnimating];
    });

}


- (IBAction)logAction:(UIButton *)sender {
    [self postCatToServer];
}


#pragma mark - VGServManager


-(void) getCatFromServer {
    
    [[VGServManager sharedManager] getCatOnSuccess:^(NSString *cat) {
        
        self.catURL = [NSURL URLWithString:cat];
        [self.catImageView setImageWithURL:self.catURL];
        self.catLabel.text = cat;
        
    } onFailure:^(NSError *error) {
        NSLog(@"error: %@",[error localizedDescription]);
        self.catLabel.text = @"Случилась ошибка во время загрузки данных";
    }];
    
}

-(void) postCatToServer {
 
    [[VGServManager sharedManager] postCat:self.catLabel.text onSuccess:^(NSURLResponse *responce) {
        self.catLabel.text = @"Успешно!";
         NSLog(@"%@", responce);
    } onFailure:^(NSError *error) {
          NSLog(@"%@",[error localizedDescription]);
        self.catLabel.text = [error localizedDescription];
    }];
    
}


@end
