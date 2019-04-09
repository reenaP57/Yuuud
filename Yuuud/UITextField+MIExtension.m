//
//  UITextField+MIExtension.m
//  MI API Examples
//
//  Created by mac-0001 on 7/30/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UITextField+MIExtension.h"

#import "Master.h"

#import "NSManagedObject+Helper.h"

#import "NSObject+NewProperty.h"
//#import "DelegateObserver.h"


static NSString *const PICKERVIEWDIDSELECTROW = @"pickerUpdateObject";
static NSString *const PICKERVIEWDIDSELECTROWHANDLER = @"pickerUpdate";
static NSString *const INITIALINDEX = @"InitialIndex";
static NSString *const VALUEDISABLED = @"ValueDisabled";
static NSString *const DEFAULTVALUE = @"defaultValue";







@interface UIViewController ()

+(NSArray *)getAllTimeZones;
+(NSDictionary *)getTimeZoneByName:(NSString *)name;

@end

@interface UIViewController ()

+(NSArray*)getAllCountries;
+(NSDictionary*)getCurrentCountryDetails;
+(NSDictionary*)getCountryByName:(NSString*)name;
+(NSDictionary*)getCountryByPhoneCode:(NSString*)name;

@end




static UITextField *activePickerTextField = nil;

static UIPickerView *textFieldPicker = nil;
static UIDatePicker *textFieldDatePicker = nil;

static NSDateFormatter *textFieldDatePickerDateFormatter = nil;


@implementation UITextField (MIExtension)


#pragma mark - General Color

-(void)setPlaceHolderColor:(UIColor*)color
{
    if (self.placeholder)
    {
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{ NSForegroundColorAttributeName : color }];
        self.attributedPlaceholder = str;
    }
}

#pragma mark - TimeZones

-(void)setPickerForTimezones
{
    [self setPickerForTimezonesWithDefaultTimeZoen:[[NSTimeZone defaultTimeZone] name]];
}

-(void)setPickerForTimezonesWithDefaultTimeZoen:(NSString *)timezone
{
    if (![UIViewController instancesRespondToSelector:@selector(getAllTimeZones)])
        NSLog(@"Please Import TimezonePicker.framework");
        
    NSArray *arrTiemZones = [UIViewController getAllTimeZones];
    
    self.text = timezone;
    [self setPickerData:[[arrTiemZones sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"country" ascending:YES]]] valueForKeyPath:@"country"]];
}

-(NSDictionary*)timezone
{
    if (![UIViewController instancesRespondToSelector:@selector(getAllTimeZones)])
        NSLog(@"Please Import TimezonePicker.framework");

    return [UIViewController getTimeZoneByName:self.text];
}

#pragma mark - Currency Symbols
- (void)setPickerForCurrencySymbolsWithoutCodesOnPicker
{
    [self setCurrencySymbols:NO];
}

- (void)setPickerForCurrencySymbols
{
    [self setCurrencySymbols:YES];
}

-(void)setCurrencySymbols:(BOOL)codes{
    
    [self setValueDisabled:YES];
    
    NSMutableArray *arrSymbols = [[NSMutableArray alloc] init];
    if (codes) {
        for (int i = 0; i < [[NSLocale availableLocaleIdentifiers] count]; i++) {
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:[NSLocale availableLocaleIdentifiers][i]];
            NSString *currencyCode = [locale objectForKey:NSLocaleCurrencyCode];
            NSString *currencySymbol = [locale objectForKey:NSLocaleCurrencySymbol];
            
            if (![[locale objectForKey:NSLocaleCurrencySymbol] isEqualToString:@"¤"]) {
                [arrSymbols addObject:[NSString stringWithFormat:@"%@ %@",currencyCode,currencySymbol]];
            }
        }
    }
    else{
        for (int i = 0; i < [[NSLocale availableLocaleIdentifiers] count]; i++) {
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:[NSLocale availableLocaleIdentifiers][i]];
            if (![[locale objectForKey:NSLocaleCurrencySymbol] isEqualToString:@"¤"]) {
                [arrSymbols addObject:[locale objectForKey:NSLocaleCurrencySymbol]];
            }
        }
    }
    NSOrderedSet* currency = [NSOrderedSet orderedSetWithArray:arrSymbols];

    __typeof(self)blockSelf = self;
    [self setPickerData:currency.array update:^(NSString *text, NSInteger row, NSInteger component) {
        [blockSelf setText:text];
    }];
    
}

