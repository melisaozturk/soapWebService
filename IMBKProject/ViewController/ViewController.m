//
//  ViewController.m
//  IMBKProject
//
//  Created by melisa öztürk on 5.04.2019.
//  Copyright © 2019 melisa öztürk. All rights reserved.
//

#import "ViewController.h"
#import "ListViewController.h"
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize key;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"IMKB HİSSE SENETLERİ/ENDEKSLER";
    [self Encrypt];
}


-(void) Encrypt {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd:MM:yyyy HH:mm"];
    
    NSString *soapMessage = [NSString stringWithFormat : @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
    "<soap:Body>"
    "<Encrypt xmlns=\"http://tempuri.org/\">"
    "<request>RequestIsValid%@</request>"
    " </Encrypt>"
    "</soap:Body>"
    "</soap:Envelope>", [dateFormatter stringFromDate:[NSDate date]]];
    
    NSLog(@"\n\nsoapMessage: %@",soapMessage);
    
    NSURL *requestURL = [NSURL URLWithString:@"http://mobileexam.veripark.com/mobileforeks/service.asmx"];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:requestURL];
    NSString *messageLength = [NSString stringWithFormat:@"%d", (int)[soapMessage length]];
    
    [myRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: @"http://tempuri.org/Encrypt" forHTTPHeaderField:@"SOAPAction"];
    [myRequest addValue: messageLength forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:myRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"\n\n%@", responseString);
        }
        self.xmlParser=[[NSXMLParser alloc] initWithData:data];
        self.xmlParser.delegate=self;
        if([self.xmlParser parse]){
            NSLog(@"%@",self.results);
        }
    }];
    [dataTask resume];
}



//  XML Parse

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    // Initialize the data array.
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    self.key = self.results[0];
    NSLog(@"%@", self.key);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    
    if([elementName isEqualToString:@"EncryptResponse"]){
        self.results=[[NSMutableArray alloc] init];
    }
    if([elementName isEqualToString:@"EncryptResult"]){
        self.parsedString=[[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if(self.parsedString){
        [self.parsedString appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    
    if([elementName isEqualToString:@"EncryptResult"]){
        [self.results addObject:self.parsedString];
        
        self.parsedString=nil;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ListViewController *newVC = segue.destinationViewController;
    newVC.myKey = self.key;
//    NSLog(@"%@", self.key);
}

@end
