/*
last update: 20121215
scsnake@gmail.com
*/
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,off
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
SetControlDelay,-1

gui,font,s10,Verdana
gui,add,text,,Paste here:
gui,font,s8,Courier New 
gui,add,edit,r15 w800 voriginal
gui,font,s10,Verdana
gui,add,button,,Convert
gui,add,button,yp x+20,Copy
gui,add,button,x+100 yp,Reset
gui,font,s8,Courier New 
gui,add,edit,xs r15 w800 vclean HwndcleanHwnd +readonly
gui,font,s6,Verdana
gui,add,text,,scsnake@gmail.com

gui,show,,Make Lab Data Cleaner !



return

ButtonReset:
guicontrol,,original,
guicontrol,,clean,
guicontrol,focus,original
return

ButtonCopy:
gui,submit,nohide
SendMessage, 0x00B1, 0, -1,, ahk_id %cleanHwnd% ;EM_SETSEL
guicontrol,focus,clean
clipboard:=clean
return

ButtonConvert:
gui,submit,nohide
/*
o:=RegExReplace(original,"\n+","`n")
o:= "`n" o "`n"
o:=RegExReplace(o,"\n(\d{7}\s\[\d{4}\](\s+(0|(0.0)|(NORMAL)|[-%#@!=,\?\$]))*\s*\n)+","`nπ`n")
;~ traytip,,% errorlevel
o:=RegExReplace(o,"\n\s+[^\n]+\ntime\/item[^\n]+\n(π\n)+((?:\s+[^\n]+\ntime\/item)|(?:群組:)|(?:\*+[^\n]+))","`nπ`n$2")
o:=RegExReplace(o,"\n群組:[^\n]+\n(π\n)+((?:群組:)|(?:\*+[^\n]+))","`nπ`n$2")
o:=RegExReplace(o,"\n\*+[^\n]+\n(π\n)+(\*+[^\n]+)","`nπ`n$2")

o:=RegExReplace(o,"\nπ\n","`n")
o:=RegExReplace(o,"\n+","`n")
o:=RegExReplace(o,"^\n|\n$","")
*/

RegExReplace(original,"`n","",total)

pan:=(total>1)?(floor(log(total))+1):1
lab:=[],i:=0
loop,parse,original,`n 
{
     if(regexmatch(l:=RegExReplace(a_loopfield,"\s+$"),"^\s+$")||!l)
          continue
     if(regexmatch(l,"^\*+[^\*]+\*+$",match))
          labRoom:=l,labGroup:="",i++,j:=0
     else if(regexmatch(l,"^群組:",match))
          labGroup:=l,labItems:="",j++,k:=0
     else if(labGroup){
          if(regexmatch(l,"^\s{15}\S+",match))
               labItems:=l,labTitle:="",k++
          else if(labItems&&regexmatch(l,"^time\/item\s{6}\([^\n]*\)$",match))
               labTitle:=l
          else if(labTitle&&!regexmatch(l " ","i)^\d{7}\s\[\d{4|\]\s((\s*|0+(.0+)?|NORMAL|[\-@#$%\^&\*\?])\s)*$"))
               lab[fill0(i,pan) labRoom,fill0(j,pan) labGroup,fill0(k,pan) labItems "`n" labTitle]?(lab[fill0(i,pan) labRoom,fill0(j,pan) labGroup,fill0(k,pan) labItems "`n" labTitle].="`n" l):(lab[fill0(i,pan) labRoom,fill0(j,pan) labGroup,fill0(k,pan) labItems "`n" labTitle]:="000" l)
     }else if(!labGroup&&!regexmatch(l " ","i)^\d{7}\s\[\d{4|\]\s((\s*|0+(.0+)?|NORMAL|[\-@#$%\^&\*\?])\s)*$"))
          lab[fill0(i,pan) labRoom]?(lab[fill0(i,pan) labRoom].="`n" l):(lab[fill0(i,pan) labRoom]:="000" l)

}

guicontrol,,clean,% RegExReplace(RegExReplace(toStr(lab),"^[0\s]+\n+","`n"),"^\n|\n$")



return

fill0(i,n){
     while(strlen(i)<n)
          i:="0" i
     return i
}

toStr(a){
     global pan
     if(!isobject(a))
          return regexreplace(a,"^\d{" pan "}")
     
     str:=""
     for k,v in a
          str.=toStr(k) "`n" toStr(v) "`n"
     return regexreplace(str,"\n$")
}

esc::
guiclose:
exitapp