#pragma mark - CoiuntrCodes

- (void)setPickerForCountryCodesWithoutCodesOnPicker
{
    [self setCountryCodes:NO update:nil];
}

- (void)setPickerForCountryCodesWithoutCodesOnPicker:(PickerSelectedObject)block
{
    [self setCountryCodes:NO update:block];
}

- (void)setPickerForCountryCodes
{
    [self setCountryCodes:YES update:nil];
}

- (void)setPickerForCountryCodes:(PickerSelectedObject)block
{
    [self setCountryCodes:YES update:block];
}

- (void)setCountryCodes:(BOOL)codes update:(PickerSelectedObject)block
{
    if (![UIViewController instancesRespondToSelector:@selector(getAllCountries)])
        NSAssert(nil,@"Please Import CountryPicker.framework");
    
    NSArray *arrCountry = [UIViewController getAllCountries];
    [self setText:[NSString stringWithFormat:@"+%@",[[UIViewController getCurrentCountryDetails] valueForKey:@"PhoneCode"]]];
    
    
    NSInteger integer = [arrCountry indexOfObject:[UIViewController getCurrentCountryDetails]];

    if (codes)
    {
        NSMutableArray *arrRows = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[arrCountry count]; i++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[arrCountry objectAtIndex:i]];
            
            [dic setValue:[NSString stringWithFormat:@"%@ (+%@)",[[arrCountry objectAtIndex:i] valueForKey:@"Name"],[[arrCountry objectAtIndex:i] valueForKey:@"PhoneCode"]] forKey:@"string"];
            [arrRows addObject:dic];
        }
        
        [self setPickerData:@{@"key":@"string",@"data":arrRows}];

        __typeof(self)blockSelf = self;
        [self setObject:^(id item, NSInteger row, NSInteger component){

            NSString *dataString = [item valueForKey:@"string"];
            
            [blockSelf setText:[dataString substringWithRange:NSMakeRange([dataString rangeOfString:@"+"].location, dataString.length-2-[dataString rangeOfString:@"(+"].location)]];
            
            if (block)
                block(item,row,component);

        } forKey:PICKERVIEWDIDSELECTROW];
    }
    else
    {
        [self setPickerData:@{@"key":@"Name",@"data":arrCountry}];
        
        __typeof(self)blockSelf = self;
        [self setObject:^(id item, NSInteger row, NSInteger component){
            
            NSString *dataString = [item valueForKey:@"Name"];
            
            [blockSelf setText:[NSString stringWithFormat:@"+%@",[[UIViewController getCountryByName:dataString] valueForKey:@"PhoneCode"]]];

            if (block)
                block(item,row,component);
            
        } forKey:PICKERVIEWDIDSELECTROW];
    }

    [self setValueDisabled:YES];
    
    [self setObject:nil forKey:PICKERVIEWDIDSELECTROWHANDLER];
    
    [self setInteger:integer forKey:INITIALINDEX];
    
    
    if ([self isFirstResponder])
    {
        [self.textFieldPicker reloadAllComponents];
        [self setInitialSelectedRow];
    }
}

- (void)setSelectedCountryCode:(NSString *)code
{
    if (![UIViewController instancesRespondToSelector:@selector(getAllCountries)])
        NSAssert(nil,@"Please Import CountryPicker.framework");

    NSDictionary *dic = [UIViewController getCountryByPhoneCode:code];
    [self setInteger:[[UIViewController getAllCountries] indexOfObject:dic] forKey:INITIALINDEX];
    [self setText:[NSString stringWithFormat:@"+%@",code]];
}

#pragma mark - UIPickerView Functions

- (void)setValueDisabled:(BOOL)disabled
{
    [self setBoolean:disabled forKey:VALUEDISABLED];
}

