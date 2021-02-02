//
//  Person.h
//  IOSAtomicDemo
//
//  Created by Mason on 2021/2/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

- (instancetype)initWithName:(NSString *)name;

- (NSString *)getPropertyName;

@end

NS_ASSUME_NONNULL_END
