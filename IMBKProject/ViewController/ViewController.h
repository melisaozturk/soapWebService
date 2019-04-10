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

//@property (strong, nonatomic) NSMutableData *responseStringList;

@property(nonatomic, strong)NSMutableArray *resultsList;

@property (nonatomic, strong) NSXMLParser *xmlParserList;
@property (nonatomic, strong) NSMutableArray *arrData; // will contain all of the desired data after the parsing has finished
//@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage; //we’ll temporarily store the two values we seek until we add it to the array.
//@property (nonatomic, strong) NSMutableString *foundValue; // used to store the found characters of the elements of interest.
//@property (nonatomic, strong) NSString *currentElement; // will be assigned with the name of the element that is parsed at any moment

@end


