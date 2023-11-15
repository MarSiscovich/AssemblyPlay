.8086
.model small
.stack 100h
.data
	titulo	db "------------------------------------------------------",0dh,0ah
			db "|                                                    |",0dh,0ah			
			db "|                    TRAGA BOLAS                     |",0dh,0ah
			db "|                                                    |",0dh,0ah
			db "------------------------------------------------------",0dh,0ah

.code 

extrn carga:proc
extrn imprimir:proc

main proc
	mov ax, @data 
	mov ds, ax

	mov bx, offset titulo
	push bx 
	call imprimir

	mov ax, 4c00h
	int 21h
main endp

end
