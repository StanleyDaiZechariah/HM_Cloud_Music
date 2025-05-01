// 跳转页面入口函数
@Builder
export function StartBuilder() {
  Start()
}

@Component
struct Start {
  // 用于控制页面操作的对象
  pathStack: NavPathStack = new NavPathStack()
  // 实现一个倒计时，当广告页（Start）静止不动超过一定时间后就自动跳转到别的页面
  // 这里我们借助生命周期函数来完成
  time: number = 3000
  aboutToAppear(): void {
    setTimeout(() => {
      this.pathStack.replacePathByName("Layout", null, false)
    }, this.time)
  }

  build() {
    // 页面跳转的地址
    NavDestination() {
      // 层叠布局
      Stack({ alignContent: Alignment.TopEnd }) {
        // 广告图片
        Image($r('app.media.ad'))
          .width('100%')
          .height('100%')
          // 这个api需要搜索关键字“安全区域”
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

        // 跳过广告按钮
        Button(`跳过`)
          .backgroundColor(Color.Gray)
          .margin({
            right: 15
          })
          .onClick(() => {
            // 这里需要注意，如果是push，那么会回到广告页面
            // this.pathStack.pushPathByName("Layout", null, false)
            // 为了防止回到广告页面，我们需要使用replace
            this.pathStack.replacePathByName("Layout", null ,false)
          })

      }
    }
    // .title('广告页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}