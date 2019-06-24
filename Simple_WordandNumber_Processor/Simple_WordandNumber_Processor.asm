.MODEL 64


.DATA
    NUMBERS DB 2h,5h,20h,19h,75h,2Ah,01h,0,7h,'$'
    MSG DW "Enter Your String : $"
    MSG2 DW "SELECT ONE PROCESS :",0Ah,0Dh,'------------------------------------------',0Ah,0Dh,"A) Number Operations ",0Ah,0Dh,'------------------------------------------',0Ah,0Dh,'1) Unsigned Find Lowest',0Ah,0Dh,'2) Unsigned Find Greatest',0Ah,0Dh,'3) Unsigned Sorting',0Ah,0Dh,"4) Signed Sorting",0Ah,0Dh,'------------------------------------------',0Ah,0Dh,"B) String Operations ",0Ah,0Dh,'------------------------------------------',0Ah,0Dh,'1) Upper2Lower',0Ah,0Dh,'2) Lower2Upper',0Ah,0Dh,'3)Work Both',0Ah,0Dh,'------------------------------------------',0Ah,0Dh,"(Enter the Number of Process (EX:A1))",0Ah,0Dh,'$'
    MSG3 DW 'RESULT IS : $' 
    MSG4 DW 'Select One Option',0Ah,0Dh,'1) Lowest to Greatest',0Ah,0Dh,'2) Greatest to Lowest',0Ah,0Dh,'$'
    ERR1 DB  0Ah,0Dh,'------------------------------------------',"!!! Please Enter a Number !!!",0Ah,0Dh,'------------------------------------------',0Ah,0Dh,'$'
    ERR2 DB 0Ah,0Dh,'------------------------------------------',0Ah,0Dh,"!!! Please Enter Correct OPCODE !!!",0Ah,0Dh,'------------------------------------------',0Ah,0Dh,'$'
    ERR3 DB 0Ah,0Dh,'------------------------------------------',0Ah,0Dh,"!!! Operation not found !!!",0Ah,0Dh,'------------------------------------------',0Ah,0Dh,'$'
    DATA1 DW 128 DUP(0)

.STACK
    DW   128  dup(0)


.CODE
MAIN PROC FAR
    MOV BX,@data
    MOV DS,BX
    
    CALL FUNC
    CALL CLRSCREEN
    ;----ROUTING TO THE OPERATION----
    CMP BH,'A'
    JZ NUMOP
    CMP BH,'B'
    JZ STROP    

NUMOP:
    CMP BL,1
    JZ UFindLowest
    CMP BL,2
    JZ UFindGreatest
    CMP BL,3
    JZ USorting
    CMP BL,4
    JZ Sorting
    
    JMP PASS1

    
STROP:
    CALL MENUSTR
            
    MOV SI,offset DATA1
    CALL scanf
    CMP BL,1
    JZ upper2lower
    CMP BL,2
    JZ lower2upper
    CMP BL,3
    ;JZ upperandlower
    JZ upperandlower_easy    
PASS1:
    
    CALL printf
PASSNUM:
    
    mov ax, 4c00h
    int 21h  
                 
MAIN ENDP
 
scanf PROC 
    
    MOV AH,01
    
L1: 
    INT 21h
    MOV [SI],AL
    INC SI
    CMP AL,0Dh ; Check Carriage Return
    JNZ L1
;----ADD $ FINISH TO THE STRING----
    DEC SI
    MOV [SI],'$'
;----NEW LINE----
    MOV AH,02
    MOV DL,0Ah
    INT 21h
    MOV DL,0Dh
    INT 21h
    ret
scanf ENDP

MENUSTR PROC
    MOV DX,offset MSG
    
    MOV AH,09H; PRINTS Data on DS:DX
    INT 21h
    MOV AH,02
    MOV DL,0Ah
    INT 21h
    MOV DL,0Dh
    INT 21h
    
    ret
MENUSTR ENDP

FUNC PROC
 F1:
    MOV DX,offset MSG2
    MOV AH,09H; PRINTS Data on DS:DX
    INT 21h
    
    MOV AH,01
    
    INT 21h
    CMP AL,41h
    JB ERROR2
    CMP AL,42h
    JA ERROR2
    MOV BH,AL
    INT 21h
    CMP AL,30h
    JB ERROR1
    CMP AL,39h 
    JA ERROR1
    SUB AL,30h
    MOV BL,AL
    
    JMP LASTCHECK
FIN:    
    ret
FUNC ENDP

CLRSCREEN PROC
    MOV AH,0
    MOV AL,2
    INT 10h

    ret
CLRSCREEN ENDP 
   
   
printf PROC
L2: 
    MOV AH,09H
    MOV DX,offset MSG3    
    INT 21h
    MOV DX,offset DATA1
    INT 21h
    ret
printf ENDP

 
upper2lower PROC
    MOV BX,offset DATA1
HEAD:              
   
    MOV DX,[BX]
    CMP DX,'$' ; CHECK FINISH
    JZ PASS1
    CMP [BX],61h ;ASCII CODE OF a IS 61h
    JAE LW1
    INC BX
    JMP HEAD
    
LW1:

    SUB DX,20h ; SUBB 20h stand for a-20h = A
    MOV [BX],DX
    INC BX
    JMP HEAD
    
    JMP PASS1
upper2lower ENDP



lower2upper PROC
    MOV BX,offset DATA1
HEAD2:              
   
    MOV DX,[BX]
    CMP DX,'$' ; CHECK FINISH
    JZ PASS1
    CMP [BX],61h ;ASCII CODE OF a IS 61h
    JB LW2
    INC BX
    JMP HEAD2
    
LW2:

    ADD DX,20h ; ADD 20h stand for A+20h = a
    MOV [BX],DX
    INC BX
    JMP HEAD2
 
  
    JMP PASS1         
