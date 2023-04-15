.model large
.stack 100h
.code
Old_08 label dword
Old_08_off dw ?
Old_08_seg dw ?
note dw 1EEh, 188h, 126h, 14Ah, 106h, 1B8h, 354h, 354h, 1EEh, 188h, 126h, 14Ah, 106h, 1B8h, 1EEh
durata dw 6,4,4,6,8,6,8,6,6,4,6,4,8,8,8


index_note dw ?
counter_durata dw ?
start: 
        
        mov ax,3508h
        int 21h
        mov cs:Old_08_off,bx
        mov cs:Old_08_seg,es
        
        mov ax,cs
        mov ds,ax
      
        mov dx,offset New_08
        mov ax,2508h
        int 21h
        
afisare_char:  
        mov al,'j'
        mov ah,0eh        
        mov bx,0
        int 10h
        mov al, 0
        
        mov ah,0
        int 16h
        cmp al,0
      
        jz afisare_char        
               
         
        mov ax,cs:Old_08_seg
        mov ds,ax
        mov dx,cs:Old_08_off
        mov ax,2508h
        int 21h
        mov ax,4c00h
        int 21h
        
        
New_08 proc far
        push ax
        push bx
        push cx
        push dx
        mov si,cs:index_note
        sub cs:counter_durata,1h
        cmp cs:counter_durata,0
        jg old
        call cs:nosound
        lea bx, cs:note
        mov cx,cs:[bx+si]
        lea bx, cs:durata
        mov dx,cs:[bx+si]
        mov bx,cx
        mov cs:counter_durata,dx       
        call cs:sound
        add si,02h
        cmp si,1ch
        jng old
        mov si,0h
old:    mov cs:index_note,si     
        pushf
        call cs:Old_08
        pop dx
        pop cx 
        pop bx
        pop ax
        iret
   New_08 endp
   
sound proc far
        
        mov ax,34DDh   
        mov dx,0012h
        div bx
        mov bx,ax
        in al,61h
        test al,03h
        jne sound1
        or al,03h
        out 61h,al
        mov al,0b6h
        out 43h,al
sound1:mov al,bl
        out 42h,al
        mov al,bh
        out 42h,al
     
        ret
sound endp

nosound proc far
    in al,61h
    and al,0FCh
    out 61h,al
    ret
nosound endp        

end start   