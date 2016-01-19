//
//  ViewController.h
//  RomanNumeralConvertor
//
//  Created by Steve Trombley on 10/27/15.
//  Copyright © 2015 Steve Trombley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *romanNumeralField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) NSDictionary *romanNumeralToBase10ConversionTable;
@property (strong, nonatomic) NSArray *validSubtractionPairs;
@property (strong, nonatomic) NSString *finalResult;

 



@end

