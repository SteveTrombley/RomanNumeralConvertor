//
//  ViewController.m
//  RomanNumeralConvertor
//
//  Created by Steve Trombley on 10/27/15.
//  Copyright © 2015 Steve Trombley. All rights reserved.
//

#import "ViewController.h"







@implementation ViewController
@synthesize romanNumeralField, resultLabel, romanNumeralToBase10ConversionTable, validSubtractionPairs, finalResult;

typedef NS_ENUM(NSUInteger, CheckPairResult)  {
    CheckPairResultSubtract,
    CheckPairResultError,
    CheckPairResultDoNothing,
};



- (void)viewDidLoad {
    [super viewDidLoad];




    romanNumeralToBase10ConversionTable=@{
                                   @"I" : @1,
                                   @"V" : @5,
                                   @"X" : @10,
                                   @"L" : @50,
                                   @"C" : @100,
                                   @"D" : @500,
                                   @"M" : @1000
                                   };

    validSubtractionPairs=@[@"IV", @"IX", @"XL", @"XC", @"CD", @"CM"];
}


-(IBAction)convertRomanNumeralAction:(id)sender {
    NSString *romanNumeral= [romanNumeralField.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    bool hasOnlyValidCharacters=[self validateCharacters:romanNumeral];
    if (!hasOnlyValidCharacters) {
        [self showErrorMessage:@"The roman numberal you entered has invalid characters.  Pelase correct and try again"];
        return;
    }

    NSString *testForSetsOfFour=[self screenForImproperSetsOfFourValues:romanNumeral];
    if (![testForSetsOfFour isEqualToString:@"pass"]) {
        [self showErrorMessage:@"A roman numeral cannot have four consecutive digits except for 'M'"];
        return;
    }

   finalResult=[self base10FromRomanNumeral:romanNumeralField.text];
    if ([finalResult isEqualToString:@"error"]) {
        [self showErrorMessage:@"Your roman numeral is invalid.  You can only subtract with the following pairs: IV, IX, XL, XC, CD, CM"];
    }
    else{
        resultLabel.text=[NSString stringWithFormat:@"Result: %@", finalResult];}

 }

//Main method for converting roman numeral
-(NSString *)base10FromRomanNumeral:(NSString *)theRomanNumeral {
    NSInteger result = 0;
    NSArray *romanCharacters=[self makeRomanCharactersArray:theRomanNumeral];
    for ( int i = 0; i < [romanCharacters count]; i++) {
        //Get the character Roman Numberal String
        NSString *currentChar=[romanCharacters objectAtIndex:i];
        NSNumber *currentCharValue=[romanNumeralToBase10ConversionTable objectForKey:currentChar];
        //Handle Last Character
        if (i == ([romanCharacters count] -1)) {
            result=result+[currentCharValue integerValue];
            break;
        }
        NSString *nextChar=[romanCharacters objectAtIndex:i+1];
        NSNumber *nextCharValue=[romanNumeralToBase10ConversionTable objectForKey:nextChar];

        //Check pair for possible subtraction;
        NSInteger intValue=(NSInteger)i;
        CheckPairResult r=[self checkForCharacter:currentChar withNextCharacter:nextChar atIndex:&intValue];

        switch (r) {

            case CheckPairResultSubtract:
                result=result+([nextCharValue integerValue] - [currentCharValue integerValue]);
                i=i+1;
                break;

            case CheckPairResultDoNothing:
                result=result+[currentCharValue integerValue];
                break;

            case CheckPairResultError:
                result=-1;
                break;
        }

        if (result==-1) { return @"error"; break; }}

    NSString *resultString=[NSString stringWithFormat:@"%ld", (long)result];
    return resultString;}

//Checks for possible subtraction
-(CheckPairResult)checkForCharacter:(NSString *)currentChar withNextCharacter:(NSString *)nextChar atIndex:(NSInteger *)indexValue {

    if ([romanNumeralToBase10ConversionTable objectForKey:currentChar] >= [romanNumeralToBase10ConversionTable objectForKey:nextChar]) {
         return CheckPairResultDoNothing;
    }

    if (![self isValidSubtractionCombination:[NSString stringWithFormat:@"%@%@", currentChar, nextChar]])  {
        return CheckPairResultError;}

    else

    { return CheckPairResultSubtract;}
}


//Validation Methods

-(bool)validateCharacters:(NSString *)romanNumeralString {                              //Validates all characters in string
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"IVXLCDM"];
    s=[s invertedSet];
    NSRange r = [romanNumeralString rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) { return false;}  else { return true;}
}

-(bool)isValidSubtractionCombination:(NSString *)thePair {                              //Validates subtraction pairs
    if ([validSubtractionPairs containsObject:thePair]) { return true;} else {return false;}
}

-(NSString *)screenForImproperSetsOfFourValues:(NSString *)romanNumeral   {             //Screen for 'IIII' sets instead of subtraction
    NSString *result=@"pass";
    NSArray *chars=@[@"I", @"V", @"X", @"L", @"C", @"D"];
    for (id digit in chars) {
        NSString *testString=[NSString stringWithFormat:@"%@%@%@%@", digit, digit, digit, digit];
        if ([romanNumeral containsString:testString]) {
            result=testString;
            break;
        }}
    return result;
    }





//Factory Methods
-(NSArray *)makeRomanCharactersArray:(NSString *)romanNumeral {
    NSMutableArray *romanCharacters = [[NSMutableArray alloc] initWithCapacity:[romanNumeral length]];
    for (int i=0; i < [romanNumeral length]; i++) {
        NSString *chr  = [NSString stringWithFormat:@"%c", [romanNumeral characterAtIndex:i]];
        [romanCharacters addObject:chr];}

    NSArray *result=[romanCharacters copy];
    return result;


}


-(void)showErrorMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Roman Numeral" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }

-(IBAction)clearResult:(id)sender {
    resultLabel.text=@"";
}





- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;}


@end
