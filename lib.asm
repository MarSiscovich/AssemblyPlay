.8086
.model small
.stack 100h
.data
	errorCarga 			db "error en la carga",0dh,0ah,24h
	cantidadCaracteres 	db 0
	direccionTexto 		dw 00
	caracteres 			db ("0123456789ABCDEF")
	ok 		   			db 0
	modo		  		db 0; 0, TEXTO
							; 1, DEC
							; 2, HEX
							; 3, BIN 

.code

public carga ; Carga caracteres en RAM 
			 ; Carga Finita DL= CANTIDAD o Infinita DL=0
			 ; Caracter de Finalizacion DH=CARACTER
			 ; 
			 ; RESTRICCIONES POR TIPO DE CARGA (BIN, HEX, DEC, TEXTO)
			 ; AH=0, TEXTO
			 ; AH=1, DEC
			 ; AH=2, HEX
			 ; AH=3, BIN
			 ;
			 ; BX offset variable a llenar
public imprimir

carga proc
		push cx
		push bx

		mov cantidadCaracteres, dl
		mov direccionTexto, bx
		mov modo, ah

	comienzaCarga:
		xor cx, cx
		cmp dl,0
		je infinita
		mov cl, cantidadCaracteres

	finita:
		mov ah, 1
		int 21h
		call checkCaracter
		cmp al, 3
		je limpia
		mov byte ptr[bx],al 
		inc bx
		loop finita
		jmp finCarga

	infinita:
		mov ah, 1
		int 21h
		cmp al, dh	
		je finInfinita
		call checkCaracter
		cmp al, 3
		je limpia
		mov byte ptr[bx],al 
		inc bx
		jmp infinita

	finInfinita:
		jmp finCarga

	limpia:

		push dx
		push ax
		mov ah, 9
		mov dx, offset errorCarga
		int 21h
		pop ax 
		pop dx
		mov bx, direccionTexto

	procLimpieza:
		cmp byte ptr[bx], 24h
		je finLimpia
		mov byte ptr[bx], 24h
		inc bx
		jmp procLimpieza

	finLimpia:
		mov bx, direccionTexto
		jmp comienzaCarga

	finCarga:
		pop bx
		pop cx
		ret

carga endp

checkCaracter proc ;RECIBE EN AL UN CARACTER y DEPENDIENDO DEL VALOR DE LA VARIBLE
					   ;MODO CHEQUEA SI ES CORRECTO EL MISMO 
		push cx 
		push si

		mov ok, 0

		cmp modo, 0 
		je finCheckCaracter
		cmp modo, 1 
		je esDec
		cmp modo, 2 
		je esHex
		cmp modo, 3 
		je esBin
	esDec:
		mov si, 0
		mov cx, 10
	checkDec:	
		cmp al, caracteres[si]
		je encontre
		inc si
	loop checkDec
		mov al, 3
		jmp finCheckCaracter

	esHex:
		mov si, 0
		mov cx, 16
	checkHex:	
		cmp al, caracteres[si]
		je encontre
		inc si
		loop checkHex
		mov al, 3
		jmp finCheckCaracter
	esBin:
		mov si, 0
		mov cx, 2
	checkBin:	
		cmp al, caracteres[si]
		je encontre
		inc si
	loop checkBin
		mov al, 3
		jmp finCheckCaracter

	encontre:
		mov ok, 1
		jmp finCheckCaracter

finCheckCaracter:
	pop si
	pop cx

	ret
	checkCaracter endp

imprimir proc
	push bp
	mov bp, sp
	push dx
	push ax
	mov dx, ss:[bp+4]

	mov ah,9
	int 21h

	pop ax
	pop dx
	pop bp
	ret 2

imprimir endp

end
