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


#import "QuickDialog.h"

@interface QMultilineTextViewController ()

@end

@implementation QMultilineTextViewController {
    BOOL _viewOnScreen;
    BOOL _keyboardVisible;
    UITextView* _textView;
}

@synthesize textView = _textView;
@synthesize resizeWhenKeyboardPresented = _resizeWhenKeyboardPresented;
@synthesize willDisappearCallback = _willDisappearCallback;
@synthesize entryElement = _entryElement;
@synthesize entryCell = _entryCell;


- (id)initWithTitle:(NSString *)title
{
    if ((self = [super init]))
    {
        self.title = (title!=nil) ? title : NSLocalizedString(@"Note", @"Note");
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
        [backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"assets/background"]]];
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 300, self.view.frame.size.height - 246)];
        _textView.layer.cornerRadius = 10;
        _textView.layer.masksToBounds = YES;
        [backView addSubview:_textView];
        _textView.delegate = self;
        //_textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _textView.font = regular14;//[UIFont systemFontOfSize:18.0f];
        _textView.backgroundColor = [UIColor clearColor];
        UIImageView *undeView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 38, 304, _textView.frame.size.height+4)];
        [undeView setImage:[[UIImage imageNamed:@"assets/search/inputSingle"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)]];
        [self.view insertSubview:undeView belowSubview:_textView];
        //
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 260, 30)];
        [label setText:self.title];
        label.font = regular12;
        label.textColor = textNormalColor;
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        //
        [backView addSubview:label];
    }
    return self;
}

- (void)loadView
{
    self.view = backView;
}

- (void)viewWillAppear:(BOOL)animated
{
    _viewOnScreen = YES;
    [_textView becomeFirstResponder];
    [super viewWillAppear:animated];
    //
    if (_maximumLength>0) {
        _counter = [[UILabel alloc] initWithFrame:CGRectMake(265, 5, 50, 30)];
        _counter.font = regular10;
        _counter.textColor = textSubtitleListColor;
        _counter.backgroundColor = [UIColor clearColor];
        _counter.text = [NSString stringWithFormat:@"%d/%d",_textView.text.length,_maximumLength];
        [backView addSubview:_counter];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    _viewOnScreen = NO;
    if (_willDisappearCallback !=nil){
        _willDisappearCallback();
    }
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) resizeForKeyboard:(NSNotification*)aNotification {
    if (!_viewOnScreen)
        return;
    
    BOOL up = aNotification.name == UIKeyboardWillShowNotification;
    
    if (_keyboardVisible == up)
        return;
    
    _keyboardVisible = up;
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve
                     animations:^{
                         CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
                         _textView.contentInset = UIEdgeInsetsMake(0.0, 0.0,  up ? keyboardFrame.size.height-200 : 0, 0.0);
                     }
                     completion:NULL];
}

- (void)setResizeWhenKeyboardPresented:(BOOL)observesKeyboard {
    if (observesKeyboard != _resizeWhenKeyboardPresented) {
        _resizeWhenKeyboardPresented = observesKeyboard;
        
        if (_resizeWhenKeyboardPresented) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeForKeyboard:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeForKeyboard:) name:UIKeyboardWillHideNotification object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if(_entryElement && _entryElement.delegate && [_entryElement.delegate respondsToSelector:@selector(QEntryDidBeginEditingElement:andCell:)]){
        [_entryElement.delegate QEntryDidBeginEditingElement:_entryElement andCell:self.entryCell];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _entryElement.textValue = textView.text;
    
    if(_entryElement && _entryElement.delegate && [_entryElement.delegate respondsToSelector:@selector(QEntryDidEndEditingElement:andCell:)]){
        [_entryElement.delegate QEntryDidEndEditingElement:_entryElement andCell:self.entryCell];
    }
    
    if (_entryElement.onValueChanged) {
        _entryElement.onValueChanged();
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if(_entryElement && _entryElement.delegate && [_entryElement.delegate respondsToSelector:@selector(QEntryShouldChangeCharactersInRangeForElement:andCell:)]){
        return [_entryElement.delegate QEntryShouldChangeCharactersInRangeForElement:_entryElement andCell:self.entryCell];
    }
    //
    if (_maximumLength>0) {
        if (_counter.text.length>_maximumLength) {
            _counter.text = [_counter.text substringToIndex:_maximumLength];
        }
        _counter.text = [NSString stringWithFormat:@"%d/%d",_textView.text.length,_maximumLength];
    }
    //
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    _entryElement.textValue = textView.text;
    if (_maximumLength>0) {
        if (_textView.text.length>_maximumLength) {
            _textView.text = [_textView.text substringToIndex:_maximumLength];
        }
        _counter.text = [NSString stringWithFormat:@"%d/%d",_textView.text.length,_maximumLength];
    }
    if(_entryElement && _entryElement.delegate && [_entryElement.delegate respondsToSelector:@selector(QEntryEditingChangedForElement:andCell:)]){
        [_entryElement.delegate QEntryEditingChangedForElement:_entryElement andCell:self.entryCell];
    }
}


@end
