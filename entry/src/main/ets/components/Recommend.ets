// 引入外部内容
import { swiperList } from "../interfaces/index"

// 提取公共样式属性（后期可能会被删除）
@Extend(Image)
function fancy() {
  .width(22)
  .aspectRatio(1)
  .fillColor('#817d83')
}

@Component
export struct Recommend {
  build() {
    // 采用垂直布局
    Column({ space: 10 }) {
      //搜索区域，采用水平布局
      Row() {
        // 搜索图标
        Image($r('app.media.ic_search'))
          .fancy()

        // 搜索输入框
        TextInput({ placeholder: '鸡哥我爱你' })
          .placeholderColor('#817d83')
          .padding({
            left: 5,
            right: 5
          })
          .fontColor('#fff')
          .layoutWeight(1)

        // 二维码扫描功能
        Image($r('app.media.ic_code'))
          .fancy()
      }
      .width('100%')
      .backgroundColor('#2d2b29')
      .border({
        radius: 20
      })
      .padding({
        left: 8,
        right: 8
      })

      // 轮播图区域
      Swiper() {
        ForEach(swiperList, (item: string) => {
          Image(item)
            .width('100%')
            .border({
              radius: 10
            })
        })
      }
      .autoPlay(true)
    }
    .width('100%')
    .height('100%')
    .padding({
      left: 10,
      right: 10,
      top: 5,
      bottom: 5
    })
  }
}