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

#import <CoreGraphics/CoreGraphics.h>
#import "QTextElement.h"

@implementation QTextElement

@synthesize text = _text;
@synthesize font = _font;
@synthesize color = _color;
@synthesize image = _image;

- (QTextElement *)init {
   self = [super init];
    _font = regular14;// [UIFont systemFontOfSize:14];
    _color = textNormalColor;// [UIColor blackColor];
    _image = @"";
    _suffix = @"";
    return self;
}

- (QTextElement *)initWithText:(NSString *)text {
    self = [self init];
    _text = text;
    _image = @"";
    return self;
}

- (QTextElement *)initWithText:(NSString *)text andSuffix:(NSString*)aSuffix {
    self = [self init];
    _text = text;
    _image = @"";
    _suffix = aSuffix;
    return self;
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"QuickformText"]];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"QuickformText"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.numberOfLines = 0;

    cell.textLabel.adjustsFontSizeToFitWidth = NO;
    cell.textLabel.text = self.title;
    cell.textLabel.numberOfLines = 3;
    
    cell.textLabel.textColor = textNormalColor;
    cell.textLabel.font = medium14;
    
    cell.detailTextLabel.font = _font;
    cell.detailTextLabel.textColor = _color;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",_text,_suffix];
    
    if (_image!=nil) {
        if (![_image isEqualToString:@""]) {
            [cell.imageView setImage:[UIImage imageNamed:_image]];
        } else {
            [cell.imageView setImage:nil];
        }
    } else {
        [cell.imageView setImage:nil];
    }
    
    return cell;
}


- (CGFloat)getRowHeightForTableView:(QuickDialogTableView *)tableView {

    if (_text==nil || [_text isEqualToString:@""]){
        return [super getRowHeightForTableView:tableView];
    }
    CGSize constraint = CGSizeMake(tableView.frame.size.width-(tableView.root.grouped ? 40.f : 20.f), 20000);
    CGSize  size= [_text sizeWithFont:_font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	CGFloat predictedHeight = size.height + 20.0f;
    if (self.title!=nil)
        predictedHeight+=30;
	return (_height >= predictedHeight) ? _height : predictedHeight;
}

- (void)fetchValueIntoObject:(id)obj {
	if (_key==nil)
		return;
	
	[obj setValue:_text forKey:_key];
}

@end