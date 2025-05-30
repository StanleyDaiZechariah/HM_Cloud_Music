import { AppStorageV2 } from '@kit.ArkUI'

import { songs, SongItemType } from '../interfaces/index'
import { GlobalMusic, SongPlayMode } from '../models/index'
import { playerManager } from '../utils/index'

// 跳转页面入口函数
@Builder
export function PlayBuilder() {
  Play()
}

@ComponentV2
@Preview
struct Play {
  @Local panelHeight: string = '0%'
  @Local panelOpacity: number = 0
  pathStack: NavPathStack = new NavPathStack();
  // 当前播放的歌曲
  @Local
  // playState: SongItemType = songs[0];
  playState: GlobalMusic = AppStorageV2.connect(GlobalMusic, 'SONG_KEY', () => new GlobalMusic())!

  // 删除按钮的自定义结构样式
  @Builder
  deleteButton(index: number) {
    Button('删除')
      .backgroundColor('#ec5c87')
      .fontColor('#fff')
      .width(80)
      .height('100%')
      .type(ButtonType.Normal)
      .onClick(() => {
        // 接收到某个歌曲的索引然后将他从列表中删除
        playerManager.removeSong(index)
        // 如果列表里面没有歌曲就回退到歌曲列表中去
        if (this.playState.playList.length === 0) {
          this.pathStack.pop()
        }
      })
  }

