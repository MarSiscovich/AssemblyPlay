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

.code

extrn carga:proc
extrn imprimir:proc
extrn moverCursorIzq:proc
extrn llenaBlanco:proc
extrn pruebaColor:proc

main proc
	mov ax, @data 
	mov ds, ax

;---------limpiado de pantalla--------
	mov bh, 0  			; Página de video (normalmente 0)
	push bx			
	mov dh, 0 			; Fila
	mov dl, 0 			; Columna
	push dx
	call moverCursorIzq 		; Mueve el cursor a la esquina superior izquierda

    	mov bh, 0     			; Página de video (normalmente 0)
   	push bx
    	mov cx, 0    		 	; Número de veces que se repetirá la escritura (limpia toda la pantalla)
    	push cx
    	call llenaBlanco 		; Llena la pantalla con espacios en blanco
;---------fin limpiado----------------

;---------prueba color-------
	mov bh, 10
	push bx
	mov ch, 0			; Punto inicial hacia abajo
	mov cl, 0			; Punto inicial hacia la derecha
	push cx
	mov dh, 50			; Filas 
	mov dl, 80 			; Columnas
	push dx
	call pruebaColor
;---------fin prueba---------

	mov bx, offset titulo
	push bx 
	call imprimir


	mov ax, 4c00h
	int 21h
main endp

end
