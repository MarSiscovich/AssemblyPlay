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

main proc
	mov ax, @data 
	mov ds, ax

;---------limpiado de pantalla--------
	; Mueve el cursor a la esquina superior izquierda
    mov ah, 2     ; Función 02h - Posiciona el cursor
    mov bh, 0     ; Página de video (normalmente 0)
    mov dh, 0     ; Fila
    mov dl, 0     ; Columna
    int 10h       ; Llama a la interrupción 10h para posicionar el cursor

    ; Llena la pantalla con espacios en blanco
    mov ah, 9     ; Función 09h - Escribir caracter y atributo en pantalla
    mov al, 20h   ; Carácter de espacio en blanco
    mov bh, 0     ; Página de video (normalmente 0)
    mov cx, 0     ; Número de veces que se repetirá la escritura (limpia toda la pantalla)
    int 10h       ; Llama a la interrupción 10h para escribir en pantalla
;---------fin limpiado----------------

;---------prueba color-------
	mov ax, 0600h
	mov bh, 9 ;color de letra y fondo
	mov ch, 0	;punto inicial hacia abajo
	mov cl, 0	;punto inicial hacia la derecha
	mov dh, 50	;filas 
	mov dl, 80 	;columnas
	int 10h
;---------fin prueba---------

	mov bx, offset titulo
	push bx 
	call imprimir


	mov ax, 4c00h
	int 21h
main endp

end
