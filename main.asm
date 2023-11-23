.8086
.model small
.stack 100h
.data
	;Datos del Juego
		ancho_pantalla DW 115h             ; the width of the window (320 pixels)
		altura_pantalla DW 0C8h            ; the height of the window (200 pixels)
		bandas_pantalla DW 6               ; variable used to check collisions early
		
		volver_menu DB "0"

		tiempo_aux DB 0   

		puntos_texto DB '0000','$'         ; text with the player two points

		scoreTitle db "SCORE: ", 24h

		vidas db '0',24h

		heart db "x <3",24h

		cocodrilo_x DW 87h                  ; current X position of the left paddle
		cocodrilo_y DW 0B2h                 ; current Y position of the left paddle

		ancho_cocodrilo DW 20h              ; default paddle width
		altura_cocodrilo DW 14h             ; default paddle height
		velocidad_cocodrilo DW 0Fh          ; default paddle velocity
	;Datos del menu y resto
		titulo		db "",0dh,0ah
					db "",0dh,0ah
					db "	  ______                             ____        __          ",0dh,0ah
					db "	 /_  __/________ _____ _____ _      / __ )____  / /___ ______",0dh,0ah			
					db "	  / / / ___/ __ `/ __ `/ __ `/_____/ __  / __ \/ / __ `/ ___/",0dh,0ah
					db "	 / / / /  / /_/ / /_/ / /_/ /_____/ /_/ / /_/ / / /_/ (__  ) ",0dh,0ah
					db "	/_/ /_/   \__,_/\__, /\__,_/     /_____/\____/_/\__,_/____/  ",0dh,0ah
					db "	               /____/                                        ",0dh,0ah,0dh,0ah,24h
					
		subt		db "              COCODRILO QUE DUERME ES CARTERA",0dh,0ah,0dh,0ah,24h

		menu		db "",0dh,0ah
					db "",0dh,0ah
					db "                             PULSE 1 PARA JUGAR",0dh,0ah
					db "",0dh,0ah
					db "                         PULSE 2 PARA INSTRUCCIONES ",0dh,0ah
					db "",0dh,0ah
					db "                            PULSE 3 PARA CREDITOS",0dh,0ah
					db "",0dh,0ah
					db "                         PULSE 4 PARA SALIR DEL JUEGO",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah,24h

		instruct		db "",0dh,0ah
					db "   ___               _                            _                          ",0dh,0ah
					db "  |_ _|  _ _    ___ | |_   _ _   _  _   __   __  (_)  ___   _ _    ___   ___ ",0dh,0ah
					db "   | |  | ' \  (_-< |  _| | '_| | || | / _| / _| | | / _ \ | ' \  / -_) (_-< ",0dh,0ah
					db "  |___| |_||_| /__/  \__| |_|    \_,_| \__| \__| |_| \___/ |_||_| \___| /__/ ",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "      - EL COCODRILO SE MUEVE CON LAS TECLAS: ('A','D')",0dh,0ah
					db "      - El OBJETIVO ES: Comerme la mayor cantidad de bolas frescas y limpias ",0dh,0ah
					db "      - Vas a perder una vida si se te cae una bola.",0dh,0ah
					db "      - Si perdes los 5 corazones fuiste, sos cartera lacoste",0dh,0ah
					db "      - En el juego presione 'P' para volver al menu de inicio.",0dh,0ah
					db "      - Otra instruccion xd",0dh,0ah
					db "      - Otra instruccion xd",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "!INGRESE CUALQUIER NUMERO PARA VOLVER AL MENU! ",0dh,0ah,24h

		creditos	db"                            _   _   _                      ",0dh,0ah               
					db"    ___   _ __    ___    __| | (_) | |_    ___    ___      ",0dh,0ah
					db"   / __| | '__|  / _ \  / _` | | | | __|  / _ \  / __|  o  ",0dh,0ah
					db"  | (__  | |    |  __/ | (_| | | | | |_  | (_) | \__ \  o  ",0dh,0ah
					db"   \___| |_|     \___|  \__,_| |_|  \__|  \___/  |___/     ",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "      -Martina (la jefa) Siscovich",0dh,0ah
					db "      -Santiago (el amante de microsoft) Rodriguez ",0dh,0ah
					db "      -Lorenzo (el proplayer de osu) Graizzaro ",0dh,0ah
					db "      -Damian (el alcoholico) Cabral",0dh,0ah
					db "      -Agustin (el esclavo del mac) Lopez ",0dh,0ah
					db "      -julian (el desamparado) barberis",0dh,0ah 
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "",0dh,0ah
					db "!INGRESE CUALQUIER NUMERO PARA VOLVER AL MENU! ",0dh,0ah,24h

		coraVacio   db "     ____         ____               ", 0dh, 0ah
					db "   _|____|_     _|____|_            ", 0dh, 0ah
					db " _|_|    |_| _ |_|    |_|_          ", 0dh, 0ah
					db "|_|         |_|         |_|         ", 0dh, 0ah
					db "|_|                     |_|         ", 0dh, 0ah
					db "|_|_                   _|_|         ", 0dh, 0ah
					db " |_|_                 _|_|           ", 0dh, 0ah
					db "   |_|_             _|_|             ", 0dh, 0ah
					db "     |_|_         _|_|               ", 0dh, 0ah
					db "       |_|_     _|_|                 ", 0dh, 0ah
					db "          |_|_|_|                     ", 0dh, 0ah
					db "            |_|                       ", 0dh, 0ah, 24h		

		cocodrilo   db "					     _ _ _           _ _ _				",0dh,0ah	
					db "					   _|_|_|_|_	    |_|_|_|_			",0dh,0ah	
					db "		       			 _|_|	  |_| _	  _|_|    |_|_			",0dh,0ah	
					db "	     _ _ _	   		|_|	_    |_|_|_|        |_|       ",0dh,0ah	
					db "	   _|_|_|_|_  		   	|_|    |_|   |_|_|_|  |_|   |_|			",0dh,0ah	
					db "	 _|_|	  |_|_ _ _ _ _ _ _ _ _ _|_|    |_|	      |_|   |_|			",0dh,0ah	
					db "  	|_|	    |_|_|_|_|_|_|_|_|_|_|_|    |_|            |_|   |_|  	",0dh,0ah	
					db " 	|_|						            |_|			",0dh,0ah	
					db " 	|_|					      		    |_|			",0dh,0ah	
					db " 	|_|       _   _   _   _	  _   _			      	    |_|			",0dh,0ah	
					db " 	|_|_    _|_|_|_|_|_|_|_|_|_|_|_|_ 			    |_|			",0dh,0ah	
					db " 	  |_|_ |_| |_| |_| |_| |_| |_| |_|			    |_|			",0dh,0ah	
					db "  	    |_|_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|_|			",0dh,0ah	
					db "          |_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|			",0dh,0ah,24h
		
		error 		db "INGRESE UNA OPCION VALIDA.",0dh,0ah,24h
		
		opcion		db "x"
