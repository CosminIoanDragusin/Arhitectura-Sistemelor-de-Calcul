
;*************************************************************************
; Procedura: sound
; Descriere: Genereaza un sunet de o anumita frecventa pe o perioada
; nelimitata de timp.
; Parametri: Primeste în registrul BX frecventa dorita.
;*************************************************************************    


.model large
.stack 100h
.code
Old_08 label dword
Old_08_off dw ? ;offsetul vechii rutine
Old_08_seg dw ? ;segmentul vechii rutine
count db ? ;contorul ce va fi afisat 



 start: xor al,al ;initializarea contorului

mov cs:count,al
mov ax,3508h ;citirea vectorului initial al întreruperii
int 21h ;timer sistem
mov cs:Old_08_off,bx ;salvarea offsetului obtinut
mov cs:Old_08_seg,es ;salvarea segmentului obtinut
mov ax,cs ;setarea noului vector
mov ds,ax
mov dx,offset New_08 ;pe functia New_08
mov ax,2508h
int 21h
mov ah,0 ;asteptarea unei taste
int 16h
mov ax,cs:Old_08_seg ;setarea vectorului înapoi
mov ds,ax ;pe vechea rutina
mov dx,cs:Old_08_off
mov ax,2508h
int 21h
mov ax,4c00h ;terminarea programului
int 21h




sound proc far
mov ax, 34DDh ;încarca în dx:ax valoarea hexa a frecventei
tactului
mov dx, 0012h ;aplicat canalului 2 al circuitului 8253
div bx ;împarte la frecventa dorita pentru a obtine
constanta
mov bx,ax ;salveaza constanta
in al, 61h ;citeste canal de date port B 8255
test al, 03h ;verifica cei mai putin semnificativi biti
jne sound1 ;daca sunt pe 1 sare
or al, 03h ;daca nu sunt pe 1 îi face 1
out 61h, al ;da drumul la sunet
mov al, 0B6h ;cuvânt de comanda 8253: canal 2, mod 3, binar
out 43h, al ;scriere cuvânt de comanda
sound1: mov al, bl ;cel mai putin semnificativ octet
out 42h, al ;trimite octet canal 2
mov al, bh ;cel mai semnificativ octet
out 42h, al ;trimite octet canal 2
ret ;iesire din procedura
sound endp  



;*************************************************************************
; Procedura: nosound
; Descriere: Opreste sunetul.
; Parametri: Nu are.
;*************************************************************************
nosound proc far
in al, 61h ;citeste canal de date port B 8255
and al, 0FCh ;reseteaza cei mai putini semnificativi 2 biti
out 61h, al ;scrie inapoi octet
ret ;revenire
nosound endp
;*************************************************************************




