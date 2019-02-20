//
//  TEMPMacro.h
//

#ifndef TEMPMacro_h
#define TEMPMacro_h

#define TEMP_EXTERN extern __attribute__((visibility ("default")))

#define  SCREENWIDTH                       [UIScreen mainScreen].bounds.size.width
#define  SCREENHEIGHT                      [UIScreen mainScreen].bounds.size.height
#define  STATUSBARHEIGHT                   [UIApplication sharedApplication].statusBarFrame.size.height
#define  NAVIGATIONBARHEIGHT               self.navigationController.navigationBar.frame.size.height
#define  TABBARHEIGHT                      self.tabBarController.tabBar.frame.size.height
#define  STATUSBARANDNAVIGATIONBARHEIGHT   (STATUSBARHEIGHT + NAVIGATIONBARHEIGHT)


#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)


#define RECT_CHANGE_X(v,x)          CGRectMake(x, Y(v), WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_Y(v,y)          CGRectMake(X(v), y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_POINT(v,x,y)    CGRectMake(x, y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_WIDTH(v,w)      CGRectMake(X(v), Y(v), w, HEIGHT(v))
#define RECT_CHANGE_HEIGHT(v,h)     CGRectMake(X(v), Y(v), WIDTH(v), h)
#define RECT_CHANGE_SIZE(v,w,h)     CGRectMake(X(v), Y(v), w, h)


#endif /* TEMPMacro_h */
