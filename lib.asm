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
	cocodrilo_x 		DW 87h                  ; current X position of the left paddle
	cocodrilo_y 		DW 0B2h                 ; current Y position of the left paddle
	ancho_cocodrilo 	DW 20h              ; default paddle width
	altura_cocodrilo	DW 14h             ; default paddle height
	velocidad_cocodrilo DW 0Fh          ; default paddle velocity

	ancho_pantalla 		DW 115h             ; the width of the window (320 pixels)
	altura_pantalla 	DW 0C8h            ; the height of the window (200 pixels)
	bandas_pantalla 	DW 6               ; variable used to check collisions early

	scoreTitle db "SCORE: ", 24h

	vidas db '5',24h

	heart db "x <3",24h

	puntos_texto DB '0000','$'         ; text with the player two points
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
public moverCursorIzq
public pruebaColor
public limpiarPantalla
public moverCocodrilo
public limpiar 
public dibujarInterfaz
public dibujarCocodrilo
extrn EXIT_GAME:proc

dibujarCocodrilo PROC
	MOV CX,cocodrilo_x          ; set the initial column (X)
	MOV DX,cocodrilo_y          ; set the initial line (Y)

	dibujarPixel:
	MOV AH,0Ch                    ; set the configuration to writing a pixel
	MOV AL,0Fh                    ; choose white as color
	MOV BH,00h                    ; set the page number
	INT 10h                       ; execute the configuration

	INC DX                        ; DX = DX + 1
	MOV AX,DX                     ; DX - PADDLE_LEFT_Y > PADDLE_HEIGHT (Y -> we exit this procedure, N -> we continue to the next line
	SUB AX,cocodrilo_y
	CMP AX,altura_cocodrilo
	JNG dibujarPixel

	MOV DX,cocodrilo_y          ; the DX register goes back to the initial line
	INC CX                        ; we advance one column

	MOV AX,CX                     ; CX - PADDLE__X > PADDLE_WIDTH (Y -> We go to the next line, N -> We continue to the next column
	SUB AX,cocodrilo_x
	CMP AX,ancho_cocodrilo
	JNG dibujarPixel   
	
	ret

dibujarCocodrilo ENDP

dibujarInterfaz PROC
	;       Draw the points of the right player (player two)
		
		MOV AH,02h                       ;set cursor position
		MOV BH,00h                       ;set page number
		MOV DH,01h                       ;set row 
		MOV DL,1dh						 ;set column
		INT 10h							 
		
		MOV AH,09h                       ;WRITE STRING TO STANDARD OUTPUT
		LEA DX,scoreTitle    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
		INT 21h                          ;print the string

		MOV AH,02h                       ;set cursor position
		MOV BH,00h                       ;set page number
		MOV DH,01h                       ;set row 
		MOV DL,23h						 ;set column
		INT 10h							 
		
		MOV AH,09h                       ;WRITE STRING TO STANDARD OUTPUT
		LEA DX,puntos_texto    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
		INT 21h                          ;print the string
		
		MOV AH,02h                       ;set cursor position
		MOV BH,00h                       ;set page number
		MOV DH,17h                       ;set row 
		MOV DL,23h						 ;set column
		INT 10h		
		
		MOV AH,09h                       ;WRITE STRING TO STANDARD OUTPUT
		LEA DX,vidas    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
		INT 21h                          ;print the string
		
		MOV AH,02h                       ;set cursor position
		MOV BH,00h                       ;set page number
		MOV DH,17h                       ;set row 
		MOV DL,24h						 ;set column
		INT 10h		
		
		MOV AH,09h                       ;WRITE STRING TO STANDARD OUTPUT
		LEA DX,heart    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
		INT 21h                          ;print the string
		
		RET
dibujarInterfaz ENDP

limpiar PROC                ; clear the screen by restarting the video mode

	MOV AH,00h                    ; set the configuration to video mode
	MOV AL,13h                    ; choose the video mode
	INT 10h                       ; execute the configuration

	MOV AH,0Bh                    ; set the configuration
	MOV BH,00h                    ; to the background color
	MOV BL,00h                    ; choose black as background color
	INT 10h                       ; execute the configuration

	RET
limpiar ENDP

moverCocodrilo PROC               ; process movement of the paddles
		; Left paddle movement

		; check if any key is being pressed (if not check the other paddle)
		MOV AH,01h
		INT 16h
		JZ finMovimiento ; ZF = 1, JZ -> Jump If Zero

		; check which key is being pressed (AL = ASCII character)
		MOV AH,00h
		INT 16h

		cmp AL,70h
		je volverr
		cmp al,50h ;(P y p)
		je volverr
		jmp seguirr
		volverr:
			call EXIT_GAME
		seguirr:
		; if it is 'a' or 'A' move left
		CMP AL,61h ; 'a'
		JE moverIzquierda
		CMP AL,41h ; 'A'
		JE moverIzquierda

		; if it is 'd' or 'D' move right
		CMP AL,64h ; 'd'
		JE moverDerecha
		CMP AL,44h ; 'D'
		JE moverDerecha
		JMP finMovimiento

	MoverIzquierda:
		CALL limpiar
		MOV AX,velocidad_cocodrilo
		SUB cocodrilo_x,AX

		MOV AX,bandas_pantalla
		CMP cocodrilo_x,AX
		JL arreglarPosicionIzq
		JMP finMovimiento

		arreglarPosicionIzq:
			MOV cocodrilo_x,AX
			JMP finMovimiento

	moverDerecha:
		CALL limpiar
		MOV AX,velocidad_cocodrilo
		ADD cocodrilo_x,AX

		MOV AX,ancho_pantalla
		SUB AX,bandas_pantalla
		SUB AX,ancho_cocodrilo
		CMP cocodrilo_x,AX
		JG ArreglarPosicionDer
		JMP finMovimiento

		ArreglarPosicionDer:
			MOV cocodrilo_x,AX

		finMovimiento:

		RET
	moverCocodrilo ENDP

limpiarPantalla proc
	
	mov ah, 0fh
	int 10h

	mov ah, 0
	int 10h

	ret

limpiarPantalla endp

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

moverCursorIzq proc 	; Mueve el cursor a la esquina superior izquierda
	push bp 
	mov bp, sp
	push si
	push di
	push ax
	mov si, ss:[bp+6]
	mov di, ss:[bp+4]

    mov ah, 2     		; Función 02h - Posiciona el cursor
    int 10h       		; Llama a la interrupción 10h para posicionar el cursor

    pop ax
    pop di
    pop si
    pop bp 
    ret 6
moverCursorIzq endp


pruebaColor proc 
	push bp 
	mov bp, sp
	push bx
	push si
	push di
	push ax
	mov bx, ss:[bp+8]
	mov si, ss:[bp+6]
	mov di, ss:[bp+4]

   	mov ax, 0600h
	int 10h

    pop ax
    pop di
    pop si
    pop bx
    pop bp 
    ret 8
pruebaColor endp

end

