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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QRootElement.h"

@interface QLabelElement : QRootElement {

@protected
    id _value;
    UIImage *_image;
    NSString *_suffix;
}

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) NSString *imageNamed;
@property(nonatomic, strong) NSString *suffix;
@property(nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property(nonatomic, unsafe_unretained) UIView *accessoryView;
@property(nonatomic, strong) id value;


@property(nonatomic) BOOL keepSelected;

- (QLabelElement *)initWithTitle:(NSString *)title Value:(id)value;
- (QLabelElement *)initWithTitle:(NSString *)title Value:(id)value suffix:(NSString*)aSuffix;

@end
