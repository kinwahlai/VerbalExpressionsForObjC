VerbalExpressionsForObjC
========================

Ported from [VerbalExpressions](https://github.com/jehna/VerbalExpressions)

VerbalExpressionsForObjC is a Objective C class  that helps to construct hard regular expressions.

## Example

### Testing if we have a valid URL
```objc
VerbalExpressions *verex = VerEx()
    .searchOneLine(YES)
    .startOfLine()
    .then( @"http" )
    .maybe( @"s" )
    .then( @"://" )
    .maybe( @"www." )
    .anythingBut( @" " )
    .endOfLine();

XCTAssertTrue([verex test:@"https://mail.google.com"], @"not a valid url");
```
### Replacing strings
```objc

NSString *result = VerEx().find(@"google").replace(@"http://www.google.com",@"yahoo");
    
XCTAssertTrue([result isEqualToString:@"http://www.yahoo.com"], @"cannot find the text to replace");
```

## Other Implementations
You can see an up to date list of all ports in our [organization](https://github.com/VerbalExpressions).
- [Javascript](https://github.com/jehna/VerbalExpressions)
- [Ruby](https://github.com/VerbalExpressions/RubyVerbalExpressions)
- [C#](https://github.com/VerbalExpressions/CSharpVerbalExpressions)
- [Python](https://github.com/VerbalExpressions/PythonVerbalExpressions)
- [Java](https://github.com/VerbalExpressions/JavaVerbalExpressions)
- [C++](https://github.com/VerbalExpressions/CppVerbalExpressions)
