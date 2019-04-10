//
//  LowestListViewController.h
//  IMBKProject
//
//  Created by melisa öztürk on 10.04.2019.
//  Copyright © 2019 melisa öztürk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LowestListViewController : UIViewController<NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSIndexPath * myIndexPath;
}

@property(strong, nonatomic)NSMutableString *nameData;
@property(strong, nonatomic)NSMutableString *fundData;
@property(strong, nonatomic)NSMutableString *gainData;

@property (strong, nonatomic) NSMutableString *myKey;
@property(strong, nonatomic)NSMutableString *symbolData;
@property(strong, nonatomic)NSMutableString *priceData;
@property(strong, nonatomic)NSMutableString *changeData;
@property(strong, nonatomic)NSMutableString *highData;
@property(strong, nonatomic)NSMutableString *lowData;
@property(strong, nonatomic)NSMutableString *volumeData;
@property(strong, nonatomic)NSMutableString *countData;

@property(nonatomic, strong)NSMutableArray *resultsList;

@property (nonatomic, strong) NSXMLParser *xmlParserList;

//lowest-List
@property (nonatomic, strong) NSMutableArray *arrIMKBData;

//List
@property (nonatomic, strong) NSMutableArray *arrListData;
@property (nonatomic, strong) NSMutableDictionary *dictTempListStorage; //we’ll temporarily store the two values we seek until we add it to the array.
@property (nonatomic, strong) NSMutableString *foundListValue; // used to store the found characters of the elements of interest.
@property (nonatomic, strong) NSString *currentListElement;


//lowest
@property (nonatomic, strong) NSMutableArray *arrNeighboursData;

//@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage; //we’ll temporarily store the two values we seek until we add it to the array.
@property (nonatomic, strong) NSMutableString *foundValue; // used to store the found characters of the elements of interest.
@property (nonatomic, strong) NSString *currentElement; // will be assigned with the name of the element that is
@end


NS_ASSUME_NONNULL_END
