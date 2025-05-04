import { media } from '@kit.MediaKit'
import { SongItemType } from '../interfaces/index'
import { GlobalMusic } from '../models/index'
import { AppStorageV2 } from '@kit.ArkUI'


class AvPlayerManager {
  // 属性 + 方法
  // 播放器
  player: media.AVPlayer | null = null
  // 共享播放数据
  currentSong: GlobalMusic = AppStorageV2.connect(GlobalMusic, 'SONG_KEY', () => new GlobalMusic())!

  // 定义一个方法 创建播放器 + 监听播放器的状态
  async init () {
    if (!this.player) {
      // 由于这个函数的返回值是一个promise，所以需要使用async + await
      this.player = await media.createAVPlayer()
    }

    // 监听歌曲状态的变化
    this.player.on('stateChange', (state) => {
      if (state == 'initialized') {
        // 如果对象不为空则调用这个方法
        this.player?.prepare()
      } else if (state == 'prepared') {
        this.player?.play()
        this.currentSong.isPlay = true
      }
    })

    // 监听歌曲时间的变化
    this.player.on('durationUpdate', (duration) => {
      this.currentSong.duration = duration
    })

    // 监听歌曲播放时间的变换
    this.player.on('timeUpdate', (time) => {
      this.currentSong.time = time
    })
  }

  // 定义一个方法 用来接收播放的音乐的资源
  /*singPlay (song: SongItemType) {
    // 如果player不为空就可以给它赋值
    this.player!.url = song.url
    this.currentSong.img = song.img
  }*/

  singPlay(song: SongItemType) {
    // 判断某一首歌是不是在列表里面，
    // some方法 检查数组里的数据是否满足某个条件 -> 只要有一个满足some 返回 true
    const inList = this.currentSong.playList.some(item => item.id === song.id)
    if (inList) {
      // 表示你选择的这一首歌在列表里面，是否是正在播放的歌曲：对比url是否相等
      if (this.currentSong.url === song.url) {
        this.player?.play()
        this.currentSong.isPlay = true
      } else {
        // 设置新的索引，然后切歌
        this.currentSong.playIndex = this.currentSong.playList.findIndex(item => item.id === song.id)
        // 切歌
        this.changeSong()
      }
    } else {
      // 反之，添加到列表中去（头部插入），切换歌曲
      this.currentSong.playList.unshift(song)
      this.currentSong.playIndex = 0
      // 切换歌曲的小方法
      this.changeSong()
    }
  }

  // 定义跳转进度的方法 seek
  seekPlay(value: number) {
    this.player?.seek(value)
  }

  // 切换歌曲的方法
  async changeSong() {
    // 重置播放器
    await this.player?.reset()
    // 将新的歌曲信息填入对象
    this.currentSong.duration = 0
    this.currentSong.time = 0
    this.currentSong.img = this.currentSong.playList[this.currentSong.playIndex].img
    this.currentSong.name = this.currentSong.playList[this.currentSong.playIndex].name
    this.currentSong.author = this.currentSong.playList[this.currentSong.playIndex].author
    this.currentSong.url = this.currentSong.playList[this.currentSong.playIndex].url
    // 将播放器对象中的歌曲地址切换掉
    this.player!.url = this.currentSong.url
  }

  // 暂停的方法
  paused () {
    this.player?.pause()
    this.currentSong.isPlay = false
  }
}

export const playerManager: AvPlayerManager = new AvPlayerManager()