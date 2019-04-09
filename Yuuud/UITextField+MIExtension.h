//
//  UITextField+MIExtension.h
//  MI API Examples
//
//  Created by mac-0001 on 7/30/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

typedef void (^PickerSelectedObject)(NSManagedObject *item, NSInteger row, NSInteger component);
typedef void (^PickerSelectRow)(NSString *text, NSInteger row, NSInteger component);
typedef void (^DatePickerValueChanged)(NSDate *date);
typedef void (^CountDownPickerValueChanged)(NSTimeInterval interval);


@interface UITextField (MIExtension)


-(void)setPlaceHolderColor:(UIColor*)color;


-(void)setPickerForTimezones;
-(void)setPickerForTimezonesWithDefaultTimeZoen:(NSString *)timezone;
-(NSDictionary*)timezone;


- (void)setPickerForCurrencySymbols;
- (void)setPickerForCurrencySymbolsWithoutCodesOnPicker;

- (void)setPickerForCountryCodes;
- (void)setPickerForCountryCodesWithoutCodesOnPicker;
- (void)setSelectedCountryCode:(NSString *)code;

- (void)setPickerForCountryCodesWithoutCodesOnPicker:(PickerSelectedObject)block;
- (void)setPickerForCountryCodes:(PickerSelectedObject)block;



- (void)setValueDisabled:(BOOL)disabled;
- (void)setPickerData:(id)pickedData;
- (void)setPickerData:(id)pickedData update:(PickerSelectRow)block;
- (void)setPickerData:(Class)entityClass predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors key:(NSString *)key update:(PickerSelectedObject)block;





-(void)setDatePickerWithDateFormat:(NSString *)format;
-(void)setDatePickerWithDateFormat:(NSString *)format defaultDate:(NSDate *)date;
-(void)setDatePickerWithDateFormat:(NSString *)format defaultDate:(NSDate *)date changed:(DatePickerValueChanged)block;

-(void)setCountdownPicker:(CountDownPickerValueChanged)block;
-(void)setCountdownPicker:(NSTimeInterval)interval changed:(CountDownPickerValueChanged)block;

-(NSDate *)date;
-(NSTimeInterval)countDownDuration;
-(void)setMinimumDate:(NSDate *)date;
-(void)setMaximumDate:(NSDate *)date;
-(void)setMinuteInterval:(NSInteger)interval;
-(void)setDatePickerMode:(UIDatePickerMode)mode;
-(void)setDate:(NSDate *)date;
-(void)setCountDownDuration:(NSTimeInterval)interval;




- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;


+(UITextField *)activePickerField;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end


// To-Do Check for timezone, date format properties