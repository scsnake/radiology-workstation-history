#MaxThreadsPerHotkey 10
#MaxThreadsBuffer ON
#MaxHotkeysPerInterval 999
#UseHook
StringCaseSense On
Process Priority,,Realtime
SetKeyDelay -1
BlockInput Send

Low = ``1234567890-=qwertyuiop[]\asdfghjkl`;'zxcvbnm,./
Shft= ~!@#$`%^&*()_+QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?

KeySet = ``1234567890-=qwertyuiop[]\asdfghjkl`;'zxcvbnm,./
Loop Parse, KeySet
{
   AllKeys := AllKeys "%x" Asc(A_LoopField) "%"
   HotKey  %A_LoopField%,  KeyDown, B
   HotKey  %A_LoopField% up, KeyUp, B
   HotKey +%A_LoopField%, CKeyDown, B
   HotKey +%A_LoopField% up, KeyUp, B
}
SentTick = 0
SetTimer Action, 10                    ; handle key repeat
RI = 0
Loop                                   ; self healing missed key releases
{                                      ; to prevent infinite repeat
   Sleep 10
   RI := Mod(RI, StrLen(KeySet)) + 1
   StringMid r, KeySet, RI, 1
   If GetKeyState(r,"P")
      Continue
   r := "x" Asc�
   %r% =
}
Return

KeyDown:                               ; register keys pressed
   key := "x" Asc(A_ThisHotKey)
   %key% = %A_ThisHotKey%
GoTo Tick

CKeyDown:                              ; register shifted keys pressed
   StringRight k, A_ThisHotKey, 1      ; remove "+"
   StringMid U,Shft,InStr(Low,k,1),1   ; convert k to Shift-%k%
   key := "x" Asc(k)
   %key% = %U%
GoTo Tick

KeyUp:                                 ; register key release
   StringReplace k, A_ThisHotKey, +    ; remove "+"
   key := "x" Asc(k)
   %key% =

Tick:                                  ; register time of key event
   KeyTick = %A_TickCount%
Action:
   Transform keys, Deref, %AllKeys%
   IfNotEqual keys, %key0%, {          ; KEYS CHANGED keys <> key0
      If (keyn = 0 and len0 = 1 and len1 = 0 and keys = "")
         GoSub SENDX                   ; short single key press
      Else If (keyn = 1 and len0 = 1 and len1 = 2 and keys = "" and SentKeys <> key0 and StrLen(SentKeys) = 1)
         GoSub SENDX                   ; overlapping keys
      len1:= StrLen(key0)
      len0:= StrLen(keys)
      key0 = %keys%                    ; previous key combination
      keyn = 0                         ; the number of repetitions
   }
   Else {                              ; NO KEY CHANGE keys == key0
      if (keys = ""
       or A_TickCount - KeyTick  < 40  and keyn = 0
       or A_TickCount - SentTick < 360 and keyn = 1
       or A_TickCount - SentTick < 60  and keyn > 1)
         Return
      keyn++
      GoTo SEND
   }
Return

SEND:
   IfLess len0,%len1%, Return          ; no send at releasing keys
SENDX:
   SentTick = %A_TickCount%            ; remember time of send
   SentKeys = %key0%
   
    ;PRIMARY KEYS - MIDDLE ROW
	IfEqual key0,a, Send a
	Else IfEqual key0,s, Send s
	Else IfEqual key0,d, Send e
	Else IfEqual key0,f, Send t
	Else IfEqual key0,j, Send n
	Else IfEqual key0,k, Send i
	Else IfEqual key0,l, Send o
	Else IfEqual key0,;, Send p
	
	;PRIMARY KEYS - TOP ROW
	Else IfEqual key0,q, Send a
	Else IfEqual key0,w, Send s
	Else IfEqual key0,e, Send e
	Else IfEqual key0,r, Send t
	Else IfEqual key0,u, Send n
	Else IfEqual key0,i, Send i
	Else IfEqual key0,o, Send o
	Else IfEqual key0,p, Send p
	
	;BASIC CHORDS - MIDDLE ROW
	Else IfEqual key0,as, Send w
	Else IfEqual key0,ad, Send x
	Else IfEqual key0,af, Send f
	Else IfEqual key0,aj, Send q
	Else IfEqual key0,ak, Send !
	Else IfEqual key0,al, Send (
	Else IfEqual key0,a;, Send ?
	Else IfEqual key0,sd, Send d
	Else IfEqual key0,sf, Send c
	Else IfEqual key0,sj, Send j
	Else IfEqual key0,sk, Send z
	Else IfEqual key0,sl, Send .
	Else IfEqual key0,s;, Send )
	Else IfEqual key0,df, Send r
	Else IfEqual key0,dj, Send y
	Else IfEqual key0,dk, Send {ASC 44}
	Else IfEqual key0,dl, Send -
	Else IfEqual key0,d;, Send {ASC 39}
	Else IfEqual key0,fj, Send b
	Else IfEqual key0,fk, Send v
	Else IfEqual key0,fl, Send g
	Else IfEqual key0,f;, Send {Backspace}
	Else IfEqual key0,jk, Send h
	Else IfEqual key0,jl, Send u
	Else IfEqual key0,j;, Send m
	Else IfEqual key0,kl, Send l
	Else IfEqual key0,k;, Send k
	Else IfEqual key0,l;, Send {ASC 59}
	
	;BASIC CHORDS - TOP ROW
	Else IfEqual key0,qw, Send w
	Else IfEqual key0,qe, Send x
	Else IfEqual key0,qr, Send f
	Else IfEqual key0,qu, Send q
	Else IfEqual key0,qi, Send !
	Else IfEqual key0,qo, Send (
	Else IfEqual key0,qp, Send ?
	Else IfEqual key0,we, Send d
	Else IfEqual key0,wr, Send c
	Else IfEqual key0,wu, Send j
	Else IfEqual key0,wi, Send z
	Else IfEqual key0,wo, Send .
	Else IfEqual key0,wp, Send )
	Else IfEqual key0,er, Send r
	Else IfEqual key0,eu, Send y
	Else IfEqual key0,ei, Send {ASC 44}
	Else IfEqual key0,eo, Send -
	Else IfEqual key0,ep, Send {ASC 39}
	Else IfEqual key0,ru, Send b
	Else IfEqual key0,ri, Send v
	Else IfEqual key0,ro, Send g
	Else IfEqual key0,rp, Send {Backspace}
	Else IfEqual key0,ui, Send h
	Else IfEqual key0,uo, Send u
	Else IfEqual key0,up, Send m
	Else IfEqual key0,io, Send l
	Else IfEqual key0,ip, Send k
	Else IfEqual key0,op, Send {ASC 59}
	
	;SHIFT KEYS - BOTTOM ROW
	Else IfEqual key0,z, Send {Shift Down}
	Else IfEqual key0,x, Send {Shift Down}
	Else IfEqual key0,c, Send {Shift Down}
	Else IfEqual key0,v, Send {Shift Down}
	Else IfEqual key0,b, Send {Shift Down}
	Else IfEqual key0,n, Send {Shift Down}
	Else IfEqual key0,m, Send {Shift Down}
	Else IfEqual key0,`,, Send {Shift Down}
	Else IfEqual key0,., Send {Shift Down}

	;CAPITAL LETTERS
	;PRIMARY KEYS - MIDDLE ROW - CAPITAL
	Else IfEqual key0,A, Send A{Shift Up}
	Else IfEqual key0,S, Send S{Shift Up}
	Else IfEqual key0,D, Send E{Shift Up}
	Else IfEqual key0,F, Send T{Shift Up}
	Else IfEqual key0,J, Send N{Shift Up}
	Else IfEqual key0,K, Send I{Shift Up}
	Else IfEqual key0,L, Send O{Shift Up}
	Else IfEqual key0,:, Send P{Shift Up}
	
	;PRIMARY KEYS - TOP ROW - CAPITAL
	Else IfEqual key0,Q, Send A{Shift Up}
	Else IfEqual key0,W, Send S{Shift Up}
	Else IfEqual key0,E, Send E{Shift Up}
	Else IfEqual key0,R, Send T{Shift Up}
	Else IfEqual key0,U, Send N{Shift Up}
	Else IfEqual key0,I, Send I{Shift Up}
	Else IfEqual key0,O, Send O{Shift Up}
	Else IfEqual key0,P, Send P{Shift Up}
	
	;BASIC CHORDS - MIDDLE ROW - CAPITAL
	Else IfEqual key0,AS, Send W{Shift Up}
	Else IfEqual key0,AD, Send X{Shift Up}
	Else IfEqual key0,AF, Send F{Shift Up}
	Else IfEqual key0,AJ, Send Q{Shift Up}
	Else IfEqual key0,AK, Send !{Shift Up}
	Else IfEqual key0,AL, Send [{Shift Up}
	Else IfEqual key0,A:, Send /{Shift Up}
	Else IfEqual key0,SD, Send D{Shift Up}
	Else IfEqual key0,SF, Send C{Shift Up}
	Else IfEqual key0,SJ, Send J{Shift Up}
	Else IfEqual key0,SK, Send Z{Shift Up}
	Else IfEqual key0,SL, Send >{Shift Up}
	Else IfEqual key0,S:, Send ]{Shift Up}
	Else IfEqual key0,DF, Send R{Shift Up}
	Else IfEqual key0,DJ, Send Y{Shift Up}
	Else IfEqual key0,DK, Send <{Shift Up}
	Else IfEqual key0,DL, Send _{Shift Up}
	Else IfEqual key0,D:, Send "{Shift Up}
	Else IfEqual key0,FJ, Send B{Shift Up}
	Else IfEqual key0,FK, Send V{Shift Up}
	Else IfEqual key0,FL, Send G{Shift Up}
	Else IfEqual key0,F:, Send {Backspace}{Shift Up}
	Else IfEqual key0,JK, Send H{Shift Up}
	Else IfEqual key0,JL, Send U{Shift Up}
	Else IfEqual key0,J:, Send M{Shift Up}
	Else IfEqual key0,KL, Send L{Shift Up}
	Else IfEqual key0,K:, Send K{Shift Up}
	Else IfEqual key0,L:, Send :{Shift Up}
	
	;BASIC CHORDS - TOP ROW
	Else IfEqual key0,QW, Send W{Shift Up}
	Else IfEqual key0,QE, Send X{Shift Up}
	Else IfEqual key0,QR, Send F{Shift Up}
	Else IfEqual key0,QU, Send Q{Shift Up}
	Else IfEqual key0,QI, Send !{Shift Up}
	Else IfEqual key0,QO, Send [{Shift Up}
	Else IfEqual key0,QP, Send /{Shift Up}
	Else IfEqual key0,WE, Send D{Shift Up}
	Else IfEqual key0,WR, Send C{Shift Up}
	Else IfEqual key0,WU, Send J{Shift Up}
	Else IfEqual key0,WI, Send Z{Shift Up}
	Else IfEqual key0,WO, Send >{Shift Up}
	Else IfEqual key0,WP, Send ]{Shift Up}
	Else IfEqual key0,ER, Send R{Shift Up}
	Else IfEqual key0,EU, Send Y{Shift Up}
	Else IfEqual key0,EI, Send <{Shift Up}
	Else IfEqual key0,EO, Send _{Shift Up}
	Else IfEqual key0,EP, Send "{Shift Up}
	Else IfEqual key0,RU, Send B{Shift Up}
	Else IfEqual key0,RI, Send V{Shift Up}
	Else IfEqual key0,RO, Send G{Shift Up}
	Else IfEqual key0,RP, Send {Backspace}{Shift Up}
	Else IfEqual key0,UI, Send H{Shift Up}
	Else IfEqual key0,UO, Send U{Shift Up}
	Else IfEqual key0,UP, Send M{Shift Up}
	Else IfEqual key0,IO, Send L{Shift Up}
	Else IfEqual key0,IP, Send K{Shift Up}
	Else IfEqual key0,OP, Send :{Shift Up}
	
	;SHIFT KEYS - BOTTOM ROW
	Else IfEqual key0,Z, Send {Shift Down}
	Else IfEqual key0,X, Send {Shift Down}
	Else IfEqual key0,C, Send {Shift Down}
	Else IfEqual key0,V, Send {Shift Down}
	Else IfEqual key0,B, Send {Shift Down}
	Else IfEqual key0,N, Send {Shift Down}
	Else IfEqual key0,M, Send {Shift Down}
	Else IfEqual key0,<, Send {Shift Down}
	Else IfEqual key0,>, Send {Shift Down}

	Else IfEqual key0,afl, Send of
	Else IfEqual key0,qro, Send of

	Else IfEqual key0,djk, Send he
	Else IfEqual key0,eiu, Send he
	
	Else IfEqual key0,aj;, Send am
	Else IfEqual key0,pqr, Send am
	
	Else IfEqual key0,dfl, Send or
	Else IfEqual key0,eor, Send or

	Else IfEqual key0,dj;, Send me
	Else IfEqual key0,eup, Send me
	
	Else IfEqual key0,dfj, Send be
	Else IfEqual key0,eru, Send be
	
	Else IfEqual key0,afk, Send if
	Else IfEqual key0,qri, Send if
	
	Else IfEqual key0,sdl, Send do
	Else IfEqual key0,weo, Send do
	
	Else IfEqual key0,asd, Send we
	Else IfEqual key0,qwe, Send we
	
	Else IfEqual key0,sjl, Send us
	Else IfEqual key0,wuo, Send us


   Else {
      L := %key%
      SendRaw %L%                      ; send last pressed key
     ;SentTick = 0xFFFFFFFF            ; uncomment for no auto repeat undefined combos
   }
Return
