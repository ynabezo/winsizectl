#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
CoordMode, Mouse, Screen
;;;;;init
;selfpid := DllCall("GetCurrentProcessId")
inifname=.\set.ini
Process, exist
selfpid := ErrorLevel
WinGet, selfprocess, ProcessName, ahk_pid %selfpid%
gapwide:=350
gwwide:=650
getscreensize(gscrx, gscry,  gscrw, gscrh)

;;gw:=300
  ;
grightmergin:=0
gbottmmergin:=0
gleft:=0
gtop:=0
gdspmode:=1
gmyid:=0

gosub, getinifile

Gosub, guisetting
gdspmode:=setguisize(1)

SetTimer, update, 100
return
;;;;;;;;;;
;gui
;;;;;;;;;;
guisetting:
    gui,add,button,r5 w50,Mergin
    gui,add,button,x+5 r5 w50,vol+10
    gui,add,button,x+5 r5 w50,vol-10
    ;gui,add,button,x+10 r4,GLASS
    gui,add,button,x+5 r5 w50,End
    
    gui,add,Text,xm,Left
    StringSplit, v, giniguiLeft , |
    Loop, %v0% {
        opt:=getchecked(ginileft,v%A_Index%)
        wk:=v%A_Index%
        gui,add,radio,vrdoLeft%A_Index% gchangesize x+10 %opt%,%wk%
    }

    gui,add,Text,xm,Right
    StringSplit, v, giniguiRight , |
    Loop, %v0% {
        opt:=getchecked(giniright,v%A_Index%)
        wk:=v%A_Index%
        gui,add,radio,vrdoRight%A_Index% gchangesize x+10 %opt%,%wk%
    }

    gui,add,Text,xm,Top
    StringSplit, v, giniguiTop , |
    Loop, %v0% {
        opt:=getchecked(ginitop,v%A_Index%)
        wk:=v%A_Index%
        gui,add,radio,vrdoTop%A_Index% gchangesize x+10 %opt%,%wk%
    }

    gui,add,Text,xm,Bottom
    StringSplit, v, giniguiBottom , |
    Loop, %v0% {
        opt:=getchecked(ginibottom,v%A_Index%)
        wk:=v%A_Index%
        gui,add,radio,vrdoBottom%A_Index% gchangesize x+10 %opt%, %wk%
    }

    gui,add,button,xm,Save
    gui,add,button,x+10,Windowlist
    ;gui,add,Checkbox,vchksizew gcheckboxchksize xm Checked,sizew
    gui,add,Checkbox,vchkslow  gcheckboxchkslow xm ,slow
    gui,add,Checkbox,x+10 vchkid ,id
    gui,add,edit,vData xm w480 ReadOnly,　
    gui,add,Text,xm,filtertitle
    gui,add,edit,vFiltitle x+10 w150 ,
    gui,add,Text,x+10,filterrocess
    gui,add,edit,vFilproce x+10 w150 ,
    gui,add,ListBox,vwinlist xm h500 w620 ReadOnly
    gui,+AlwaysOnTop
    return



;;;;;;;;;;;;;
;event
;;;;;;;;;;;
getinifile:
    IniRead, giniguitop, %inifname%, gui, mergintop , 0|100|1/8|1/6
    IniRead, giniguileft, %inifname%, gui, merginleft , 0|100|1/8|1/6
    IniRead, giniguiright, %inifname%, gui, merginright , 0|100|1/6|1/4
    IniRead, giniguibottom, %inifname%, gui, merginbottom , 0|100|1/3|2/5

    IniRead, ginitop, %inifname%, mergin, top , 0
    IniRead, ginileft, %inifname%, mergin, left , 0
    IniRead, giniright, %inifname%, mergin, right , 0
    IniRead, ginibottom, %inifname%, mergin, bottom , 0
    IniRead, giniexcexe, %inifname%, excloud, exe
         , heartyai|miyasukueyecon|intentionTransmission
    IniRead, giniexcexclass, %inifname%, excloud, workerw|
    IniRead, giniexcclass, %inifname%, excloud, 
    return
setinifile:
    IniWrite, giniguitop, %inifname%, gui, mergintop 
    IniWrite, giniguileft, %inifname%, gui, merginleft
    IniWrite, giniguiright, %inifname%, gui, merginright
    IniWrite, giniguibottom, %inifname%, gui, merginbottom

    IniWrite, ginitop, %inifname%, mergin, top
    IniWrite, ginileft, %inifname%, mergin, left
    IniWrite, giniright, %inifname%, mergin, right
    IniWrite, ginibottom, %inifname%, mergin, bottom
    IniWrite, giniexcexe, %inifname%, excloud, exe
    IniWrite, giniexcexclass, %inifname%, excloud, workerw|
    IniWrite, giniexcclass, %inifname%, excloud 
    return