  // 播放计时器的逻辑
  number2time(number: number) {
    // 毫秒 → 秒 → 分+秒; 先判断是否大于1分钟
    if (number > 60 * 1000) {
      const s = Math.floor(number / 1000 % 60)
      const m = Math.floor(number / 1000 / 60)
      const second = s.toString().padStart(2, '0')
      const minute = m.toString().padStart(2, '0')
      return minute + ':' + second
    } else {
      const s = Math.floor(number / 1000 % 60)
      const second = s.toString().padStart(2, '0')
      return '00:' + second
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        // 播放
        Stack() {
          // 变色背景
          Image(this.playState.img)
            .width('100%')
            .height('100%')
            .blur(1000)
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

          // 内容
          Column() {
            // //   播放界面
            Column() {
              // 图片
              Stack({ alignContent: Alignment.Top }) {
                Row() {
                  Row() {
                    Image(this.playState.img)
                      .width('70%')
                      .borderRadius(400)
                  }
                  .backgroundImage($r('app.media.ic_cd'))
                  .backgroundImageSize(ImageSize.Cover)
                  .justifyContent(FlexAlign.Center)
                  .width('100%')
                  .borderRadius(400)
                  .clip(true)
                  .aspectRatio(1)
                }
                .margin({
                  top: 50
                })
                .width('90%')
                .aspectRatio(1)
                .justifyContent(FlexAlign.Center)
                .padding(24)

                // 唱针
                Image($r('app.media.ic_stylus'))
                  .width(200)
                  .aspectRatio(1)
                  .rotate({
                    angle: -55,
                    centerX: 100,
                    centerY: 30
                  })
                  .animation({
                    duration: 500
                  })
              }

              // 歌曲信息
              Stack() {
                // 第一个
                Column({ space: 8 }) {
                  Text(this.playState.name)
                    .fontSize(28)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#4bb0c4')
                  Text(this.playState.author)
                    .fontSize(18)
                    .fontColor('#4bb0c4')
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
                .zIndex(1)

                // 第二个
                Column({ space: 8 }) {
                  Text(this.playState.name)
                    .fontSize(28)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#ec5c87')
                  Text(this.playState.author)
                    .fontSize(18)
                    .fontColor('#ec5c87')
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
                .zIndex(2)

                // 第三个
                Column({ space: 8 }) {
                  Text(this.playState.name)
                    .fontSize(28)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color.White)
                  Text(this.playState.author)
                    .fontSize(18)
                    .fontColor(Color.White)
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
                .zIndex(3)
              }
              .layoutWeight(1)

              // 操作
              Row() {
                Badge({ value: '99+', style: { badgeSize: 12, badgeColor: '#45CCCCCC' } }) {
                  Image($r("app.media.ic_like"))
                    .fillColor(Color.White)
                    .width(24)
                }

                Badge({ value: '10W', style: { badgeSize: 12, badgeColor: '#45cccccc' } }) {
                  Image($r("app.media.ic_comment_o"))
                    .fillColor(Color.White)
                    .width(18)
                }

                Badge({ value: 'hot', style: { badgeSize: 12, badgeColor: '#a8ff3131' } }) {
                  Image($r("app.media.ic_bells_o"))
                    .fillColor(Color.White)
                    .width(24)
                }

                Badge({ value: 'vip', style: { badgeSize: 12, badgeColor: '#b7efd371' } }) {
                  Image($r("app.media.ic_download_o"))
                    .fillColor(Color.White)
                    .width(24)
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceAround)

              // 播放
              Column() {
                // 进度条
                Row({ space: 4 }) {
                  Text(this.number2time(this.playState.time))
                    .fontSize(12)
                    .fontColor(Color.White)
                  Slider({
                    value: this.playState.time,
                    min: 0,
                    max: this.playState.duration
                  })
                    .layoutWeight(1)
                    .blockColor(Color.White)
                    .selectedColor(Color.White)
                    .trackColor('#ccc5c5c5')
                    .trackThickness(2)
                    .onChange((value) => {
                      playerManager.seekPlay(value)
                    })
                  Text(this.number2time(this.playState.duration))
                    .fontSize(12)
                    .fontColor(Color.White)
                }
                .width('100%')
                .padding(24)

                // 切换
                Row() {
                  if (this.playState.playMode === SongPlayMode.AUTO) {
                    Image($r('app.media.ic_auto'))
                      .fillColor(Color.White)
                      .width(30)
                      .onClick(() => {
                        this.playState.playMode = SongPlayMode.RANDOM
                      })
                  } else if (this.playState.playMode === SongPlayMode.RANDOM) {
                    Image($r('app.media.ic_random'))
                      .fillColor(Color.White)
                      .width(30)
                      .onClick(() => {
                        this.playState.playMode = SongPlayMode.REPEAT
                      })
                  } else {
                    Image($r('app.media.ic_repeat'))
                      .fillColor(Color.White)
                      .width(30)
                      .onClick(() => {
                        this.playState.playMode = SongPlayMode.AUTO
                      })
                  }

                  Image($r("app.media.ic_prev"))
                    .fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      playerManager.prevPlay()
                    })

                  // 播放按钮
                  Image(!this.playState.isPlay ? $r('app.media.ic_play') : $r('app.media.ic_paused'))
                    .fillColor(Color.White)
                    .width(50)
                    .onClick(() => {
                      !this.playState.isPlay ? playerManager.singPlay(this.playState.playList[this.playState.playIndex]) : playerManager.paused()
                    })
                  // 下一首
                  Image($r('app.media.ic_next'))
                    .fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      playerManager.nextPlay()
                    })
                  // 播放列表
                  Image($r('app.media.ic_song_list'))
                    .fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      this.panelHeight = '50%'
                      this.panelOpacity = 1
                    })
                }
                .width('100%')
                .padding({
                  bottom: 24
                })
                .justifyContent(FlexAlign.SpaceAround)
              }
              .width('100%')
            }
            .layoutWeight(1)
            .width('100%')
          }
        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Transparent)


        // 列表
        Column() {
          Column() {

          }
          .width('100%')
          .layoutWeight(1)
          .onClick(() => {
            this.panelHeight = '0%'
            this.panelOpacity = 0
          })

          Column() {
            Row() {
              Row() {
                Image($r("app.media.ic_play"))
                  .width(20)
                  .fillColor('#ff5186')
              }
              .width(50)
              .aspectRatio(1)
              .justifyContent(FlexAlign.Center)

              Row({ space: 8 }) {
                Text(`播放列表 (${this.playState.playList.length})`)
                  .fontColor(Color.White)
                  .fontSize(14)
              }
              .layoutWeight(1)

              Image($r('app.media.ic_close'))
                .fillColor('#ffa49a9a')
                .width(24)
                .height(24)
                .margin({ right: 16 })
                .onClick(() => {
                  this.panelHeight = '0%'
                  this.panelOpacity = 0
                })
            }
            .width('100%')
            .backgroundColor('#ff353333')
            .padding(8)
            .border({
              width: { bottom: 1 },
              color: '#12ec5c87'
            })
            .borderRadius({
              topLeft: 4,
              topRight: 4
            })

            // 播放列表
            List() {
              ForEach(this.playState.playList, (item: SongItemType, index: number) => {
                ListItem() {
                  Row() {
                    Row() {
                      Text((index + 1).toString())
                        .fontColor('#ffa49a9a')
                    }
                    .width(50)
                    .aspectRatio(1)
                    .justifyContent(FlexAlign.Center)

                    // 列表
                    Row({ space: 10 }) {
                      Column() {
                        Text(item.name)
                          .fontSize(14)
                          .fontColor('#ffa49a9a')
                        Text(item.author)
                          .fontSize(12)
                          .fontColor(Color.Gray)
                      }
                      .layoutWeight(1)
                      .alignItems(HorizontalAlign.Start)
                      .justifyContent(FlexAlign.Center)
                    }
                    .layoutWeight(1)

                    Image($r('app.media.ic_more'))
                      .width(24)
                      .height(24)
                      .margin({ right: 16 })
                      .fillColor(Color.Gray)
                  }
                  .alignItems(VerticalAlign.Center)
                  .onClick(() => {
                    playerManager.singPlay(item)
                  })
                }
                .swipeAction({
                  // 在列表项最右边显示一个删除按钮
                  end: this.deleteButton(index)
                })
                .border({
                  width: { bottom: 1 },
                  color: '#12ec5c87'
                })
              })
            }
            .layoutWeight(1)
            .backgroundColor('#ff353333')

          }
          .height(400)
        }
        .height(this.panelHeight)
        // .height('100%')
        .animation({
          duration: 300
        })
        .backgroundColor('#ff353333')
        .opacity(this.panelOpacity)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])

      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Transparent)

    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .hideTitleBar(true) // 隐藏标题栏
  }
}