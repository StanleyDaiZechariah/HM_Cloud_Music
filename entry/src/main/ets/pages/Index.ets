import { AppStorageV2 } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Index {
  // 控制页面跳转的对象
  // pathStack : NavPathStack = new NavPathStack();
  pathStack : NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  build() {
    Navigation(this.pathStack){
    }.onAppear(() => {
      this.pathStack.pushPathByName("Start", null, false);
    })
    .hideNavBar(true) // 设置是否隐藏导航栏，直接显示路由栈栈顶的页面
  }
}