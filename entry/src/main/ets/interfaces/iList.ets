export interface RecommendDailyType {
  img: string // 图片
  title: string // 简介文字
  type: string // 标题文字
  top: string // 标题背景颜色
  bottom: string // 简介背景色
}

export const dailyRecommend: RecommendDailyType[] = [
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/recommend1.png',
    title: '每日推荐 | 今天从《不得不爱》听起 | 私人雷达',
    type: '每日推荐',
    top: '#660000',
    bottom: '#382e2f'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/recommend2.png',
    title: '从 [Nothing on Me] 开启无限漫游',
    type: '私人漫游',
    top: '#382e2f',
    bottom: '#a37862'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/recommend3.png',
    title: '每日推荐 | 今天从《不得不爱》听起 | 私人雷达',
    type: '华语流行',
    top: '#a37862',
    bottom: '#174847'
  },
  {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/recommend4.png',
    title: '每日推荐 | 今天从《不得不爱》听起 | 私人雷达',
    type: '私人雷达',
    top: '#174847',
    bottom: '#174847'
  }
]