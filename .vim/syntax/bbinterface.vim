" Vim syntax file
" Language:    BBInterface Bro@m Language (version 0.9.9)
" Version:     0.9.9.1
" Maintainer:  Juhani Pelli | UnkHz
" Last Change: 2006 Aug 15

" Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case match



" @BBInterface ...
syn match bbiBroamChar 	/@/ nextgroup=bbiBBInterface
syn keyword bbiBBInterface 	BBInterface contained nextgroup=bbiSet,bbiPlugin,bbiModule,bbiControl skipwhite


" @BBInterface Set ...
syn keyword bbiSet 	Set contained nextgroup=bbiStatic,bbiVarname skipwhite
syn keyword bbiStatic 	Static contained nextgroup=bbiVarname skipwhite
syn match bbiVarname	"\S\+" contained contains=bbiVariable nextgroup=@bbiValue skipwhite

" @BBInterface Plugin ...
syn keyword bbiPlugin 	Plugin contained nextgroup=bbiPluginCommand,bbiSetPluginProperty,bbiPluginLoad skipwhite
syn keyword bbiPluginCommand	Edit Save SaveAs Revert About contained nextgroup=@bbiValue skipwhite
syn keyword bbiSetPluginProperty	SetPluginProperty contained skipwhite nextgroup=bbiPluginProperty
syn match bbiPluginLoad	"Load\s\+\S\+"he=s+4 contained contains=bbiVariable,bbiScript skipwhite nextgroup=bbiPluginFrom
syn match bbiPluginFrom	"from\s\+\S\+"he=s+4 contained contains=bbiVariable nextgroup=bbiPluginInto skipwhite
syn keyword bbiPluginInto	into contained nextgroup=@bbiValue skipwhite
syn keyword bbiPluginProperty	SnapWindows SnapDistance SnapPadding IconSaturation IconHue ClickRaise DeskDropCommand SuppressErrors ZeroControlsAllowed UseTooltip ClearConfigurationOnLoad ModuleAutoSave GlobalOnload GlobalOnunload EnableShadows contained nextgroup=@bbiValue skipwhite

" @BBInterface Module ...
syn keyword bbiModule 	Module contained nextgroup=bbiModuleCommand, bbiModuleAction,bbiSetModuleProperty skipwhite
syn keyword bbiModuleCommand	Toggle Edit Rename OnLoad OnUnload SetDefault contained nextgroup=@bbiValue skipwhite
syn keyword bbiModuleAction	Create Load contained skipwhite
syn match bbiSetModuleProperty	"SetModuleProperty\s\+\S\+"he=s+17 contained contains=bbiVariable skipwhite nextgroup=bbiModuleProperty
syn keyword bbiModuleProperty	Author Comments contained nextgroup=@bbiValue skipwhite


" @BBInterface Control ...
syn keyword bbiControl 	Control contained nextgroup=bbiControlCommand,@bbiCreateCmds,@bbiSetCmds skipwhite
syn keyword bbiControlCommand 	Delete Rename Clone SaveAs RemoveAgent DetachFromModule contained


" @BBInterface Control Create...
syn cluster bbiCreateCmds	contains=bbiCreate,bbiCreateChild
syn keyword bbiCreate 	Create contained skipwhite nextgroup=bbiType
syn match bbiCreateChild	"CreateChild\s\+\S\+"he=s+11 contained contains=bbiVariable skipwhite nextgroup=bbiType
syn keyword bbiType	Frame Label Button SwitchButton Slider contained


" @BBInterface Control Set*Property <control> ...
syn cluster bbiSetCmds	contains=bbiSetWindowProperty,bbiSetControlProperty,bbiSetAgentProperty,bbiSetAgent,bbiExternalPlugin
syn match bbiSetWindowProperty	"SetWindowProperty\s\+\S\+"he=s+17 contained contains=bbiVariable skipwhite nextgroup=bbiWindowProperty
syn match bbiSetControlProperty	"SetControlProperty\s\+\S\+"he=s+18 contained contains=bbiVariable skipwhite nextgroup=bbiControlProperty
syn keyword bbiWindowProperty	X Y Width Height Border IsVisible Style IsOnAllWorkspaces IsOnTop IsSlitted IsToggledWithPlugins AutoHide IsTransparent Transparency Color ColorTo TextColor Bevel Detach contained nextgroup=@bbiValue
syn keyword bbiControlProperty	VAlign HAlign HasTitleBar IsLocked Pressed Value Reversed Vertical Appearance BroadcastValueMinimum BroadcastValueMaximum contained nextgroup=@bbiValue skipwhite


