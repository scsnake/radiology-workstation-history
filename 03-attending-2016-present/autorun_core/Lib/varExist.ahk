/*
Usage : VarExist(Var)

VarExist determines the existence of variable and returns a numerical value..
where,

0 indicates that the variable does not exist
1 indicates that the variable does exist and contains data
2 indicates that the variable does exist and is empty
*/

;~ varExist(ByRef v) { ; Requires 1.0.46+
   ;~ return &v = &n ? 0 : v = "" ? 2 : 1 
;~ }

VarExist(ByRef Var="")        {       ; * * * Determines a variable existence. * * *
                                ;
IfEqual, Var,,Return, 0         ; If no parameter, return 0
                                ;
VarAddr = % & %Var%             ; Obtain pointer to the variable
                                ;
x := "Var" . Chr(160)           ; x will contain a non-existing variable name
NonExistent := &%x%             ; Obtain pointer to the non-existing variable
                                ;
if ( VarAddr = NonExistent ) {  ; Compare both the pointers and
   Return, 0                    ; if equal, Return 0 to indicate that
                             }  ; the variable does not exist 
else                            ;
   If ( %Var% = "" )         {  ; If Var is empty Return 2
      Return, 2                 ;  
                             }  ;
Return 1                        ; If above conditions do not apply, Return 1
                        }       ; to indicate variable exists with data
                        
                        
                        ;~ a:=1
                        ;~ b:="a"
                        
                        ;~ MsgBox % varExist(b)