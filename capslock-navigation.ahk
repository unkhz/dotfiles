#Warn  ; Enable warnings to assist with detecting common errors.
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance
ProcessSetPriority "High"

; Set capslock navigation
SetCapsLockState "AlwaysOff"

CapsLock::Escape

CapsLock & i::Up
CapsLock & j::Left
CapsLock & k::Down
CapsLock & l::Right
CapsLock & h::Home
CapsLock & SC0027::End
CapsLock & BackSpace::Delete
CapsLock & Space:: {
	Click "Down"
	KeyWait "Space"
	Click "Up"
}