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
		puntos db 0
		ancho_pantalla DW 115h             ;  (320 pixels)
		altura_pantalla DW 0C8h            ;  (200 pixels)
		bandas_pantalla DW 6               ; 
		
		origenX DW 0A0h  ;posiciones de origen          DONDE SE RESETEA AL CHOCAR
		origenY DW 00Ah                                 

		;pelota santi
		posX		  DW 0A0h	;columna  (centrado)
		posY		  DW 05h	;fila     (centrado)
		tamanioPelota DW 04h	;4 pixeles de alto y ancho

		speedX	DW 05h	;velocidad horizontal (innecesario para nuestro caso)
		speedY	DW 02h	;velocidad vertical
		
		;----cocodrilo julian
		PADDLE__X DW 84h            
		PADDLE__Y DW 0B1h            


		PADDLE_WIDTH DW 1Fh                                  

		CROCO_INICIO_X DW 00h            
		CROCO_INICIO_Y DW 00h                      
  
		CROCO_BOCA_X DW 00h
		CROCO_BOCA_Y DW 00h

		ancho_cocodrilo DW 1Fh              
		altura_cocodrilo DW 13h              
		velocidad_cocodrilo DW 12h 
		;----

		volver_menu DB "0"
		tiempo_aux DB 0   
		puntos_texto DB '000','$'         
		scoreTitle db "SCORE: ", 24h
		vidas1 db ' x',24h
		vidas2 db '1',24h
		heart db 03h, 24h
		textogameover 	db "",0dh,0ah
						db "",0dh,0ah
						db "",0dh,0ah
						db "",0dh,0ah
						db "",0dh,0ah
						db "",0dh,0ah
						db "",0dh,0ah
						db "                 _______      ___      .___  ___.  _______ ",0dh,0ah
						db "                /  _____|    /   \     |   \/   | |   ____|",0dh,0ah
						db "               |  |  __     /  ^  \    |  \  /  | |  |__   ",0dh,0ah
						db "               |  | |_ |   /  /_\  \   |  |\/|  | |   __|  ",0dh,0ah
						db "               |  |__| |  /  _____  \  |  |  |  | |  |____ ",0dh,0ah
						db "                \______| /__/     \__\ |__|  |__| |_______|",0dh,0ah
						db "                                                             ",0dh,0ah
						db "                 ______   ____    ____  _______ .______      ",0dh,0ah
						db "                /  __  \  \   \  /   / |   ____||   _  \     ",0dh,0ah
						db "               |  |  |  |  \   \/   /  |  |__   |  |_)  |    ",0dh,0ah
						db "               |  |  |  |   \      /   |   __|  |      /     ",0dh,0ah
						db "               |  `--'  |    \    /    |  |____ |  |\  \----.",0dh,0ah
						db "                \______/      \__/     |_______|| _| `._____|",0dh,0ah
	
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "       2: RETRY ",0dh,0ah
					db "",0dh,0ah
					db "       3: MAIN MENU",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah,24h

		
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
	ORG 100h
	seed DD 0 ; Semilla para la generación de números aleatorios

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
	public IMP_PIXEL
	public gameover
	extrn EXIT_GAME:proc
	extrn resume:proc
	
	;==========================================================================
	
	gameover proc
			MOV AH,00h                  ; SET CONFIGURACION DE VIDEO
			MOV AL,02h                  ; MODO DE VIDEO
			INT 10h                     ; 
			
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

			mov bx, offset textogameover
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
	gameover endp
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
	
	random proc 	
		mov ah, 2ch
		int 21h
		xor ax, ax
		mov al, dl
		mov cl, 0ah
		div cl
		xor ah, ah

		cmp al, 0
		je es0
		cmp al, 1
		je es1
		cmp al, 2
		je es2
		cmp al, 3
		je es3
		cmp al, 4
		je es4
		cmp al, 5
		je es5
		cmp al, 6
		je es6
		cmp al, 7
		je es7
		cmp al, 8
		je es8
		cmp al, 9
		je es9
		es0:
		mov origenX, 027h
		ret
		es1:
		mov origenX, 032h
		ret
		es2:
		mov origenX, 096h
		ret
		es3:
		mov origenX, 078h
		ret
		es4:
		mov origenX, 055h
		ret
		es5:
		mov origenX, 043h
		ret
		es6:
		mov origenX, 035h
		ret
		es7:
		mov origenX, 09h
		ret
		es8:
		mov origenX, 07h
		ret
		es9:
		mov origenX, 03h

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
	;--
		mov ax, speedY
		add posY, ax        ;velocidad Y

		;chequeo si la pelota pasó el borde inferior

		mov ax, altura_pantalla
		sub ax, tamanioPelota   ;RESETEO POSICION SI TOCA
		sub ax, bandas_pantalla        ;EL BORDE INFERIOR
		cmp posY, ax
		jg cagaste

		chequeoColision:        ;colisión con paddle
		mov ax, posX
		add ax, tamanioPelota
		cmp ax, PADDLE__X 
		jng noColision

		mov ax, PADDLE__X  
		add ax, ancho_cocodrilo
		cmp posX, ax
		jnl noColision

		mov ax, posY
		add ax, tamanioPelota
		cmp ax, PADDLE__Y
		jng noColision

		mov ax, PADDLE__Y
		add ax, altura_cocodrilo
		cmp posY, ax
		jnl noColision

		;si llegó acá, hubo colisión
		;+1 punto
		inc puntos
		mov bx, offset puntos_texto
		mov dl, puntos
		call regtoascii
		inc speedx
		jmp resetPos
		noColision:
		ret
		cagaste:
			call GameOver
		resetPos:
			call posicionInicial
			ret
		negSpeedX:
			neg speedX
			ret
	muevoPelota endp

	;==========================================================================
	
	posicionInicial proc
		mov origenX, ax
		mov ax, origenX
		mov posX, ax

		mov ax, origenY
		mov posY, ax

		ret
	posicionInicial endp

	;==========================================================================

	moverCocodrilo PROC               
		
		MOV AH,01h
		INT 16h
		JZ finMovimiento 

		MOV AH,00h
		INT 16h

		cmp AL,70h
		je volverr
		cmp al,50h 
		je volverr
		jmp seguirr
		volverr:
			call MENUPAUSE
		seguirr:
		; 'a' or 'A' para mover izquierda
		CMP AL,61h ; 'a'
		JE moverIzquierda
		CMP AL,41h ; 'A'
		JE moverIzquierda

		; 'd' or 'D' para mover derecha
		CMP AL,64h ; 'd'
		JE moverDerecha
		CMP AL,44h ; 'D'
		JE moverDerecha
		JMP finMovimiento

	MoverIzquierda:
		CALL limpiar
		MOV AX,velocidad_cocodrilo
		SUB PADDLE__X,AX

		MOV AX,bandas_pantalla
		CMP PADDLE__X,AX
		JL arreglarPosicionIzq
		JMP finMovimiento

		arreglarPosicionIzq:
			MOV PADDLE__X,AX
			JMP finMovimiento

	moverDerecha:
		CALL limpiar
		MOV AX,velocidad_cocodrilo
		ADD PADDLE__X,AX

		MOV AX,ancho_pantalla
		SUB AX,bandas_pantalla
		SUB AX,ancho_cocodrilo
		CMP PADDLE__X,AX
		JG ArreglarPosicionDer
		JMP finMovimiento

		ArreglarPosicionDer:
			MOV PADDLE__X,AX

		finMovimiento:

		RET
	moverCocodrilo ENDP

	;==========================================================================

	dibujarCocodrilo PROC

		;;;;;;
		;;;DIBUJO PADDLE
		;;;;;;

		MOV CX, PADDLE__X        ; columna inicial (x)
		MOV DX, PADDLE__Y        ; fila inicial (y)

		DRAW_PADDLE:
		
			CALL IMP_PIXEL
			INC CX
									
        	MOV AX, CX
			SUB AX, PADDLE__X          
			CMP AX, PADDLE_WIDTH      
			JNG DRAW_PADDLE

		MOV CX, PADDLE__X         
		MOV DX, PADDLE__Y        

		ADD CX, 0Dh
		INC DX

		;;GUARDO POSICION DE INICIO DE COCODRILO
		MOV CROCO_INICIO_X, CX 
		MOV CROCO_INICIO_Y, DX 
		;;

		CALL IMP_PIXEL

		INC CX 
		CALL IMP_PIXEL

		INC CX 
		CALL IMP_PIXEL

		INC CX 
		CALL IMP_PIXEL

		INC CX 
		CALL IMP_PIXEL

		INC CX 
		CALL IMP_PIXEL

		INC CX 
		CALL IMP_PIXEL

		INC CX
		INC DX
		CALL IMP_PIXEL

		INC CX
		INC DX
		CALL IMP_PIXEL

		INC DX
		CALL IMP_PIXEL

		INC DX
		CALL IMP_PIXEL

		INC DX
		CALL IMP_PIXEL

		INC DX
		CALL IMP_PIXEL

		INC DX
		CALL IMP_PIXEL

		;;;;;;
		;GUARDO LA POSICION PARA DESPUES DIBUJAR LA BOCA
		;;;;;;

		MOV CROCO_BOCA_X, CX
		MOV CROCO_BOCA_Y, DX
		;;;;;

		;;;;;
		INC DX 
		DEC CX
		CALL IMP_PIXEL

		INC DX 
		DEC CX
		CALL IMP_PIXEL

		INC DX 
		DEC CX
		CALL IMP_PIXEL

		;;;;;
		DEC CX
		CALL IMP_PIXEL

		DEC CX
		CALL IMP_PIXEL

		DEC CX
		CALL IMP_PIXEL

		DEC CX
		CALL IMP_PIXEL

		;;;;;
		DEC CX 
		DEC DX
		CALL IMP_PIXEL

		DEC CX 
		DEC DX
		CALL IMP_PIXEL

		DEC CX 
		DEC DX
		CALL IMP_PIXEL
		;;;;;

		DEC DX
		CALL IMP_PIXEL

		DEC DX
		CALL IMP_PIXEL

		DEC DX
		CALL IMP_PIXEL

		DEC DX
		CALL IMP_PIXEL

		DEC DX
		CALL IMP_PIXEL
		;;;;;

		INC CX
		DEC DX
		CALL IMP_PIXEL

		;;;;;;
		;COMIENZO DIBUJADO INTERIOR
		;;;;;;

		;;;;;;
		;OJO IZQUIERDO
		;;;;;;

		MOV CX, CROCO_INICIO_X
		MOV DX, CROCO_INICIO_Y

		ADD CX, 01h 
		ADD DX, 02h
		CALL IMP_PIXEL

		INC DX
		CALL IMP_PIXEL

		INC CX 
		CALL IMP_PIXEL 

		INC DX
		CALL IMP_PIXEL 

		;;;;;;
		;OJO DERECHO
		;;;;;;

		ADD CX, 02h
		CALL IMP_PIXEL 

		DEC DX 
		CALL IMP_PIXEL 

		INC CX 
		CALL IMP_PIXEL 

		DEC DX 
		CALL IMP_PIXEL 

		;;;;;;
		;BOCA DE IZQUIERDA A DERECHA
		;;;;;;

		MOV CX, CROCO_BOCA_X
		MOV DX, CROCO_BOCA_Y

		DEC CX
		DEC DX
		CALL IMP_PIXEL

		INC DX 
		DEC CX
		CALL IMP_PIXEL

		INC DX 
		DEC CX
		CALL IMP_PIXEL

		;;;;;
		DEC CX
		CALL IMP_PIXEL

		DEC CX
		CALL IMP_PIXEL

		DEC CX
		CALL IMP_PIXEL

		DEC CX
		CALL IMP_PIXEL

		;;;;;
		DEC CX 
		DEC DX
		CALL IMP_PIXEL

		DEC CX 
		DEC DX
		CALL IMP_PIXEL

		DEC CX 
		DEC DX
		CALL IMP_PIXEL

		ret


	dibujarCocodrilo ENDP
	
	;==========================================================================

	IMP_PIXEL PROC

		MOV AH,0Ch                    
		MOV AL,0Fh                    
		MOV BH,00h                    
		INT 10h

		RET

	IMP_PIXEL ENDP 
	
	;==========================================================================
	
	MENUPAUSE proc 
			MOV AH,00h                  
			MOV AL,02h                 
			INT 10h                     
			
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

			cargas2:
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
		menuComp2:
			cmp opcionpausa, '1'
			je Eresumen2

			cmp opcionpausa, '2'
			je Ereset2
			

			cmp opcionpausa, '3'
			je Ereset2
			

			jmp cargas
			Eresumen2:
			call resume
			Ereset2:
			call resetear
		ret
	MENUPAUSE ENDP
	
	;==========================================================================
	 
	resetear PROC
		; Inicializar puntos_texto con '0000'
		MOV SI, OFFSET puntos_texto
		MOV CX, 3
		MOV AL, '0'
		REPEAT_POINTS:
			MOV [SI], AL
			INC SI
			LOOP REPEAT_POINTS
		; Inicializar la caida desde el techo
		mov origenX, 0A0h
		mov origenY, 00Ah

		; Inicializar posX, posY, speedX y speedY con valores específicos
		MOV posX, 0A0h
		MOV posY, 05h
		MOV speedX, 05h
		MOV speedY, 02h

		; Inicializar cocodrilo_x y cocodrilo_y con valores específicos
		MOV PADDLE__X, 84h
		MOV PADDLE__Y, 0B1h

		; Inicializar vidas con ' x1'
		MOV SI, OFFSET vidas2
		MOV byte ptr [SI + 2], '1'

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
		;       
			
			MOV AH,02h                      
			MOV BH,00h                      
			MOV DH,01h                      
			MOV DL,1dh						
			INT 10h							 
			
			MOV AH,09h                       
			LEA DX,scoreTitle   
			INT 21h                          

			MOV AH,02h                       
			MOV BH,00h                      
			MOV DH,01h                       
			MOV DL,23h						 
			INT 10h							 
			
			MOV AH,09h                      
			LEA DX,puntos_texto    
			INT 21h                          
			
			MOV AH,02h                       
			MOV BH,00h                      
			MOV DH,17h                       
			MOV DL,23h						
			INT 10h		
			
			MOV AH,09h                       
			LEA DX,heart    
			INT 21h                         
			
			MOV AH,02h                       
			MOV BH,00h                     
			MOV DH,17h                       
			MOV DL,24h						 
			INT 10h		
			
			MOV AH,09h                       
			LEA DX,vidas1    
			INT 21h                          
			
			MOV AH,02h                      
			MOV BH,00h                      
			MOV DH,17h                      
			MOV DL,23h						 
			INT 10h

			MOV AH,09h                       
			LEA DX,vidas2    
			INT 21h                         
			
			RET
	dibujarInterfaz ENDP
	
	regtoascii proc  	; Recibe en bx el offset de una variable de 3 bytes, y el numero a convertir por dl no mayor a 255
		push ax
		push dx

		add bx,2
		xor ax,ax
		mov al, dl
		mov dl, 10
		div dl
		add [bx],ah

		xor ah,ah
		dec bx
			div dl
		add [bx],ah

		xor ah,ah
		dec bx
			div dl
		add [bx],ah

		pop dx
		pop ax

		ret
	regtoascii endp

	;==========================================================================

	limpiar PROC               		; limpia la pantalla reseteando el modo de video

		MOV AH,00h                  
		MOV AL,13h                   
		INT 10h                      

		MOV AH,0Bh                    
		MOV BH,00h                   
		MOV BL,00h                    
		INT 10h                      

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
