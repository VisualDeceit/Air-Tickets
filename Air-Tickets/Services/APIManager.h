//
//  APIManager.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 24.06.2021.
//

#import <Foundation/Foundation.h>
#import "City.h"
#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

#define API_TOKEN @"6ff61158c98bbf368f3592e9d998ea04"
#define API_URL_IP_ADDRESS @"https://api.ipify.org/?format=json"
#define API_URL_CHEAP @"https://api.travelpayouts.com/v1/prices/cheap"
#define API_URL_CITY_FROM_IP @"https://www.travelpayouts.com/whereami?ip="
#define AirlineLogo(iata) [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png", iata]];



@interface APIManager : NSObject

+ (instancetype)shared;
- (void)cityForCurrentIP:(void (^)(City *city))completion;
- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;

@end

NS_ASSUME_NONNULL_END
