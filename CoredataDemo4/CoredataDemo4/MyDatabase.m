//
//  MyDatabase.m
//  CoredataDemo4
//
//  Created by Anke on 15/2/8.
//  Copyright (c) 2015年 Anke. All rights reserved.
//

#import "MyDatabase.h"
#import <CoreData/CoreData.h>
#import "Person.h"

@implementation MyDatabase
{
    // CoreData数据操作的上下文，负责所有的数据操作，类似于SQLite的数据库连接句柄
    NSManagedObjectContext *_context;
}
#pragma mark - 数据库单例初始化
+ (id)shareMyDatabase
{
    static MyDatabase *myDB = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        myDB = [[MyDatabase alloc] init];
    });
    return myDB;
}

- (id)init
{
    self = [super init];
    if (self) {

        // 创建数据库
        // 1. 实例化数据模型(将所有定义的模型都加载进来)
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        // 2. 实例化持久化存储调度，要建立起桥梁，需要模型
        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // 3. 添加一个持久化的数据库到存储调度
        // 3.1 建立数据库保存在沙盒的URL
        NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [docs[0] stringByAppendingPathComponent:@"anke.db"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        // 3.2 打开或者新建数据库文件
        // 如果文件不存在，则新建之后打开
        // 否者直接打开数据库
        NSError *error = nil;
        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
        
        if (error) {
            NSLog(@"打开数据库出错 - %@", error.localizedDescription);
        } else {
            NSLog(@"打开数据库成功！");
            
            _context = [[NSManagedObjectContext alloc] init];
            
            _context.persistentStoreCoordinator = store;
        }

    }
    return self;
}


#pragma mark - 添加操作
- (void)addPersonWithModel:(NSDictionary *)dic
{
    // 1. 实例化并让context“准备”将一条个人记录增加到数据库
    Person *per = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:_context];
    // 2.赋值
    per.name = @"wangwu";
    per.tel = @"123456";
    // 3. 保存(让context保存当前的修改)
    if ([_context save:nil]) {
        NSLog(@"新增成功");
    } else {
        NSLog(@"新增失败");
    }
}

#pragma mark - 删除操作
- (void)removePersonWithModel:(NSString *)guid
{
    // 1. 实例化查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    // 2. 设置谓词条件
    request.predicate = [NSPredicate predicateWithFormat:@"name = 'wangwu'"];
    // 3. 由上下文查询数据
    NSArray *result = [_context executeFetchRequest:request error:nil];
    // 4. 输出结果
    for (Person *per in result) {
        NSLog(@"%@ %@", per.name,per.tel);
        // 删除一条记录
        [_context deleteObject:per];
        break;
    }
    // 5. 通知_context保存数据
    if ([_context save:nil]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

#pragma mark - 按条件查询
- (void)quePersonWithStr:(NSString *)guid
{
    // 1. 实例化一个查询(Fetch)请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    // 在谓词中CONTAINS类似于数据库的 LIKE '%王%'
    request.predicate = [NSPredicate predicateWithFormat:@"name LIKE '*五'"];
    // 2. 让_context执行查询数据
    NSArray *array = [_context executeFetchRequest:request error:nil];
    for (Person *per in array) {
        NSLog(@"name == %@,tel == %@",per.name,per.tel);
    }
}

#pragma mark - 更新对应的数据
- (void)updatePersonWithStr:(NSString *)guid
{
    // 1. 实例化查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    // 2. 设置谓词条件
    request.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS '王五'"];
    // 3. 由上下文查询数据
    NSArray *result = [_context executeFetchRequest:request error:nil];
    // 4. 输出结果
    for (Person *per in result) {
        NSLog(@"name == %@,tel == %@",per.name,per.tel);
        // 更新名字
        per.name = @"李四";
    }
    // 通知上下文保存保存
    [_context save:nil];
}

#pragma mark - 取出该表中所有数据
- (void)allPerson
{
    // 1. 实例化一个查询(Fetch)请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    // 2. 让_context执行查询数据
    NSArray *array = [_context executeFetchRequest:request error:nil];
    for (Person *per in array) {
        NSLog(@"name == %@,tel == %@",per.name,per.tel);
    }
}
@end
