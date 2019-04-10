//
//  ListViewController.m
//  IMBKProject
//
//  Created by melisa öztürk on 8.04.2019.
//  Copyright © 2019 melisa öztürk. All rights reserved.
//

#import "ListViewController.h"
#import "ListCell.h"
#import "DetailViewController.h"

@interface ListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblList;

@end

@implementation ListViewController
@synthesize symbolData;
@synthesize myKey;
@synthesize changeData;
@synthesize countData;
@synthesize volumeData;
@synthesize lowData;
@synthesize highData;
@synthesize priceData;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Hisse Senedi Ve Endeksler";
   
    [self List];
}

-(void) List {
//    NSLog(@"%@", self.myKey);
    
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd:ww:MM"];
//    NSString * dateString = [dateFormatter stringFromDate:[NSDate date]];

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
                                                  
                                                  [self.xmlParserList parse];
                                                  
                                              }
                                          }];
    [dataTaskList resume];

}

//  XML Parse

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    // Initialize the neighbours data array.
    self.arrNeighboursData = [[NSMutableArray alloc] init];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
//    NSLog(@"%@",self.arrSymbolData);
//    self.temp = self.arrSymbolData[0];;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblList reloadData];
    });
    NSLog(@"%@", self.arrNeighboursData);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    // If the current element name is equal to "StockandIndex" then initialize the temporary dictionary.
    if ([elementName isEqualToString:@"StockandIndex"]) {
        self.dictTempDataStorage = [[NSMutableDictionary alloc] init];
    }
    // Keep the current element.
    self.currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // Store the found characters if only we're interested in the current element.
    if ([self.currentElement isEqualToString:@"Symbol"] || [self.currentElement isEqualToString:@"Price"] || [self.currentElement isEqualToString:@"Difference"] || [self.currentElement isEqualToString:@"Volume"] || [self.currentElement isEqualToString:@"Buying"] || [self.currentElement isEqualToString:@"Selling"] || [self.currentElement isEqualToString:@"Hour"] || [self.currentElement isEqualToString:@"Total"] || [self.currentElement isEqualToString:@"DayPeakPrice"] || [self.currentElement isEqualToString:@"DayLowestPrice"]) {
        
        if (![string isEqualToString:@"\n"]) {
            [self.foundValue appendString:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    
    if ([elementName isEqualToString:@"StockandIndex"]) {
        // If the closing element equals to "geoname" then the all the data of a neighbour country has been parsed and the dictionary should be added to the neighbours data array.
            [self.arrNeighboursData addObject:[[NSDictionary alloc] initWithDictionary:self.dictTempDataStorage]];
    }
    else if ([elementName isEqualToString:@"Symbol"]){
        // If the country name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Symbol"];
    }
    else if ([elementName isEqualToString:@"Price"]){
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Price"];
    }
    
    else if ([elementName isEqualToString:@"Difference"]){
        //        [self.dictTempDataStorage setValue:self.foundValue forKey:@"Price"];
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Difference"];
    }
    else if ([elementName isEqualToString:@"Volume"]){
        //        [self.dictTempDataStorage setValue:self.foundValue forKey:@"Price"];
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Volume"];
    }
    else if ([elementName isEqualToString:@"Buying"]){
        //        [self.dictTempDataStorage setValue:self.foundValue forKey:@"Price"];
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Buying"];
    }
    else if ([elementName isEqualToString:@"Selling"]){
        //        [self.dictTempDataStorage setValue:self.foundValue forKey:@"Price"];
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Selling"];
    }
    else if ([elementName isEqualToString:@"Hour"]){
        //        [self.dictTempDataStorage setValue:self.foundValue forKey:@"Price"];
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Hour"];
    }
    else if ([elementName isEqualToString:@"Total"]){
        //        [self.dictTempDataStorage setValue:self.foundValue forKey:@"Price"];
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Total"];
    }
    else if ([elementName isEqualToString:@"DayLowestPrice"]){
        //        [self.dictTempDataStorage setValue:self.foundValue forKey:@"Price"];
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"DayLowestPrice"];
    }
    else if ([elementName isEqualToString:@"DayPeakPrice"]){
        //        [self.dictTempDataStorage setValue:self.foundValue forKey:@"Price"];
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"DayPeakPrice"];
    }
    
//     Clear the mutable string.
    [self.foundValue setString:@""];
   
}

// TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrNeighboursData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblSymbol.text = [[self.arrNeighboursData objectAtIndex:indexPath.row] objectForKey:@"Symbol"];
    cell.lblPrice.text = [[self.arrNeighboursData objectAtIndex:indexPath.row] objectForKey:@"Price"];
    cell.lblHour.text = [[self.arrNeighboursData objectAtIndex:indexPath.row] objectForKey:@"Hour"];
    cell.lblBuying.text = [[self.arrNeighboursData objectAtIndex:indexPath.row] objectForKey:@"Buying"];
    cell.lblVolume.text = [[self.arrNeighboursData objectAtIndex:indexPath.row] objectForKey:@"Volume"];
    cell.lblSelling.text = [[self.arrNeighboursData objectAtIndex:indexPath.row] objectForKey:@"Selling"];
    cell.lblDifference.text = [[self.arrNeighboursData objectAtIndex:indexPath.row] objectForKey:@"Difference"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"DetailSegue" sender:tableView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     NSIndexPath *myIndexPath = [self.tblList indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"DetailSegue"]) {
            self.symbolData = [[self.arrNeighboursData objectAtIndex:myIndexPath.row] objectForKey:@"Symbol"];
            self.priceData =  [[self.arrNeighboursData objectAtIndex:myIndexPath.row] objectForKey:@"Price"];
            self.highData =  [[self.arrNeighboursData objectAtIndex:myIndexPath.row] objectForKey:@"DayPeakPrice"];
            self.lowData =  [[self.arrNeighboursData objectAtIndex:myIndexPath.row] objectForKey:@"DayLowestPrice"];
            self.volumeData =  [[self.arrNeighboursData objectAtIndex:myIndexPath.row] objectForKey:@"Volume"];
            self.countData =  [[self.arrNeighboursData objectAtIndex:myIndexPath.row] objectForKey:@"Total"];
            self.changeData =  [[self.arrNeighboursData objectAtIndex:myIndexPath.row] objectForKey:@"Difference"];
        
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
