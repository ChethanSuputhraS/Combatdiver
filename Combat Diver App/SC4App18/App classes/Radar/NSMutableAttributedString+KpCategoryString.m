//
//  NSMutableAttributedString+KpCategoryString.m
//  Elite Operator
//
//  Created by stuart watts on 30/10/2017.
//  Copyright © 2017 com.oneclick.elite. All rights reserved.
//

#import "NSMutableAttributedString+KpCategoryString.h"

@implementation NSMutableAttributedString (KpCategoryString)

-(void)setColorForText:(NSString*) textToFind withColor:(UIColor*) color
{
    NSRange range = [self.mutableString rangeOfString:textToFind options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}
@end