/*
*********檢驗室:B2***********
B2-1______-0______   BLOOD SITEPermcath10/9洗腎前抽血
     ID+DS Blood.#1:       Enterococcus faecalis


----------------------------------------------
Antibiotic               1 
----------------------------------------------
Ampicillin               S 
Ciprofloxacin            S 
Gentamicin120μg          S 
Penicillin  G            S 
Tetracycline             R 
Teicoplanin              S 
Vancomycin               S 

B2-1______-0______   BLOOD SITEperipheral
     ID+DS Blood.#1:       Enterococcus faecalis


----------------------------------------------
Antibiotic               1 
----------------------------------------------
Ampicillin               S 
Ciprofloxacin            I 
Gentamicin120μg          S 
Penicillin  G            S 
Tetracycline             R 
Teicoplanin              S 
Vancomycin               S 

B2-1______-0______   BLOOD SITEPeripheral10/9洗腎前抽
     ID+DS Blood.#1:       No aerobic&anaerobic pathogens

B2-1______-0______   BLOOD SITEPermcath星期四洗腎前抽
     ID+DS Blood.#1:       Enterococcus faecalis


----------------------------------------------
Antibiotic               1 
----------------------------------------------
Ampicillin               S 
Ciprofloxacin            I 
Gentamicin120μg          S 
Penicillin  G            S 
Tetracycline             R 
Teicoplanin              S 
Vancomycin               S 


*********檢驗室:B3***********
B3-1______-0______   RANDOM URINE SITEVoided urine 七
     ID+DS Urine #1:       No aerobic pathogens


*********檢驗室:PO***********

群組:

               Sugar(One to  uch)         
time/item      (*)          
1______ [1629] 180          
1______ [0437] 162          
1______ [1619] 208          
1______ [0414] 148          
1______ [1640] 172          
1______ [0425] 146          
1______ [1831] 144          
1______ [0411] 155          
1______ [1612] 139          
1______ [0405] 130          
1______ [1632] 96           
1______ [0409] 116          
1______ [1612] 141          
1______ [0411] 125          
1______ [1706] 158          
1______ [0407] 134          
1______ [1616] 142          
1______ [0358] 128          
1______ [1615] 135          
1______ [0411] 127          
1______ [1635] 147          
1______ [0423] 135          
1______ [1633] 159          
1______ [0421] 127          
1______ [1617] 129          
1______ [0404] 122          
1______ [1629] 139          
1______ [0418] 153          
1______ [1607] 132          
1______ [0406] 118          
1______ [1655] 144          
1______ [0415] 141          
1______ [1639] 111          
1______ [0404] 137          
1______ [1628] 168          
1______ [0415] 117          
1______ [1707] 148          
1______ [0410] 180          
*********檢驗室:HE***********

群組:CBC+PLT

               WBC           RBC           HB            HCT           MCV          
time/item      (K/μL)        (M/μL)        (g/dL)        (%)           (fL)         
1______ [0727] 17.55         2.90          8.4           25.3          87.2          
1______ [0802] 12.45         3.51          10.0          32.5          92.6         
               MCH           MCHC          PLT           RDW-CV        PS           
time/item      (pg)          (g/dL)        (K/μL)        (%)           ()           
1______ [0727] 29.0          33.2          293           16.0          -            
1______ [0802] 28.5          30.8          211           17.2          -            
群組:WBC D/C

               Blast         Promyl.       Myelo.        Meta          Band         
time/item      (%)           (%)           (%)           (%)           (%)          
1______ [0727] 0.0           0.0           1.9           0.0           0.0          
1______ [0802] 0.0           0.0           0.0           0.0           0.0          
               Seg           Eos.          Baso.         Mono.         Lym.         
time/item      (%)           (%)           (%)           (%)           (%)          
1______ [0727] 94.3          0.0           0.0           0.9           2.9          
1______ [0802] 82.3          1.2           0.3           9.5           6.7          
               Aty.Lym.      PlasmaCell    Normobl.      PS           
time/item      (%)           (%)           ()            ()           
1______ [0727] 0.0           0.0           0             -            
1______ [0802] 0.0           0.0           0             -            
*********檢驗室:BC***********

群組:General BioChemistry

               Alb           ALT           Na            K             Cl           
time/item      (g/dL)        (U/L)         (mmol/L)      (mmol/L)      (mmol/L)     
1______ [0727] 2.8           415           125           4.1           92           
1______ [0802] 3.1           55            134           4.1                        
               Ca            P             CRP          
time/item      (mmol/L)      (mg/dL)       (mg/dL)      
1______ [0727] 2.04          4.9           6.01         
1______ [0802]                             2.79         
群組:Hormones

               Free T4(CIA)  hsTSH(CIA)    Cortisol DL   ACTH                       
time/item      (ng/dL)       (μIU/mL)      (μg/dL)       (pg/mL)      
1______ [0746]                             22.7          34.2         
1______ [0814] 1.08          3.24                                     
群組:TDM

               Vancomycin   
time/item      (μg/mL)      
1______ [0727] 86.69        
1______ [0805] 13.61        
*********檢驗室:RL***********

群組:WBC Classification

               Blast         Promyl.       Myelo.        Meta          Band         
time/item      (%)           (%)           ()            (%)           (%)          
1______ [1510] 0.0           0.0           0.0           0.0           0.0          
1______ [0753] 0.0           0.0           0.0           0.0           0.0          
1______ [0828] 0.0           0.0           0.0           0.0           0.0          
               Seg           Eos.          Baso.         Mono.         Lym.         
time/item      (%)           (%)           (%)           (%)           (%)          
1______ [1510] 81.4          1.0           0.2           7.9           9.5          
1______ [0753] 82.4          1.4           0.2           5.8           10.2         
1______ [0828] 75.6          1.6           0.3           8.7           13.8         
               Aty.Lym.      PlasmaCell    Normobl.      PS           
time/item      (%)           (%)           ()            ()           
1______ [1510] 0.0           0.0           0             -            
1______ [0753] 0.0           0.0           0             -            
1______ [0828] 0.0           0.0           0             -            
群組:CBC+PLT

               WBC           RBC           HB            HCT           MCV          
time/item      (K/μL)        (M/μL)        (g/dL)        (%)           (fL)         
1______ [1510] 11.49         2.74          7.8           24.1          88.0         
1______ [0753] 11.10         3.51          10.1          31.4          89.5         
1______ [0828] 8.92          3.35          9.6           30.9          92.2         
               MCH           MCHC          PLT           PS           
time/item      (pg)          (g/dL)        (K/μL)        ()           
1______ [1510] 28.5          32.4          252           -            
1______ [0753] 28.8          32.2          261           -            
1______ [0828] 28.7          31.1          223           -            
群組:General BioChemistry

               UA(B)         ALB           ALT          
time/item      (mg/dL)       (g/dL)        (U/L)        
1______ [1510] 7.1           2.5           41           
1______ [0753]               2.7           104          
1______ [0828]               2.9           23           
群組:Biochemistry

               UN            Na            K             Cl            T-BIL        
time/item      (mg/dL)       (mmole/L)     (mmole/L)     (mmole/L)     (mg/dL)      
1______ [1510]               126           3.5           95            0.53         
1______ [0753] 37.0          132           3.9           98            0.78         
1______ [0828] 46.7          134           3.8                                      
               Ca            P             AST           LacticAcid   
time/item      (mmole/L)     (mg/dL)       (U/L)         (mmole/L)    
1______ [1510] 1.86          3.9                         1.1          
1______ [0753] 1.99          3.4           69                         
1______ [0828]                                                        
群組:Yes

               C-Reactive P  rotein       
time/item      (mg/dL)      
1______ [1510] 7.97         
1______ [0753] 3.04         
1______ [0828] 4.21         
*********檢驗室:OP***********

群組:STOOL

               O.B.         
time/item      (*)          
1______ [0816] -            
*********檢驗室:B2***********
B2-1______-0______   BLOOD SITEPeripheral
     ID+DS Blood.#1:       Enterococcus faecalis


----------------------------------------------
Antibiotic               1 
----------------------------------------------
Ampicillin               S 
Ciprofloxacin            S 
Gentamicin120μg          S 
Penicillin  G            S 
Tetracycline             R 
Teicoplanin              S 
Vancomycin               S 

B2-1______-0______   BLOOD SITEPeripheral
     ID+DS Blood.#1:       Enterococcus faecalis


----------------------------------------------
Antibiotic               1 
----------------------------------------------
Ampicillin               S 
Ciprofloxacin            S 
Gentamicin120μg          S 
Penicillin  G            S 
Tetracycline             R 
Teicoplanin              S 
Vancomycin               S 


*********檢驗室:PO***********

群組:

               Sugar(One to  uch)         
time/item      (*)          
1______ [2216] 30           
1______ [0009] 95           
1______ [0257] 27           
1______ [0430] 56           
1______ [0856] 31           
1______ [1048] 50           
1______ [1351] 93           
1______ [1801] 33           
1______ [2146] 51           
1______ [0108] 185          
1______ [0111] 155          
1______ [0405] 141          
1______ [0902] 223          
1______ [1204] 186          
1______ [1854] 153          
1______ [2205] 250          
1______ [0405] 270          
1______ [1016] 248          
1______ [1655] 258          
1______ [2211] 252          
1______ [0402] 190          
1______ [1228] 192          
1______ [2251] 177          
1______ [0404] 149          
1______ [1253] 164          
1______ [2117] 201          
1______ [0359] 143          
*********檢驗室:RL***********

群組:SEDIMENT

               RBC(S)        WBC(S)        EpithCell(S)  Cast(S)       Crystal(S)                 
time/item      (/HPF)        (/HPF)        (/HPF)        (/LPF)        (*)          
1______ [0556] 0 - 2         2 - 5         0 - 2         -             -            
1______ [1431] 0-2           5-10          -             -             Amo-urate(2+  )            
               Others(S)     Bacteria     
time/item      (*)           (*)          
1______ [0556] -             1+           
1______ [1431] -             +            
群組:MULTISTIX

               Sp. Gr.(C)    pH(C)         Protein(C)    Glu.(C)       Ketones(C)   
time/item      (*)           (*)           (mg/dL)       (mg/dL)       (*)          
1______ [0556] 1.012         5.5           300 ( 3+ )    30 ( +/- )    -            
1______ [1431] 1.012         5.5           300 ( 3+ )    100 ( 1+ )    -            
               O.B.(C)       Urobil.(C)    Bil.(C)       Nitrite(C)    WBC(C)       
time/item      (*)           (mg/dL)       (*)           (*)           (*)          
1______ [0556] -             NORMAL        -             -             -            
1______ [1431] -             NORMAL        -             -             -            
               Color         Turbidity    
time/item      (*)           (*)          
1______ [0556] Yellow        Cloudy       
1______ [1431] Yellow        +            
群組:Blood pH/Gas

               PH            PCO2          PO2           HCO3          BaseExcess   
time/item      (*)           (mmHg)        (mmHg)        (mEq/l)       (mEq/l)      
1______ [1942] 7.355         41.8          37.0          23.6          -2.2         
群組:General BioChemistry

               ALT          
time/item      (U/L)        
1______ [2028] 254          
1______ [1327] 117          
群組:Biochemistry

               UN            CRE           Na            K             CK           
time/item      (mg/dL)       (mg/dL)       (mmole/L)     (mmole/L)     (U/L)        
1______ [2028] 24.9          3.8           133           4.1           46           
1______ [1327] 34.5          4.1           126           3.6                        
               CK-MB         %CKMB         Troponin I   
time/item      (U/L)         (%)           (ng/mL)      
1______ [2028] 13.9          30.2          0.651        
1______ [1327]                                          
群組:WBC Classification

               Blast         Promyl.       Myelo.        Meta          Band         
time/item      (%)           (%)           ()            (%)           (%)          
1______ [2028] 0.0           0.0           0.0           0.0           0.0          
1______ [1327] 0.0           0.0           0.0           0.0           0.0          
               Seg           Eos.          Baso.         Mono.         Lym.         
time/item      (%)           (%)           (%)           (%)           (%)          
1______ [2028] 84.9          0.9           0.1           7.8           6.3          
1______ [1327] 85.7          0.8           0.2           6.0           7.3          
               Aty.Lym.      PlasmaCell    Normobl.      PS           
time/item      (%)           (%)           ()            ()           
1______ [2028] 0.0           0.0           0             -            
1______ [1327] 0.0           0.0           0             -            
群組:CBC+PLT

               WBC           RBC           HB            HCT           MCV          
time/item      (K/μL)        (M/μL)        (g/dL)        (%)           (fL)         
1______ [2028] 12.78         3.11          9.1           28.7          92.3         
1______ [1327] 11.85         2.87          8.4           25.7          89.5         
               MCH           MCHC          PLT           PS           
time/item      (pg)          (g/dL)        (K/μL)        ()           
1______ [2028] 29.3          31.7          158           -            
1______ [1327] 29.3          32.7          136           -            
群組:Yes

               pro-BNP      
time/item      (pg/mL)      
1______ [2028] >35000       
群組:Coagulation

               PT            PT Cont       PTT           PT INR       
time/item      (sec)         (sec)         (sec)         ()           
1______ [2028] 13.0          11.4          33.0          1.24         

*/
