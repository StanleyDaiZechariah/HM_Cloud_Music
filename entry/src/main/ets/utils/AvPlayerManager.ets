import { media } from '@kit.MediaKit'
import { SongItemType } from '../interfaces/index'


class AvPlayerManager {
  // 属性 + 方法
  // 播放器
  player: media.AVPlayer | null = null

  // 定义一个方法 创建播放器 + 监听播放器的状态
  async init () {
    if (!this.player) {
      // 由于这个函数的返回值是一个promise，所以需要使用async + await
      this.player = await media.createAVPlayer()
    }

    this.player.on('stateChange', (state) => {
      if (state == 'initialized') {
        // 如果对象不为空则调用这个方法
        this.player?.prepare()
      } else if (state == 'prepared') {
        this.player?.play()
      }
    })
  }

  // 定义一个方法 用来接收播放的音乐的资源
  singPlay (song: SongItemType) {
    // 如果player不为空就可以给它赋值
    this.player!.url = song.url
  }
}

export const playerManager: AvPlayerManager = new AvPlayerManager()