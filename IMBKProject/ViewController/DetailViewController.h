//
//  DetailViewController.h
//  IMBKProject
//
//  Created by melisa öztürk on 8.04.2019.
//  Copyright © 2019 melisa öztürk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController<NSXMLParserDelegate>
{
    
}

@property (strong, nonatomic) NSMutableString *symbolData;
@property (strong, nonatomic) NSMutableString *key;
@property(strong, nonatomic)NSMutableString *priceData;
@property(strong, nonatomic)NSMutableString *changeData;
@property(strong, nonatomic)NSMutableString *highData;
@property(strong, nonatomic)NSMutableString *lowData;
@property(strong, nonatomic)NSMutableString *volumeData;
@property(strong, nonatomic)NSMutableString *countData;

@property(nonatomic, strong)NSMutableArray *results;
@property (nonatomic, strong) NSXMLParser *xmlParser;


@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage; //we’ll temporarily store the two values we seek until we add it to the array.
@property (nonatomic, strong) NSMutableString *foundValue; // used to store the found characters of the elements of interest.
@property (nonatomic, strong) NSString *currentElement; // will be assigned with the name of the element that is parsed at any moment
@end

NS_ASSUME_NONNULL_END
