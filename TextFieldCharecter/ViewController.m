//
//  ViewController.m
//  TextFieldCharecter
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import "ViewController.h"
#define kMaxLength 8
@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TF;
@property (weak, nonatomic) IBOutlet UITextField *characterTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.TF addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    
     [self.characterTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark - 字节限制方法
-(void)textLengthChange:(id)sender
{
    UITextField * textField=(UITextField*)sender;
    NSString * temp = textField.text;
    if (textField.markedTextRange ==nil)
    {
        while(1)
        {
            if ([temp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 24) {
                break;
            }
            else
            {
                temp = [temp substringToIndex:temp.length-1];
            }
        }
        textField.text=temp;
    }
}
#pragma mark - 字符限制方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 解决当双击切换标点时误删除正常文字 bug
    NSString *punctuateSring = @"，。？！._@/#";
    if (range.length == 0 && string.length == 1 && [punctuateSring containsString:string]) {
        return NO;
    }
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField{
    if (self.characterTF == textField) {
        UITextRange *selectedRange = textField.markedTextRange;
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            // 没有高亮选择的字
            // 1. 过滤非汉字、字母、数字字符
            self.characterTF.text = [self filterCharactor:textField.text withRegex:@"[^a-zA-Z0-9\u4e00-\u9fa5]"];
            // 2. 截取
            if (self.characterTF.text.length >= 12) {
                self.characterTF.text = [self.characterTF.text substringToIndex:12];
            }
        } else {
            // 有高亮选择的字 不做任何操作
        }
    }
}

// 过滤字符串中的非汉字、字母、数字
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *filterText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:filterText options:NSMatchingReportCompletion range:NSMakeRange(0, filterText.length) withTemplate:@""];
    return result;
}//得到字节数函数
- (int)stringConvertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p) { 
            p++; 
            strlength++; 
        } 
        else { 
            p++; 
        }
    }
    return (strlength+1);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