- (void)setPickerData:(id)pickedData update:(PickerSelectRow)block
{
    [self setObject:nil forKey:PICKERVIEWDIDSELECTROW];
    [self setObject:block forKey:PICKERVIEWDIDSELECTROWHANDLER];
    [self setPickerData:pickedData];
}

- (void)setPickerData:(id)pickedData
{
    [self setValueDisabled:NO];

    [self addDelegate:[DelegateObserver sharedInstance]];
    
    [self setInputView:self.textFieldPicker];
    [[self valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];

    [self setObject:pickedData forKey:@"pickerData"];
    
    if ([self isFirstResponder])
    {
        [self.textFieldPicker reloadAllComponents];
        [self setInitialSelectedRow];
    }
}

- (void)setPickerData:(Class)entityClass predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors key:(NSString *)key update:(PickerSelectedObject)block
{
    [self setObject:block forKey:PICKERVIEWDIDSELECTROW];
    [self setPickerData:@{@"data":[entityClass fetch:predicate sortedBy:sortDescriptors],@"key":key}];
}

-(NSArray *)pickerArray
{
    id pickerData = [self objectForKey:@"pickerData"];
    
    if ([pickerData isKindOfClass:[NSArray class]])
        return pickerData;
    else
        return [[pickerData objectForKey:@"data"] valueForKeyPath:[pickerData objectForKey:@"key"]];
}

-(id)pickerDataObjectAtIndex:(NSInteger)index
{
    id pickerData = [self objectForKey:@"pickerData"];
    
    if ([pickerData isKindOfClass:[NSArray class]])
        return [pickerData objectAtIndex:index];
    else
        return [[pickerData objectForKey:@"data"] objectAtIndex:index];
}

#pragma mark - UIPickerView Delegate

-(UIPickerView *)textFieldPicker
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFieldPicker = [[UIPickerView alloc] init];
        
        [textFieldPicker addDataSource:[DelegateObserver sharedInstance]];
        [textFieldPicker addDelegate:[DelegateObserver sharedInstance]];

    });
    
    return textFieldPicker;
}

-(void)setInitialSelectedRow
{
    if (self.text.length>0 && [self pickerArray].count>0 && [[self pickerArray] containsObject:self.text])
    {
        int index = (int) [[self pickerArray] indexOfObject:self.text];
        [self.textFieldPicker selectRow:index inComponent:0 animated:NO];
    }
    else if(![self booleanForKey:VALUEDISABLED])
    {
        if ([self pickerArray].count>0)
        {
            self.text = [[self pickerArray] objectAtIndex:0];
            [self.textFieldPicker selectRow:0 inComponent:0 animated:NO];
            
            PickerSelectRow block = [self objectForKey:PICKERVIEWDIDSELECTROWHANDLER];
            if (block)
                block([[self pickerArray] objectAtIndex:0], 0, 0);
            
            PickerSelectedObject blockObject = [self objectForKey:PICKERVIEWDIDSELECTROW];
            if (blockObject)
                blockObject([self pickerDataObjectAtIndex:0], 0, 0);
        }
    }
    else if ([self objectForKey:INITIALINDEX] && [self integerForKey:INITIALINDEX]>0 && [self integerForKey:INITIALINDEX]<[self pickerArray].count)
    {
        [self pickerDidSelectRow:[self integerForKey:INITIALINDEX]];
        [self.textFieldPicker selectRow:[self integerForKey:INITIALINDEX] inComponent:0 animated:NO];
    }
}


#pragma mark - UIDatePicker Coundown Methods

-(void)setCountdownPicker:(CountDownPickerValueChanged)block
{
    [self setCountdownPicker:self.textFieldDatePicker.countDownDuration changed:block];
}

