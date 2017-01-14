.386
.model flat, stdcall
option casemap : none

includelib D:\masm32\lib\msvcrt.lib

scanf PROTO C formatStr:DWORD, var_in:VARARG
printf PROTO C lpszFormat_IN:DWORD, var_in:VARARG

system PROTO C lpszFormat_in:DWORD

exit	PROTO C ExitCode:DWORD

.data

	ex REAL8 0.0 ;保存计算出的x的指数形式
	temp REAL8 0.0
	te_num REAL8 0.0 ;临时计算结果
	x_ori REAL8 0.0 ;初始的x
	x REAL8 0.0
	a1 REAL8 0.0
	a2 REAL8 0.0
	a2_temp REAL8 1.0
	two REAL8 2.0 ;常数2
	one REAL8 1.0 ;常数1
	a3 REAL8 0.0
	zhengshu REAL8 0.0 ;ex 取整的结果
	xiaoshu REAL8 0.0 ;ex的小数部分

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
	;计算第一项
	fld x	;x装入栈顶
	fst x_ori ;栈顶内容复制到x_ori
	fsqrt	;栈顶x求平方根
	fmul a1 ;栈顶内容乘a1
	fst a1	;栈顶内容存入a1
	;计算第二项
	fldl2e ;log以2为底的e入栈
	fmul x_ori
	fst ex ;计算出新的指数
	
	fld one
	fst st(1)
	fld ex
	;求出整数和小数部分
	fprem
	fst xiaoshu
	
	fld ex
	fsub xiaoshu
	frndint
	fst zhengshu
	fld xiaoshu
	f2xm1
	fadd one
	fst a2_temp ;2^xiaoshu存入a2_temp
	
	;整数部分
	fld zhengshu
	;frndint
	fstp st(1)
	fld a2_temp
	fscale
	fst te_num
	fmul a2
	fstp a2
	
	;计算第三项
	fld x_ori
	fsin
	fmul a3
	fstp a3
	
	;所有的结果加起来
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
