import { AppStorageV2 } from '@kit.ArkUI'

import { songs, SongItemType} from '../interfaces/index'
import { playerManager } from '../utils/index'
import { GlobalMusic } from '../models/index'

@ComponentV2
export struct Find {
  // 页面跳转控制对象
  pathStack : NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  // 当前播放的歌曲
  @Local
  playState: GlobalMusic = AppStorageV2.connect(GlobalMusic, 'SONG_KEY', () => new GlobalMusic())!

  build() {
    Column() {
      Text('猜你喜欢')
        .fontColor('#fff')
        .width('100%')
        .margin({ bottom: 10 })
      List() {
        ForEach(songs, (item: SongItemType) => {
          ListItem() {
            Row() {
              // 图
              Stack() {
                Image(item.img)
                  .width(80)
                  .border({ radius: 8 })
                  .margin({ right: 10 })
                // 这个图片需要放到条件渲染中去，只有正在播放的音乐才可以使用这一张图
                if (this.playState.url === item.url && this.playState.isPlay) {
                  Image($r('app.media.wave'))
                    .width(24)
                }
              }

              // 字
              Column() {
                Text(item.name)
                  .fontColor('#F3F3F3')
                  .width('100%')
                  .fontWeight(700)
                  .margin({ bottom: 15 })
                Row() {
                  Text('VIP')
                    .fontColor('#9A8E28')
                    .border({ width: 1, color: '#9A8E28', radius: 12 })
                    .padding({
                      left: 5,
                      right: 5,
                      top: 3,
                      bottom: 3
                    })
                    .margin({ right: 10 })
                  Text(item.author)
                    .fontColor('#696969')
                }
                .width('100%')
              }
              .layoutWeight(1)

              // 更多
              Image($r('app.media.ic_more'))
                .width(24)
                .fillColor('#FEFEFE')
            }
            .width('100%')
            .height(80)
            // .backgroundColor(Color.Pink)
            .margin({ bottom: 10 })
            .onClick(() => {
              this.pathStack.pushPathByName('Play', null, false)
              playerManager.singPlay(item)
            })

          }
        })
      }
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#131313')
    .padding({ left: 10, right: 10 })
    // 扩充组件安全区域
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}