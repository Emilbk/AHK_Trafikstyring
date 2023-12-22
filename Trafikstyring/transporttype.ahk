#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%
p6_ret_transportype()
return



Pause::
{
    ExitApp
    return
}
+Pause::
{
   Pause, toggle, 1
   P6_aktiver()
   return
}
    +^r::
{
    Reload
    sleep 2000
    return
}

; ^q::
; {
    p6_ret_transportype()
    return
; }


p6_vl_vindue()
{
    vl := P6_hent_vl()
    sleep 30
    SendInput, ^{F12}
    sleep 250
    clipboard :=
    SendInput, ^c
    clipwait 0.5
    if (InStr(clipboard, "opdateringern")) ; tjek for tidligere vl-vindue stadig åbent
    {
        SendInput, !y
    }
    clipboard :=
    vl_opslag := clipboard
    tid_start := A_TickCount
    while (vl_opslag != vl)
    {
        Send, +{F10}c
        vl_opslag := clipboard
        sleep 100
        tid_nu := A_TickCount - tid_start
        if (tid_nu > 12000)
        {
            return 0
        }
    }
    vl := clipboard
    return vl
}
P6_hent_vl()
{
    global s
    clipboard := ""
    P6_planvindue()
    SendInput, !l
    sleep 150 ; ikke P6-afhængig
    SendInput, +{F10}c
    ClipWait, 2, 0
    vl := Clipboard
    return vl
}
P6_planvindue()
{
    global s
    P6_aktiver()
    P6_alt_menu("{escape} {alt}", "tp")
}
P6_aktiver()
{
    IfWinNotActive, PLANET
    {
        WinActivate, PLANET
        WinWaitActive, PLANET
        sleep 100
        SendInput, {esc} ; registrerer ikke første tryk, når der skiftes til vindue
        sleep 300
        return 1
    }
    return 0
}

P6_alt_menu(byref tast1 := "", byref tast2 := "")
{
    Sendinput %tast1%
    sleep 40
    SendInput, %tast2%
    sleep 40
}
p6_ret_transportype_hent_vl()
{


    SendInput, !{right}
    sleep 500
    clipboard :=
    while (clipboard = "")
        {
    SendInput, +{F10}c
    sleep 100
    clipwait 1
        }
    vl := clipboard
    vl_split := StrSplit(vl)
    if (vl_split[1] = "3")
        {
            return vl
        }
    Else
        {
            vl := "ikke"
            return vl
        }
    sleep 100
    return vl
}
p6_ret_transportype()
{
    sleep 40
    InputBox, dato, dato, indsæt dato, , , , , , , , 24
    if (ErrorLevel = 1)
        ExitApp
    FileAppend, , vl_seneste.txt
    FileRead, vl_seneste, vl_seneste.txt
    if (ErrorLevel = 1)
        ExitApp
    vl_seneste := vl_seneste - 1
    sleep 40
    InputBox, start_vl, Start-VL, Indtast første vl,, , , , , , , %vl_seneste%
    P6_planvindue()
    P6_alt_menu("{alt}", "tl")
    forfra:
    sleep 100
    SendInput, {tab} %dato% +{tab}
    sleep 300
    SendInput, %start_vl% {enter}
    sleep 2000
    SendInput, {enter}
    sleep 100
   while (vl != "ikke")
        {
    vl := p6_ret_transportype_hent_vl()
    if (vl = "ikke")
        {
            vl :=
            break
        }
    vl_seneste := vl
    FileDelete, vl_seneste.txt
    FileAppend, %vl_seneste%, vl_seneste.txt
 
            trtype := "ikke defineret"
            barn1 := 0 ; slet
            sleep 200
            SendInput, ^æ{enter 2}!u
            sleep 200
            while (trtype != "")
                {
            clipboard :=
            barn1_omgang := 0
            while (Clipboard != "barn1") and (barn1 = 0) ; slet
                {  ; slet
                    SendInput, +{f10}c ; slet
                    clipwait 1  ; slet
                    SLEEP 300
                    barn1_omgang += 1
                    if (barn1_omgang = 10)
                        barn1 := 3
                }  ; slet
            barn1 := 1 ; slet
            Clipboard :=
            SendInput, +{f10}c
            clipwait 1
            sleep 80
            trtype := clipboard
            if (trtype = "fyn24" or trtype = "syd24")
                {
                    ; MsgBox, , , fundet
                    SendInput, {delete}
                    trtype := "slettet"
                    sleep 20
                }
            if (trtype = "")
                {}
            Else
                {
                    SendInput, {tab}
                    sleep 20
                }
                }
            ; MsgBox, , , asd   , 
            SendInput, {enter}
            sleep 200
        }
        MsgBox, , , Ikke MT-VL, 5
        if (dato != "26")
            {
                dato := dato +1
                start_vl := 3000
                Goto, forfra
            }
        sleep 100
        ExitApp


    return
}