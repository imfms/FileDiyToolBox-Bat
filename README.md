`V0.5` `20161213`
# FileDiyToolBox | 文档收集便捷工具箱

> 该工具初期是用于解决学习Android开发期间各种API各种工具一堆一堆的堆彻而导致的找一个工具需要各种翻目录各种费时间的问题，事实证明该工具经过几个版本的迭代更新完美的解决了工具、文档多的烦恼，作者目前日常已经离不开该工具

## 功能概述

工具收集工具箱，用于整理自己的各种常用工具、文档、目录、文件，非常方便的自定义工具箱

可以给自己的工具整理一个一级列表，进而达到集中处理的效果，因为工具是使用批处理编写，故使用纯键盘操作(抛弃鼠标)

工具层级关系如下，提供对工具的`增删改查`功能

- 列表1
	- 工具1
	- 工具2
- 列表N
	- 工具N
	- 工具N+1

列表属性

- `名称`
- `备注`

工具属性

- `名称`
- `路径`
- `起始目录`
- `运行参数`
- `备注`

## 使用帮助

每个作业页面都会有帮助提示(一个问号?), 输入?则会给出该页面的帮助提示

	#文档收集便捷工具箱
	#主列表
	#序列   名称    备注
	 1.     testlist        test
	#请选择子列表(?):?
	#列表帮助
			输入列表序列号或名称可直接进入列表
			+ 添加列表,可在+后直接跟欲添加列表的名称即可
			- 删除列表,可在-后直接跟欲删除列表序列号或名称
			# 修改列表,可在#后直接跟欲修改列表序列号或名称

### 引导

工具首次会提醒用户创建列表、工具等，按照提示走即可

- 列表引导

		#文档收集便捷工具箱
		#主列表
		#当前子列表为空,请试着添加一个列表
		#添加列表
		|       列表名称:testlist
		|       备注(可选):test

- 工具引导

		#文档收集便捷工具箱
		#子列表 : testlist
		#当前列表工具为空,请试着添加一项工具
		#添加工具到: testlist
		|       工具名称:test
		|       工具路径:c:\windows\notepad.exe
		|       起始目录(可选):
		|       运行参数(可选):
		|       备注(可选):testtool

### 列表页帮助

	#文档收集便捷工具箱
	#主列表
	#序列   名称    备注
	 1.     testlist        test
	#请选择子列表(?):

- 进入指定列表
	- `列表名称/序列` 输入该列表的序列或名称
- 添加列表
	- `+` 输入`+`根据提示下一步
	- `+列表名称` 输入`+列表名称`根据提示下一步
- 删除列表
	- `-` 输入`-`根据提示下一步
	- `-列表名称/序列` 输入`-列表名称/序列`根据提示下一步
- 修改列表
	- `#` 输入`#`根据提示下一步
	- `#列表名称/序列` 输入`#列表名称/序列` 根据提示下一步

### 工具页帮助

	#文档收集便捷工具箱
	#子列表 : testlist
	#序列   名称    备注
	 1.     test    testtool
	#请选择工具(?):


- 打开指定工具
	- `工具名称/序列` 输入该工具的序列或名称
- 添加工具
	- `+` 输入`+`根据提示下一步
	- `+工具名称` 输入`+工具名称`根据提示下一步
- 删除工具
	- `-` 输入`-`根据提示下一步
	- `-工具名称/序列` 输入`-工具名称/序列`根据提示下一步
- 修改工具
	- `#` 输入`#`根据提示下一步
	- `#工具名称/序列` 输入`#工具名称/序列` 根据提示下一步
- 返回到列表页
	- `0` 输入单独数字`0`即可

#### 工具技巧

- 打开指定工具所在的目录
	- `工具名称/序列空格`
	

### 修改页帮助

	#文档收集便捷工具箱
	#列表属性修改
	 1. 名称: testlist
	 2. 备注: test
	#请选择属性(?):

	#文档收集便捷工具箱
	#工具属性修改
	 1. 名称: test
	 2. 路径: c:\windows\notepad.exe
	 3. 参数:
	 4. 起始目录:
	 5. 备注: testtool
	#请选择属性(?):

- 修改指定属性
	1. `属性序列` 输入属性序列，回车
	2. `更新值` 输入更新值
		- `不输入`回车为不修改
		- `空格`回车为默认
- 返回上一层
	- `0`输入单独数字`0`即可

## 命令行参数帮助

	本工具路径 [列表序列/名称 [工具序列/名称 [/path 起始目录] [/args 参数1 参数2 参数3 ...]]]

### 实例
- 打开主页面

		本工具

- 打开`testlist`列表

		本工具 testlist

- 打开`testlist`列表下的`testtool`工具

		本工具 testlist testtool

- 以`C:\Windows`作为工具起始目录的情况下 打开`testlist`列表下的`testtool`工具
		
		本工具 testlist testtool /path C:\Windows

- 以`C:\Windows`作为工具起始目录并为其添加参数`start` `mysql`的情况下打开`testlist`列表下的`testtool`工具

		本工具 testlist testtool /path C:\Windows /args start mysql

## 使用技巧

1. 创建一个本工具的快捷方式并给其设置一个简单的名称，例如`T`, 并将其放置到Windows`PATH`环境目录下，这样就可以直接使用`Windows` + `R`快捷键打开运行对话框，直接输入T ...即可直接随时Win+R使用本工具

2. 对于一些高频使用列表使用一个全局快捷键设置程序对该列表进行直接打开，达到一种按快捷键然后直接输入名称则打开该工具的快捷
	- 推荐全局快捷键程序[HotkeyP](https://sourceforge.net/projects/hotkeyp/)

3. 通过命令行参数的系列配置对高级文本编辑器`运行命令`配置为一个运行快捷键命令运行所有格式源文本，例如作者的Notepad++的运行则配置了这样两个运行方式
	
	作者经常使用的为Notepad++, 以下变量根据使用的高级记事本不同而不同
	- `$(EXT_PART)` 扩展名
	- `$(FULL_CURRENT_PATH)` 当前编辑文件全路径
	
	1. 直接按照默认执行

			本工具路径 $(EXT_PART) $(EXT_PART) /args $(FULL_CURRENT_PATH)

	2. 进入该格式工具选择列表执行
			
			本工具路径 $(EXT_PART) /args $(FULL_CURRENT_PATH)

			#文档收集便捷工具箱
			#子列表 : .html
			#序列   名称    备注
			 1.     tw      世界之窗
			 2.     lb      猎豹浏览器
			 3.     ie      IE浏览器
			 4.     .html   html默认
			 5.     .htm    htm默认
			#请选择工具(?):

## TODO
1. 工具执行方式添加以管理员方式执行
2. 减少一些名称保留符限制
	- 含有`？`的名称更改为
	- `数字`开头的名称限制更改为全数字限制
3. 添加名称保留符限制
	- 名称中不能含有空格
3. 添加一些输入工具名称后追加`特殊符号`达到一些使用快捷效果的功能
4. 添加在当前工具参数基础上通过空格后添加内容的方式追加到工具打开时的参数功能
5. 修复BUG
	- 新建工具时的名称结尾可以包含`空格`

## 相关链接

- [TextDatabase-Bat](https://github.com/imfms/TextDatabase-Bat) 底层文本数据库存储引擎
- [HotkeyP](https://sourceforge.net/projects/hotkeyp/) 全局快捷键设置工具