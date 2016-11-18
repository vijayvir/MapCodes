//
//  MapSearchBar.m
//  WarnUp
//
//  Created by Apple on 18/11/16.
//  Copyright © 2016 WarnUp. All rights reserved.
//

#import "MapSearchBar.h"
#import <objc/runtime.h>
static char associateKey;

@implementation MapSearchBar

{
   
    
}
@synthesize delegateMSB;

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    
    
    

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        
        UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
        
        [keyboardDoneButtonView sizeToFit];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(numberPaddoneClicked:)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        CGRect frameimg = CGRectMake(0,0,  [UIScreen mainScreen].bounds.size.width - 100  ,70);
        
        UILabel * lblFormatedText = [[UILabel alloc] initWithFrame:frameimg];
        
        lblFormatedText.text = @"";
        
        lblFormatedText.textColor = [UIColor whiteColor];
        
        
        UIBarButtonItem *leftLabel =[[UIBarButtonItem alloc] initWithCustomView:lblFormatedText];
        
        objc_setAssociatedObject(keyboardDoneButtonView, &associateKey, lblFormatedText, OBJC_ASSOCIATION_RETAIN);
        
        
       
            
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:leftLabel,space,space,doneButton, nil]];
     
        self.inputAccessoryView = keyboardDoneButtonView;
        
        self.delegate = self;

    }
    
    
    
    return self;
}

- (void)keyboardWillShow:(NSNotification *)n
{
}
#pragma mark- SearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    

 UILabel *label = objc_getAssociatedObject(self.inputAccessoryView , &associateKey);
 label.text = @"";
 return YES;
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    UILabel *label = objc_getAssociatedObject(self.inputAccessoryView , &associateKey);
    
    label.text = [self getFormmatedText:searchText];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%f",[self getLocationFromAddressString:searchBar.text].latitude);
    
    
        if (delegateMSB)
        {
            if ([delegateMSB respondsToSelector:@selector(mapSearchBarDidClickOnSearchButton:region:searchBar:)])
            {
                
                CLLocationCoordinate2D coordinates = [self getLocationFromAddressString:searchBar.text] ;
                
                MKCoordinateRegion region;
                
                region.center.latitude =coordinates.latitude;
                
                region.center.longitude = coordinates.longitude;
                
                region.span.latitudeDelta = 1.0;
                
                region.span.longitudeDelta = 1.0;
        
                [delegateMSB mapSearchBarDidClickOnSearchButton:[self getLocationFromAddressString:searchBar.text] region:region searchBar:self];
                
                 self.text = @"";
                
                [self resignFirstResponder];
                
            }
            
        }
    
}
#pragma mark- Functions


-(NSString*) getFormmatedText: (NSString*) addressStr
{
    NSString * formatedText  = @"";

    
    
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"formatted_address\" :" intoString:nil] && [scanner scanString:@"\"formatted_address\" :" intoString:nil])
        {
            [scanner scanUpToString:@"\"formatted_address\" :" intoString:&formatedText];
            
            
            
           
        }
        
        else{
            formatedText  = @"";
        }
    }
 
    return formatedText;
}

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
    if ([scanner scanUpToString:@"\"location\" :" intoString:nil] && [scanner scanString:@"\"location\" :" intoString:nil])
    {
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil])
        {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil])
            {
                [scanner scanDouble:&longitude];
            }
        }
    }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    return center;
}




-(void)numberPaddoneClicked:(id)sender
{
    self.text = @"";
    [self resignFirstResponder];

    
}



@end
