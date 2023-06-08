org 0x7c00 ;the memory adresse of the bios
bits 16

;Macro to define the end of a new line
%define endl 0x0D, 0x0A  


start:
;jump to the main function
 jmp main

;the purpose of this function is to write the message to the screen in bios
write:
 push si 
 push ax

.loop:
 lodsb ;copy the data in the si(stack pointer) register
 or al,al ;checks for a null byte
 jz .finished ;if a null byte is found we jump to finished

; assembly int=10(bios interrupt), ah = 0Eh(Teletype output)
 mov ah, 0x0e
 mov bh, 0
 int 0x10

;we call the sub-routine .loop until null byte is found
 jmp .loop


.finished:
;we pop the registers and return
 pop si
 pop ax
 ret

main:
 mov ax, 0 ;intilize ax, not intilized at runtime
 
 mov si, msg ; move the message into the si register
 call write ; call the funtion write


msg: db "welcome to my bootloader it doesn't do much", endl,0
times 510-($-$$) db 0 ;fill up the data not used on the harddrive with 0's
dw 0xAA55 ;the bios signateur