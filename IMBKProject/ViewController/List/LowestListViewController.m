//
//  LowestListViewController.m
//  IMBKProject
//
//  Created by melisa öztürk on 10.04.2019.
//  Copyright © 2019 melisa öztürk. All rights reserved.
//

#import "LowestListViewController.h"
#import "ListCell.h"
#import "DetailViewController.h"

@interface LowestListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblLowest;

@end

@implementation LowestListViewController
@synthesize myKey;
@synthesize changeData;
@synthesize countData;
@synthesize volumeData;
@synthesize lowData;
@synthesize highData;
@synthesize priceData;
@synthesize symbolData;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"IMKB Düşenler";
    self.arrIMKBData = [[NSMutableArray alloc] init];
    
    [self List];
    
}


-(void) get {

    
    for (int i = 0; i < self.arrListData.count; i++) {
        NSDecimalNumber *dDif = [self.arrListData[i] objectForKey:@"Difference"];
        double  myDif = dDif.doubleValue;
        
        if ( myDif < 0){
//            NSLog(@"%.2f düşen", myDif);
            [self.arrIMKBData addObject: self.arrListData[i]];
        }
//        NSLog(@"%@",self.arrIMKBData);
    }
}

-(void) List {
    
    NSString *soapMessageList = [NSString stringWithFormat: @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetForexStocksandIndexesInfo> <tem:request><tem:IsIPAD>true</tem:IsIPAD><tem:DeviceID>test</tem:DeviceID><tem:DeviceType>ipad</tem:DeviceType><tem:RequestKey>%@</tem:RequestKey><tem:Period>Day</tem:Period></tem:request></tem:GetForexStocksandIndexesInfo></soapenv:Body></soapenv:Envelope>", self.myKey];
    
    NSLog(@"\n\nsoapMessageList: %@",soapMessageList);
    
    NSURL *requestURLList = [NSURL URLWithString:@"http://mobileexam.veripark.com/mobileforeks/service.asmx"];
    NSMutableURLRequest *myRequestList = [NSMutableURLRequest requestWithURL:requestURLList];
    NSString *messageLengthList = [NSString stringWithFormat:@"%d", (int)[soapMessageList length]];
    
    [myRequestList addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequestList addValue: @"http://tempuri.org/GetForexStocksandIndexesInfo" forHTTPHeaderField:@"SOAPAction"];
    [myRequestList addValue: messageLengthList forHTTPHeaderField:@"Content-Length"];
    [myRequestList setHTTPMethod:@"POST"];
    [myRequestList setHTTPBody: [soapMessageList dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *sessionList = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTaskList = [sessionList dataTaskWithRequest:myRequestList
                                                        completionHandler:^(NSData *dataList, NSURLResponse *responseList, NSError *errorList)
                                          {
                                              if (!errorList) {
                                                  NSString *responseStringList = [[NSString alloc] initWithData:dataList encoding:NSUTF8StringEncoding];
                                                  NSLog(@"\n\n%@", responseStringList);
                                                  
                                                  self.xmlParserList=[[NSXMLParser alloc] initWithData:dataList];
                                                  self.xmlParserList.delegate=self;
                                                  // Initialize the mutable string that we'll use during parsing.
                                                  self.foundListValue = [[NSMutableString alloc] init];
                                                  
                                                  [self.xmlParserList parse];
                                                  
                                              }
                                          }];
    [dataTaskList resume];
    
}

//  XML Parse

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    // Initialize the data array.
    self.arrListData = [[NSMutableArray alloc] init];
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [self get];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblLowest reloadData];
    });
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    // If the current element name is equal to "StockandIndex" then initialize the temporary dictionary.
    if ([elementName isEqualToString:@"StockandIndex"]) {
        self.dictTempListStorage = [[NSMutableDictionary alloc] init];
    }
    
    // Keep the current element.
    self.currentListElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // Store the found characters if only we're interested in the current element.
    
    if ([self.currentListElement isEqualToString:@"Symbol"] || [self.currentListElement isEqualToString:@"Price"] || [self.currentListElement isEqualToString:@"Difference"] || [self.currentListElement isEqualToString:@"Volume"] || [self.currentListElement isEqualToString:@"Buying"] || [self.currentListElement isEqualToString:@"Selling"] || [self.currentListElement isEqualToString:@"Hour"] || [self.currentListElement isEqualToString:@"Total"] || [self.currentListElement isEqualToString:@"DayPeakPrice"] || [self.currentListElement isEqualToString:@"DayLowestPrice"]) {
        
        if (![string isEqualToString:@"\n"]) {
            [self.foundListValue appendString:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    if ([elementName isEqualToString:@"StockandIndex"]) {
        // If the closing element equals to "StockandIndex" then the all the data of a has been parsed and the dictionary should be added to the array.
        [self.arrListData addObject:[[NSDictionary alloc] initWithDictionary:self.dictTempListStorage]];
    }
    else if ([elementName isEqualToString:@"Symbol"]){
        [self.dictTempListStorage setObject:[NSString stringWithString:self.foundListValue] forKey:@"Symbol"];
    }
    else if ([elementName isEqualToString:@"Price"]){
        [self.dictTempListStorage setObject:[NSString stringWithString:self.foundListValue] forKey:@"Price"];
    }
    
    else if ([elementName isEqualToString:@"Difference"]){
        [self.dictTempListStorage setObject:[NSString stringWithString:self.foundListValue] forKey:@"Difference"];
    }
    else if ([elementName isEqualToString:@"Volume"]){
        [self.dictTempListStorage setObject:[NSString stringWithString:self.foundListValue] forKey:@"Volume"];
    }
    else if ([elementName isEqualToString:@"Buying"]){
        [self.dictTempListStorage setObject:[NSString stringWithString:self.foundListValue] forKey:@"Buying"];
    }
    else if ([elementName isEqualToString:@"Selling"]){
        [self.dictTempListStorage setObject:[NSString stringWithString:self.foundListValue] forKey:@"Selling"];
    }
    else if ([elementName isEqualToString:@"Hour"]){
        [self.dictTempListStorage setObject:[NSString stringWithString:self.foundListValue] forKey:@"Hour"];
    }
    else if ([elementName isEqualToString:@"Total"]){
        [self.dictTempListStorage setObject:[NSString stringWithString:self.foundListValue] forKey:@"Total"];
    }
    else if ([elementName isEqualToString:@"DayLowestPrice"]){
        [self.dictTempListStorage setObject:[NSString stringWithString:self.foundListValue] forKey:@"DayLowestPrice"];
    }
    else if ([elementName isEqualToString:@"DayPeakPrice"]){
        [self.dictTempListStorage setObject:[NSString stringWithString:self.foundListValue] forKey:@"DayPeakPrice"];
    }
    //     Clear the mutable string.
    [self.foundListValue setString:@""];
    
}


// TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrIMKBData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
        cell.lblSymbol.text = [[self.arrIMKBData objectAtIndex:indexPath.row] objectForKey:@"Symbol"];
        cell.lblPrice.text = [[self.arrIMKBData objectAtIndex:indexPath.row] objectForKey:@"Price"];
        cell.lblHour.text = [[self.arrIMKBData objectAtIndex:indexPath.row] objectForKey:@"Hour"];
        cell.lblBuying.text = [[self.arrIMKBData objectAtIndex:indexPath.row] objectForKey:@"Buying"];
        cell.lblVolume.text = [[self.arrIMKBData objectAtIndex:indexPath.row] objectForKey:@"Volume"];
        cell.lblSelling.text = [[self.arrIMKBData objectAtIndex:indexPath.row] objectForKey:@"Selling"];
        cell.lblDifference.text = [[self.arrIMKBData objectAtIndex:indexPath.row] objectForKey:@"Difference"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"DetailLow" sender:tableView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *myIndexPath = [self.tblLowest indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"DetailLow"]) {
        self.symbolData = [[self.arrIMKBData objectAtIndex:myIndexPath.row] objectForKey:@"Symbol"];
        self.priceData =  [[self.arrIMKBData objectAtIndex:myIndexPath.row] objectForKey:@"Price"];
        self.highData =  [[self.arrIMKBData objectAtIndex:myIndexPath.row] objectForKey:@"DayPeakPrice"];
        self.lowData =  [[self.arrIMKBData objectAtIndex:myIndexPath.row] objectForKey:@"DayLowestPrice"];
        self.volumeData =  [[self.arrIMKBData objectAtIndex:myIndexPath.row] objectForKey:@"Volume"];
        self.countData =  [[self.arrIMKBData objectAtIndex:myIndexPath.row] objectForKey:@"Total"];
        self.changeData =  [[self.arrIMKBData objectAtIndex:myIndexPath.row] objectForKey:@"Difference"];
        
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.symbolData = self.symbolData;
        detailVC.priceData = self.priceData;
        detailVC.highData = self.highData;
        detailVC.lowData = self.lowData;
        detailVC.volumeData = self.volumeData;
        detailVC.countData = self.countData;
        detailVC.changeData = self.changeData;
        detailVC.key = self.myKey;
        //        NSLog(@"%@" , myIndexPath);
    }
}
@end
