#import "QPickerElement.h"
#import "QPickerTableViewCell.h"
#import "QPickerTabDelimitedStringParser.h"

@implementation QPickerElement
{
@private
    NSArray *_items;
    
    UIPickerView *_pickerView;
}

@synthesize items = _items;
@synthesize valueParser = _valueParser;

- (QPickerElement *)init
{
    if (self = [super init]) {
        self.valueParser = [QPickerTabDelimitedStringParser new];
        self.suffix = @"";
    }
    return self;
}

- (QPickerElement *)initWithTitle:(NSString *)title items:(NSArray *)items value:(id)value
{
    if ((self = [super initWithTitle:title Value:value])) {
        _items = items;
        self.valueParser = [QPickerTabDelimitedStringParser new];
        _suffix = @"";
    }
    return self;
}

- (QPickerElement *)initWithTitle:(NSString *)title items:(NSArray *)items value:(id)value suffix:(NSString*)aSuffix {
    if ((self = [super initWithTitle:title Value:value suffix:aSuffix])) {
        _items = items;
        _suffix = aSuffix;
        self.valueParser = [QPickerTabDelimitedStringParser new];
    }
    return self;
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller
{
    QPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QPickerTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[QPickerTableViewCell alloc] init];
    }
    
//    QPickerTableViewCell *cell = [[QPickerTableViewCell alloc] init];

    UIPickerView *pickerView = nil;
    [cell prepareForElement:self inTableView:tableView pickerView:&pickerView suffix:_suffix];
    _pickerView = pickerView;
    
    cell.textLabel.textColor = textNormalColor;
    cell.textLabel.font = regular14;
    
    cell.detailTextLabel.textColor = textNormalColor;
    cell.detailTextLabel.font = regular14;
    
    cell.textField.textColor = textNormalColor;
    cell.textField.font = regular14;
    
    cell.imageView.image = self.image;

    return cell;
}

- (void)fetchValueIntoObject:(id)obj
{
	if (_key != nil) {
        [obj setValue:_value forKey:_key];
    }
}

- (NSArray *)selectedIndexes
{
    NSMutableArray *selectedIndexes = [NSMutableArray arrayWithCapacity:_pickerView.numberOfComponents];
    for (int component = 0; component < _pickerView.numberOfComponents; component++) {
        [selectedIndexes addObject:[NSNumber numberWithInteger:[_pickerView selectedRowInComponent:component]]];
    }
    return selectedIndexes;
}

@end