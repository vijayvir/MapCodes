//
//  MapSearchBar.h
//  WarnUp
//
//  Created by Apple on 18/11/16.
//  Copyright © 2016 WarnUp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapSearchBarDataDelegate;


@protocol MapSearchBarDataDelegate <NSObject>
@optional
- (void)  mapSearchBarClickOnDoneButton:(UISearchBar *)fileName;
- (void)  mapSearchBarDidClickOnSearchButton:(CLLocationCoordinate2D )cooridinates region:(MKCoordinateRegion) region searchBar:(UISearchBar*)bar ;

@end



@interface MapSearchBar : UISearchBar<UISearchBarDelegate>

@property (nonatomic) IBInspectable NSString * rightBarText;
@property(weak,nonatomic) IBOutlet id<MapSearchBarDataDelegate>delegateMSB;

@end
