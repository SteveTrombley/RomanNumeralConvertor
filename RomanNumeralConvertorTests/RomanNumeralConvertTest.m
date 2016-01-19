//
//  RomanNumeralConvertTest.m
//  RomanNumeralConvertor
//
//  Created by Steve Trombley on 10/27/15.
//  Copyright © 2015 Steve Trombley. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface ViewController (Test)

-(NSString *)base10FromRomanNumeral:(NSString *)theRomanNumeral;
-(bool)isValidSubtractionCombination:(NSString *)thePair;
-(bool)validateCharacters:(NSString *)romanNumeralString;
-(NSString *)screenForImproperSetsOfFourValues:(NSString *)romanNumeral;


 @end 

@interface RomanNumeralConvertTest : XCTestCase

@property (strong, nonatomic) NSDictionary *romanNumeralToBase10ConversionTable;
@property (strong, nonatomic) NSArray *validSubtractionPairs;
@property (strong, nonatomic) NSString *finalResult;


@property (strong, nonatomic) ViewController *vc;

@end

@implementation RomanNumeralConvertTest
@synthesize romanNumeralToBase10ConversionTable, validSubtractionPairs, finalResult, vc;
- (void)setUp {
    [super setUp];
    self.vc=[[ViewController alloc] init];
 
    

    self.vc.romanNumeralToBase10ConversionTable=@{
                                           @"I" : @1,
                                           @"V" : @5,
                                           @"X" : @10,
                                           @"L" : @50,
                                           @"C" : @100,
                                           @"D" : @500,
                                           @"M" : @1000
                                           };

    self.vc.validSubtractionPairs=@[@"IV", @"IX", @"XL", @"XC", @"CD", @"CM"];
}

- (void)tearDown {
    self.vc=nil;
    [super tearDown];
}


-(void)testRomanNumeralToBase10Conversion {
    NSString *result=[vc base10FromRomanNumeral:@"XCIX"];
    NSString *expectedResult=@"99";
    XCTAssertEqualObjects(result, expectedResult, @"return did not match");
 }

-(void)testForInvalidSubtractionPair {
    bool result = [vc isValidSubtractionCombination:@"IM"];
    XCTAssertFalse(result, @"IM is not a valid substraction pair");
}

-(void)testForInvalidCharacters {
    bool result = [vc validateCharacters:@"XiI"];
    XCTAssertFalse(result, @"i is not a valid character");}

-(void)testForSetsOfFour {
    NSString *result=[vc screenForImproperSetsOfFourValues:@"XXIIII"];
    XCTAssertEqualObjects(@"IIII", result, @"IIII is an invalid set");
    }




 @end