" @BBInterface Control ExternalPlugin <control> ...
syn match bbiExternalPlugin	"ExternalPlugin\s\+\S\+"he=s+14 contained contains=bbiVariable skipwhite nextgroup=bbiExtplugCmds,bbiExtplugSet
syn match bbiExtplugSet	"SetProperty\s\+\S\+"he=s+11 contained contains=bbiVariable skipwhite nextgroup=bbiExtplugProperty
syn keyword bbiExtplugCmds	Load Unload About contained nextgroup=@bbiValue skipwhite
syn keyword bbiExtplugProperty	Position IsVisible contained nextgroup=@bbiValue skipwhite


" @BBInterface Control SetAgent <control> ...
syn match bbiSetAgent	"SetAgent\s\+\S\+"he=s+8 contained contains=bbiVariable skipwhite nextgroup=bbiMount
syn match bbiSetAgentProperty	"SetAgentProperty\s\+\S\+\s\+\S\+"he=s+16 contained contains=bbiVariable,bbiMount skipwhite nextgroup=bbiAgentProperty
syn keyword bbiMount	Caption Image ImageWhenPressed MouseDown MouseUp LeftMouseDown LeftMouseUp RightMouseDown RightMouseUp MiddleMouseDown MiddleMouseUp OnDrop Value OnChange OnGrab OnRelease Pressed Unpressed contained nextgroup=bbiAgent,bbiBroamAgent skipwhite
syn keyword bbiAgentProperty	Scale VAlign HAlign Size VAlign HAlign MinValue MaxValue Arguments WorkingDir Source contained nextgroup=@bbiValue skipwhite
syn keyword bbiAgent	Bitmap Icon TGA Graph Run BBInterfaceControl MixerScale MixerBool StaticText CompoundText SystemMonitor SwitchedState System Winamp contained nextgroup=@bbiValue skipwhite
syn match bbiBroamAgent	"Bro@m" contained nextgroup=@bbiValue skipwhite


" Misc stuff
syn cluster bbiValue	contains=bbiVariable,bbiExprChar,bbiStringChar,bbiWhiteSpace,bbiBroamChar
syn match bbiScript 	"\[\S\+\]"
syn match bbiVariable 	"\$[^$]\+\$"
syn match bbiDollar 	"\$\{2\}"
syn match bbiComment 	"^!.*$"
syn match bbiNumber 	"\d\+" contained 
syn match bbiBool 	"false\|true" contained
syn match bbiExprChar 	"[?()+\-*/#<>&|=:^%]\|\(rgb10:\)\|!=" nextgroup=bbiNumber,bbiVariable skipwhite
syn match bbiStringChar 	"[\"]" nextgroup=bbiVariable
syn match bbiWhiteSpace 	"\s" nextgroup=bbiNumber,bbiBool,bbiVariable skipwhite


" The default highlighting.
if version >= 508 || !exists("did_bbi_syn_inits")
  if version < 508
    let did_bbi_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink bbiBBInterface	Keyword
  HiLink bbiSet	Keyword
  HiLink bbiPlugin	Keyword
  HiLink bbiModule	Keyword
  HiLink bbiControl	Keyword
  HiLink bbiScript	Function
  
  HiLink bbiStatic	Statement
  HiLink bbiCreate	Statement
  HiLink bbiCreateChild	Statement
  HiLink bbiControlCommand	Statement
  HiLink bbiPluginCommand	Statement
  HiLink bbiPluginLoad	Statement
  HiLink bbiPluginFrom	Statement
  HiLink bbiPluginInto	Statement
  HiLink bbiModuleCommand	Statement
  HiLink bbiModuleAction	Statement
  HiLink bbiSetAgent	Statement
  HiLink bbiSetAgentProperty	Statement
  HiLink bbiSetControlProperty	Statement
  HiLink bbiSetWindowProperty	Statement
  HiLink bbiSetPluginProperty	Statement
  HiLink bbiSetModuleProperty	Statement
  HiLink bbiExternalPlugin	Statement
  HiLink bbiExtplugSet	Statement
  HiLink bbiExtplugCmds	Statement
  
  HiLink bbiType	Type
  HiLink bbiAgent	Type
  HiLink bbiBroamAgent	Type
  
  HiLink bbiMount	Statement
  HiLink bbiAgentProperty	Statement	
  HiLink bbiPluginProperty	Statement
  HiLink bbiModuleProperty	Statement
  HiLink bbiControlProperty	Statement
  HiLink bbiWindowProperty	Statement
  HiLink bbiExtplugProperty	Statement
  
  HiLink bbiVariable	Identifier
  HiLink bbiNumber	Number
  HiLink bbiBool	Boolean
  HiLink bbiExprChar	Number
  HiLink bbiBroamChar	SpecialChar
  HiLink bbiDollar	SpecialChar
  HiLink bbiComment	Comment
  delcommand HiLink
endif

let b:current_syntax = "bbinterface"

" vim: ts=40
