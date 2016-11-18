//
//  MapSearchBar.m
//  WarnUp
//
//  Created by Apple on 18/11/16.
//  Copyright © 2016 WarnUp. All rights reserved.
//

#import "MapSearchBar.h"

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
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(numberPaddoneClicked:)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:space,doneButton, nil]];
        
        
        
        self.inputAccessoryView = keyboardDoneButtonView;
        self.delegate = self;
        
        
 
    }
    
    
    
    return self;
}


- (void)keyboardWillShow:(NSNotification *)n
{
  
    
}



#pragma mark- Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
    
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
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    

    
    
    
    
//    CLLocationCoordinate2D myLocation;
//    // -- modified from the stackoverflow page - we use the SBJson parser instead of the string scanner --
//    
//    NSString       *esc_addr1 = [addressStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//    NSString            *req1 = [NSString stringWithFormat: @"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr1];
//    NSDictionary *googleResponse =  [NSString stringWithContentsOfURL:[NSURL URLWithString:req1] encoding:NSUTF8StringEncoding error:NULL];
//    
//    NSDictionary    *resultsDict = [googleResponse valueForKey:  @"results"];   // get the results dictionary
//    NSDictionary   *geometryDict = [   resultsDict valueForKey: @"geometry"];   // geometry dictionary within the  results dictionary
//    NSDictionary   *locationDict = [  geometryDict valueForKey: @"location"];   // location dictionary within the geometry dictionary
//    
//    // -- you should be able to strip the latitude & longitude from google's location information (while understanding what the json parser returns) --
//    NSArray *latArray = [locationDict valueForKey: @"lat"]; NSString *latString = [latArray lastObject];     // (one element) array entries provided by the json parser
//    NSArray *lngArray = [locationDict valueForKey: @"lng"]; NSString *lngString = [lngArray lastObject];     // (one element) array entries provided by the json parser
//    
//    myLocation.latitude = [latString doubleValue];     // the json parser uses NSArrays which don't support "doubleValue"
//    myLocation.longitude = [lngString doubleValue];
//    
    //return myLocation;
}




-(void)numberPaddoneClicked:(id)sender
{
  //  [self datePickerValueChanged:datePicker];
    self.text = @"";
    
    [self resignFirstResponder];
    
//    if (delegateDP)
//    {
//        if ([delegateDP respondsToSelector:@selector(vjDatePickerClickOnDoneBytton:)])
//        {
//            [delegateDP vjDatePickerClickOnDoneBytton:self];
//        }
//        
//    }
    
    
}

@end
