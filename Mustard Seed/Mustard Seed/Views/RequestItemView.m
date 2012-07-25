//
//  RequestItemView.m
//  Mustard Seed
//
//  Created by Isaac Wang on 7/23/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import "RequestItemView.h"

#import "Item.h"

@implementation RequestItemView {
    UIButton *_requestButton;
    Item *_requestItem;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Add explanation text
        UILabel *requestText = [[UILabel alloc] initWithFrame:self.frame];
        requestText.textAlignment = UITextAlignmentCenter;
        requestText.text = @"Can't find something?";
        
        // Add request button
        //UIButton *requestButton = [[UIButton alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        
        // Initialization code
        [self addSubview:requestText];
    }
    return self;
}

+ (Item *) requestItem {
    return [[Item alloc] initWithAttributes:[NSDictionary dictionaryWithObject:@"http://www.nprlibrary.org/file/images/search_600.jpg" forKey:@"img_url"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
