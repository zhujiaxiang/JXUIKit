//
//  JXDropdownMenu.m
//  JXDropdownMenu
//
//  Created by 朱佳翔 on 16/8/3.
//  Copyright © 2016年 朱佳翔. All rights reserved.

#import "JXDropdownMenu.h"
#import "JXDropdownMenuItem.h"

static UIColor *gTintColor;
static UIFont *gTitleFont;

@interface JXDropdownMenu ()

@property(nonatomic, retain) UIControl *overlayView; //模态背景
@property(nonatomic, assign) CGFloat arrowPosition;
@property(nonatomic, retain) UIView *contentView;
@property(nonatomic, retain) NSArray *menuItems;

@end

@implementation JXDropdownMenu

- (id)init {
  self = [super initWithFrame:CGRectZero];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = YES;
    self.alpha = 0;

    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 1;
  }

  return self;
}

- (void)setupFrameInView:(UIView *)view fromRect:(CGRect)fromRect {
  const CGSize contentSize = _contentView.frame.size;
  const CGFloat outerWidth = view.bounds.size.width;
  const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;
  const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;
  const CGFloat widthHalf = contentSize.width * 0.5f;
  const CGFloat kMargin = 5.f;

  CGPoint point = (CGPoint){rectXM - widthHalf, rectY1};

  if ((point.x + contentSize.width + kMargin) > outerWidth)
    point.x = outerWidth - contentSize.width - kMargin;

  _arrowPosition = rectXM - point.x;
  _contentView.frame = (CGRect){0, 0, contentSize};

  self.frame = (CGRect){point, contentSize.width, contentSize.height};
}

- (void)showMenuFromRect:(CGRect)rect menuItems:(NSArray *)menuTems {
  _menuItems = menuTems;

  for (JXDropdownMenuItem *menuItem in _menuItems) //中间对齐
  {
    menuItem.alignment = NSTextAlignmentCenter;
  }

  UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];

  [self addSubview:self.contentView];
    
  [self setupFrameInView:keywindow fromRect:rect]; //设置self.frame
  self.overlayView.frame = keywindow.bounds;

  [self.overlayView addSubview:self];
  [keywindow addSubview:self.overlayView];

  _contentView.hidden = YES;
  const CGRect toFrame = self.frame;
  self.frame = (CGRect){self.arrowPoint, 1, 1};

  [UIView animateWithDuration:0.2 //属性动画
      animations:^(void) {
        self.alpha = 1.0f;
        self.frame = toFrame;
      }
      completion:^(BOOL completed) {
        _contentView.hidden = NO;
      }];
}

