data segment
    expr dw 1024 dup(0) ;保存表达式
    char dw 1024 dup(0) ;仅保存符号，为了符号与数字区分expr
    tag dw 1024 dup(0)  ;标记数组，判断一段内容是否被计算过
    temp_result dw 0
    result dw 0
    right dw 0
    left dw 0
    front_left dw 43
    deep dw 0
    
    shang dw 0
    yushu dw 0
    
    temp dw 0   ;保存临时读入的符号 
  
    i db 0 ;循环变量
    n db 0 ;记录总共的字符数
     
    
    
    
data ends

code segment
    assume cs:code ds:data
    
    start:
        mov ax, data
        mov ds, ax
        
        lea di, expr
        lea si, char
        
        
        ;从键盘读取表达式
    input:
        call inputch
        cmp al, 13
        je input_over
        cmp al, 43  ;比较是否为“+”
        je plus_minus_parens
        cmp al, 45  ;比较是否为“-”
        je plus_minus_parens
        cmp al, 40  ;比较是否为“（”
        je plus_minus_parens
        cmp al, 41  ;比较是否为“）”
        je plus_minus_parens
        jmp numbers 
        
        
        
        
    plus_minus_parens:
        cmp temp, 0
        je store_plus
        mov bx, temp
        mov temp, 0
        mov [di], bx
        inc n
        inc di
        inc di
        inc si
        inc si
    store_plus:     
        mov ah, 0
        mov [di], ax
        mov [si], ax
        inc n
        inc di
        inc di
        inc si
        inc si
        jmp input
        
    numbers:
        sub al, 48
        mov ah, 0
        mov cx, 10
        mov bx, ax   ;刚读入的数字临时存入bx
        mov ax, temp  ;临时保存的数字存入ax
        mul cx
        add ax, bx
        mov temp, ax
        jmp input
        
        
        
    input_over: ;输入结束
         
        cmp temp, 0
        je print_endl
        mov bx, temp
        mov [di], bx
        mov temp, 0
        inc n
        inc di
        inc di
        inc si
        inc si
        
    print_endl:
        mov [di], 13
        mov [si], 13    
        ;打印换行符
        mov dl, 10
        mov ah, 02h
        int 21h
		
		
		;打印回车符
		mov dl, 13
        mov ah, 02h
        int 21h
 
    top_check:
        mov ax, result
        mov bx, front_left
        cmp front_left, 45
        je front_left_sub
        add ax, temp_result
        mov front_left, 43
        jmp top_check_cont
        
    front_left_sub: 
        mov front_left, 43
        sub ax, temp_result    
    
    
    top_check_cont:
        mov deep, 0        
        mov result, ax 
        mov temp_result , 0      
        lea si, char                          
        lea di, expr
        
        
    check_paren:
        mov ax, [si]
        cmp ax, 40
        je cont_cmp
        ;je with_paren ;有括号
    cmp_13:    
        cmp ax, 13
        je no_paren ;比较完了，没有括号
        inc si
        inc si 
        jmp check_paren
        
    cont_cmp:
        mov bx, [si+2048]
        cmp bx, 1
        je cmp_13
        jmp with_paren
            
        
    with_paren:
        mov i, 0
        lea di, expr
        lea si, char
        ;找最左边的右括号
    find_left_most_right_paren:    
        mov ax, [si]
        cmp ax, 41
        je cont_cmp_f_l_l_p
        ;je find_left_left_paren
    cont_cmp_right:    
        inc si
        inc si
        inc di
        inc di
        inc right
        jmp find_left_most_right_paren
    cont_cmp_f_l_l_p:
        mov bx, [si+2048]
        cmp bx, 0
        je find_left_left_paren
        jmp cont_cmp_right    
        
        
    find_left_left_paren:
        ;mov ax, 07fffh
        mov [si+2048], 1
        ;mov [di], ax
        mov ax, right
        mov left, ax
    l_l_p:    
        dec si
        dec si
        dec left
        mov ax, [si]
        cmp ax, 40
        jnz l_l_p
        mov ax, [si+2048]
        cmp ax, 0
        je find_over    
        ;je find_over;左右都找到开始计算括号中间的值
        jmp l_l_p 
        
        
    find_over:
        lea di, expr
        lea si, char
        
        add di, left
        add di, left
        ;inc di
        add si, left
        add si, left
        ;检查左括号左边是什么
    check_left:     
        add deep, 2
        mov bx, left
        add bx, left
        sub bx, deep
        cmp bx, 0
        jl cont_find_over
        mov ax, char[bx]
        mov front_left, ax
        cmp ax, 45
        je cont_find_over
        cmp ax, 43
        je cont_find_over
        cmp ax, 40;如果左括号前边还是左括号
        je check_right
        
        
    check_right:
        mov bx, right
        add bx, right
        add bx, deep
        mov ax, char[bx]
        cmp ax, 41
        je check_left
        jmp check_over
        
    check_over:
        mov bx, left
        sub bx, deep
        cmp bx, 0
        jl front_left_43
        mov ax, char[bx]
        mov front_left, ax 
        
        
    front_left_43:
        mov front_left, 43
        
                   
        
        
    cont_find_over:    
        mov [si+2048], 1
        ;mov [di], 07fffh
        
        mov left, 0
        mov right, 0
        ;inc si
    start_cal:    
        ;cmp si, 07fffh
        ;je top_check
        inc di
        inc di
        inc si
        inc si
        mov ax, [si+2048]
        cmp ax, 1
        je top_check 
        mov ax, [si]
      
        cmp ax, 45;是减号
        je minus
        cmp ax, 43;是加号
        je plus
        mov ax, [di]
        ;mov [di], 07fffh
        mov [si+2048], 1
        add ax, temp_result
        mov temp_result, ax
        jmp start_cal
        
    minus:
        ;mov [di], 07fffh
        mov [si+2048], 1
        inc si
        inc si
        inc di
        inc di
        ;mov ax, [di]
        ;neg ax
        ;判断是数字还是字符
        mov ax, [si]
        cmp ax, 0
        jne start_cal
        mov ax, temp_result
        sub ax, [di]
        ;mov [di], 07fffh
        mov [si+2048], 1
        mov temp_result, ax
        jmp start_cal
        
    plus:
        ;mov [di], 07fffh
        mov [si+2048], 1
        inc si
        inc si
        inc di
        inc di
        ;判断是数字还是字符
        mov ax, [si]
        cmp ax, 0
        jne start_cal
        mov ax, [di]
        ;mov [di], 07fffh
        mov [si+2048], 1
        add ax, temp_result
        mov temp_result, ax
        jmp start_cal
        
        jmp top_check
            
        
        
        
    no_paren:
        lea di, expr
        lea si, char  
        mov temp_result, 0
    no_paren_cal_top:    
        mov ax, [si+2048]
        cmp ax, 0    ;---------->不能以tag是否为0为标准应该以char数组
        je no_paren_cal
        inc si
        inc si
        inc di
        inc di
        jmp no_paren_cal_top
        
        
    no_paren_cal:
        mov ax, [si] 
        cmp ax, 13
        je print
        cmp ax, 45;?'-'
        je no_paren_minus
        cmp ax, 43;?'+'
        je no_paren_plus
        ;是数字
        mov ax, [di]
        add ax, temp_result
        mov temp_result, ax
        inc di
        inc di
        inc si
        inc si
        jmp no_paren_cal_top
        
    no_paren_minus:
        mov ax, temp_result
        inc di
        inc di
        inc si
        inc si
        ;判断是数字还是字符
        mov bx, [si]
        cmp bx, 0
        jne no_paren_cal_top
        mov bx, [di]
        sub ax, bx
        mov temp_result, ax
        inc di
        inc di
        inc si
        inc si
        jmp no_paren_cal_top
        
    no_paren_plus:
        mov ax, temp_result
        inc di
        inc di
        inc si
        inc si  
        ;判断是数组还是字符
        mov bx, [si]
        cmp bx, 0
        jne no_paren_cal_top
        add ax, [di]
        mov temp_result, ax
        inc di
        inc di
        inc si
        inc si
        jmp no_paren_cal_top       
    
        ;jmp print
        
                    
    print:
        mov ax, temp_result
        add ax, result
        mov result, ax
        
        cmp ax, 0
        jl lower_than_0
        mov bx, ax
        mov dl, 10
        xor cx, cx
        
    next_1:
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
    outp_1:
        pop ax
        mov dx, ax
        add dl, 30h
        mov ah, 02h
        int 21h
        loop outp_1
        
        jmp all_over
        
                
        
        
        
        
    lower_than_0:
        mov dl, 45
        mov ah, 02h
        int 21h
        
        mov ax, result
        neg ax
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
    outp:
        pop ax
        mov dx, ax
        add dl, 30h
        mov ah, 02h
        int 21h
        loop outp        
        
               
    
    
    all_over:
        mov ah, 4ch
        int 21h    


;读入一个字符的过程
inputch proc
    push dx
    mov ah, 01h
    int 21h
    pop dx
    ret
inputch endp       
    
    
code ends

    end start
    
    
    
    