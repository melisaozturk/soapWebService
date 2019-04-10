//
//  ViewController.h
//  IMBKProject
//
//  Created by melisa öztürk on 5.04.2019.
//  Copyright © 2019 melisa öztürk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSXMLParserDelegate>
{
}

//Encrypt
@property (strong, nonatomic) NSMutableData *responseString;

@property(nonatomic, strong)NSMutableArray *results;
@property(nonatomic, strong)NSMutableString *parsedString;
@property(nonatomic, strong)NSXMLParser *xmlParser;

@property (strong, nonatomic) NSMutableString *key;

@property(nonatomic, strong)NSMutableArray *resultsList;

@property (nonatomic, strong) NSXMLParser *xmlParserList;
@property (nonatomic, strong) NSMutableArray *arrData; 

@end


