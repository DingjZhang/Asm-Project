data segment
    n db 0 ;n的阶乘
    result db 18 dup(0)
    temp db 18 dup(0)
    base dw 0;保存数组基地址
    multi db 2;乘数
    carry db 0;进位
    arr_size db 18
    times db 0;计算乘的次数
    temp_multi db 0
    
data ends

code segment
    assume cs:code, ds: data
    
    start:
        mov ax, data
        mov ds, ax
        
        ;从键盘读取n
    input:    
        call inputch
        cmp al, 13
        je input_over
        
        sub al, 30h
        mov dl, al
        mov al, n
        mov cl, 10
        mul cl
        add al, dl
        mov n, al
        jmp input 
        
        
    input_over:    
        
        ;打印换行符
        mov dl, 10
        mov ah, 02h
        int 21h
		
		
		;打印回车符
		mov dl, 13
        mov ah, 02h
        int 21h
        
        ;开始计算阶乘
        ;jmp over
        lea di, result
        mov [di], 1
        
        cmp n, 1 ;1的阶乘则直接打印
        je print
        
        ;n不是1则开始计算
    calcul:          
        lea di, result
        mov ah, multi
        cmp ah, n
        ja print
        cmp multi, 9
        ja double
        jmp single
        
        
        double:;multi是两位数需要获取个位和十位
            mov cl, 10
            mov al, multi
            mov ah, 0 
            mov temp_multi, al
            div cl
            
            mov multi, ah 
            lea si, temp
            inc si
            mov cx, 17
            assign:
                mov ah, [di]
                mov [si], ah
                inc si
                inc di
            loop assign
            lea di, result
            
            double_1:
            
                mov ah, times
                cmp ah, arr_size
                je d_m_p_p
                mov al, [di]
                mul multi
                add al, carry
                cmp al, 10
                jae d_carry_1
                mov carry, 0
                mov [di], al
                inc di
                inc times
                jmp double_1
                
                d_carry_1:
                    mov cl, 10
                    div cl
                    mov carry, al
                    mov [di], ah
                    inc di
                    inc times
                    jmp double_1
                    
                        
            
            
        
            jmp d_m_p_p;double计算完应该multi++
        
        
        ;multi是一位数乘一次即可
            
        single:    
            mov ah, times
            cmp ah, arr_size
            je m_p_p   ;乘完了18次让multi++，否则继续计算
            mov al, [di]
            mul multi
            add al, carry
            cmp al, 10
            jae carry_1
            mov carry, 0
            mov [di], al
            inc di
            inc times
            jmp single
            
            carry_1:
                mov cl, 10
                div cl
                mov carry, al
                mov [di], ah
                inc di
                inc times
                jmp single            
            
            jmp m_p_p;singl计算完应该multi++
        
        
        
        m_p_p:
            mov carry, 0
            mov times, 0
            inc multi
            jmp calcul
            
        d_m_p_p:
            mov carry, 0
            mov times, 0
            inc temp_multi
            mov dl, temp_multi
            mov multi, dl 
            ;令temp与result相加
            lea di, result
            lea si, temp
            inc si
            inc di
            mov cx, 17
            plus:    
                mov al, [di]
                add al, [si]
                
                add al, carry
                cmp al, 9
                ja plus_carry
                mov [di], al
                mov carry, 0
                inc di
                inc si
                jmp plus_over
                
                
                
                
                plus_carry:
                    mov carry, 1
                    sub al, 10
                    mov [di], al
                    inc di
                    inc si
                   
                   
                
            plus_over:
            
            loop plus
            
            
            
            jmp calcul    
            
        
    
    
    print:
        lea di, result
        mov base, di
        add di, 17
        
    di_cmp:    
        cmp [di], 0
        je di_sub
        jmp print_re
        
        di_sub:
            dec di
            jmp di_cmp
            
        print_re:
            mov dl, [di]
            add dl, 30h
            mov ah, 02h
            int 21h
            cmp di, base
            je over
            dec di
            jmp print_re
            
                  
        
    over:
        mov ah, 4ch
        int 21h    
    


inputch proc
    push dx
    mov ah, 01h
    int 21h
    pop dx
    ret
inputch endp        
    
    
code ends

    end start