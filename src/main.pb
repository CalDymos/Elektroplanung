EnableExplicit

XIncludeFile "TForm.pbi"
XIncludeFile "Form1.pbi"

Global *form1.Form1::frmCtx  ; Pointer to the main window instance

;<comment>
;  <summary>Initializes and displays the main application window.</summary>
;  <return>No return value</return>
;  <example>InitMainWindow()</example>
;</comment>
Procedure InitMainWindow()
  *form1 = Form1::Init()
  Form1::Show(*form1)
EndProcedure

;<comment>
;  <summary>Runs the main event loop of the application.</summary>
;  <return>No return value</return>
;  <example>RunMainLoop()</example>
;</comment>
Procedure RunMainLoop()
  Define.i event, gadget, menu
  
  Repeat
    event = WaitWindowEvent()
    gadget = EventGadget()
    menu = EventMenu()
    
    *form1\Callback(*form1, event, gadget, menu)
  ForEver
EndProcedure

; --- Application entry point ---
InitMainWindow()
RunMainLoop()
