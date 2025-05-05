import { avSession } from "@kit.AVSessionKit"
import { backgroundTaskManager } from "@kit.BackgroundTasksKit"
import { wantAgent } from "@kit.AbilityKit";
import { AppStorageV2 } from "@kit.ArkUI";


import { SongItemType } from "../interfaces/index";
import { GlobalMusic } from "../models/index";
import { playerManager } from "../utils/index";


class AvSessionManager {
  // 接收session对象
  session: avSession.AVSession | null = null
  // 歌曲播放状态
  playState: GlobalMusic = AppStorageV2.connect(GlobalMusic, 'SONG_KEY', () => new GlobalMusic())!

  // 初始化方法
  async init(content: Context) {
    this.session = await avSession.createAVSession(content , 'bgPlay', 'audio')
    this.registerEvent()
  }

  // 申请长时任务的方法
  async startBackgroundTask () {
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      // 点击通知后，将要执行的动作列表
      // 添加需要被拉起应用的bundleName和abilityName
      wants: [
        {
          bundleName: "com.example.hm_cloud_music",
          abilityName: "EntryAbility"
        }
      ],
      // 指定点击通知栏消息后的动作是拉起ability
      actionType: wantAgent.OperationType.START_ABILITY,
      // 使用者自定义的一个私有值
      requestCode: 0,
      // 点击通知后，动作执行属性
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG],
    };

    const want = await wantAgent.getWantAgent(wantAgentInfo)

    await backgroundTaskManager.startBackgroundRunning(getContext(), backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, want)
  }

  // 设置元数据的方法
  setMetaData (song: SongItemType) {
    this.session?.setAVMetadata({
      assetId: song.id,
      title: song.name,
      mediaImage: song.img,
      artist: song.author,
      duration: this.playState.duration
    })
  }

  // 设置播放状态的方法
  setAVPlayBackState () {
    this.session?.setAVPlaybackState({
      state: this.playState.isPlay ? avSession.PlaybackState.PLAYBACK_STATE_PLAY : avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
      speed: 1,
      position: {
        elapsedTime: this.playState.time, // 歌曲播放的时间
        updateTime: new Date().getTime() // 系统时间
      },
      duration: this.playState.duration
    })
  }

  // 注册命令的方法
  registerEvent() {
    this.session?.on('play', () => {
      playerManager.singPlay(this.playState.playList[this.playState.playIndex])
    })

    this.session?.on('pause', () => {
      playerManager.paused()
    })

    this.session?.on('playPrevious', () => {
      playerManager.prevPlay()
    })

    this.session?.on('playNext', () => {
      playerManager.nextPlay()
    })

    this.session?.on('seek', (value: number) => {
      playerManager.seekPlay(value)
    })

    this.session?.activate()
  }

  // 注销会话
  async destroySession() {
    await this.session?.destroy()
  }
}

export const sessionManager: AvSessionManager = new AvSessionManager()