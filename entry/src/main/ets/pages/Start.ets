// 跳转页面入口函数
@Builder
export function StartBuilder() {
  Start()
}

@Component
struct Start {
  // 用于控制页面操作的对象
  pathStack: NavPathStack = new NavPathStack()

  build() {
    // 页面跳转的地址
    NavDestination() {
      Button('点击跳转到布局页面')
        .onClick(() => {
          this.pathStack.pushPathByName("Layout", null, false)
        })
    }
    .title('广告页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}