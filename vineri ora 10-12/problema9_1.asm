;**********************************************************************
.model small
.stack 100h
.data
oldmode db ? ;va stoca modul video precedent
.code
;**********************************************************************
; Procedura: SetVideoMode
; Descriere: Setarea unui mod video.
; Parametri: al - modul video.
;**********************************************************************
SetVideoMode proc near
mov ah,00h
int 10h
ret
SetVideoMode endp
;**********************************************************************
; Procedura: GetVideoMode
; Descriere: Citirea modului video curent.
; Parametri: Returneaza in al modul video.
;**********************************************************************
GetVideoMode proc near
mov ah,0Fh
int 10h
ret
GetVideoMode endp
;**********************************************************************
; Procedura: PutPixel
; Descriere: Afisarea unui pixel de o anumita culoare.
; Parametri: ax,bx - coordonatele de afisare;
; dl - culoarea;
;**********************************************************************
PutPixel proc near
push al ;salvarea registrilor folositi
push bl
push cx
push dx
push es
push dx ;salvare culoare
push ax ;salvare coordonate
push bx
mov dx,03Ceh ;dezactivare set/reset
mov ax,0001h
out dx,al
mov ax,0003h ;registrul de rotire date
out dx,al
mov al,05h ;registrul de mod
out dx,al
mov dx,03CFh
in al,dx ;citire continut
and al,0FCh ;setare mod 0 de scriere
out dx,al ;scriere
pop ax ;restaurare inversa coordonate
pop bx
mov cl,bl ;salvare LSB al coordonatei x
mov dx,80 ;dx=numarul de octeti pe linie
mul dx ;ax=y×80
shr bx,1 ;bx=x/8
shr bx,1
shr bx,1
add bx,ax ;bx=y×80+x/8
mov ax,0A000h ;segmentul memoriei video
mov es,ax ;es:bx - adresa octetului cautat
mov ax,cx
and cl,7 ;pastreaza doar primii trei biti
xor cl,7 ;ii complementeaza
mov ah,1 ;calculul mastii
shl ah,cl
mov dx,03Ceh ;registrul de mascare biti
mov al,8
out dx,ax ;scrierea mastii
mov cx,4 ;contor plane
mov ah,01h ;valoarea initiala a mastii pentru planul activ
pop dx ;reface culoarea
ppet0:
push dx ;salvarea culorii
mov dx,03C4h ;selectarea planului
mov al,02h ;registrul 2
out dx,ax ;in ah este setat bitul corespunzator planului
mov al,byte ptr es:[bx] ;citire &quot;inutila&quot;
pop dx ;restaturarea culorii
mov al,dl
and al,ah ;bitul corespunzator din culoare este setat?
jnz ppet1
xor al,al ;avem nevoie de un bit de 0
jmp ppet2
ppet1:
mov al,0FFh ;avem nevoie de un bit de 1
ppet2:
mov byte ptr es:[bx],al ;scriere 00h sau FFh - ne bazam pe masca
shl ah,1 ;trecere la planul urmator
loop ppet0 ;inchide bucla
pop es ;restaureaza registri
pop dx
pop cx
pop bx
pop ax
ret
PutPixel endp
;**********************************************************************
; Procedura: HorizontalLine
; Descriere: Afisarea unei linii orizontale de o anumita culoare.
; Parametri: ax,bx - coordonatele de inceput;
; cx - numarul de pixeli;
; dl - culoarea;
;***********************************************************************
HorizontalLine proc near
hlet0:
call PutPixel
inc ax
cmp ax,200
je ret
loop hlet0
ret
HorizontalLine endp
;**********************************************************************
; Procedura: Getch
; Descriere: Asteptarea apasarii unei taste.
; Parametri: Nu are.
;**********************************************************************
Getch proc near
mov ah,0
int 16h
ret
Getch endp
;**********************************************************************
; Programul principal.
;**********************************************************************
start:
mov ax,@data
mov ds,ax
call GetVideoMode ;citirea modului video curent
mov oldmode,al
mov al,12h ;setarea modului grafic 12h
call SetVideoMode
mov ax,100 ;coordonata x de final
mov bx,100 ;coordonata y de final
mov cx,120 ;numarul de pixeli
mov dl,12 ;culoarea
call HorizontalLine ;trasarea liniei orizontale
call Getch ;asteptarea apasarii unei taste
mov al,oldmode
call SetVideoMode ;restaurarea modului video initial
mov ax,4c00h ;iesirea din program
int 21h
end start
;**********************************************************************