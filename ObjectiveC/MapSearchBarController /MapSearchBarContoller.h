//
//  MapSearchBarContoller.h
//  SearchBarControllerDemo
//
//  Created by Apple on 19/11/16.
//  Copyright © 2016 vijayvirSingh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@protocol MapSearchBarContollerDelegate;


@protocol MapSearchBarContollerDelegate <NSObject>

@optional

- (void)  mapSearchBarContollerClickOnDoneButton:(UISearchBar *)fileName;

- (void)  mapSearchBarContollerDidClickOnSearchButton:(CLLocationCoordinate2D )cooridinates region:(MKCoordinateRegion) region searchBar:(id)bar ;

@end

@interface MapSearchBarContoller : NSObject <UISearchControllerDelegate,UISearchDisplayDelegate,UISearchResultsUpdating , UISearchBarDelegate>

#pragma mark- IBOutlet
@property (weak, nonatomic) IBOutlet UISearchDisplayController *resultSearchController;

@property(weak,nonatomic) IBOutlet id<MapSearchBarContollerDelegate>delegateMSB;


#pragma mark- Functions 

-(void)mapSearchBarContollerInitialize;


@end
