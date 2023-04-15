MODEL SMALL 
.STACK 
.DATA 

    BUFFER_1  DB   2080 DUP(0)
    BUFFER_2  DB  208 DUP(0)
    FISIER  DB "caractereleMele.in", 0      
    HANDLE  DW  ?
    
.CODE 

    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
     
    MOV AH, 11h
    MOV AL, 12h
    MOV BL, 02h
    INT 10h;
        
    MOV AH, 11h
    MOV AL, 12h
    MOV BL, 03h
    INT 10h 
        
     
    MOV AX, 1103h        
    MOV BL, 0BH      
    INT 10h
        
         
    MOV AH, 3Dh
    MOV AL, 00h          
    LEA DX, FISIER
    INT 21h
        
    MOV HANDLE, AX
        
         
    MOV BX, AX           
    MOV AH, 3Fh                 
    MOV CX, 2080         
    LEA DX, BUFFER_1   
    INT 21H
        
         
    MOV BX, [HANDLE]
    MOV AH, 3Eh     
    INT 21h
            
        
         
    LEA SI, BUFFER_1
    LEA DI, BUFFER_2
    MOV CX,208
REPETA_1:
    PUSH CX
        
    MOV CX, 8
    MOV BX,0
    MOV AX,0
REPETA_2:
    MOV AL,BYTE PTR [SI]
    SUB AL,30H
    SHL BX,1
    ADD BL,AL
    INC SI
    LOOP REPETA_2
    MOV BYTE PTR[DI],BL
    INC SI
    INC SI
    INC DI
    POP CX 

LOOP REPETA_1
        
    LEA BP, BUFFER_2 
    MOV AH, 11h      
    MOV AL, 00h      
    MOV BH, 08H      
    MOV BL, 02h      
    MOV CX,  26      
    MOV DX, 41H      
        
    INT 10h 
            
    MOV AH, 08h              
    INT 21H
    
    MOV AX, 4C00H 
    INT 21H 
        
END     