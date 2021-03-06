//
//  ViewController.m
//  RegularExpression_Learn
//
//  Created by 綦 on 16/7/6.
//  Copyright © 2016年 PowesunHolding. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - 控制器周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self predicateLearn];
    [self regularExpressionLearn];
}

#pragma mark - 自定义方法
/**
 *  谓词的使用
 */
- (void)predicateLearn
{
    NSArray *arr = @[@1, @2, @3, @4, @4, @5, @5, @6, @7];
    NSArray *arr1 = @[@4, @5, @8];
    
    //筛选出arr2在arr1中的元素
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF in %@",arr];
    NSArray *temp = [arr1 filteredArrayUsingPredicate:predicate];
    NSLog(@"\ntemp:\n%@", temp);
    
    //比较运算>,<,==,>=,<=,!=
    predicate = [NSPredicate predicateWithFormat:@"SELF > 4"];
    temp = [arr filteredArrayUsingPredicate:predicate];
    NSLog(@"\ntemp:\n%@", temp);
    [temp enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"\ntemp:%@",obj);
    }];
    
    //范围运算符：IN、BETWEEN
    predicate = [NSPredicate predicateWithFormat:@"SELF in {4}"];
    temp = [arr filteredArrayUsingPredicate:predicate];
    NSLog(@"\ntemp:\n%@", temp);
    predicate = [NSPredicate predicateWithFormat:@"SELF between {3, 4.1}"];
    temp = [arr filteredArrayUsingPredicate:predicate];
    NSLog(@"\ntemp:\n%@", temp);
    
    //字符串查找
    arr = @[@"Beijing", @"Shanghai", @"Guangzhou", @"Foshan", @"Xianggan", @"Aomen"];
    predicate = [NSPredicate predicateWithFormat:@"SELF == 'Foshan'"];
    temp = [arr filteredArrayUsingPredicate:predicate];
    [temp enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"\n%@",obj);
    }];
    
    //字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
    //@"name CONTAINS[cd] 'ang'"  //包含某个字符串
    //@"name BEGINSWITH[c] 'sh'"    //以某个字符串开头
    //@"name ENDSWITH[d] 'ang'"      //以某个字符串结束
    //注:[c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。
    arr = @[@"速度加快第三方",@"是否收到回复撒酒疯"];
    predicate = [NSPredicate predicateWithFormat:@"SELF contains '加'"];
    temp = [arr filteredArrayUsingPredicate:predicate];
    [temp enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"\n%@",obj);
    }];
    
    //通配符：LIKE
    predicate = [NSPredicate predicateWithFormat:@"SELF like '*加*'"];
    temp = [arr filteredArrayUsingPredicate:predicate];
    [temp enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"\n%@",obj);
    }];
}
- (void)regularExpressionLearn
{
    {
        /*
        语法：
        
        　　首先，特殊符号’^'和’$'。他们的作用是分别指出一个字符串的开始和结束。eg：
        
        　　“^one”：表示所有以”one”开始的字符串（”one cat”，”one123″，·····）；
        
        　　类似于:- (BOOL)hasPrefix:(NSString *)aString;
        
        　　“a dog$”：表示所以以”a dog”结尾的字符串（”it is a dog”，·····）；
        
        　　类似于:- (BOOL)hasSuffix:(NSString *)aString;
        
        　　“^apple$”：表示开始和结尾都是”apple”的字符串，这个是唯一的~；
        
        　　“banana”：表示任何包含”banana”的字符串。
        
        　　类似于 iOS8的新方法- (BOOL)containsString:(NSString *)aString,搜索子串用的。
        
        　　‘*’，’+'和’?'这三个符号，表示一个或N个字符重复出现的次数。它们分别表示“没有或更多”（[0,+∞]取整），“一次或更多”（[1,+∞]取整），“没有或一次”（[0,1]取整）。下面是几个例子：
        
        　　“ab*”：表示一个字符串有一个a后面跟着零个或若干个b（”a”, “ab”, “abbb”,……）；
        
        　　“ab+”：表示一个字符串有一个a后面跟着至少一个b或者更多（ ”ab”, “abbb”,……）；
        
        　　“ab?”：表示一个字符串有一个a后面跟着零个或者一个b（ ”a”, “ab”）；
        
        　　“a?b+$”：表示在字符串的末尾有零个或一个a跟着一个或几个b（ ”b”, “ab”,”bb”,”abb”,……）。
        
        　　可以用大括号括起来（{}），表示一个重复的具体范围。例如
        
        　　“ab{4}”：表示一个字符串有一个a跟着4个b（”abbbb”）；
        
        　　“ab{1,}”：表示一个字符串有一个a跟着至少1个b（”ab”,”abb”,”abbb”,……)；
        
        　　“ab{3,4}”：表示一个字符串有一个a跟着3到4个b（”abbb”,”abbbb”)。
        
        　　那么，“*”可以用{0，}表示，“+”可以用{1，}表示，“?”可以用{0，1}表示
        
        　　注意：可以没有下限，但是不能没有上限！例如“ab{,5}”是错误的写法
        
        　　“ | ”表示“或”操作：
        
        　　“a|b”：表示一个字符串里有”a”或者”b”；
        
        　　“(a|bcd)ef”：表示”aef”或”bcdef”；
        
        　　“(a|b)*c”：表示一串”a”"b”混合的字符串后面跟一个”c”；
        
        　　方括号”[ ]“表示在括号内的众多字符中，选择1-N个括号内的符合语法的字符作为结果，例如
        
        　　“[ab]“：表示一个字符串有一个”a”或”b”（相当于”a|b”）；
        
        　　“[a-d]“：表示一个字符串包含小写的’a'到’d'中的一个（相当于”a|b|c|d”或者”[abcd]“）；
        
        　　“^[a-zA-Z]“：表示一个以字母开头的字符串；
        
        　　“[0-9]a”：表示a前有一位的数字；
        
        　　“[a-zA-Z0-9]$”：表示一个字符串以一个字母或数字结束。
        
        　　“.”匹配除“\r\n”之外的任何单个字符：
        
        　　“a.[a-z]“：表示一个字符串有一个”a”后面跟着一个任意字符和一个小写字母；
        
        　　“^.{5}$”：表示任意1个长度为5的字符串；
        
        　　“\num” 其中num是一个正整数。表示”\num”之前的字符出现相同的个数，例如
        
        　　“(.)\1″：表示两个连续的相同字符。
        
        　　“10\{1,2\}” : 表示数字1后面跟着1或者2个0 (“10″,”100″)。
        
        　　” 0\{3,\} ” 表示数字为至少3个连续的0 （“000”，“0000”，······）。
        
        　　在方括号里用’^'表示不希望出现的字符，’^'应在方括号里的第一位。
        
        　　“@[^a-zA-Z]4@”表示两个”@”中不应该出现字母）。
        
        　　常用的还有：
        
        　　“ \d ”匹配一个数字字符。等价于[0-9]。
        
        　　“ \D”匹配一个非数字字符。等价于[^0-9]。
        
        　　“ \w ”匹配包括下划线的任何单词字符。等价于“[A-Za-z0-9_]”。
        
        　　“ \W ”匹配任何非单词字符。等价于“[^A-Za-z0-9_]”。
        
        　　iOS中书写正则表达式，碰到转义字符，多加一个“\”,例如：
        
        　　全数字字符：@”^\\d\+$”
         */
    }
    
    //1.正则表达式与NSPredicate连用
    NSString *testStr = @"1";
    if ([self isNumberString:testStr]) {
        NSLog(@"\n%@:是数字！", testStr);
    }
    else
    {
        NSLog(@"\n%@:不是数字！", testStr);
    }
    
    //2.NSString方法
    testStr = @"shdfsd";
    if ([self isLetterString:testStr]) {
        NSLog(@"\n%@:是字母！", testStr);
    }
    else
    {
        NSLog(@"\n%@:不是字母！", testStr);
    }
    
    //3.正则表达式类（NSRegularExpression）
    testStr = @"sdeiow82938";
    if ([self isNumberAndLetterString:testStr]) {
        NSLog(@"\n%@:是数字或字母！", testStr);
    }
    else
    {
        NSLog(@"\n%@:不是数字或字母！", testStr);
    }
    
    {
        /*
         常用的正则表达式
        
        　　1.验证用户名和密码：”^[a-zA-Z]\w{5,15}$”
                以字母开头接5至15个包括字符串在内的任意单词字符
        　　2.验证电话号码：（”^(\\d{3,4}-)\\d{7,8}$”）
         
        　　eg：021-68686868  0511-6868686；
        
        　　3.验证手机号码：”^1[3|4|5|7|8][0-9]\\d{8}$”；
        
        　　4.验证身份证号（15位或18位数字）：”\\d{14}[[0-9],0-9xX]”；
        
        　　5.验证Email地址：(“^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\.\\w+([-.]\\w+)*$”)；
        
        　　6.只能输入由数字和26个英文字母组成的字符串：(“^[A-Za-z0-9]+$”) ;
        
        　　7.整数或者小数：^[0-9]+([.]{0,1}[0-9]+){0,1}$
        
        　　8.只能输入数字：”^[0-9]*$”。
        
        　　9.只能输入n位的数字：”^\\d{n}$”。
        
        　　10.只能输入至少n位的数字：”^\\d{n,}$”。
        
        　　11.只能输入m~n位的数字：”^\\d{m,n}$”。
        
        　　12.只能输入零和非零开头的数字：”^(0|[1-9][0-9]*)$”。
        
        　　13.只能输入有两位小数的正实数：”^[0-9]+(.[0-9]{2})?$”。
        
        　　14.只能输入有1~3位小数的正实数：”^[0-9]+(\.[0-9]{1,3})?$”。
        
        　　15.只能输入非零的正整数：”^\+?[1-9][0-9]*$”。
        
        　　16.只能输入非零的负整数：”^\-[1-9][]0-9″*$。
        
        　　17.只能输入长度为3的字符：”^.{3}$”。
        
        　　18.只能输入由26个英文字母组成的字符串：”^[A-Za-z]+$”。
        
        　　19.只能输入由26个大写英文字母组成的字符串：”^[A-Z]+$”。
        
        　　20.只能输入由26个小写英文字母组成的字符串：”^[a-z]+$”。
        
        　　21.验证是否含有^%&’,;=?$\”等字符：”[^%&',;=?$\x22]+”。
                                    
        　　22.只能输入汉字：”^[\u4e00-\u9fa5]{0,}$”。
        
        　　23.验证URL：”^http://([\\w-]+\.)+[\\w-]+(/[\\w-./?%&=]*)?$”。
        
        　　24.验证一年的12个月：”^(0?[1-9]|1[0-2])$”正确格式为：”01″～”09″和”10″～”12″。
        
        　　25.验证一个月的31天：”^((0?[1-9])|((1|2)[0-9])|30|31)$”正确格式为；”01″～”09″、”10″～”29″和“30”~“31”。
        
        　　26.获取日期正则表达式：\\d{4}[年|\-|\.]\\d{\1-\12}[月|\-|\.]\\d{\1-\31}日?
        
        　　评注：可用来匹配大多数年月日信息。
        
        　　27.匹配双字节字符(包括汉字在内)：[^\x00-\xff]
        
        　　评注：可以用来计算字符串的长度（一个双字节字符长度计2，ASCII字符计1）
        
        　　28.匹配空白行的正则表达式：\n\s*\r
        
        　　评注：可以用来删除空白行
        
        　　29.匹配HTML标记的正则表达式：<(\S*?)[^>]*>.*?</>|<.*? />
        
        　　评注：网上流传的版本太糟糕，上面这个也仅仅能匹配部分，对于复杂的嵌套标记依旧无能为力
        
        　　30.匹配首尾空白字符的正则表达式：^\s*|\s*$
        
        　　评注：可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，非常有用的表达式
        
        　　31.匹配网址URL的正则表达式：[a-zA-z]+://[^\s]*
        
        　　评注：网上流传的版本功能很有限，上面这个基本可以满足需求
        
        　　32.匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$
        
        　　评注：表单验证时很实用
        
        　　33.匹配腾讯QQ号：[1-9][0-9]\{4,\}
        
        　　评注：腾讯QQ号从10 000 开始
        
        　　34.匹配中国邮政编码：[1-9]\\d{5}(?!\d)
        
        　　评注：中国邮政编码为6位数字
        
        　　35.匹配ip地址：((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)
         */
    }
}
/**
 *  判断是否为数字
 *
 *  @param str 需判断的字符串
 */
- (BOOL)isNumberString:(NSString *)str
{
    //表示以数字开头，间接至少一个同样的字符，并以此字符结尾
    NSString *regularStr = @"^[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", regularStr];
    return [predicate evaluateWithObject:str];
}
/**
 *  判断是否为字母
 *
 *  @param str 需判断的字符串
 */
- (BOOL)isLetterString:(NSString *)str
{
    //表示以字母开头，间接至少一个同样的字符，并以此字符结尾
    NSRange rage = [str rangeOfString:@"^[a-zA-Z]+$" options:NSRegularExpressionSearch];
    if (rage.location == NSNotFound) {
        return NO;
    }
    else
    {
        return YES;
    }
}
/**
 *  判断是否为数字或字母
 *
 *  @param str 需判断的字符串
 */
- (BOOL)isNumberAndLetterString:(NSString *)str
{
    NSError *error = NULL;
    //表示以数字或字母开头，间接至少一个同样的字符，并以此字符结尾
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"^[0-9a-zA-Z]+$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regularExpression firstMatchInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    if (result) {
        if (result.range.length == str.length) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

@end
