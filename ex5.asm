.386
.model flat, stdcall
option casemap : none

includelib D:\masm32\lib\msvcrt.lib

scanf PROTO C formatStr:DWORD, var_in:VARARG
printf PROTO C lpszFormat_IN:DWORD, var_in:VARARG

system PROTO C lpszFormat_in:DWORD

exit	PROTO C ExitCode:DWORD

.data

	ex REAL8 0.0 ;����������x��ָ����ʽ
	temp REAL8 0.0
	te_num REAL8 0.0 ;��ʱ������
	x_ori REAL8 0.0 ;��ʼ��x
	x REAL8 0.0
	a1 REAL8 0.0
	a2 REAL8 0.0
	a2_temp REAL8 1.0
	two REAL8 2.0 ;����2
	one REAL8 1.0 ;����1
	a3 REAL8 0.0
	zhengshu REAL8 0.0 ;ex ȡ���Ľ��
	xiaoshu REAL8 0.0 ;ex��С������

	hint db 'x, a1, a2, a3: ', 0
	error_msg db 'Error: x < 0!', 0
	pause db 'pause', 0
	newLine db 0dh, 0ah, 0
	fp db '%lf', 0
	
.code
start:
	invoke printf, addr hint
	invoke scanf, addr fp, addr x
	invoke scanf, addr fp, addr a1
	invoke scanf, addr fp, addr a2
	invoke scanf, addr fp, addr a3
	
	fldz
	fcom x
	fstsw ax
	sahf
	ja print_error
	jmp calcu
	
print_error:
	invoke printf, addr error_msg
	invoke printf, addr newLine
	jmp endl
	
calcu:
	;�����һ��
	fld x	;xװ��ջ��
	fst x_ori ;ջ�����ݸ��Ƶ�x_ori
	fsqrt	;ջ��x��ƽ����
	fmul a1 ;ջ�����ݳ�a1
	fst a1	;ջ�����ݴ���a1
	;����ڶ���
	fldl2e ;log��2Ϊ�׵�e��ջ
	fmul x_ori
	fst ex ;������µ�ָ��
	
	fld one
	fst st(1)
	fld ex
	;���������С������
	fprem
	fst xiaoshu
	
	fld ex
	fsub xiaoshu
	frndint
	fst zhengshu
	fld xiaoshu
	f2xm1
	fadd one
	fst a2_temp ;2^xiaoshu����a2_temp
	
	;��������
	fld zhengshu
	;frndint
	fstp st(1)
	fld a2_temp
	fscale
	fst te_num
	fmul a2
	fstp a2
	
	;���������
	fld x_ori
	fsin
	fmul a3
	fstp a3
	
	;���еĽ��������
	fld a3 
	fadd a1
	fadd a2
	
	fstp a3
	invoke printf, addr fp, a3
	invoke printf, addr newLine
	
	
endl:
	invoke system, addr pause
	invoke exit, 0
	
end start
