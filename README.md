# 这是一个方便操作i3wm布局保存与恢复的脚本

## Usage

save layout

``` shell
cd i3LayoutEazySave
bash savei3.sh <workspace_num>
```

restore layout

``` shell
bash ~/.config/i3/sh/workspace_num.sh
```

## Usage Tips

你可以用下面这个简单的脚本一次性恢复多个布局

``` shell
#!/bin/bash

for var in  ~/.config/i3/sh/*
do
		bash ${var}
done
```

## 特性

- [x] 多显示器适配
- [x] 恢复脚本自动开启已打开应用(不完美)

## todo

- [ ] README国际化
