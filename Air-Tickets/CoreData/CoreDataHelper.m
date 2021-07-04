//
//  CoreDataHelper.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 04.07.2021.
//

#import "CoreDataHelper.h"

@interface CoreDataHelper()

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation CoreDataHelper

+ (instancetype)sharedInstance{
    static CoreDataHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CoreDataHelper new];
        [instance setup];
    });
    return instance;
}

- (void)setup {
    //Экземпляр NSManagedObjectModel представляет файл модели, описывающий типы, свойства и отношения
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    NSAssert(modelURL, @"Failed to locate momd bundle in application");
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(_managedObjectModel, @"Failed to initialize mom from URL: %@", modelURL);
    
    //Экземпляр NSPersistentStoreCoordinator сохраняет и извлекает экземпляры типов из БД
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    
    //Экземпляр NSManagedObjectContext отслеживает изменения экземпляров типов
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    
    [self setManagedObjectContext:_managedObjectContext];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask] lastObject];
        
        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
        
        NSError *error = nil;
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        if (!store) {
            NSLog(@"Failed to initalize persistent store: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
    });
}

- (void)save {
    NSError *error = nil;
    if ([[self managedObjectContext] save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

- (BOOL)isFavorite:(Ticket *)ticket {
    return [self favoriteFromTicket:ticket];
}

- (FavoriteTicketMO *)favoriteFromTicket:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    return [[[self managedObjectContext] executeFetchRequest:request error:nil] firstObject];
}

- (void)addToFavorite:(Ticket *)ticket {
    //создание записи через NSEntityDescription
    ///FavoriteTicketMO *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:[self managedObjectContext]];
    //создание записи через инициализатор (IOS10+)
    FavoriteTicketMO *favorite = [[FavoriteTicketMO alloc] initWithContext:[self managedObjectContext]];
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departure = ticket.departure;
    favorite.expires = ticket.expires;
    favorite.flightNumber = ticket.flightNumber.intValue;
    favorite.returnDate = ticket.returnDate;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.created = [NSDate date];
    [self save];
}

- (void)removeFromFavorite:(Ticket *)ticket {
    FavoriteTicketMO *favorite = [self favoriteFromTicket:ticket];
    if (favorite) {
        [[self managedObjectContext] deleteObject:favorite];
        [self save];
    }
}

- (NSArray *)favorites {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [[self managedObjectContext] executeFetchRequest:request error:nil];
}


@end
