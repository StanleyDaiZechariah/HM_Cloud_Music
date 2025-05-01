// 引入外部的资源
import { tabData, TabClass } from '../interfaces/index'

// 跳转页面入口函数
@Builder
export function LayoutBuilder() {
  Layout()
}

@Component
struct Layout {
  pathStack: NavPathStack = new NavPathStack()

  // 自定义的导航栏的结构
  @Builder tabBuilder(item: TabClass) {
    // 采用垂直布局
    Column({ space: 8 }) {
      // 导航图标
      Image(item.icon)
        .width(24)
        .aspectRatio(1)
        .margin({
          top: 2,
          bottom: 2
        })
        .fillColor('#63aaaa')

      // 导航文本
      Text(item.text)
        .fontSize(14)
        .fontColor('#63aaaa')
    }
  }

  build() {
    NavDestination() {
      // 使用tab组件设计布局
      Tabs({ barPosition: BarPosition.End }) {
        ForEach(tabData, (item: TabClass, index: number) => {
          TabContent() {
            Text(item.text)
          }
          .tabBar(this.tabBuilder(item)) // 我们将自定义导航栏的样式和结构
          .backgroundColor('#131215')
        }, (item: TabClass) => item.text)
      }
      .backgroundColor('#3b3f42')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    // .title('布局页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}