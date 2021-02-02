//
//  Person.m
//  IOSAtomicDemo
//
//  Created by Mason on 2021/2/2.
//

#import "Person.h"
#import <objc/runtime.h>

@interface Person ()

@property (atomic, copy) NSString *name;

@end

@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
{
    self = [self init];
    if (self) {
        self.name = name;
    }
    return self;
}

- (NSString *)name
{
    if (!_name) {
        _name = [NSString string];
    }
    return _name;
}

- (NSString *)getPropertyName
{
    return [self name];
}

@end
