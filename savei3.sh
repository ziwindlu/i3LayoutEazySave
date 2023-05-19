#!/bin/bash

function usage {
				echo "Usage: savei3.sh <workspace_num>"
				echo "Example:"
				echo "        savei3.sh 1"
}
# 参数空则退出
# If the parameter is empty, the system exits
if [[ $# -ne 1 ]] ;then
				usage
				exit 1
fi
# 参数不在1-10中则退出
# If the parameter is not in the range of 1 to 10, the script returns
if [[ $1 -lt 1 || $1 -gt 10 ]] ;then
				# echo "可接受的参数只能为1-10"
				echo "The acceptable parameters range from 1 to 10"
				usage
				exit 1
fi
if ! command -v jq > /dev/null ;then
				# echo "需要安装jq软件包"
				echo "You need the package \"jq\" "
				exit 1
fi

# 保存页面参数的根目录
# The root directory
i3ConfigRoot="$HOME""/.config/i3"
if ! test -d $i3ConfigRoot/json ;then
				mkdir -p "$i3ConfigRoot""/json"
fi
if ! test -d $i3ConfigRoot/sh ;then
				mkdir -p "$i3ConfigRoot""/sh"
fi

shell="$i3ConfigRoot"'/sh/'"$1"'.sh'
json="$i3ConfigRoot"'/json/'"$1"'.json'

# 获取workspace名
# Get workspace name
workspaceName=`i3-msg -t get_workspaces | jq '.[] | select(.num=='"$1"').name'`
# 获取所在显示器位置
# Get workspace output monitor
workspaceOutput=`i3-msg -t get_workspaces | jq '.[] | select(.num=='"$1"').output'`

# 保存布局
# Save layout
i3-save-tree --workspace "$1"  > "$json".tmp
# 按照arch官方进行去杂，保证恢复的时候可以恢复
# In accordance with arch official impurity removal, to ensure that the recovery can be restored
sed -i 's|^\(\s*\)// "|\1"|g; /^\s*\/\//d' "$json".tmp
# 将json中所有title、window_role键删除
# Delete all title and window_role keys from json
jq 'del(.. | .title? ,.window_role?)' "$json".tmp > "$json"
rm "$json".tmp

# 恢复脚本模板
# The template
template="#!/bin/bash

i3-msg \"workspace {{ workspaceName  }}; append_layout ~/.config/i3/json/{{ workspaceNum  }}.json\"
i3-msg \"move workspace to output {{ workspaceOutput  }}\"

# This is your application, you may modify them
"
# 生成恢复脚本
# Generate restore script
echo "$template" | sed "s/{{ workspaceOutput  }}/$workspaceOutput/g" | sed "s/{{ workspaceNum  }}/$1/g" | sed "s/{{ workspaceName  }}/$workspaceName/g"  > "$shell"

# 获取应用名，规则为class首字母小写，如果你有更好的方案请提出，万分感谢
# Get the application name, the rule is class first letter lowercase, if you have a better solution please suggest, thank you very much
apps=$( jq '.. | .class? //empty' "$json" | sed 's/\\//g;s/\^//g;s/\$//g;s/\"//g' | sed -r 's/(^| )(.)/\1\L\2/g')

# 将应用附加到脚本最后
# Append the command to open the application to the end of the script
for app in ${apps[@]}
do
				echo '('"$app"'>/dev/null 2>&1 &)' >> $shell
done

# echo "恢复脚本已生成到 $shell"' 中，请前往查看'
echo "The restore script has been generated into $shell"' ,check it out'
