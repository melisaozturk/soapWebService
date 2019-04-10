//
//  ListCell.h
//  IMBKProject
//
//  Created by melisa öztürk on 8.04.2019.
//  Copyright © 2019 melisa öztürk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSymbol;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblVolume;
@property (weak, nonatomic) IBOutlet UILabel *lblHour;
@property (weak, nonatomic) IBOutlet UILabel *lblSelling;
@property (weak, nonatomic) IBOutlet UILabel *lblBuying;
@property (weak, nonatomic) IBOutlet UILabel *lblDifference;

@end

NS_ASSUME_NONNULL_END
