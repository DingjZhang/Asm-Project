data segment
    expr dw 1024 dup(0) ;������ʽ
    char dw 1024 dup(0) ;��������ţ�Ϊ�˷�������������expr
    tag dw 1024 dup(0)  ;������飬�ж�һ�������Ƿ񱻼����
    temp_result dw 0
    result dw 0
    right dw 0
    left dw 0
    front_left dw 43
    deep dw 0
    
    shang dw 0
    yushu dw 0
    
    temp dw 0   ;������ʱ����ķ��� 
  
    i db 0 ;ѭ������
    n db 0 ;��¼�ܹ����ַ���
     
    
    
    
data ends

code segment
    assume cs:code ds:data
    
    start:
        mov ax, data
        mov ds, ax
        
        lea di, expr
        lea si, char
        
        
        ;�Ӽ��̶�ȡ���ʽ
    input:
        call inputch
        cmp al, 13
        je input_over
        cmp al, 43  ;�Ƚ��Ƿ�Ϊ��+��
        je plus_minus_parens
        cmp al, 45  ;�Ƚ��Ƿ�Ϊ��-��
        je plus_minus_parens
        cmp al, 40  ;�Ƚ��Ƿ�Ϊ������
        je plus_minus_parens
        cmp al, 41  ;�Ƚ��Ƿ�Ϊ������
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
        mov bx, ax   ;�ն����������ʱ����bx
        mov ax, temp  ;��ʱ��������ִ���ax
        mul cx
        add ax, bx
        mov temp, ax
        jmp input
        
        
        
    input_over: ;�������
         
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
        ;��ӡ���з�
        mov dl, 10
        mov ah, 02h
        int 21h
		
		
		;��ӡ�س���
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
        ;je with_paren ;������
    cmp_13:    
        cmp ax, 13
        je no_paren ;�Ƚ����ˣ�û������
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
        ;������ߵ�������
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
        ;je find_over;���Ҷ��ҵ���ʼ���������м��ֵ
        jmp l_l_p 
        
        
    find_over:
        lea di, expr
        lea si, char
        
        add di, left
        add di, left
        ;inc di
        add si, left
        add si, left
        ;��������������ʲô
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
        cmp ax, 40;���������ǰ�߻���������
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
      
        cmp ax, 45;�Ǽ���
        je minus
        cmp ax, 43;�ǼӺ�
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
        ;�ж������ֻ����ַ�
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
        ;�ж������ֻ����ַ�
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
        cmp ax, 0    ;---------->������tag�Ƿ�Ϊ0Ϊ��׼Ӧ����char����
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
        ;������
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
        ;�ж������ֻ����ַ�
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
        ;�ж������黹���ַ�
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


;����һ���ַ��Ĺ���
inputch proc
    push dx
    mov ah, 01h
    int 21h
    pop dx
    ret
inputch endp       
    
    
code ends

    end start
    
    
    
    