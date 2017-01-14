data segment
    n db 0 ;n�Ľ׳�
    result db 18 dup(0)
    temp db 18 dup(0)
    base dw 0;�����������ַ
    multi db 2;����
    carry db 0;��λ
    arr_size db 18
    times db 0;����˵Ĵ���
    temp_multi db 0
    
data ends

code segment
    assume cs:code, ds: data
    
    start:
        mov ax, data
        mov ds, ax
        
        ;�Ӽ��̶�ȡn
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
        
        ;��ӡ���з�
        mov dl, 10
        mov ah, 02h
        int 21h
		
		
		;��ӡ�س���
		mov dl, 13
        mov ah, 02h
        int 21h
        
        ;��ʼ����׳�
        ;jmp over
        lea di, result
        mov [di], 1
        
        cmp n, 1 ;1�Ľ׳���ֱ�Ӵ�ӡ
        je print
        
        ;n����1��ʼ����
    calcul:          
        lea di, result
        mov ah, multi
        cmp ah, n
        ja print
        cmp multi, 9
        ja double
        jmp single
        
        
        double:;multi����λ����Ҫ��ȡ��λ��ʮλ
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
                    
                        
            
            
        
            jmp d_m_p_p;double������Ӧ��multi++
        
        
        ;multi��һλ����һ�μ���
            
        single:    
            mov ah, times
            cmp ah, arr_size
            je m_p_p   ;������18����multi++�������������
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
            
            jmp m_p_p;singl������Ӧ��multi++
        
        
        
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
            ;��temp��result���
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