.8086
.model small
.stack 100h
.data
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
				db "      - Otra instruccion xd",0dh,0ah
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
		je finprograma
	;si no se ingresa una opcion válida...
		jmp cargas

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
	jugar:
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
end