;Codigo
.code

	extrn carga:proc
	extrn 
	extrn imprimir:proc
	extrn moverCursorIzq:proc
	extrn llenaBlanco:proc
	extrn pruebaColor:proc

	main proc
		mov ax, @data 
		mov ds, ax

		comienzo:
		;---------limpiado de pantalla--------
			; Mueve el cursor a la esquina superior izquierda

			mov bh, 0     ; Página de video (normalmente 0)
			push bx
			mov dh, 0     ; Fila
			mov dl, 0     ; Columna
			push dx
			call moverCursorIzq

			mov ah, 0fh
			int 10h
			mov ah, 0
			int 10h			;LIMPIEZA DE PANTALLA CONVERTIR EN LIBRERIA
		;---------fin limpiado----------------

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

		;---------impresion del menu---------
			mov bx, offset titulo
			push bx 
			call imprimir
			
			mov bh, 0  				
			push bx					
			mov dh, 8 				
			mov dl, 8 				
			push dx					 
			call moverCursorIzq ;Mueve el cursor al final del programa

			mov bx, offset subt
			push bx 
			call imprimir

			mov bx, offset menu
			push bx 
			call imprimir
		;---------fin impresion menu---------	
		cargas:
		;---------carga de la opcion---------

			mov ah, 1
			int 21h
			mov [opcion], al

		;---------fin de la carga de la opcion---------

		;---------limpiado de pantalla--------
			; Mueve el cursor a la esquina superior izquierda

			mov bh, 0     ; Página de video (normalmente 0)
			push bx
			mov dh, 0     ; Fila
			mov dl, 0     ; Columna
			push dx
			call moverCursorIzq

			mov ah, 0fh
			int 10h
			mov ah, 0
			int 10h			;LIMPIEZA DE PANTALLA CONVERTIR EN LIBRERIA
		;---------fin limpiado----------------

		;---------Comparaciones----------------
		menuComp:
			cmp opcion, '1'
			je jugar

			cmp opcion, '2'
			je instrucciones

			cmp opcion, '3'
			je creditoss
			
			cmp opcion, '4'
			je atajo
			;si no se ingresa una opcion válida...

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
			mov bx, offset error
			push bx 
			call imprimir
			jmp cargas
		;---------fin comparaciones----------------
		atajo:
		jmp finprograma
		jugar:
		CALL limpiar			; set initial video mode configurations
		jmp CHECK_TIME  
		atajo2:
		jmp comienzo
		CHECK_TIME:
		;se ve si sigue activo el juego
		ok:
			MOV AH,2Ch                 ; get the system time
			INT 21h                    ; CH = hour CL = minute DH = second DL = 1/100 seconds

			CMP DL,tiempo_aux          ; is the current time equal to the previous one(tiempo_aux)?
			JE CHECK_TIME              ; if it is the same, check again

										;clear the screen by restarting the video mode
		cmp volver_menu, "1"
		je atajo2
		CALL moverCocodrilo              ; move the two paddles (check for pressing of keys)
		CALL dibujarCocodrilo         ; draw the two paddles with the updated positions
		CALL dibujarInterfaz                 ;draw the game User Interface
		JMP CHECK_TIME                   ; after everything checks time again

		call EXIT_GAME
		jmp comienzo
		instrucciones:
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

				mov bx, offset instruct
				push bx 
				call imprimir
				mov bx, offset opcion
				push bx
				mov dl, 1
				push dx
				mov ah, 1
				push ax
				call carga
				jmp comienzo

		creditoss:
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

				mov bx, offset creditos
				push bx 
				call imprimir
				mov bx, offset opcion
				push bx
				mov dl, 1
				push dx
				mov ah, 1
				push ax
				call carga
				jmp comienzo

		finPrograma:
			mov ax, 4c00h
			int 21h
	main endp

	moverCocodrilo PROC               ; process movement of the paddles
		; Left paddle movement

		; check if any key is being pressed (if not check the other paddle)
		MOV AH,01h
		INT 16h
		JZ finMovimiento ; ZF = 1, JZ -> Jump If Zero

		; check which key is being pressed (AL = ASCII character)
		MOV AH,00h
		INT 16h

		cmp AL,70
		je volverr
		cmp al, 50 ;(P y p)
		je volverr
		jmp seguir
		volverr:
		mov dl, offset volver_menu
		mov dl, "1"
		seguir:
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

	EXIT_GAME PROC            ; goes back to the text mode

		MOV AH,00h                    ; set the configuration to video mode
		MOV AL,02h                    ; choose the video mode
		INT 10h                       ; execute the configuration

		jmp comienzo
	EXIT_GAME ENDP
end
