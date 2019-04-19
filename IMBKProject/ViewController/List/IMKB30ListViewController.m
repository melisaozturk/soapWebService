//
//  IMKB30ListViewController.m
//  IMBKProject
//
//  Created by melisa öztürk on 9.04.2019.
//  Copyright © 2019 melisa öztürk. All rights reserved.
//

#import "IMKB30ListViewController.h"
#import "ListCell.h"
#import "DetailViewController.h"

@interface IMKB30ListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tbl30;

@end

@implementation IMKB30ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"IMKB-30";
    self.arrIMKBData = [[NSMutableArray alloc] init];

    [self List];
    
}

-(void) get {

    for (NSDictionary *item in self.arrData) {
        NSString *string = [item objectForKey:@"Symbol"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", string];
        NSArray *results = [self.arrListData filteredArrayUsingPredicate:predicate];
        [self.arrIMKBData addObjectsFromArray: results];

        NSLog(@"%@", self.arrIMKBData);
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
                                                  self.foundValue = [[NSMutableString alloc] init];
                                                  self.foundListValue = [[NSMutableString alloc] init];

                                                  [self.xmlParserList parse];
                                                  
                                              }
                                          }];
    [dataTaskList resume];
    
}

//  XML Parse

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    // Initialize the data array.
    self.arrData = [[NSMutableArray alloc] init];
    self.arrListData = [[NSMutableArray alloc] init];

}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [self get];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tbl30 reloadData];
    });
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    // If the current element name is equal to "StockandIndex" then initialize the temporary dictionary.
   
        if ([elementName isEqualToString:@"IMKB30"]) {
            self.dictTempDataStorage = [[NSMutableDictionary alloc] init];
        }
        if ([elementName isEqualToString:@"StockandIndex"]) {
            self.dictTempListStorage = [[NSMutableDictionary alloc] init];
        }
    
    // Keep the current element.
    self.currentElement = elementName;
    self.currentListElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // Store the found characters if only we're interested in the current element.
    if ([self.currentElement isEqualToString:@"Symbol"] || [self.currentElement isEqualToString:@"Name"] || [self.currentElement isEqualToString:@"Gain"] || [self.currentElement isEqualToString:@"Fund"]) {
        
        if (![string isEqualToString:@"\n"]) {
            [self.foundValue appendString:string];
        }
    }
    if ([self.currentListElement isEqualToString:@"Symbol"] || [self.currentListElement isEqualToString:@"Price"] || [self.currentListElement isEqualToString:@"Difference"] || [self.currentListElement isEqualToString:@"Volume"] || [self.currentListElement isEqualToString:@"Buying"] || [self.currentListElement isEqualToString:@"Selling"] || [self.currentListElement isEqualToString:@"Hour"] || [self.currentListElement isEqualToString:@"Total"] || [self.currentListElement isEqualToString:@"DayPeakPrice"] || [self.currentListElement isEqualToString:@"DayLowestPrice"]) {
        
        if (![string isEqualToString:@"\n"]) {
            [self.foundListValue appendString:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    
    if ([elementName isEqualToString:@"IMKB30"]) {
        // If the closing element equals to "IMKB30" then the all the data has been parsed and the dictionary should be added to the array.
        [self.arrData addObject:[[NSDictionary alloc] initWithDictionary:self.dictTempDataStorage]];
    }
    else if ([elementName isEqualToString:@"Fund"]){
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Fund"];
    }
    else if ([elementName isEqualToString:@"Gain"]){
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Gain"];
    }
    else if ([elementName isEqualToString:@"Name"]){
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Name"];
    }
    else if ([elementName isEqualToString:@"Symbol"]){
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Symbol"];
    }
    if ([elementName isEqualToString:@"StockandIndex"]) {
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
    [self.foundValue setString:@""];
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
    [self performSegueWithIdentifier:@"Detail30" sender:tableView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *myIndexPath = [self.tbl30 indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"Detail30"]) {
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
