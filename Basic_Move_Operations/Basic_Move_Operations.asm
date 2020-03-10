;MOV INSTRUCTION EXAMPLES FOR ALL REGISTERS AND MEMORY
.MODEL 64

.DATA    

    X DB 15h
    Y DW 01F0h
    Z DW 0000h   
    ARRAY DW 0005h,00010h,0015h,0020h 
    
    2D_ARRAY DB 01h,02h,03h,04h
    DB 05h,06h,07h,08h
    DB 09h,10h,11h,12h
    DB 13h,14h,15,16h
    

.STACK    
    
.CODE

MAIN PROC FAR
   
   ; MOV INSTANT DATA TO REG 
   
   ; REGISTERS THAT ALLOW DIRECT DATA INITIALIZATION : AX,BX,CX,DX,
   MOV AX,0012h
   MOV BX,2000h
   MOV CX,3020h  
   MOV DX,0F00h   
   MOV SI,4020h 
   MOV DI,0A200h 
   ; EMULATOR SOMETIMES CAN GIVE AN ERROR ( PUTTING 0 TO BEGINNING OF YOUR NUMBER CAN SOLVE THIS PROBLEM
   ; EXAMPLE (FFh => 0FFh, FFFFh => 0FFFFh)   
   ;--------------------------
   
   ; REGISTERS THAT DONT ALLOW DIRECT DATA INITIALIZATION : DS,SS,ES,CD
   
   ; TO SOLVE THIS PROBLEM WE FIRST USE GENERAL REGISTERS ( AX,BX,CX,DX )
   ; AND MOVE TO SEGMENTS
   
   MOV AX,1025h
   MOV DS,AX
   MOV SS,AX
   MOV ES,AX 
                                                                   
   ; MOV ES,DS ; -> NOT ALLOWED ( YOU HAVE TO USE GENERAL REGISTERS )     
   ;--------------------------
   
   ; MOVE REG TO REG
   MOV AX,BX
   MOV CX,AX
   MOV DX,AX
   MOV AX,DS
   MOV ES,AX  
   ;-------------------------- 
   
   ;MOVE MEMORY TO REG 
   
   
   ; WITHOUT IMITIALIZING DATA SEGMENT, YOU CANT USE MEMORY
   ; INITIALIZING DATA SEGMENT
   MOV AX,@DATA
   MOV DS,AX
   ; -------------------------
   
   MOV BX,offset X ; IT'S LIKE POINTER IN C
   MOV AL,[BX] ; GET THE VALUE WHERE BX POINTED
   ; BE CAREFUL DATA X IS BYTE, YOU HAVE TO MOVE IT AN 8 bit Register.
   ; YOU ALLOWED TO USE BX,DI,SI FOR DATA SEGMENT
   
   LEA DI,Y ; (MOV DI, offset Y) SAME THING
   MOV CX,[DI]
   
   
   ; IMITATE ARRAYS {C}
   
   LEA SI,ARRAY;
   
   MOV AX,[SI] 
   
   MOV BX,[SI+2] ; WE HAVE TO DEAL WITH WORD, SO WE ADD 2 TO REACH NEXT ITEM
   
   ADD SI,2
   MOV CX,[SI]  
   ; YOU HAVE TO SEE SAME NUMBER IN BX AND CX
   ADD SI,2
   MOV DX,[SI]
               
   ; YOU CAN USE LOOP TO MAKE THIS PROCESS EASY 
   
   ;2D ARRAYS
        
   MOV AX,0; STANDS FOR Y
   MOV CX,0; STANDS FOR X 
   MOV SI,4; STANDS FOR NUMBER OF ELEMENTS IN A ROW
   
   LEA BX,2D_ARRAY ; LOAD STARTING ADDRESS OF 2D_ARRAY  
   
   
   MOV AX,1
   MOV CX,1 
   ; GET 2D_ARRAY[Y][X] = 2D_ARRAY[1][1] = 06h
    
   MUL SI ; CALCULATING ROW ADDRESS
   MOV DI,BX   ; STARTING ADDRESS
   ADD DI,AX   ; ADDING COLUMN ADDRESS
   ADD DI,CX
   MOV DL,[DI]
   
   ;--------------------------
   
   ; MOVE REG TO MEMORY
    
   ; WITHOUT IMITIALIZING DATA SEGMENT, YOU CANT USE MEMORY
   ; INITIALIZING DATA SEGMENT
   MOV AX,@DATA
   MOV DS,AX
   ; -------------------------
   
   MOV BX,offset Y
   MOV [BX],0FFFFh 
              
   MOV CX,25FFh           
   MOV [BX],CX
   
    
    
    
MAIN ENDP

MOV AH, 0    ; EXIT INTERRUPT TO RETURN BIOS
INT 21H