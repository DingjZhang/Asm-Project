include 'emu8086.inc'

.model small

.data
    array dw 36 dup(0)	;��ά����
    i dw 0	;���ѭ������
    j dw 0	;�ڲ�ѭ������
    shang dw 0 ;��ӡ�׶ε���
    yushu dw 0	;��ӡ�׶ε�����
    
.code
    .startup
    
        lea di, array
        mov cx, 36
        mov dx, 37
		
    ;��array���и�ֵ    
    L1: mov ax, cx
        sub dx, ax
        mov [di], dx 
        mov dx, 37
        add di, 2
        loop L1
    
    lea di, array    
    ;��ӡ��������
    L2: ;���ѭ��
        
        L3: 	;�ڲ�ѭ��
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
            
            ;���Ϊʮ������
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
     
           
            mov dl, 32	;��ӡ�ո�
            mov ah, 02h
            int 21h
            
            inc j 
            mov ax, i
            cmp j, ax
            jbe L3
            
        ;��ӡ���з�
        mov dl, 10
        mov ah, 02h
        int 21h
		
		
		;��ӡ�س���
		mov dl, 13
        mov ah, 02h
        int 21h
        
        
        
        mov ax, j
        sub j, ax
        inc i
        cmp i, 6
        jb L2
        jmp L4	;����
        
    L4:
    
    
             
    
    .exit
	
	
	DEFINE_PRINT_NUM
    
end



