//
//  OutpatientViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/20.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OutpatientViewControllerDelegate <NSObject>

-(void)transfer:(NSArray *)valueArray;

@end

@interface OutpatientViewController : UIViewController

@property(assign,nonatomic)id<OutpatientViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *quedingBtn;

- (IBAction)backAndFinish:(UIButton *)sender;

@end
