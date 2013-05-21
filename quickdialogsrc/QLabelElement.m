//                                
// Copyright 2011 ESCOZ Inc  - http://escoz.com
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//


#import "QLabelElement.h"

@implementation QLabelElement {
@private
    UITableViewCellAccessoryType _accessoryType;
}


@synthesize image = _image;
@synthesize value = _value;
@synthesize accessoryType = _accessoryType;
@synthesize accessoryView = _accessoryView;
@synthesize keepSelected = _keepSelected;
@synthesize suffix = _suffix;

- (QLabelElement *)initWithTitle:(NSString *)title Value:(id)value {
    self = [super init];
    _title = title;
    _value = value;
    _keepSelected = YES;
    _image = nil;
    return self;
}

- (QLabelElement *)initWithTitle:(NSString *)title Value:(id)value suffix:(NSString*)aSuffix {
    self = [super init];
    _title = title;
    _value = value;
    _keepSelected = YES;
    _image = nil;
    _suffix = aSuffix;
    return self;
}

-(void)setImageNamed:(NSString *)name {
    self.image = [UIImage imageNamed:name];
}

- (NSString *)imageNamed {
    return nil;
}


- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    QTableViewCell *cell = (QTableViewCell *) [super getCellForTableView:tableView controller:controller];
    cell.accessoryType = _accessoryType== (int) nil ? UITableViewCellAccessoryNone : _accessoryType;
    if (_accessoryView) {
        cell.accessoryView = _accessoryView;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.text = _title;
    //
    cell.textLabel.font = medium14;
    cell.textLabel.textColor = textNormalColor;
    //
    if (_suffix.length>0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[_value description],_suffix];
    } else {
        cell.detailTextLabel.text = [_value description];
    }
    //
    cell.detailTextLabel.font = regular14;
    cell.detailTextLabel.textColor = textNormalColor;
    //
    cell.imageView.image = _image;
    cell.accessoryType = _accessoryType != UITableViewCellAccessoryNone ? _accessoryType : ( self.sections!= nil || self.controllerAction!=nil ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone);
    cell.selectionStyle = self.sections!= nil || self.controllerAction!=nil ? UITableViewCellSelectionStyleBlue: UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)path {
    [super selected:tableView controller:controller indexPath:path];
    if (!self.keepSelected)
        [tableView deselectRowAtIndexPath:path animated:YES];
}


@end
