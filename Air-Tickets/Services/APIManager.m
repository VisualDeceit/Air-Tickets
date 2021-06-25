//
//  APIManager.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 24.06.2021.
//

#import "APIManager.h"
#import "DataManager.h"
#import "Ticket.h"

@implementation APIManager

+ (instancetype)shared {
    static APIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [APIManager new];
    });
    return instance;
};

- (void)cityForCurrentIP:(void (^)(City * _Nonnull))completion {
    [self IPAddressWithCompletion:^(NSString *ipAddress) {
        NSString *url = [NSString stringWithFormat:@"%@%@",API_URL_CITY_FROM_IP, ipAddress];
        [self loadFromURL:url withCompletion:^(id  _Nullable result) {
            NSDictionary *json = result;
            NSString *iata = [json valueForKey:@"iata"];
            if (iata) {
                City *city = [[DataManager sharedInstance] cityForIATA:iata];
                if (city) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(city);
                    });
                };
            };
        }];
    }];
}

//наш ip адрес
- (void)IPAddressWithCompletion:(void (^)(NSString *ipAddress))completion {
    [self loadFromURL:API_URL_IP_ADDRESS withCompletion:^(id  _Nullable result) {
        NSDictionary *json = result;
        completion([json valueForKey:@"ip"]);
    }];
}

//загрузка данных из сети
-(void)loadFromURL:(NSString *)urlString withCompletion:(void (^)(id _Nullable result))completion {
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            completion([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
    }] resume];
}

- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion {
     NSString *urlString = [NSString stringWithFormat:@"%@?%@&token=%@", API_URL_CHEAP, [self searchRequestQuery:request], API_TOKEN];
    [self loadFromURL:urlString withCompletion:^(id  _Nullable result) {
        NSDictionary *response = result;
        if (response) {
            NSDictionary *json = [[response valueForKey:@"data"] valueForKey:request.destionation];
            NSMutableArray *array = [NSMutableArray new];
            for (NSString *key in json) {
                NSDictionary *value = [json valueForKey: key];
                Ticket *ticket = [[Ticket alloc] initWithDictionary:value];
                ticket.from = request.origin;
                ticket.to = request.destionation;
                [array addObject:ticket];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array);
            });
        }
    }];
}

- (NSString *)searchRequestQuery:(SearchRequest) request {
    NSString *result = [NSString stringWithFormat:@"origin=%@&destination=%@", request.origin, request.destionation];
    if (request.departDate && request.returnDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM";
        result = [NSString stringWithFormat:@"%@&depart_date=%@&return_date=%@", result, [dateFormatter stringFromDate:request.departDate], [dateFormatter stringFromDate:request.returnDate]];
    }
    return result;
}

@end
