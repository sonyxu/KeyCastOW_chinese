#Requires AutoHotkey v2.0
Persistent

; ShareX程序路径
ShareXPath:="C:\Program Files\ShareX\ShareX.exe"
; KeyCastOW.exe程序路径
KeyCastOWPath:="C:\Tools\Other_Tools\keystroke_visualizer_Tools\KeyCastOW\keycastow.exe"
; SetDpi工具
SetDPIPath:="C:\Tools\Other_Tools\SetDpi.exe"

; 监视鼠标，坐标相对于整个屏幕
CoordMode "Mouse", "Screen"

ProcessCloseAll(PIDOrName)
{
	; 结束所有进程名的运行
	While ProcessExist(PIDOrName)
		ProcessClose PIDOrName
}

GetCMDOutput(command){
	Shell := ComObject("WScript.Shell")
	exec := Shell.Exec(A_ComSpec " /C " command)
	return exec.StdOut.ReadAll()
}

^+PrintScreen:: ; 触发快捷键
{
	if not FileExist(KeyCastOWPath)
	{
		MsgBox "KeyCastOW.exe执行路径不存在！请编辑ahk文件修改KeyCastOWPath为目标exe执行路径！"
		ExitApp
	}
	if not FileExist(ShareXPath)
	{
		; 当目标程序不存在，报告错误
		MsgBox "ShareX.exe执行路径不存在！请编辑ahk文件修改ShareXPath为目标exe执行路径！"
		ExitApp
	}
	if not FileExist(SetDPIPath)
	{
		; 当目标程序不存在，报告错误
		MsgBox "SetDpi.exe执行路径不存在！请编辑ahk文件修改SetDPIPath为目标exe执行路径！"
		ExitApp
	}
	
	; 先结束键盘的程序，否则无法加载配置文件
	ProcessCloseAll "keycastow.exe"
	
	
	
	; 执行 SetDPI.exe get 命令并获取输出
	output := GetCMDOutput(SetDPIPath " get")
	
	; 获取字符串中的DPI缩放倍率
	DPI_ZOOM:=StrReplace(output,"Current Resolution: ","")
	DPI_ZOOM:=Integer(DPI_ZOOM) / 100
	
	RunWait ShareXPath " -ScreenRecorderGIF"
	
	; 等到鼠标按住再松开，获取最后松开时所在的坐标轴
	KeyWait "LButton", "D" ; 等待鼠标左键按下
	KeyWait "LButton"  ; 等待鼠标左键被释放
	MouseGetPos &mouseX, &mouseY  ; 获取鼠标当前的坐标
	mouseX:=mouseX / DPI_ZOOM
	mouseX:=Integer(mouseX)-1
	; ExitApp 
	mouseY:=mouseY / DPI_ZOOM
	mouseY:=Integer(mouseY)-1
	

	
	
	; INI文件为keycastow.exe工作路径下的ini文件
	iniFile_Path:=StrReplace(KeyCastOWPath,"keycastow.exe","keycastow.ini")
	
	if FileExist(iniFile_Path)
	{
		; 把键盘位置移到截图的矩阵中
		; 替换INI文件中的offsetX和offsetY值
		IniWrite mouseX,iniFile_Path,"KeyCastOW","offsetX"
		IniWrite mouseY,iniFile_Path,"KeyCastOW","offsetY"
	}else{
		; 若目标ini文件不存在，则创建ini文件写入配置
		FileAppend "[KeyCastOW]`n", iniFile_Path, "UTF-8"
		IniWrite mouseX, iniFile_Path, "KeyCastOW", "offsetX"
		IniWrite mouseY, iniFile_Path, "KeyCastOW", "offsetY"
		IniWrite "500", iniFile_Path, "KeyCastOW", "keyStrokeDelay"
		IniWrite "1500", iniFile_Path, "KeyCastOW", "lingerTime"
		IniWrite "500", iniFile_Path, "KeyCastOW", "fadeDuration"
		IniWrite "4934475", iniFile_Path, "KeyCastOW", "bgColor"
		IniWrite "16777215", iniFile_Path, "KeyCastOW", "textColor"
		IniWrite "DBFFFFFF00000000000000000000000084030000000000010000040041007200690061006C00200042006C00610063006B000000FEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFA", iniFile_Path, "KeyCastOW", "labelFont"
		IniWrite "200", iniFile_Path, "KeyCastOW", "bgOpacity"
		IniWrite "230", iniFile_Path, "KeyCastOW", "textOpacity"
		IniWrite "200", iniFile_Path, "KeyCastOW", "borderOpacity"
		IniWrite "16744448", iniFile_Path, "KeyCastOW", "borderColor"
		IniWrite "4", iniFile_Path, "KeyCastOW", "borderSize"
		IniWrite "16", iniFile_Path, "KeyCastOW", "cornerSize"
		IniWrite "4", iniFile_Path, "KeyCastOW", "labelSpacing"
		IniWrite "3", iniFile_Path, "KeyCastOW", "maximumLines"
		IniWrite "1", iniFile_Path, "KeyCastOW", "visibleShift"
		IniWrite "1", iniFile_Path, "KeyCastOW", "visibleModifier"
		IniWrite "1", iniFile_Path, "KeyCastOW", "mouseCapturing"
		IniWrite "0", iniFile_Path, "KeyCastOW", "mouseCapturingMod"
		IniWrite "1", iniFile_Path, "KeyCastOW", "keyAutoRepeat"
		IniWrite "1", iniFile_Path, "KeyCastOW", "mergeMouseActions"
		IniWrite "1", iniFile_Path, "KeyCastOW", "alignment"
		IniWrite "0", iniFile_Path, "KeyCastOW", "onlyCommandKeys"
		IniWrite "1", iniFile_Path, "KeyCastOW", "draggableLabel"
		IniWrite "1", iniFile_Path, "KeyCastOW", "tcModifiers"
		IniWrite "66", iniFile_Path, "KeyCastOW", "tcKey"
		IniWrite "", iniFile_Path, "KeyCastOW", "branding"
		IniWrite "<+>", iniFile_Path, "KeyCastOW", "comboChars"

	}

  


	; 执行键盘显示程序
	Run KeyCastOWPath
	; 防止意外结束键盘显示
	sleep 700
	; 当检测到截图所需的ffmpeg结束运行时关闭键盘显示
	ffmpeg_PID:=ProcessWaitClose("ffmpeg.exe")
	if not ffmpeg_PID
	{
		ProcessCloseAll "keycastow.exe"
	}
	return
}