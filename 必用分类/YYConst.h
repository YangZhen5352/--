#import <UIKit/UIKit.h>


/** 网易新闻域名 */
UIKIT_EXTERN NSString * const kNetEaseDomain;


// 通知
// 左边菜单视图按钮被选中的通知
UIKIT_EXTERN NSString *const YYLeftDockMenuDidSelectNotification;
// 通过这个key可以取出左边菜单视图中被选中按钮的索引
UIKIT_EXTERN NSString *const YYSelectedLeftDockMenuIndexKey;


/// 字体大小
#define YYFont [UIFont systemFontOfSize:12]

UIKIT_EXTERN const int YYWindowHeight;
/// 动画执行的时间
UIKIT_EXTERN const double YYDuration;
/// 动画停留的时间
UIKIT_EXTERN const double YYDelay;