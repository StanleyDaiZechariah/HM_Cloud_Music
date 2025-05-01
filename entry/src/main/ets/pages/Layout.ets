// 跳转页面入口函数
@Builder
export function LayoutBuilder() {
  Layout()
}

@Component
struct Layout {
  pathStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
    }
    .title('布局页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}