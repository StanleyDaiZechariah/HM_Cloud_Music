// 引入外部内容
import { swiperList, dailyRecommend, recommendList} from "../interfaces/index"
import { RecommendDailyType } from '../models/RecommendDailyType'
import { RecommendListType } from '../models/RecommendListType'

// 提取公共样式属性（后期可能会被删除）
@Extend(Image)
function fancy() {
  .width(22)
  .aspectRatio(1)
  .fillColor('#817d83')
}

@Component
export struct Recommend {

  // 每日推荐区域的自定义标题结构
  @Builder
  titleBuilder (title: string) {
    // 采用水平布局
    Row() {
      // 顶层文本
      Text(title)
        .fontColor('#fff')
        .fontWeight(700)
        .layoutWeight(1)

      // 更多图标
      Image($r('app.media.ic_more'))
        .width(22)
        .fillColor('#fff')
    }
    .width('100%')
    .height(40)
  }

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


      // 每日推荐区域
      this.titleBuilder('每日推荐')
      List() {
        // 循环渲染多个数据
        ForEach(dailyRecommend, (item: RecommendDailyType) => {
          // 每一个具体的列表项
          ListItem() {
            // 采用垂直布局
            Column() {
              // 推荐项的标题
              Text(item.type)
                .width('100%')
                .height(40)
                .backgroundColor(item.top)
                .padding({
                  left: 5
                })
                .fontSize(14)
                .fontColor('#fff')

              // 推荐项的图片素材
              Image(item.img)
                .width('100%')

              // 推荐项描述文字
              Text(item.title)
                .width('100%')
                .backgroundColor(item.bottom)
                .padding(5)
                .fontSize(14)
                .fontColor('#fff')
                .maxLines(2) // 文字显示的最大行数
                .textOverflow({ overflow: TextOverflow.Ellipsis }) // 当文本超出指定长度时的显示样式
            }
            .width('40%')
            // .height(200)
            // .backgroundColor(Color.Pink)
            .borderRadius(10)
            .margin({
              right: 10
            })
            .clip(true) // 裁剪，在谁身上就裁剪谁
          }
        })
      }
      .listDirection(Axis.Horizontal) // 调整list组件的布局方向
      .height(230)
      .scrollBar(BarState.Off) // 去除滑动条


      // 每日歌单区域
      this.titleBuilder('推荐歌单')
      List() {
        // 循环渲染多个数据
        ForEach(recommendList, (item: RecommendListType) => {
          // 具体数据项
          ListItem() {
            // 采用垂直布局
            Column() {
              // 采用层叠布局
              Stack({ alignContent: Alignment.TopStart }) {
                // 数据项的图片
                Image(item.img)
                  .width('100%')
                  .height(100)
                  .borderRadius(8)

                // 文播放量
                Text(item.count)
                  .fontColor('#fff')
                  .fontSize(12)
                  .fontWeight(700)
                  .margin(5)
              }

              // 数据项内容
              Text(item.title)
                .fontColor('#fff')
                .fontSize(14)
                .width('100%')
                .padding(5)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('30%')
            // .height(200)
            // .backgroundColor(Color.Gray)
            .margin({
              right: 10
            })
          }
        })
      }
      .listDirection(Axis.Horizontal)
      .height(230)
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