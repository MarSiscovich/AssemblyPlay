.8086
.model small
.stack 100h
.data
	titulo		db "	  ______                             ____        __          ",0dh,0ah
			db "	 /_  __/________ _____ _____ _      / __ )____  / /___ ______",0dh,0ah			
			db "	  / / / ___/ __ `/ __ `/ __ `/_____/ __  / __ \/ / __ `/ ___/",0dh,0ah
			db "	 / / / /  / /_/ / /_/ / /_/ /_____/ /_/ / /_/ / / /_/ (__  ) ",0dh,0ah
			db "	/_/ /_/   \__,_/\__, /\__,_/     /_____/\____/_/\__,_/____/  ",0dh,0ah
			db "	               /____/                                        ",0dh,0ah,24h

	subt		db "               COCODRILO QUE DUERME ES CARTERA                   ",0dh,0ah,0dh,0ah,24h

	menu		db "                             PULSE 1 PARA JUGAR",0dh,0ah
			db "",0dh,0ah
			db "                         PULSE 2 PARA INSTRUCCIONES ",0dh,0ah
			db "",0dh,0ah
			db "                            PULSE 3 PARA CREDITOS",0dh,0ah,0dh,0ah,24h

	opcion		db 0

	coraVacio	db "     ____         ____	 				",0dh,0ah
			db "   _|____|_     _|____|_     	        ",0dh,0ah
			db " _|_|    |_| _ |_|    |_|_				",0dh,0ah
			db "|_|         |_|         |_| 			",0dh,0ah
			db "|_|                     |_|	   			",0dh,0ah
			db "|_|_                   _|_|	     		",0dh,0ah
			db "  |_|_               _|_|    			",0dh,0ah
			db " 	|_|_           _|_|					",0dh,0ah
			db " 	  |_|_       _|_|					",0dh,0ah
			db " 	    |_|_   _|_|						",0dh,0ah
			db " 	      |_|_|_|						",0dh,0ah				
			db " 	        |_|							",0dh,0ah,24h		

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







.code

extrn carga:proc
extrn imprimir:proc
extrn moverCursor:proc
extrn llenaBlanco:proc
extrn pruebaColor:proc

main proc
	mov ax, @data 
	mov ds, ax

;---------limpiado de pantalla--------
	mov bh, 0  							; Página de video (normalmente 0)
	push bx			
	mov dh, 0 							; Fila
	mov dl, 2 							; Columna
	push dx
	call moverCursor	 				; Mueve el cursor 

    mov bh, 0     						; Página de video (normalmente 0)
   	push bx
    mov cx, 0    		 				; Número de veces que se repetirá la escritura (limpia toda la pantalla)
    push cx
    call llenaBlanco 					; Llena la pantalla con espacios en blanco
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

	mov bx, offset titulo
	push bx 
	call imprimir

	mov bh, 0  							
	push bx			
	mov dh, 8 							
	mov dl, 8 							
	push dx
	call moverCursor 					

	mov bx, offset subt
	push bx 
	call imprimir

	mov bx, offset menu
	push bx 
	call imprimir

	mov bx, offset coraVacio
	push bx 
	call imprimir

	mov bx, offset opcion
	push bx
	mov dl, 1
	push dx
	mov ah, 1
	push ax
	call carga

	;---------limpiado de pantalla--------
	mov bh, 0  							; Página de video (normalmente 0)
	push bx			
	mov dh, 0 							; Fila
	mov dl, 2 							; Columna
	push dx
	call moverCursor	 				; Mueve el cursor 
	mov bh, 0     						; Página de video (normalmente 0)
   	push bx
    mov cx, 15000		   		   		; Número de veces que se repetirá la escritura (limpia toda la pantalla)
    push cx
    call llenaBlanco 					; Llena la pantalla con espacios en blanco
;---------fin limpiado----------------

	cmp opcion, 1
	je jugar

	cmp opcion, 2
	je instrucciones

	je creditos

jugar:
	mov ax, 4c00h
	int 21h
instrucciones:
	mov ax, 4c00h
	int 21h
creditos:
	mov ax, 4c00h
	int 21h
main endp

end
