//
//  Person.h
//  CoredataDemo4
//
//  Created by Anke on 15/2/8.
//  Copyright (c) 2015年 Anke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * tel;

@end
