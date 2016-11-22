//
//  MapSearchBarContoller.m
//  SearchBarControllerDemo
//
//  Created by Apple on 19/11/16.
//  Copyright © 2016 vijayvirSingh. All rights reserved.
//

#import "MapSearchBarContoller.h"

    CGPoint  activeOrigin = { 0.f, 15.f };
    CGPoint  deActiveOrigin = { 50.f, 64.f };

@implementation MapSearchBarContoller

{
    NSArray * results;

}
@synthesize delegateMSB,resultSearchController;


#pragma mark - SearchBar Controller

#pragma mark - Initial metthods 

-(void)mapSearchBarContollerInitialize
{
   [self  searchBarIsActive:NO];
    resultSearchController.searchBar.returnKeyType  =  UIReturnKeyDone;
    resultSearchController.delegate = self;
    
    self.resultSearchController.searchResultsTableView.backgroundColor = [UIColor clearColor];
    self.resultSearchController.searchResultsTableView.separatorColor = [UIColor clearColor];
    
 
//    [self observe:resultSearchController.searchContentsController.view keyPath:@"hidden" options:NSKeyValueObservingOptionNew block:^(id observer, UIView* view, NSDictionary *change)
//    {
//        if ([change[NSKeyValueChangeNewKey] boolValue] == YES) {
//            view.hidden = NO;
//        }
//    }];
//    resultSearchController.dimsBackgroundDuringPresentation = NO;
    
    
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    
}
- (void)didDismissSearch{
    
}


- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    
}



- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}

#pragma mark -  Scrollview delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if(results != nil )
    {
        if (results.count == 0)
        {
            resultSearchController.active = false;
            
            [self  searchBarIsActive:NO];
            
            
        }
    }
    
}


#pragma mark - Tableview DataSourse and delegate 


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    if(results == nil )
    {
        return 0 ;

    }
    if (results.count > 0)
    {
            return results.count ;
    }

    return 0 ;
}




-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];

    
    
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"] ;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
 
    cell.textLabel.text =  [NSString stringWithFormat:@"%@", [results[indexPath.row] objectForKey:@"formatted_address"] ];
    
    return cell;
    

    
    
   }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (delegateMSB)
    {
        if ([delegateMSB respondsToSelector:@selector(mapSearchBarContollerDidClickOnSearchButton:region:searchBar:)])
        {
        
            CLLocationCoordinate2D coordinates = [self makeCorordinates:[[[results[indexPath.row] objectForKey:@"geometry" ] objectForKey:@"location" ]objectForKey:@"lat" ] lng:[[[results[indexPath.row] objectForKey:@"geometry" ] objectForKey:@"location" ]objectForKey:@"lng" ]];
            
            MKCoordinateRegion region;
            
            region.center.latitude =coordinates.latitude;
            
            region.center.longitude = coordinates.longitude;
            
            region.span.latitudeDelta = 0.50;
            
            region.span.longitudeDelta = 0.50;
            
            [delegateMSB mapSearchBarContollerDidClickOnSearchButton:coordinates region:region searchBar:self];
            
             resultSearchController.active = false;
            if(resultSearchController.active  == false)
            {
                
                [self searchBarIsActive:NO];
                
                
              
                
            }
            
        }
        
    }
}



#pragma mark Searchbar Delegate 
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [self searchBarIsActive:YES];

    return YES;
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    if(resultSearchController.active  == false)
    {

    [self searchBarIsActive:NO];
    
    }
    
   
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (![searchText isEqualToString:@""])
    {
         NSLog(@"%@",[self getFormmatedText:searchText]);
    }
    
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
     resultSearchController.active = false;
    
    if(resultSearchController.active  == false)
    {
                  [self searchBarIsActive:NO];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
     resultSearchController.active = false;
    
    if(resultSearchController.active  == false)
    {
                 [self searchBarIsActive:NO];
        
    }
}



#pragma mark - Touch delegate 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}

#pragma mark- 

#pragma mark- Funtions

-(void)searchBarIsActive : (BOOL) isActive
{
    
    if (isActive)
    {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        
        resultSearchController.searchBar.frame = CGRectMake(activeOrigin.x,  activeOrigin.y ,keyWindow.frame.size.width , resultSearchController.searchBar.frame.size.height);
        
        
        resultSearchController.searchBar.center = CGPointMake(keyWindow.center.x,
                                                               resultSearchController.searchBar.center.y);
        
        
        UITextField *searchField = [resultSearchController.searchBar valueForKey:@"_searchField"];
        
        searchField.textColor = [UIColor whiteColor];
        
        UIColor *color = [UIColor blackColor];
        searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:searchField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        resultSearchController.searchBar.backgroundColor = [UIColor redColor];
        
        
        
    }
    else
    {
        
        UITextField *searchField = [resultSearchController.searchBar valueForKey:@"_searchField"];
        
        searchField.textColor = [UIColor blackColor];
        
        UIColor *color = [UIColor blackColor];
        
        searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:searchField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        
        resultSearchController.searchBar.backgroundColor = [UIColor clearColor];
        
        resultSearchController.searchBar.showsCancelButton = false;
        
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        
        resultSearchController.searchBar.frame = CGRectMake(deActiveOrigin.x, deActiveOrigin.y  ,keyWindow.frame.size.width - 100, resultSearchController.searchBar.frame.size.height);
    }
    
}

-(CLLocationCoordinate2D) makeCorordinates: (NSString*) lat lng:(NSString*) lng
{
    CLLocationCoordinate2D center;
    
    center.latitude=lat.floatValue;
    
    center.longitude = lng.floatValue;
    
    return center;
}

-(NSString*) getFormmatedText: (NSString*) addressStr
{
    NSString * formatedText  = @"";
    
    
    
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    
    id result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    
    
    NSData *objectData = [result dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
    
    NSArray  *dictionary = [json objectForKey:@"results"];
    
    
    if ([json objectForKey:@"results"])
    {
        results = [json objectForKey:@"results"];
        
    }
    else{
        results =nil ;
        
    }
    formatedText  = @"";
    
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
@end
