###
	A demo for resolving some project existing bugs.

	## branch && tag
		t0.1.0. Getui 
			react-native-getui 1.1.17 在iOS上有闪退的bug,
			1.安装,测试，查找这版原因

			可能的bug
			bug 
				TestApp(8309,0x104bdab80) malloc: Heap corruption detected, free list is damaged at 0x280eb7fa0
				*** Incorrect guard value: 0
				TestApp(8309,0x104bdab80) malloc: *** set a breakpoint in malloc_error_break to debug

			xcode 设置里 product -> scheme -> edit scheme -> run -> diagnostics 
				添加 address sanitizer
			未再出现，-》 打算完善推送功能后，再打release 包试一下
				release 包发现闪退  原因?

			2.完善个推功能
				a. Login 页面 获取 clientId

			3. 问题解决
				查看个推官网 
					http://docs.getui.com/getui/mobile/ios/xcode/
				按3.7 步骤操作，打包发现不在出现闪退，疑似解决奔溃问题。