- (UIImage *)JX_imageWithColor:(UIColor *)color {
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

- (UIView *)contentView {
  for (UIView *v in self.subviews) {
    [v removeFromSuperview];
  }

  if (!_menuItems.count)
    return nil;

  const CGFloat kMinMenuItemHeight = 32.f;
  const CGFloat kMinMenuItemWidth = 32.f;
  const CGFloat kMarginX = 10.f;
  const CGFloat kMarginY = 3.f;

  UIFont *titleFont = [self titleFont];
  if (!titleFont)
    titleFont = [UIFont fontWithName:@"Heiti SC" size:12];
  ;

  CGFloat maxImageWidth = 0;
  CGFloat maxItemHeight = 0;
  CGFloat maxItemWidth = 0;

  for (JXDropdownMenuItem *menuItem in _menuItems) {

    const CGSize imageSize = menuItem.image.size;
    if (imageSize.width > maxImageWidth)
      maxImageWidth = imageSize.width;
  }

  if (maxImageWidth) {
    maxImageWidth += kMarginX;
  }

  for (JXDropdownMenuItem *menuItem in _menuItems) {
      
    [UIFont fontWithName:@"Heiti SC" size:12];
    const CGSize titleSize = [menuItem.title sizeWithFont:titleFont];
    const CGSize imageSize = menuItem.image.size;

    const CGFloat itemHeight =
        MAX(titleSize.height, imageSize.height) + kMarginY * 2;
    const CGFloat itemWidth = ((!menuItem.enabled && !menuItem.image)
                                   ? titleSize.width
                                   : maxImageWidth + titleSize.width) +
                              kMarginX * 4;

    if (itemHeight > maxItemHeight)
      maxItemHeight = itemHeight;

    if (itemWidth > maxItemWidth)
      maxItemWidth = itemWidth;
  }

  maxItemWidth = MAX(maxItemWidth, kMinMenuItemWidth);
  maxItemHeight = MAX(maxItemHeight, kMinMenuItemHeight);

  const CGFloat titleX = kMarginX * 2 + maxImageWidth;
  const CGFloat titleWidth = maxItemWidth - titleX - kMarginX * 2;

  UIImage *selectedImage =
      [self JX_imageWithColor:[UIColor colorWithWhite:0.8
                                                alpha:0.9]];

  UIImage *gradientLine =
      [JXDropdownMenu gradientLine:(CGSize){maxItemWidth, 1}];

  UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
  contentView.autoresizingMask = UIViewAutoresizingNone;
  contentView.backgroundColor = [UIColor clearColor];
  contentView.opaque = NO;

  CGFloat itemY = kMarginY * 2;
  NSUInteger itemNum = 0;

  for (JXDropdownMenuItem *menuItem in _menuItems) {

    const CGRect itemFrame = (CGRect){0, itemY, maxItemWidth, maxItemHeight};

    UIView *itemView = [[UIView alloc] initWithFrame:itemFrame];
    itemView.autoresizingMask = UIViewAutoresizingNone;
    itemView.backgroundColor = [UIColor clearColor];
    itemView.opaque = NO;

    [contentView addSubview:itemView];

    if (menuItem.enabled) {

      UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
      button.tag = itemNum;
      button.frame = itemView.bounds;
      button.enabled = menuItem.enabled;
      button.backgroundColor = [UIColor clearColor];
      button.opaque = NO;
      button.autoresizingMask = UIViewAutoresizingNone;

      [button addTarget:self
                    action:@selector(performAction:)
          forControlEvents:UIControlEventTouchUpInside];

      [button setBackgroundImage:selectedImage
                        forState:UIControlStateHighlighted];

      [itemView addSubview:button];
    }

    if (menuItem.title.length) {

      CGRect titleFrame;

      if (!menuItem.enabled && !menuItem.image) {

        titleFrame =
            (CGRect){kMarginX * 2, kMarginY, maxItemWidth - kMarginX * 4,
                     maxItemHeight - kMarginY * 2};

      } else {

        titleFrame = (CGRect){titleX, kMarginY, titleWidth,
                              maxItemHeight - kMarginY * 2};
      }

      UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
      titleLabel.text = menuItem.title;
      titleLabel.font = titleFont;
      titleLabel.textAlignment = menuItem.alignment;
      titleLabel.textColor =
          menuItem.foreColor ? menuItem.foreColor : [UIColor blackColor];
      titleLabel.backgroundColor = [UIColor clearColor];
      titleLabel.autoresizingMask = UIViewAutoresizingNone;
      [itemView addSubview:titleLabel];
    }

    if (menuItem.image) {

      const CGRect imageFrame = {kMarginX * 2, kMarginY, maxImageWidth,
                                 maxItemHeight - kMarginY * 2};
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
      imageView.image = menuItem.image;
      imageView.clipsToBounds = YES;
      imageView.contentMode = UIViewContentModeCenter;
      imageView.autoresizingMask = UIViewAutoresizingNone;
      [itemView addSubview:imageView];
    }

    if (itemNum < _menuItems.count - 1) {

      UIImageView *gradientView =
          [[UIImageView alloc] initWithImage:gradientLine];
      gradientView.frame = (CGRect){0, maxItemHeight + 1, gradientLine.size};
      gradientView.contentMode = UIViewContentModeLeft;
      [itemView addSubview:gradientView];

      itemY += 2;
    }

    itemY += maxItemHeight;
    ++itemNum;
  }

  contentView.frame = (CGRect){0, 0, maxItemWidth, itemY + kMarginY};

  _contentView = contentView;
  return _contentView;
}

- (void)performAction:(id)sender {
  [self dismissMenu:YES];

  UIButton *button = (UIButton *)sender;
  JXDropdownMenuItem *menuItem = _menuItems[button.tag];
  [menuItem performAction];
}

- (void)drawRect:(CGRect)rect {
  [self drawBackground:self.bounds inContext:UIGraphicsGetCurrentContext()];
}

- (void)drawBackground:(CGRect)frame inContext:(CGContextRef)context {
    
  CGFloat R0 = 1, G0 = 1, B0 = 1;
  CGFloat R1 = 1, G1 = 1, B1 = 1;

  UIColor *tintColor = [self tintColor];
  if (tintColor) {

    CGFloat a;
    [tintColor getRed:&R0 green:&G0 blue:&B0 alpha:&a];
  }

  CGFloat X0 = frame.origin.x;
  CGFloat Y0 = frame.origin.y;
  CGFloat Y1 = frame.origin.y + frame.size.height;
  // render body

  const CGFloat locations[] = {0, 1};
  const CGFloat components[] = {
      R0, G0, B0, 1, R1, G1, B1, 1,
  };

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGGradientRef gradient = CGGradientCreateWithColorComponents(
      colorSpace, components, locations,
      sizeof(locations) / sizeof(locations[0]));
  CGColorSpaceRelease(colorSpace);

  CGPoint start, end;

  start = (CGPoint){X0, Y0};
  end = (CGPoint){X0, Y1};

  CGContextDrawLinearGradient(context, gradient, start, end, 0);

  CGGradientRelease(gradient);
}

- (UIControl *)overlayView {
  if (!_overlayView) {
    _overlayView = [[UIControl alloc] init];
    _overlayView.frame = [[UIScreen mainScreen] bounds];
    _overlayView.backgroundColor = [UIColor clearColor];
    [_overlayView addTarget:self
                     action:@selector(dismissMenu:)
           forControlEvents:UIControlEventTouchUpInside];
  }
  return _overlayView;
}

- (void)dismissMenu:(BOOL)animated {
  if (self.superview) {
      
    if (animated) {
      _contentView.hidden = YES;
      const CGRect toFrame = (CGRect){self.arrowPoint, 1, 1};

      [UIView animateWithDuration:0.2
          animations:^(void) {
            self.alpha = 0;
            self.frame = toFrame;
          }
          completion:^(BOOL finished) {
            [self.overlayView removeFromSuperview];
            [self removeFromSuperview];
          }];
    } else {
      [self.overlayView removeFromSuperview];
      [self removeFromSuperview];
    }
  }
}

- (CGPoint)arrowPoint {
  CGPoint point;
  point = self.center;

  return point;
}

+ (UIImage *)gradientLine:(CGSize)size {
  const CGFloat locations[5] = {0, 0.2, 0.5, 0.8, 1};

  const CGFloat R = 0.44f, G = 0.44f, B = 0.44f;

  const CGFloat components[20] = {R, G,   B, 0.3, R, G,   B, 0.3, R, G,
                                  B, 0.3, R, G,   B, 0.3, R, G,   B, 0.3};

  return [self gradientImageWithSize:size
                           locations:locations
                          components:components
                               count:5];
}

+ (UIImage *)gradientImageWithSize:(CGSize)size
                         locations:(const CGFloat[])locations
                        components:(const CGFloat[])components
                             count:(NSUInteger)count {
  UIGraphicsBeginImageContextWithOptions(size, NO, 0);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGGradientRef colorGradient =
      CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
  CGColorSpaceRelease(colorSpace);
  CGContextDrawLinearGradient(context, colorGradient, (CGPoint){0, 0},
                              (CGPoint){size.width, 0}, 0);
  CGGradientRelease(colorGradient);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

- (UIColor *)tintColor {
  return gTintColor;
}

- (UIFont *)titleFont {
  return gTitleFont;
}

@end
