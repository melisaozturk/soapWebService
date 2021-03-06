//
//  IMKB100ViewController.h
//  IMBKProject
//
//  Created by melisa öztürk on 10.04.2019.
//  Copyright © 2019 melisa öztürk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMKB100ViewController : UIViewController<NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *filteredData;

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

//newLast
@property (nonatomic, strong) NSMutableArray *arrIMKBData;

//List
@property (nonatomic, strong) NSMutableArray *arrListData;
@property (nonatomic, strong) NSMutableDictionary *dictTempListStorage; //we’ll temporarily store the two values we seek until we add it to the array.
@property (nonatomic, strong) NSMutableString *foundListValue; // used to store the found characters of the elements of interest.
@property (nonatomic, strong) NSString *currentListElement;


//imkb100
@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage; //we’ll temporarily store the two values we seek until we add it to the array.
@property (nonatomic, strong) NSMutableString *foundValue; // used to store the found characters of the elements of interest.
@property (nonatomic, strong) NSString *currentElement; // will be assigned with the name of the element that is parsed at any moment

@end

NS_ASSUME_NONNULL_END
