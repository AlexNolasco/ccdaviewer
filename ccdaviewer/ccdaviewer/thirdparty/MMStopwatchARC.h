//  MMStopwatch.h
//  MBMLibrary
//  Created by Matt Maher on 1/24/12.

#import <Foundation/Foundation.h>
// - - - - - - - - - - - - - - - - - - -
@interface MMStopwatchARC : NSObject {
  @private
    NSMutableDictionary *items;
}
+ (void)start:(NSString *)name;
+ (void)stop:(NSString *)name;
+ (void)print:(NSString *)name;
@end


// - - - - - - - - - - - - - - - - - - -
@interface MMStopwatchItemARC : NSObject {
  @private
    NSString *name;
    NSDate *started;
    NSDate *stopped;
}
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *started;
@property (nonatomic, strong) NSDate *stopped;


+ (MMStopwatchItemARC *)itemWithName:(NSString *)name;
- (void)stop;
- (NSTimeInterval)runtime;
- (double)runtimeMills;
@end