-(void)setCountdownPicker:(NSTimeInterval)interval changed:(CountDownPickerValueChanged)block
{
    [self setDatePickerMode:UIDatePickerModeCountDownTimer];

    [self setObject:block forKey:@"countdownPickerBlock"];
    
    [self addDelegate:[DelegateObserver sharedInstance]];

    [self setInputView:self.textFieldDatePicker];
    [[self valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];

    [self setCountDownDuration:interval];
}


#pragma mark - UIDatePicker Methods

-(void)setDatePickerWithDateFormat:(NSString *)format
{
    [self setDatePickerWithDateFormat:format defaultDate:[NSDate date]];
}

-(void)setDatePickerWithDateFormat:(NSString *)format defaultDate:(NSDate *)date
{
    [self setDatePickerWithDateFormat:format defaultDate:date changed:[self objectForKey:@"datePickerBlock"]];
}

-(void)setDatePickerWithDateFormat:(NSString *)format defaultDate:(NSDate *)date changed:(DatePickerValueChanged)block
{
    [self setDatePickerMode:UIDatePickerModeDateAndTime];

    [self setObject:format forKey:@"dateformat"];
    [self setObject:block forKey:@"datePickerBlock"];
    
    [self addDelegate:[DelegateObserver sharedInstance]];

    [self setInputView:self.textFieldDatePicker];
    [[self valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    
    [self setDate:date];
}

#pragma mark - UIDatePicker Properties

-(void)setMinuteInterval:(NSInteger)interval
{
    [self setInteger:interval forKey:@"minuteInterval"];
    
    if ([self isFirstResponder])
    {
        [textFieldDatePicker setMinuteInterval:[self integerForKey:@"minuteInterval"]];
    }
}

-(void)setMinimumDate:(NSDate *)date
{
    [self setObject:date forKey:@"minimumDate"];

    if ([self isFirstResponder])
    {
        [textFieldDatePicker setMinimumDate:[self objectForKey:@"minimumDate"]];
    }
}

-(void)setMaximumDate:(NSDate *)date
{
    [self setObject:date forKey:@"maximumDate"];

    if ([self isFirstResponder])
    {
        [textFieldDatePicker setMaximumDate:[self objectForKey:@"maximumDate"]];
    }
}

-(void)setDatePickerMode:(UIDatePickerMode)mode
{
    [self setInteger:mode forKey:@"datePickerMode"];

    if ([self isFirstResponder])
    {
        [textFieldDatePicker setDatePickerMode:[self integerForKey:@"datePickerMode"]];
    }
}

-(void)setDate:(NSDate *)date
{
    [self setObject:date forKey:DEFAULTVALUE];
    self.text = [self.textFieldDatePickerDateFormatter stringFromDate:date];
    
    DatePickerValueChanged block = [self objectForKey:@"datePickerBlock"];
    if (block)
        block(date);


    if ([self isFirstResponder])
    {
        [self.textFieldDatePicker setDate:date];
    }
}

-(void)setCountDownDuration:(NSTimeInterval)interval
{
    [self setObject:[NSNumber numberWithDouble:interval] forKey:DEFAULTVALUE];
    
    CountDownPickerValueChanged block = [self objectForKey:@"countdownPickerBlock"];
    if (block)
        block(interval);
    
    if ([self isFirstResponder])
    {
        [self.textFieldDatePicker setCountDownDuration:interval];
    }
}

-(NSDate *)date
{
    return [self objectForKey:DEFAULTVALUE];
}

-(NSTimeInterval)countDownDuration
{
    return [[self objectForKey:DEFAULTVALUE] doubleValue];
}

#pragma mark - UIDatePicker Delegate

-(NSDateFormatter *)textFieldDatePickerDateFormatter
{
    if(!textFieldDatePickerDateFormatter)
        textFieldDatePickerDateFormatter = [[NSDateFormatter alloc] init];

    [textFieldDatePickerDateFormatter setDateFormat:[self objectForKey:@"dateformat"]];

    return textFieldDatePickerDateFormatter;
}

-(UIDatePicker *)textFieldDatePicker
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFieldDatePicker = [[UIDatePicker alloc] init];
    });

    [textFieldDatePicker setTimeZone:[NSTimeZone defaultTimeZone]];
    
    return textFieldDatePicker;
}

