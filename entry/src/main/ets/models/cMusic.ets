import { SongItemType } from "../interfaces/index"

export enum SongPlayMode {
  AUTO = 'auto',
  RANDOM = 'random',
  REPEAT = 'repeat'
}

@ObservedV2
export class GlobalMusic {
  @Trace img: string = ""  // 音乐封面
  @Trace name: string = ""  // 音乐名称
  @Trace author: string = ""  // 作者
  @Trace url: string = ""  // 当前播放链接
  @Trace time: number = 0  // 播放时间
  @Trace duration: number = 0  // 音乐的播放时长


  // 歌曲列表
  @Trace playIndex: number = 0 // 当前播放歌曲的索引
  @Trace playList: SongItemType[] = [] // 播放列表

  // 播放和暂停功能
  @Trace isPlay: boolean = false // 播放的状态

  // 播放模式
  @Trace playMode: SongPlayMode = SongPlayMode.AUTO
}