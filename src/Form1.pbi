;/////////////////////////////////////////////////////////////////////////////////
; Form1 Module – Derived from Base Form (TForm)
;/////////////////////////////////////////////////////////////////////////////////
; Description:
; Implements the specific window logic for the Form1 dialog.
; This module registers and controls an instance of #Form1 defined in Form1.pbf.
;
; Notes:
; - This module uses the TForm infrastructure for initialization, display, and cleanup.
; - The Form1Event() procedure is used as the central event handler.
;/////////////////////////////////////////////////////////////////////////////////

DeclareModule Form1
  
  Structure frmCtx Extends TForm::_frmCtx
  EndStructure
  
  Declare.i Init()  
  Declare Show(*ctx.frmCtx)                                       
  Declare Close(*ctx.frmCtx)                                     
EndDeclareModule

Module Form1
  EnableExplicit
  
  XIncludeFile "Form1.pbf"
  
  ;<comment>
  ;  <summary>Callback function for handling Form1-specific events.</summary>
  ;  <param><b>*ctx</b>: Pointer to the form context (frmCtx).</param>
  ;  <param><b>event</b>: Event type identifier (e.g., #PB_Event_Gadget).</param>
  ;  <param><b>gadget</b>: ID of the gadget associated with the event.</param>
  ;  <return>No return value</return>
  ;  <example>Automatically invoked by the main event loop via callback.</example>
  ;</comment>
  Procedure Form1Event(*ctx.frmCtx, event.i, gadget.i, menu.i)
    ;Prüfen, ob das Event zum Fenster gehört
    If EventWindow() = *ctx\wndNum
      Select event
        Case #PB_Event_Menu
          Select menu
            Case #FormMenu_Exit
              Close(*ctx)
              End 0
          EndSelect
          
        Case #PB_Event_Gadget
          Select gadget
              ; TODO: Implement gadget actions
          EndSelect
          
        Case #PB_Event_CloseWindow
          Close(*ctx) 
          End 0
          ProcedureReturn 
      EndSelect
    EndIf
  EndProcedure
  
  ;<comment>
  ;  <summary>Initializes a Form1 instance.</summary>
  ;  <return>Returns a pointer to the initialized frmCtx structure, or #Null on failure.</return>
  ;  <example>*ctx = Form1::Init()</example>
  ;</comment>
  Procedure.i Init()
    
    ProcedureReturn TForm::__Init(#Form1, @OpenForm1(), #Null, @Form1Event())
  EndProcedure
  
  
  ;<comment>
  ;  <summary>Displays the given Form1 instance.</summary>
  ;  <param><b>*ctx</b>: Pointer to the frmCtx structure to show.</param>
  ;  <return>No return value</return>
  ;  <example>Form1::Show(*ctx)</example>
  ;</comment>
  Procedure Show(*ctx.frmCtx)
    
    TForm::__Show(*ctx)
    
  EndProcedure
  
  ;<comment>
  ;  <summary>Closes the given Form1 instance.</summary>
  ;  <param><b>*ctx</b>: Pointer to the frmCtx structure to close.</param>
  ;  <return>Returns the pointer again (or #Null if closed).</return>
  ;  <example>Form1::Close(*ctx)</example>
  ;</comment>
  Procedure Close(*ctx.frmCtx)
    
    ProcedureReturn TForm::__Close(*ctx)
  EndProcedure
EndModule
