//
//  main.m
//  IOSAtomicDemo
//
//  Created by Mason on 2021/2/2.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        Person *person = [[Person alloc] initWithName:@"Mason"];
        NSLog(@"姓名: %@", [person getPropertyName]);
    }
    return 0;
}