-(void)datePickerValueChanged:(UIDatePicker *)datepicker
{
    switch (datepicker.datePickerMode)
    {
        case UIDatePickerModeTime:
        case UIDatePickerModeDate:
        case UIDatePickerModeDateAndTime:
        {
            [self setObject:datepicker.date forKey:DEFAULTVALUE];
            
            self.text = [self.textFieldDatePickerDateFormatter stringFromDate:datepicker.date];

            DatePickerValueChanged block = [self objectForKey:@"datePickerBlock"];
            if (block)
                block(datepicker.date);
        }
            break;
        case UIDatePickerModeCountDownTimer:
        {
            [self setObject:[NSNumber numberWithDouble:datepicker.countDownDuration] forKey:DEFAULTVALUE];

            CountDownPickerValueChanged block = [self objectForKey:@"countdownPickerBlock"];
            if (block)
                block(datepicker.countDownDuration);
        }
            break;
    }
}


#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL isCalledFromIQKeyboard = NO;
    
    if (NSClassFromString(@"IQKeyboardManager"))
    {
        isCalledFromIQKeyboard = [textField performSelectorFromStringWithReturnBoolean:@"isAskingCanBecomeFirstResponder"];
    }
    
    if (!isCalledFromIQKeyboard)
    {
        if ([textField.inputView isKindOfClass:[UIPickerView class]])
        {
            activePickerTextField = textField;
            
            [textField.textFieldPicker reloadAllComponents];
            [textField setInitialSelectedRow];
        }
        else if ([textField.inputView isKindOfClass:[UIDatePicker class]])
        {
            [textField.textFieldDatePicker removeTarget:nil action:NULL forControlEvents:UIControlEventValueChanged];
            [textField.textFieldDatePicker addTarget:textField action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            
            [textField.textFieldDatePicker setDatePickerMode:[textField integerForKey:@"datePickerMode"]];
            
            
            switch (textField.textFieldDatePicker.datePickerMode)
            {
                case UIDatePickerModeTime:
                case UIDatePickerModeDate:
                case UIDatePickerModeDateAndTime:
                {
                    [textField.textFieldDatePicker setMinuteInterval:[textField integerForKey:@"minuteInterval"]];
                    [textField.textFieldDatePicker setMinimumDate:[textField objectForKey:@"minimumDate"]];
                    [textField.textFieldDatePicker setMaximumDate:[textField objectForKey:@"maximumDate"]];
                    
                    if ([textField objectForKey:DEFAULTVALUE])
                        [textField.textFieldDatePicker setDate:[textField objectForKey:DEFAULTVALUE]];
                    else
                    {
                        if ([[NSDate date] compare:textField.textFieldDatePicker.maximumDate] == NSOrderedDescending)
                            [textField setDate:textField.textFieldDatePicker.maximumDate];
                        else if([[NSDate date] compare:textField.textFieldDatePicker.minimumDate] == NSOrderedAscending)
                            [textField setDate:textField.textFieldDatePicker.minimumDate];
                        else
                            [textField setDate:[NSDate date]];
                        
                        [textField.textFieldDatePicker setDate:[textField objectForKey:DEFAULTVALUE]];
                    }
                }
                    break;
                case UIDatePickerModeCountDownTimer:
                {
                    [textField.textFieldDatePicker setCountDownDuration:[[textField objectForKey:DEFAULTVALUE] doubleValue]];
                }
                    break;
            }
        }
    }
    
    return YES;
}

+(UITextField *)activePickerField
{
    return activePickerTextField;
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[activePickerTextField pickerArray] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[activePickerTextField pickerArray] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [activePickerTextField pickerDidSelectRow:row];
}

- (void)pickerDidSelectRow:(NSInteger)row
{
    if ([[self pickerArray] count] <=row)
        return;
    
    if (![self booleanForKey:VALUEDISABLED])
        self.text = [[self pickerArray] objectAtIndex:row];
    
    [self setInteger:row forKey:INITIALINDEX];
    
    PickerSelectRow block = [self objectForKey:PICKERVIEWDIDSELECTROWHANDLER];
    if (block)
        block([[self pickerArray] objectAtIndex:row], row, 0);
    
    PickerSelectedObject blockObject = [self objectForKey:PICKERVIEWDIDSELECTROW];
    if (blockObject)
        blockObject([self pickerDataObjectAtIndex:row], row, 0);
}


@end
