//
//  DetailViewController.m
//  IMBKProject
//
//  Created by melisa öztürk on 8.04.2019.
//  Copyright © 2019 melisa öztürk. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblSymbol;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblChange;
@property (weak, nonatomic) IBOutlet UILabel *lblLow;
@property (weak, nonatomic) IBOutlet UILabel *lblHigh;
@property (weak, nonatomic) IBOutlet UILabel *lblLast;
@property (weak, nonatomic) IBOutlet UILabel *lblVolume;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.symbolData;
//    NSLog(@"%@", self.symbolData);
   
    [self Detail];
}

-(void) Detail {
//    [dateFormatter setDateFormat:@"EEEE/wwww/MMMM"];
//    [dateFormatter setLocale:locale];
//
//    NSString * dateString = [dateFormatter stringFromDate:[NSDate date]];
    
//    NSLog(@"%@", dateString);
    NSString *soapMessage = [NSString stringWithFormat: @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetForexStocksandIndexesInfo> <tem:request><tem:IsIPAD>true</tem:IsIPAD><tem:DeviceID>test</tem:DeviceID><tem:DeviceType>ipad</tem:DeviceType><tem:RequestKey>%@</tem:RequestKey><tem:RequestedSymbol>%@</tem:RequestedSymbol><tem:Period>Month</tem:Period></tem:request></tem:GetForexStocksandIndexesInfo></soapenv:Body></soapenv:Envelope>", self.key, self.symbolData];
    
    NSLog(@"\n\nsoapMessage: %@",soapMessage);

    NSURL *requestURL = [NSURL URLWithString:@"http://mobileexam.veripark.com/mobileforeks/service.asmx"];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:requestURL];
    NSString *messageLength = [NSString stringWithFormat:@"%d", (int)[soapMessage length]];
    
    [myRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: @"http://tempuri.org/GetForexStocksandIndexesInfo" forHTTPHeaderField:@"SOAPAction"];
    [myRequest addValue: messageLength forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *sessionList = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTaskList = [sessionList dataTaskWithRequest:myRequest
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if (!error) {
                                                  NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                  NSLog(@"\n\n%@", responseString);
                                                  
                                                  self.xmlParser = [[NSXMLParser alloc] initWithData:data];
                                                  self.xmlParser.delegate = self;
                                                  self.foundValue = [[NSMutableString alloc] init];
                                                  
                                                  [self.xmlParser parse];
                                                  
                                              }
                                          }];
    [dataTaskList resume];
    
}

//  XML Parse

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    self.arrNeighboursData = [[NSMutableArray alloc] init];

}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
//    NSLog(@"%@",self.arrNeighboursData[0]);
//    NSLog(@"%@", self.arrDetailPrice);
//        NSLog(@"%@", self.arrDetailDate);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lblSymbol.text = self.symbolData;
        self.lblVolume.text =  self.volumeData;
        self.lblLow.text = self.lowData;
        self.lblHigh.text = self.highData;
        NSString* s = [[self.arrNeighboursData lastObject] valueForKey:@"Price"];
        self.lblLast.text = s;
        self.lblCount.text = self.countData;
        self.lblPrice.text = self.priceData;
        self.lblChange.text = self.changeData;
    });

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    // If the current element name is equal to "geoname" then initialize the temporary dictionary.
    if ([elementName isEqualToString:@"StockandIndexGraphic"]) {
        self.dictTempDataStorage = [[NSMutableDictionary alloc] init];
    }
    
    // Keep the current element.
    self.currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    // Store the found characters if only we're interested in the current element.
    if ([self.currentElement isEqualToString:@"Price"] ||
        [self.currentElement isEqualToString:@"Date"]) {
        
        if (![string isEqualToString:@"\n"]) {
            [self.foundValue appendString:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    if ([elementName isEqualToString:@"StockandIndexGraphic"]) {
        // If the closing element equals to "geoname" then the all the data of a neighbour country has been parsed and the dictionary should be added to the neighbours data array.
        [self.arrNeighboursData addObject:[[NSDictionary alloc] initWithDictionary:self.dictTempDataStorage]];
    }
    else if ([elementName isEqualToString:@"Price"]){
        // If the country name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Price"];
    }
    else if ([elementName isEqualToString:@"Date"]){
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Date"];
    }
    
    // Clear the mutable string.
    [self.foundValue setString:@""];
}

@end
