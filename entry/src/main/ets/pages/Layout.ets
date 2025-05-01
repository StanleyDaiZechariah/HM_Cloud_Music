// 引入外部的资源
import { Find, Mine, Moment, Recommend } from '../components'
import { tabData, TabClass } from '../interfaces/index'

// 跳转页面入口函数
@Builder
export function LayoutBuilder() {
  Layout()
}

@ComponentV2
struct Layout {
  pathStack: NavPathStack = new NavPathStack()
  // 确认导航页当前的索引值
  @Local currentIndex: number = 0

  // 自定义的导航栏的结构
  @Builder tabBuilder(item: TabClass, index: number) {
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
        .fillColor(this.currentIndex === index ? '#e85a88' : '#63aaaa')

      // 导航文本
      Text(item.text)
        .fontSize(14)
        .fontColor(this.currentIndex === index ? '#e85a88' : '#63aaaa')
    }
  }

  build() {
    NavDestination() {
      // 使用tab组件设计布局
      Tabs({ barPosition: BarPosition.End }) {
        // 使用循环渲染的方式加载导航栏信息
        ForEach(tabData, (item: TabClass, index: number) => {
          // 导航栏内容
          TabContent() {
            // 使用条件渲染的方式来加载不同的组件内容
            if (this.currentIndex === 0) {
              Recommend()
            } else if (this.currentIndex === 1) {
              Find()
            } else if (this.currentIndex === 2) {
              Moment()
            } else {
              Mine()
            }
          }
          .tabBar(this.tabBuilder(item, index)) // 我们将自定义导航栏的样式和结构
          .backgroundColor('#131215')
        }, (item: TabClass) => item.text)
      }
      .backgroundColor('#3b3f42')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
    // .title('布局页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}