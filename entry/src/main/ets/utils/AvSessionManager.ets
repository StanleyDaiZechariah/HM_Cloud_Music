import { avSession } from "@kit.AVSessionKit"
import { backgroundTaskManager } from "@kit.BackgroundTasksKit"
import { wantAgent } from "@kit.AbilityKit";


class AvSessionManager {
  // 接收session对象
  session: avSession.AVSession | null = null

  // 初始化方法
  async init(content: Context) {
    this.session = await avSession.createAVSession(content , 'bgPlay', 'audio')
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
}

export const sessionManager: AvSessionManager = new AvSessionManager()