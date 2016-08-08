//
//  MyDatabase.h
//  CoredataDemo4
//
//  Created by Anke on 15/2/8.
//  Copyright (c) 2015年 Anke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDatabase : NSObject

+ (id)shareMyDatabase;
//增加
- (void)addPersonWithModel:(NSDictionary *)dict;
//删除
- (void)removePersonWithModel:(NSString *)guid;
//条件查询
- (void)quePersonWithStr:(NSString *)guid;
//修改
- (void)updatePersonWithStr:(NSString *)guid;
//展示表中所有数据（无条件查询）
- (void)allPerson;
@end