GuiClose:
    ExitApp
ButtonEND:
    ExitApp, 0
ButtonMergin:
    if (gdspmode!=1)
        gdspmode:=setguisize(1)
    else
        gdspmode:=setguisize(2)
    Return
ButtonWindowlist:
    if (gdspmode!=3)
        gdspmode:=setguisize(3)
    else
        gdspmode:=setguisize(2)
    Return
ButtonSave:
    Gosub, setinifile
Checkboxchkslow:
    GuiControlGet, chkslow
    SetTimer, update, off
    if chkslow =1
        SetTimer, update, 30000
    Else
        SetTimer, update, 250
    Return
Checkboxchktooltip:
        GuiControlGet, chktooltip

    
Buttonvol+10:
    Send, {Volume_Up 5}
    Return
Buttonvol-10:
    Send, {Volume_Down 5}
    Return
ButtonGLASS:
    ;Send, {#+}
    winActivate, ahk_id %aid%
    Sleep, 100
    Send, {Down 5}

    Return
    
changesize:
    changemerginfunc()
    Return
;
;
;
update:
    MouseGetPos, msX, msY, msWin, msCtrl
    ;ToolTip,  %tooltipmsg% %msx%x%msy%, , , 1
    ;======== active windo
    winget,aid,id,A
    if gmyid=0
        gmyid:=aid
    if aid!=%gmyid%
    {
        getahkidinfo(aid,procname,this_title,this_class)
        ControlGetFocus, wkctl,  ahk_id %aid%
        if ErrorLevel = 0
            ControlGet, actl, Hwnd,, %wkctl%,ahk_id %aid%
        GuiControl, , data ,%procname% %this_title%  %aid%  %wkctl%  %actl%
    }
    ;======== dsp tooltip
    ;if chktootip = 1
    ;    ToolTip, gtooltip, , , 
    ;Else
    ;    ToolTip, , , , 


    getwinlist()

    Return

;;;;;;;;;;;;
;suboutin
;;;;;;;;;;;;
getradio(name,list,width){
    StringSplit, aryv, list , |
    Loop, %aryv0% {
        GuiControlGet,  %name%%A_Index%
        if %name%%A_Index%=1
            Return computemergin(aryv%A_Index%,width)_
        }
}
computemergin(val, width){
    if val contains /
    {
        StringSplit, wkn, val, /, 
        wk:= width * wkn1 // wkn2
        val=%wk%
    }
    Return val
}

getchecked(a,b){
    if (a=b)
        Return, " checked"
    Else
        return 
}
getdesktopsize(ByRef x,ByRef y,ByRef w,ByRef h){
    SysGet, sz, MonitorWorkArea ,1
    x:=szLeft
    w:=szRight-szLeft
    y:=szTop
    h:=szBottom-szTop
}
getscreensize(ByRef x,ByRef y,ByRef w,ByRef h){
    WinGetPos, x, y,  w, h,  Program Manage
}

changemerginfunc(){
    global grightmergin, gbottmmergin
    global gleft, gtop
    getdesktopsize(x, y, w, h)
    
    gtop:=getradio("rdoTop",giniguiTop,h)
    gleft:=getradio("rdoLeft",giniguiLeft,w)
    grightmergin:=getradio("rdoRight",giniguiRight,w)
    gbottmmergin:=getradio("rdoBottom",giniguiBottom,h)
}
setguisize(flg){
    OutputDebug, %flg%
    global gapwide,gwwid
    getdesktopsize(sx,sy,sw,sh)
    if flg=1
    {
        changemerginfunc()           
        wkx:=sx+sw-gapwide
        wkw:=gapwide-55
        gui,Show,x%wkx% y50 w%wkw% h80 ,touchkey
    }
    if flg=2
    {
        wkx:=sx+sw-gapwide
        wkw:=gapwide-55
        gui,Show,x%wkx% y50 w%wkw% h200 ,touchkey
    }
    if flg=3
    {
        wkx:=sx+sw-gwwide
        wkw:=gwwide-55
        gui,Show,x%wkx% y50 w%wkw% h600 ,touchkey
    }

    Return flg
}
getahkidinfo(ahkid,byref proc,byref title,ByRef class){
        WinGetTitle, title, ahk_id %ahkid%
        WinGetClass, class, ahk_id %ahkid%
        WinGet, proc, ProcessName, ahk_id %ahkid%
}
n4(x){
    z:="    " x
    StringRight, wk, z, 5
    ;SetFormat, float, 4.0
    ;x+=0
    Return %wk%
}
getwinlist(){
    global grightmergin, gbottmmergin
    global gleft, gtop
    global gmyid
    global gscrx,gscry,gscrw,gscrh
    ;global sx,sy,sh,sw
    getdesktopsize(dskx,dsky,dskw,dskh)
    dl:=dskx+gleft
    dt:=dsky+gtop
    dw:=dskw-grightmergin-gleft
    dh:=dskh-gbottmmergin-gtop
    GuiControlGet, chkid
    GuiControlGet, filtitle
    GuiControlGet, filproce
    WinGet, id, list, , , Program Manager
    wk:=""
    Loop, %id%
    {
        StringTrimRight, this_id, id%a_index%, 0
        WinGetPos, X, Y,  w, h, ahk_id %this_id%
        getahkidinfo(this_id,this_process,this_title,this_class)
        if ((InStr(this_title, filtitle)=0) and (filtitle !=""))
            Continue
        if ((InStr(this_process, filproce)=0) and (filproce !=""))
            Continue

        swe:=0
        if x<-30000
            swe=E      ;最小化除外
        else if this_id=%gmyid%
            swe:=1      ;自分自身
        else if getexcloude(this_process,this_class) = 1
            swe=e
        wk:=" "
        ret1:=getnxnw(x,w,dl,dw, nx, nw)
        if ret1=1
            wk:="<"
        if ret1=2
            wk:="("
        if ret1=3
            wk:=">"
        this_title:=wk this_title

        wk:=" "
        ret2:=getnynh(y,h,dt,dh, ny, nh)
        if ret2=1
            wk:="^"
        if ret2=2
            wk:="-"
        if ret2=3
            wk:="_"
        this_title:=wk this_title
    
        if swe=0
        {   ;サイズ変更
            if (x < -1)  or (y < -1)
                WinRestore, ahk_id %this_id%
            ;WinMove, ahk_id %this_id%, , nnx, nnY , nnw, nnh
            WinMove, ahk_id %this_id%, , nx, ny , nw, nh
        }
        sp:=" "
        wklist := wklist "|"  swe sw sp this_id
        wklist := wklist sp n4(x) "," n4(y)
        wklist := wklist sp n4(w) "x" n4(h)
        wklist := wklist sp n4(nx) "," n4(ny)
        wklist := wklist sp n4(nw) "x" n4(nh)
        wklist := wklist "  [" this_process  "]  "
        wklist := wklist  this_title
        if chkid=1
            wklist := wklist "  [" this_class  "]  " 
    }
    GuiControl, , winlist , %wklist%
    Return
}
isexist(v,list){
    StringSplit, aryv, list , |
    Loop, %aryv0%{
        wk:=aryv%a_index%
        if InStr(v, aryv%a_index%) > 0 
            Return True
    }
    return False
}
getexcloude(this_proc,this_class){
    global giniexcexe,gniexcexclass,giniexcclass
    swe:=0
    if isexist(this_proc,giniexcexe)
        swe:=1
    else if InStr(this_proc, "explorer.exe") > 0 
        {
            if isexist(this_class,giniexcexclass)
                swe:=1
        }
    else if isexist(this_class,giniexcclass)
        swe:=1
    ;else if InStr(this_title, "intentionTransmission.exe") > 0 
            ;if InStr(this_class, "ApplicationFrameWindow") > 0 


    Return swe
}

getnxnw(x,w,dl,dw,byref nx,byref nw){
    nx:=x
    nw:=w
    sw1:=0
    maxx:=dl+dw
    if (w > dw)
        nw:=dw

    if (x > maxx)
    {
        sw1:=1
        nx:=maxx-nw
    }
    else if (x + w > maxx)
    {
        sw1:=2
        nx:=maxx-nw        
    }
    Else if (x < dl)
    {
        sw1:=3
        nx:=dl
    } 
    Return sw1
}

getnynh(y,h,dt,dh,byref ny,byref nh){
    ny:=y
    nh:=h
    sw1:=0
    maxy:=dt+dh
    if (h > dh)
        nh:=dh
    if (y >  maxy)
    {
        sw1:=1
        ny:=maxy- nh
    }
    else if(y+h>maxy)
    {
        sw1:=2
        ny:=maxy-nh 
    }
    else if(y<dt)
    {
        sw1:=3
        ny:=dt 
    }
    Return sw1
}    

