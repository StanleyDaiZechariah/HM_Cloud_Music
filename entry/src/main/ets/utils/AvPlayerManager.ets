import { media } from '@kit.MediaKit'
import { SongItemType } from '../interfaces/index'
import { GlobalMusic, SongPlayMode } from '../models/index'
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
      } else if (state == 'completed') {
        this.nextPlay(true) // 自动下一首
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

  // 切换到上一首： 根据播放模式来计算下一首或者上一首歌的索引
  // 随机 -> 计算随即索引
  // 列表 -> ++
  prevPlay() {
    if (this.currentSong.playMode === SongPlayMode.RANDOM) {
      // 随机播放：Math.random() 0~1 随即小数 左闭右开
      this.currentSong.playIndex = Math.floor(Math.random() * this.currentSong.playList.length)
    } else {
      // 列表顺序播放
      this.currentSong.playIndex--
      if (this.currentSong.playIndex < 0) {
        // 去最后一首
        this.currentSong.playIndex = this.currentSong.playList.length - 1
      }
    }
    this.singPlay(this.currentSong.playList[this.currentSong.playIndex])
  }

  // 切换到下一首： 根据播放模式来计算下一首或者上一首歌的索引
  // 重复播放 -> 播放模式为 repeat 且 播放器自动播放下一首 -> 后者是 completed 状态 -> 传入一个数据表示是自动的
  // 随机 -> 计算随即索引
  // 列表 -> ++
  nextPlay(autoNextPlay?: boolean) {
    if (this.currentSong.playMode === SongPlayMode.REPEAT && autoNextPlay === true) {
      // 真重复播放： 索引不变
      this.currentSong.playIndex = this.currentSong.playIndex
    } else if (this.currentSong.playMode === SongPlayMode.RANDOM) {
      // 随机播放：Math.random() 0~1 随即小数 左闭右开
      this.currentSong.playIndex = Math.floor(Math.random() * this.currentSong.playList.length)
    } else {
      // 列表播放
      this.currentSong.playIndex++
      if (this.currentSong.playIndex >= this.currentSong.playList.length) {
        // 去第一首
        this.currentSong.playIndex = 0
      }
    }
    // 播放音乐
    this.singPlay(this.currentSong.playList[this.currentSong.playIndex])
  }
}

export const playerManager: AvPlayerManager = new AvPlayerManager()