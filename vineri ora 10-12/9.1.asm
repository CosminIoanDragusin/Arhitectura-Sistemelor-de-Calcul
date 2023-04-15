.model small
.stack 100h
.data
oldmode db ?                     
 
x0      db 150
x1      db 100
y0      db 200  
y1      db 100
doi     db 2                     
Adx0    db ?
Adx1    db ?
Ady0    db ?
Ady1    db ?

nrPixels        db ?                     
deltax          db ?
deltay          db ?

curentx         db ?
curenty         db ?

.code

SetVideoMode proc near
mov ah,00h
int 10h
ret
SetVideoMode endp

GetVideoMode proc near
mov ah,0Fh
int 10h
ret
GetVideoMode endp

PutPixel proc near
push ax                      
push bx
push cx
push dx
push es
push dx                          
push ax                          
push bx
mov dx,03Ceh                         
mov ax,0001h
out dx,ax
mov ax,0003h                     
out dx,ax
mov al,05h                   
out dx,al
mov dx,03CFh
in al,dx                         
and al,0FCh                          
out dx,al                        
pop ax                          
pop bx
mov cl,bl                       
mov dx,80                       
mul dx                          
shr bx,1                        
shr bx,1
shr bx,1
add bx,ax                        
mov ax,0A000h                    
mov es,ax                        
mov ax,cx
and cl,7                         
xor cl,7                         
mov ah,1                         
shl ah,cl
mov dx,03Ceh                         
mov al,8
out dx,ax                        
mov cx,4                         
mov ah,01h                       
pop dx                           
ppet0:
push dx                          
mov dx,03C4h                 
mov al,02h                       
out dx,ax                        
mov al,byte ptr es:[bx]              
pop dx                       
mov al,dl
and al,ah                    
jnz ppet1
xor al,al                    
jmp ppet2
ppet1:
mov al,0FFh                          
ppet2:
mov byte ptr es:[bx],al                  
shl ah,1                         
loop ppet0                   
pop es                       
pop dx
pop cx
pop bx
pop ax
ret
PutPixel endp

Getch proc near
mov ah,0
int 16h
ret
Getch endp

 

Draw proc near
    mov curentx,al
    mov curenty,bl
    cmp al,ah
    ja ContX1    
    jb ContX2    
    mov Adx0,0
    mov Adx1,0
    jmp FinishXCompare
ContX1:
    mov Adx0,-1
    mov Adx1,-1
    jmp FinishXCompare
ContX2:
    mov Adx0,1
    mov Adx1,1
FinishXCompare:
    cmp bl,bh
    ja ContY1
    jb ContY2
    mov Ady0,0
    mov Ady1,0
    jmp FinishYCompare
ContY1:
    mov Ady0,-1
    mov Ady1,-1
    jmp FinishYCompare
ContY2:
    mov Ady0,1
    mov Ady1,1
FinishYCompare:
    push ax  
    push bx  
    mov bl,ah 
    mov bh,0
    mov ah,0
    sub ax,bx
    mov deltax,al
    pop bx
    pop ax
    push ax  
    push bx  
    mov al,bh
    mov ah,0
    mov bh,0
    sub bx,ax
    mov deltay,bl
    pop bx  
    pop ax  
    mov al,deltax  
    mov bl,deltay  
    cmp al,bl
    jb DXLDY     
 
    mov numPixels,al
    mov Adx0,0
    mov Ady1,0
    jmp Incepe
DXLDY:
     
    mov numPixels,bl
    mov Adx1,0
    mov Ady0,0
Incepe:
    mov cl,numPixels
    mov dl,4
    mov al,curentx
    mov bl,curenty
FOR_LINIE:
    mov ah,0
    mov bh,0
    call PutPixel
     
    push ax
    push bx
    mov al,deltay
    mul doi
    mov deltay,al
    mov al,deltay
    cmp al,deltax
    jb Continua   
 
    mov al,deltay
    sub al,deltax
    mov deltay,al
     
    pop bx
    pop ax
    add al,Adx0
    add bl,Ady0
 
    push ax
    push bx
    Continua:
    pop bx
    pop ax
    add al,Adx1
    add bl,Ady1
    dec cx
    cmp cx,0
    jne FOR_LINIE
    ret
Draw endp

                         

start:
mov ax,@data
mov ds,ax
call GetVideoMode                    
mov oldmode,al
mov al,12h                       
call SetVideoMode
    mov al,x0
    mov bl,y0
    mov ah,x1
    mov bh,y1
    mov dl,8 ;culoarea
    call Draw                    
call Getch                       
mov al,oldmode
call SetVideoMode                    
mov ax,4c00h                         
int 21h
end start