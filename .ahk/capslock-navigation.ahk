#Warn  ; Enable warnings to assist with detecting common errors.
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance
ProcessSetPriority "High"

; Set capslock navigation
SetCapsLockState "AlwaysOff"

; Avoid triggering Windows keydown combos like Ctrl-Shift-Esc and Ctrl-Alt-Esc
CapsLock:: {
	KeyWait "CapsLock"
	Send "{Esc}"
}
; Navigate
CapsLock & i::Up
CapsLock & j::Left
CapsLock & k::Down
CapsLock & l::Right
CapsLock & h::Home
CapsLock & SC0027::End

; Edit
CapsLock & BackSpace::Delete
CapsLock & s::^s
CapsLock & z::^z
CapsLock & x::^x
CapsLock & c::^c
CapsLock & v::^v