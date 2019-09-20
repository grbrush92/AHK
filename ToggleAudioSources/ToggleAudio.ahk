﻿#include VA.ahk	;VA.ahk has to be in the same folder as this script
#Persistent	;this keeps the script running if no hotkeys are set (though one is)
#SingleInstance force ;forces a single instance of the script

; Class declaration
class ToggleAudio{
    __New()
    {
        ; The headphone enpoint string and endpoint vars will probably need to be adjusted for your personal machine
        this.headphoneEndpointString := "Speakers (Realtek High Definition Audio)"
        this.speakersEndpointString := "Acer X34 (NVIDIA High Definition Audio)"
        this.endpointToggle := False
        this.soundOnChange := True
        if (this.IsDeviceHeadphones())
        {
            this.endpointToggle := True
        }
        this.SetEndpoint()
        this.ChangeIcon()
    }
    ToggleEndpoint()
    {
        this.endpointToggle := !this.endpointToggle
        this.SetEndpoint()
        this.ChangeIcon()
        if (this.soundOnChange) 
            this.PlaySound()
    }
    ChangeIcon()
    {
        if (this.IsDeviceHeadphones())
        {
            Menu, Tray, Icon, head-0.ico,,1
        }
        else
        {
            Menu, Tray, Icon, speak-0.ico,,1 
        }
    }
    SetEndpoint()
    {
        if(this.endpointToggle)
        {
            VA_SetDefaultEndpoint(this.headphoneEndpointString, 0)
        }
        else
        {
            VA_SetDefaultEndpoint(this.speakersEndpointString, 0)
        }
    }
    IsDeviceHeadphones()
    {
        deviceName := VA_GetDeviceName(VA_GetDevice())
        if ("" . deviceName = this.headphoneEndpointString)
        {
            return True
        }
        else
        {
            return False
        }
    }
    PlaySound()
    {
        SoundPlay, %A_ScriptDir%\quack.wav, Wait
    }
}

; Script Initialize
toggleAudio := new ToggleAudio

; Right click menu options
Menu, Tray, Add
Menu, Tray, Add, Toggle Audio Source, MenuToggleEndpoint

; End script initialize
return

; Menu functions
MenuToggleEndpoint:
    toggleAudio.ToggleEndpoint()
Return

; Hotkeys
!x::
    toggleAudio.ToggleEndpoint()
Return

; Helpers
KillToolTip:
    SetTimer, KillToolTip, Off
    ToolTip
Return