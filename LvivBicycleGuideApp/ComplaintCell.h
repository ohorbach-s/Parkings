//
//  ComplaintCellTableViewCell.h
//  LvivBicycleGuideApp
//
//  Created by Alexxx on 11/10/14.
//  Copyright (c) 2014 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplaintCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UILabel *complainSubject;
@property (weak, nonatomic) IBOutlet UILabel *dateOfComplaint;

@end