lower2upper ENDP

upperandlower PROC ;METHOD 1(HARD) JUST WANT TO SHOW HOW YOU CAN USE STACK
    MOV BX,offset DATA1
    MOV CX,0
HEAD3:    
    MOV DX,[BX]
    CMP DX,'$'
    JZ PASS2
    CMP [BX],61h
    JB LW3
    INC BX
    JMP HEAD3

LW3:

    PUSH BX
    INC CX
    INC BX
    JMP HEAD3
    
PASS2:

    MOV BX,offset DATA1
HEAD5:              
   
    MOV DX,[BX]
    CMP DX,'$' ; CHECK FINISH
    JZ HEAD4
    CMP [BX],61h ;ASCII CODE OF a IS 61h
    JAE LW4
    INC BX
    JMP HEAD5
    
LW4:

    SUB DX,20h ; ADD 20h stand for A+20h = a
    MOV [BX],DX
    INC BX
    JMP HEAD5


    
HEAD4:
    POP BX
    MOV DX,[BX]
    ADD DX,20h
    MOV [BX],DX
    LOOP HEAD4
    JMP PASS1         
upperandlower ENDP

upperandlower_easy PROC ;METHOD 2(VERY EASY)
    
    MOV BX,offset DATA1
    
HEAD6:
    
    MOV DL,[BX]
    XOR DL,20h ; IT WILL CHANGE UPPER TO LOWER,LOWER TO UPPER. CHECK IT WITH YOUR HAND
    MOV [BX],DL
    INC BX
    CMP [BX],'$'
    JNZ HEAD6
    
    JMP PASS1         
upperandlower_easy ENDP

UFindLowest PROC
    MOV BX,offset NUMBERS
    MOV DL,0FFh
HEAD7:
    CMP [BX],'$'
    JZ PASSNUM
    CMP DL,[BX]
    JB PASSL
    MOV DL,[BX]
PASSL:
    INC BX    
    JMP HEAD7
    
    JMP PASSNUM
UFindLowest ENDP

UFindLowest_Sort PROC
    MOV BX,offset NUMBERS
    MOV DL,0FFh
HEAD10:
    CMP [BX],'$'
    JZ PASSNUM
    CMP DL,[BX]
    JB PASSL2
    MOV DL,[BX]
PASSL2:
    INC BX    
    JMP HEAD10
    
    JMP PASSNUM
UFindLowest_Sort ENDP
   
UFindGreatest PROC
    MOV BX,offset NUMBERS
    MOV DL,0 

    
HEAD8:
    CMP [BX],'$'
    JZ PASSNUM
    CMP DL,[BX]
    JA PASSU
    MOV DL,[BX]
PASSU:
    INC BX
    INC CX    
    JMP HEAD8
    
    
    JMP PASSNUM
UFindGreatest ENDP

UFindGreatest_Sort PROC
    MOV BX,offset NUMBERS
    MOV DX,0
    MOV AX,0
    
HEAD9:
    CMP [BX],'$'
    JZ DEL1
    CMP DL,[BX]
    JA PASSU2
    MOV DL,[BX]
    MOV AX,BX

PASSU2:
    INC BX
      
    JMP HEAD9
    
DEL1:
    
    MOV BX,AX
    PUSH DX
    MOV [BX],0
    JMP BACK1  
UFindGreatest_Sort ENDP

USorting PROC
    MOV DX,offset MSG4
    MOV AH,09H; PRINTS Data on DS:DX
    INT 21h
    MOV AH,01
    INT 21h
    SUB AL,30h;ASCII TO NUMBER 
    MOV BX,offset NUMBERS
    MOV CX,0
    
    MOV BX,offset NUMBERS
    
LP1:    

    CMP [BX],'$'    
    JZ L2G1
    INC BX
    INC CX
    JMP LP1
    
LPF:
   
    CMP [BX],'$'    
    JZ G2L1
    INC BX
    INC CX
    JMP LPF
    
    
L2G1:
    DEC CX
    MOV AH,02
    MOV DL,0Ah
    INT 21h
    MOV DL,0Dh
    PUSH DX
    
LOOPL2G1:    
    CALL UFindGreatest_Sort
BACK1:
    DEC CX
    POP BX
    MOV DL,[BX]
    MOV AH,02
    INT 21h
    MOV DL,' '
    INT 21h
    LOOP LOOPL2G1

    
    JMP FN2
G2L1:

  
    
    
FN2: 
    POP DX
    MOV AH,02
    
    JMP PASSNUM
USorting ENDP


Sorting PROC
    MOV DX,offset MSG4
    MOV AH,09H; PRINTS Data on DS:DX
    INT 21h
    MOV BX,offset NUMBERS    
    
    
    JMP PASSNUM
Sorting ENDP
     
   
ERROR1:
    MOV DX,offset ERR1
    MOV AH,09H; PRINTS Data on DS:DX
    INT 21h
    JMP F1
ERROR2:
    MOV DX,offset ERR2
    MOV AH,09H; PRINTS Data on DS:DX
    INT 21h
    JMP F1

ERROR3:
    MOV DX,offset ERR3
    MOV AH,09H; PRINTS Data on DS:DX
    INT 21h
    JMP F1

LASTCHECK:;CHECK OPERATION CODE A OR B
    CMP BH,'A'
    JZ MENU_A
    
    CMP BH,'B'
    JZ MENU_B
    
    
MENU_A:;CHECH OPCODE IS TRUE AND AVAIBLE
  CMP BL,4
  JA ERROR3
  JMP FIN
MENU_B:;CHECH OPCODE IS TRUE AND AVAIBLE
  CMP BL,3
  JA ERROR3
  JMP FIN
  
  
  
END MAIN