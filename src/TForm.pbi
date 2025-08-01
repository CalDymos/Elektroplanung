;/////////////////////////////////////////////////////////////////////////////////
; Base Form Module – TForm
;/////////////////////////////////////////////////////////////////////////////////
; Description:
; Provides a general abstraction layer for handling multiple form instances.
; Each form context (frmCtx) stores window ID, parent reference and an optional callback.
; This module supports initialization, display and cleanup of window instances.
;
; Notes:
; - All procedures with the '__' prefix are intended for internal use within this
;   module or by inheriting modules only.
; - All variables and structures with the '_' prefix are considered internal and
;   should not be accessed externally.
; - All public properties must start with Get_... or Set_...
;/////////////////////////////////////////////////////////////////////////////////

DeclareModule TForm
  Prototype EventCallback(*ctx, event.i, gadget.i, menu.i)
  Prototype OpenFormProc(x = 0, y = 0, width = 919, height = 615)
  
  Structure _frmCtx
    wndNum.i
    wndParentNum.i
    Callback.EventCallback ; Function pointer to the instance-specific event handler
  EndStructure
  
  Declare.i __Init(wndNum.i, *OpenForm.OpenFormProc, wndParentNum.i = -1, *Callback.EventCallback = #Null)  
  Declare __Show(*ctx._frmCtx)                                       
  Declare __Close(*ctx._frmCtx)                                      
EndDeclareModule

Module TForm
  EnableExplicit
  Global OpenForm.OpenFormProc
  Global NewList Forms._frmCtx()  ; Liste für Fenster-Instanzen
  
  Global _wndParentID ; Required for the form designer. 
                      ; If a form is to be assigned to a parent, 
                      ; _wndParentID should be entered in the Parent field in the form designer.
  
  ;<comment>
  ;  <summary>Initializes and registers a new window context (frmCtx) for the given window ID. Must be called in the inheriting module.</summary>
  ;  <param><b>wndNum</b>: The PureBasic window ID to be associated with the form.</param>
  ;  <param><b>*OpenForm</b>: Pointer to the form-opening procedure (must match OpenFormProc prototype).</param>
  ;  <param><b>parentNum</b>: Optional parent window ID. Default is -1 (no parent).</param>
  ;  <param><b>*Callback</b>: Optional pointer to a user-defined Event callback procedure for the Form.</param>
  ;  <return>Returns a pointer to the created frmCtx structure, or #Null on failure.</return>
  ;  <example>*ctx = TForm::__Init(#Form1, @OpenForm1(), -1, @FormCallback())</example>
  ;</comment>
  Procedure.i __Init(wndNum.i, *OpenForm.OpenFormProc, wndParentNum.i = -1, *Callback.EventCallback = #Null)
    
    If wndParentNum > 0
      _wndParentID = WindowID(wndParentNum)
    Else
      _wndParentID = 0
    EndIf
    
    If *OpenForm
      OpenForm = *OpenForm 
      OpenForm()
    EndIf
    
    AddElement(Forms())   
    Forms()\wndNum = wndNum 
    Forms()\wndParentNum = wndParentNum
    Forms()\Callback = *Callback 
    
    ProcedureReturn @Forms()  
  EndProcedure
  
  ;<comment>
  ;  <summary>Closes the given form context window and removes it from the Forms list. Must be called in the inheriting module.</summary>
  ;  <param><b>*ctx</b>: Pointer to the frmCtx structure to be closed.</param>
  ;  <return>Returns the pointer (set to #Null) if successful, unchanged otherwise.</return>
  ;  <example>TForm::__Close(*ctx)</example>
  ;</comment>
  Procedure __Show(*ctx._frmCtx)
    If *ctx = #Null
      Debug "ERROR: __Show(): *ctx is NULL"
      ProcedureReturn
    EndIf
    
    HideWindow(*ctx\wndNum, #False)
    SetActiveWindow(*ctx\wndNum)
    
  EndProcedure
  
  ;<comment>
  ;  <summary>Returns the form callback assigned to the given window ID. Must be called in the inheriting module.</summary>
  ;  <param><b>wndNum</b>: The PureBasic window ID for which the callback is requested.</param>
  ;  <return>Returns the callback pointer if found, 0 otherwise.</return>
  ;  <example>*cb = TForm::GetCallback(EventWindow())</example>
  ;</comment>
  Procedure __Close(*ctx._frmCtx)
    If *ctx = #Null
      Debug "ERROR: __Close(): *ctx is NULL"
      ProcedureReturn
    EndIf
    
    ForEach Forms()
      If @Forms() = *ctx
        CloseWindow(Forms()\wndNum)
        DeleteElement(Forms())  ; Remove window from list
        *ctx = #Null
        Break
      EndIf
    Next
    
    ProcedureReturn *ctx
  EndProcedure
EndModule
