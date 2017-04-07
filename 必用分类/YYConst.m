#import <UIKit/UIKit.h>

// 网易新闻域名
NSString * const kNetEaseDomain = @"http://c.m.163.com/nc/article/headline/";

// 通知
// 左边菜单视图按钮被选中的通知
NSString *const YYLeftDockMenuDidSelectNotification = @"HMLeftDockMenuDidSelectNotification";
// 通过这个key可以取出左边菜单视图中被选中按钮的索引
NSString *const YYSelectedLeftDockMenuIndexKey = @"HMSelectedLeftDockMenuIndexKey";



const int YYWindowHeight = 20;
/// 动画执行的时间
const double YYDuration = 0.5;
/// 动画停留的时间
const double YYDelay = 1.5;


// 窗口的高度
static const CGFloat HMWindowHeight = 20;
// 动画的执行时间
static const CGFloat HMDuration = 0.5;
// 窗口的停留时间
static const CGFloat HMDelay = 1.5;
// 字体大小
#define HMFont [UIFont systemFontOfSize:12]

