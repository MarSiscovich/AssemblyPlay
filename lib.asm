.8086
.model small
.stack 100h
.data
		errorCarga 		db "error en la carga",0dh,0ah,24h
		cantidadCaracteres 	db 0
		direccionTexto 		dw 00
		caracteres 		db ("0123456789ABCDEF")
		ok 		   	db 0
		modo		  	db 0 			; 0, TEXTO
								; 1, DEC
								; 2, HEX
								; 3, BIN 
	;Datos del Juego
		ancho_pantalla DW 115h             ; the width of the window (320 pixels)
		altura_pantalla DW 0C8h            ; the height of the window (200 pixels)
		bandas_pantalla DW 6               ; variable used to check collisions early
		
		origenX DW 0A0h  ;posiciones de origen          DONDE SE RESETEA AL CHOCAR
		origenY DW 00Ah                                 

		;pelota santi
		posX		  DW 0A0h	;columna  (centrado)
		posY		  DW 64h	;fila     (centrado)
		tamanioPelota DW 04h	;4 pixeles de alto y ancho

		speedX	DW 05h	;velocidad horizontal (innecesario para nuestro caso)
		speedY	DW 02h	;velocidad vertical
		
		cocodrilo_x DW 87h                  ; current X position of the left paddle
		cocodrilo_y DW 0B2h                 ; current Y position of the left paddle

		ancho_cocodrilo DW 20h              ; default paddle width
		altura_cocodrilo DW 14h             ; default paddle height
		velocidad_cocodrilo DW 16h          ; default paddle velocity

		volver_menu DB "0"
		tiempo_aux DB 0   
		puntos_texto DB '0000','$'         ; text with the player two points
		scoreTitle db "SCORE: ", 24h
		vidas db ' x5',24h
		heart db 03h, 24h
		
		MenuPausa 	db "",0dh,0ah
					db "",0dh,0ah
					db "     ________ _______ _____  ____________________",0dh,0ah
					db "     ___  __ \___    |__  / / /__  ___/___  ____/",0dh,0ah
					db "     __  /_/ /__  /| |_  / / / _____ \ __  __/   ",0dh,0ah
					db "     _  ____/ _  ___ |/ /_/ /  ____/ / _  /___   ",0dh,0ah
					db "     /_/      /_/  |_|\____/   /____/  /_____/   ",0dh,0ah
					db "                                                 ",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "       1: RESUME",0dh,0ah
					db "",0dh,0ah
					db "       2: RETRY ",0dh,0ah
					db "",0dh,0ah
					db "       3: MAIN MENU",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah,24h
		opcionPausa db "x",24h

