eof = 065                   

data segment
    intxt db '2.txt', 0
    inhandle dw 0000h
    array db 10 dup(0)
    buffer db 0
    temp db 0
    i dw 0	;控制外层循环
    j dw 0	;控制内层循环
    n dw 8
    yushu dw 10
    shang dw 10 
    
data ends

code segment
    assume cs:code, ds:data
    
    start:  
    
        mov ax, data
        mov ds, ax 
        lea di, array
        ;打开文件2.txt  
        
        
        mov ax, 3d00h
        mov dx, offset intxt
        int 21h
        jnc open_2_ok
        jmp over
        
    open_2_ok:
        mov inhandle, ax
        mov temp, 0
        ;开始从文件中读字符
    read:    
        call readch
        jc over
        cmp al, eof ;读到的是不是文件结束符
        jz sort ;是，则跳转到排序
        cmp al, 0dh
        jz read
        cmp al, 0ah ;读到的是不是回车符
        jz calcul ;是
        jc over ;读到数字
        sub al, 30h
        mov ah, temp	;temp×10
        add ah, temp
        add ah, temp
        add ah, temp
        add ah, temp
        add ah, temp
        add ah, temp
        add ah, temp
        add ah, temp
        add ah, temp
        add ah, al
        mov temp, ah
        ;mov [di], ah
        
        jmp read
             
        
    calcul:;存入数组
        mov ah, temp 
        mov [di], ah
        inc di
        mov temp, 0
        jmp read    
       
    sort: ;开始排序
     
        lea di, array
        mov i, 0
    L1: 
        mov cx, n
        dec cx
        cmp cx, i
        je print
        mov j, 0
        
        L2: 
            mov ax, n
            dec ax
            sub ax, i
            cmp j, ax
            je i_p_p
            
            lea di, array
            add di, j
            mov ah, [di]
            inc di
            mov al, [di]
            
            cmp ah, al
            ja exchange_p
            inc j
            jmp L2
            
            exchange_p:
                mov ah, [di]
                dec di
                mov al, [di]
                mov [di], ah
                inc di 
                mov [di], al
                inc j
                jmp L2
                
            i_p_p:
                inc i
                jmp L1    
                
                
           
       
    print:  lea di, array
    ;打印结果
    print_f:   
        mov al, [di]
        mov ah, 0
        
        mov bx, ax
        mov dl, 10
        xor cx, cx
   next:
        mov yushu, 10 
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
        
        inc di 
        
        mov dl, 32	;打印空格
        mov ah, 02h
        int 21h
        
        
        
   outp:
        pop ax
        mov dx, ax
        add dl, 30h
        mov ah, 2
        int 21h
        loop outp
        
        
        dec n
        mov ax, n
        cmp ax, 0
        je over
        jmp print_f
        
        
    over:
        mov ah, 4ch
        int 21h
        
        
;读文件过程        
readch proc
        mov bx, inhandle
        mov cx, 1
        mov dx, offset buffer
        mov ah, 3fh
        int 21h
        jc readch2
        cmp ax, cx
        mov al, eof
        jb readch1
        mov al, buffer
        
    readch1:clc
    readch2:ret
readch endp


        
code ends

    end start