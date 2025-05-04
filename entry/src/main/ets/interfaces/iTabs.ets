// 导航栏的数据接口类型
export interface TabClass {
  text: string
  icon: ResourceStr
}

// 导航栏数据
export const tabData: TabClass[] = [
  { text: '推荐', icon: $r('app.media.ic_recommend') },
  { text: '发现', icon: $r('app.media.ic_find') },
  { text: '动态', icon: $r('app.media.ic_moment') },
  { text: '我的', icon: $r('app.media.ic_mine') }
]