.code

	public carga 	; Carga caracteres en RAM 
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
	public random		; PROCESO ALEATORIO - Devuelve en AL un número del 0 al 9 usando los milisegundos del la función TIME$
	public imprimir
	public moverCursorIzq
	public pruebaColor
	public limpiarPantalla
	public moverCocodrilo
	public limpiar 
	public dibujarInterfaz
	public dibujarCocodrilo
	public muevoPelota
	public posicionInicial
	public dibujoPelota
	public MENUPAUSE
	extrn EXIT_GAME:proc
	extrn resume:proc
	
	;==========================================================================
	
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

	;==========================================================================

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
	
	;==========================================================================

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
	
	;==========================================================================
	
	random proc 		; PROCESO ALEATORIO - Devuelve en AL un número del 0 al 9 usando los milisegundos del la función TIME$	
		push cx
		push dx

		mov ah, 2ch
		int 21h
		xor ax, ax
		mov al, dl
		mov cl, 0ah
		div cl
		xor ah, ah

		pop dx
		pop cx
		ret
	random endp

	;==========================================================================

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

	;==========================================================================

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

	;==========================================================================

  	dibujoPelota proc 
		
		mov cx, posX	;columna
		mov dx, posY	;fila

		dibujoH:	;a través de las columnas
			mov ah, 0Ch	;configuración para dibujar un pixel
			mov al, 0Fh	;color blanco
			mov bh, 00h
			int 10h 		;ejecuto

			inc cx
			mov ax, cx
			sub ax, posX
			cmp ax, tamanioPelota
		jng dibujoH

		mov cx,posX		;columna inicial
		inc dx			;avanza línea

		mov ax, dx
		sub ax, posY
		cmp ax, tamanioPelota
		jng dibujoH

		ret
	dibujoPelota endp

	;==========================================================================

	posicionInicial proc
		mov ax, origenX
		mov posX, ax

		mov ax, origenY
		mov posY, ax


		ret
	posicionInicial endp

	;==========================================================================

	muevoPelota proc
	;---SI LLEGA A LOS BORDES LATERALES, SE CAMBIA LA DIRECCION X
		mov ax, speedX
		add posX, ax        ;velocidad X

		mov ax, bandas_pantalla
		cmp posX, ax        ;posX < 0 + bordes
		jl negSpeedX

		mov ax, ancho_pantalla
		sub ax, tamanioPelota   ;posX > bordes- tamanioPelota
		sub ax, bandas_pantalla
		cmp posX, ax
		jg negSpeedX

		mov ax, speedY
		add posY, ax        ;velocidad Y

		;chequeo si la pelota pasó el borde inferior

		mov ax, altura_pantalla
		sub ax, tamanioPelota   ;RESETEO POSICION SI TOCA
		sub ax, bandas_pantalla          ;EL BORDE INFERIOR
		cmp posY, ax
		jg resetPos

		chequeoColision:        ;colisión con paddle
		mov ax, posX
		add ax, tamanioPelota
		cmp ax, cocodrilo_x
		jng noColision

		mov ax, cocodrilo_x
		add ax, ancho_cocodrilo
		cmp posX, ax
		jnl noColision

		mov ax, posY
		add ax, tamanioPelota
		cmp ax, cocodrilo_y
		jng noColision

		mov ax, cocodrilo_y
		add ax, altura_cocodrilo
		cmp posY, ax
		jnl noColision

		;si llegó acá, hubo colisión
		jmp resetPos
		
		noColision:
		ret

		resetPos:
		call posicionInicial
		ret
		
		negSpeedX:
		neg speedX
		ret
	muevoPelota endp

	;==========================================================================

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

	;==========================================================================

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
			call MENUPAUSE
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
	
	;==========================================================================
	
	MENUPAUSE proc 
			MOV AH,00h                  ; set the configuration to video mode
			MOV AL,02h                  ; choose the video mode
			INT 10h                     ; execute the configuration
			
			mov bh, 0     ; Página de video (normalmente 0)
			push bx
			mov dh, 0     ; Fila
			mov dl, 0     ; Columna
			push dx

			call moverCursorIzq

			call limpiarPantalla
			;---------prueba color-------
			mov bh, 10
			push bx
			mov ch, 0							; Punto inicial hacia abajo
			mov cl, 0							; Punto inicial hacia la derecha
			push cx
			mov dh, 50							; Filas 
			mov dl, 80 							; Columnas
			push dx
			call pruebaColor
			;---------fin prueba---------

			mov bx, offset MenuPausa
			push bx
			call imprimir
			
			mov bh, 0  				
			push bx					
			mov dh, 8 				
			mov dl, 8 				
			push dx					 
			call moverCursorIzq ;Mueve el cursor al final del programa

			cargas:
		;---------carga de la opcion---------¿
			mov bx, offset opcionpausa
			mov dl, 1
			mov ah, 1
			call carga
		;---------fin de la carga de la opcion---------

		;---------limpiado de pantalla--------
			; Mueve el cursor a la esquina superior izquierda

			mov bh, 0     ; Página de video (normalmente 0)
			push bx
			mov dh, 0     ; Fila
			mov dl, 0     ; Columna
			push dx
			call moverCursorIzq

			call limpiarPantalla
		;---------fin limpiado----------------

		;---------Comparaciones----------------
		menuComp:
			cmp opcionpausa, '1'
			je Eresumen

			cmp opcionpausa, '2'
			je Ereset
			

			cmp opcionpausa, '3'
			je Ereset
			

			jmp cargas
			Eresumen:
			call resume
			Ereset:
			call resetear
		ret
	MENUPAUSE ENDP
	 
resetear PROC
    ; Inicializar puntos_texto con '0000'
    MOV SI, OFFSET puntos_texto
    MOV CX, 4
    MOV AL, '5'
    REPEAT_POINTS:
        MOV [SI], AL
        INC SI
        LOOP REPEAT_POINTS
	; Inicializar la caida desde el techo
	mov origenX, 0A0h
	mov origenY, 00Ah

    ; Inicializar posX, posY, speedX y speedY con valores específicos
    MOV posX, 0A0h
    MOV posY, 64h
    MOV speedX, 05h
    MOV speedY, 02h

    ; Inicializar cocodrilo_x y cocodrilo_y con valores específicos
    MOV cocodrilo_x, 87h
    MOV cocodrilo_y, 0B2h

    ; Inicializar vidas con ' x5'
    MOV SI, OFFSET vidas
    MOV byte ptr [SI + 2], '0'

    ; Inicializar heart con 03h (carácter de corazón)
    MOV heart, 03h

    ; Verificar la opción de pausa y llamar a la función correspondiente
    CMP opcionpausa, '2'
    JE Eresume
    CMP opcionpausa, '3'
    JE Eexit
    JMP Eexit ; En caso de que la opción no sea 2 ni 3, salir directamente
	Eresume:
		CALL resume
	Eexit:
		CALL EXIT_GAME
    RET
resetear ENDP
	
	;==========================================================================

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
			LEA DX,heart    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
			INT 21h                          ;print the string
			
			MOV AH,02h                       ;set cursor position
			MOV BH,00h                       ;set page number
			MOV DH,17h                       ;set row 
			MOV DL,24h						 ;set column
			INT 10h		
			
			MOV AH,09h                       ;WRITE STRING TO STANDARD OUTPUT
			LEA DX,vidas    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
			INT 21h                          ;print the string
			
			RET
	dibujarInterfaz ENDP

	;==========================================================================

	limpiar PROC               		; clear the screen by restarting the video mode

		MOV AH,00h                    ; set the configuration to video mode
		MOV AL,13h                    ; choose the video mode
		INT 10h                       ; execute the configuration

		MOV AH,0Bh                    ; set the configuration
		MOV BH,00h                    ; to the background color
		MOV BL,00h                    ; choose black as background color
		INT 10h                       ; execute the configuration

		RET
	limpiar ENDP

	;==========================================================================

	limpiarPantalla proc
		mov ah, 0fh
		int 10h

		mov ah, 0
		int 10h

		ret

	limpiarPantalla endp

	;==========================================================================
end
