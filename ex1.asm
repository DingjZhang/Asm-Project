include 'emu8086.inc'

.model small

.data
    array dw 36 dup(0)	;二维数组
    i dw 0	;外层循环控制
    j dw 0	;内层循环控制
    shang dw 0 ;打印阶段的商
    yushu dw 0	;打印阶段的余数
    
.code
    .startup
    
        lea di, array
        mov cx, 36
        mov dx, 37
		
    ;对array进行赋值    
    L1: mov ax, cx
        sub dx, ax
        mov [di], dx 
        mov dx, 37
        add di, 2
        loop L1
    
    lea di, array    
    ;打印左下三角
    L2: ;外层循环
        
        L3: 	;内层循环
            lea di, array
            mov ax, i
            add ax, i
            add ax, i
            add ax, i
            add ax, i
            add ax, i
            add ax, j
            add ax, ax
            add di, ax
            mov dx, [di]
            mov ax, 0
            add ax, dx
            
            ;输出为十进制数
            mov bx, ax
            mov dl, 10
            xor cx, cx
      next: mov yushu, 10
            div dl 
            mov bl, ah
            mov bh, 0
            mov yushu, bx
            mov ah, 0
            mov shang, ax
            push bx
            inc cx
            cmp shang, 0
            jnz next
      outp: pop ax
            mov dx, ax
            add dl, 30h
            mov ah, 2
            int 21h
            loop outp
     
           
            mov dl, 32	;打印空格
            mov ah, 02h
            int 21h
            
            inc j 
            mov ax, i
            cmp j, ax
            jbe L3
            
        ;打印换行符
        mov dl, 10
        mov ah, 02h
        int 21h
		
		
		;打印回车符
		mov dl, 13
        mov ah, 02h
        int 21h
        
        
        
        mov ax, j
        sub j, ax
        inc i
        cmp i, 6
        jb L2
        jmp L4	;结束
        
    L4:
    
    
             
    
    .exit
	
	
	DEFINE_PRINT_NUM
    
end



