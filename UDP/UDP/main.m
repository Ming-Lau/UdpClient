//
//  main.m
//  UDP
//
//  Created by 刘明 on 16/8/17.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Start.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Start* st = [[Start alloc]init];
        [st start];
        [[NSRunLoop mainRunLoop]run];
    }
    return 0;
}
