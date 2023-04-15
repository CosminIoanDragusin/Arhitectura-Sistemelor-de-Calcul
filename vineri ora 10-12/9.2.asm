.model small
.stack 100h
.data
    NrColoane dw 300
    NegUnu  db  -1
    oldmode db ?  
    x0      db  50
    x1      db  120
    y0      db  20
    y1      db  35
 
    AddX1   db  ?
    AddX2   db  ?
    AddY1   db  ?
    AddY2   db  ?
    numPixels   db  ?
    addNum      db  ?
    deltax      db  ?
    deltay      db  ?
    denom       db  ?
    num         db  ?
    currentX    db  ?
    currentY    db  ?
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
    push dx
    push cx
    push es
    push di
    push ax
    mov ax,0A000h        
    mov es,ax        
    pop ax
    mov di,ax        
    mov ax,bx 
    push dx          
    mul NrColoane       
    add di,ax        
    pop dx           
    mov [es:di],dl 
    pop di
    pop es
    pop cx
    pop dx
    pop bx
    pop ax
    ret
PutPixel endp
 
Getch proc near
    mov ah,0
    int 16h
    ret
Getch endp
 
DeseneazaLinie proc near
 
    mov currentX,al
    mov currentY,bl
 
    cmp al,ah
    ja ContX1   
    jb ContX2    
    mov AddX1,0
    mov AddX2,0
    jmp FinishXCompare 
ContX1:
     
    mov AddX1,-1
    mov AddX2,-1
    jmp FinishXCompare
ContX2:
     
    mov AddX1,1
    mov AddX2,1
FinishXCompare:
    cmp bl,bh
    ja ContY1
    jb ContY2
    mov AddY1,0
    mov AddY2,0
    jmp FinishYCompare
ContY1:
     
    mov AddY1,-1
    mov AddY2,-1
    jmp FinishYCompare
ContY2:
     
    mov AddY1,1
    mov AddY2,1
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
    jns FinishNegDY  
    mov al,bl
    imul NegUnu  
    mov deltay,al
FinishNegDY:
    pop bx
    pop ax
    mov al,deltax
    mov bl,deltay
    cmp al,bl
    jb DXLDY     
 
    mov numPixels,al
    mov addNum,bl
    mov denom,al
    mov num,bl
    mov AddX1,0
    mov AddY2,0
    jmp Incepe
DXLDY:
     
    mov numPixels,bl
    mov addNum,al
    mov denom,bl
    mov num,al
    mov AddX2,0
    mov AddY1,0
Incepe:
    mov cl,numPixels
    mov dl,4
    mov al,currentX
    mov bl,currentY
FOR_LINIE:
    mov ah,0
    mov bh,0
    call PutPixel
     
    push ax
    push bx
 
    mov al,num
    add al,addNum
    mov num,al
     
    mov al,num
    cmp al,denom
    jb Continua   
     
    mov al,num
    sub al,denom
    mov num,al
     
    pop bx
    pop ax
    add al,AddX1
    add bl,AddY1
    
 
    push ax
    push bx
    
Continua:

     
    pop bx
    pop ax
    
    add al,AddX2
    add bl,AddY2
    
    dec cx
    cmp cx,0
    jne FOR_LINIE
    
    ret

 
start:

    mov ax,@data
    mov ds,ax
    call GetVideoMode  
    mov oldmode,al
    mov al,13h  
    call SetVideoMode
    mov al,x0
    mov bl,y0
    mov ah,x1
    mov bh,y1
    mov dl,7  
    call DeseneazaLinie
    call Getch  
    mov al,oldmode
    call SetVideoMode  
    mov ax,4c00h  
    int 21h
    
end start
 