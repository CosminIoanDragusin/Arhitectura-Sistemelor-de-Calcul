.model large
.stack 200h


date segment
Old_08 label dword
Old_08_off dw ? ;offsetul vechii rutine
Old_08_seg dw ? ;segmentul vechii rutine
count db ? ;contorul ce va fi afi?at

 sunet struc
 nota:dw ?
 durata:dw ?
ends sunet

vector sunet<190,400 ms>,<213,300 ms>,<179,350 ms>,<225,300 ms>,<239,300 ms>,<253,300 ms>,<284, 300 ms>

date ends
.code

; Programul principal.
;*************************************************************************
start: xor al,al ;ini?ializarea contorului

mov cs:count,al
mov ax,3508h ;citirea vectorului ini?ial al ?ntreruperii
int 21h ;timer sistem
mov cs:Old_08_off,bx ;salvarea offsetului ob?inut
mov cs:Old_08_seg,es ;salvarea segmentului ob?inut
mov ax,cs ;setarea noului vector
mov ds,ax
mov dx,offset New_08 ;pe func?ia New_08
mov ax,2508h
int 21h
mov ah,0 ;a?teptarea unei taste
int 16h
mov ax,cs:Old_08_seg ;setarea vectorului ?napoi
mov ds,ax ;pe vechea rutin?
mov dx,cs:Old_08_off
mov ax,2508h
int 21h
mov ax,4c00h ;terminarea programului
int 21h

;*************************************************************************
; Procedura: New_08
; Descriere: Noua ?ntrerupere de timer sistem.
; Parametri: Nu are.
;*************************************************************************
New_08 proc far

mov al,cs:count ;citirea contorului
push ax ;salvarea ?n stiv?
add al,&#39;0&#39; ;formarea codului ASCII
mov ah,0eh ;pentru afi?are se folose?te func?ia

0eh

mov bx,0 ;a ?ntreruperii 10h
int 10h
pop ax ;refacerea contorului
inc al ;incrementarea contorului

cmp al,0ah ;a ajuns la 10?
jne next
xor al,al ;resetarea contorului
next: mov cs:count,al ;refacerea valorii variabilei
pushf ;necesar pentru apelul vechii rutine
call cs:Old_08 ;apelul vechii rutine
iret ;revenirea din ?ntrerupere

New_08 endp
end start


;*************************************************************************
; Procedura: sound
; Descriere: Genereaz? un sunet de o anumit? frecven?? pe o perioad?
; nelimitat? de timp.
; Parametri: Prime?te ?n registrul BX frecven?a dorit?.
;*************************************************************************
sound proc far
mov ax, 34DDh ;?ncarc? ?n dx:ax valoarea hexa a frecven?ei
tactului
mov dx, 0012h ;aplicat canalului 2 al circuitului 8253
div bx ;?mparte la frecven?a dorit? pentru a ob?ine
constanta
mov bx,ax ;salveaz? constanta
in al, 61h ;cite?te canal de date port B 8255
test al, 03h ;verific? cei mai pu?in semnificativi bi?i
jne sound1 ;dac? sunt pe 1 sare
or al, 03h ;daca nu sunt pe 1 ?i face 1
out 61h, al ;d? drumul la sunet
mov al, 0B6h ;cuv?nt de comand? 8253: canal 2, mod 3, binar
out 43h, al ;scriere cuv?nt de comand?
sound1: mov al, bl ;cel mai pu?in semnificativ octet
out 42h, al ;trimite octet canal 2
mov al, bh ;cel mai semnificativ octet
out 42h, al ;trimite octet canal 2
ret ;ie?ire din procedur?
sound endp
;*************************************************************************
; Procedura: nosound
; Descriere: Opreste sunetul.
; Parametri: Nu are.
;*************************************************************************
nosound proc far
in al, 61h ;cite?te canal de date port B 8255
and al, 0FCh ;reseteaz? cei mai pu?in semnificativi 2 bi?i
out 61h, al ;scrie ?napoi octet
ret ;revenire
nosound endp