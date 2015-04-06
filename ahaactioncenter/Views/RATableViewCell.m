
//The MIT License (MIT)
//
//Copyright (c) 2014 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RATableViewCell.h"

@interface RATableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *customTitleLabel;

@end

@implementation RATableViewCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  self.selectedBackgroundView = [UIView new];
  self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
  
}

- (void)prepareForReuse
{
  [super prepareForReuse];
}

- (void)setupWithTitle:(NSString *)title level:(NSString *)level
{
  self.customTitleLabel.text = title;
    //NSLog(@"level %i", level);
  if ([level intValue] == 0) {
    self.detailTextLabel.textColor = [UIColor blackColor];
  }
    
    CGFloat left;
  
  if ([level intValue] == 1) {
      self.backgroundColor = [UIColor whiteColor];
      left = 11 + 40 * [level intValue];
  } else if ([level intValue]  == 2) {
      self.backgroundColor = [UIColor lightGrayColor];
      left = 11 + 25 * [level intValue];
  } else if ([level intValue]  >= 3) {
      self.backgroundColor = [UIColor darkGrayColor];
      left = 11 + 20 * [level intValue];
  }
  
  
  
  CGRect titleFrame = self.customTitleLabel.frame;
  titleFrame.origin.x = left;
  self.customTitleLabel.frame = titleFrame;
}

@end
