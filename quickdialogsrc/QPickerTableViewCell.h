//
//  QPickerTableViewCell.h
//  QuickDialog
//
//  Created by HiveHicks on 05.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QEntryTableViewCell.h"

NSString * const QPickerTableViewCellIdentifier;

@interface QPickerTableViewCell : QEntryTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *_pickerView;
    NSString *_suffix;
}

@property (nonatomic, strong) UIPickerView *pickerView;
@property (strong, nonatomic) NSString *suffix;

- (void)prepareForElement:(QEntryElement *)element inTableView:(QuickDialogTableView *)tableView pickerView:(UIPickerView **)pickerView;
- (void)prepareForElement:(QEntryElement *)element inTableView:(QuickDialogTableView *)tableView pickerView:(UIPickerView **)pickerView suffix:(NSString*)aSuffix;
- (void)setPickerViewValue:(id)value;
- (id)getPickerViewValue;

@end
