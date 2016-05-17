<% 
'��ASP����



'������ú��� 20150402  �е�����������ȷ�ģ��Ժ������İ�
Function BatchFindFunction(ConfigPath,VariableList)
	Dim ConfigContent,LCaseConfigContent,SplStr,VariableName,C
	Dim ObjCode,Content
	If CheckFile(ConfigPath)=False Then
		BatchFindFunction=""
		Call Echo("�����ļ�������", ConfigPath)
		Exit Function
	End If
	ConfigContent=GetFText(ConfigPath)
	LCaseConfigContent = LCase(ConfigContent)
	LCaseConfigContent=Replace(Replace(LCaseConfigContent, ",","|"), vbCrlf,"|")
	SplStr=Split(VariableList,"|")
	For Each VariableName In SplStr
		If VariableName<>"" And InStr(LCaseConfigContent,"|"& VariableName &"|") Then
			C=C & GetFindFileFunction(ConfigPath,VariableName) & vbCrlf 
		End If
	Next
	BatchFindFunction = C
End Function
'���ָ���������Ǹ��ļ������ 20150402
Function GetFindFileFunction(ByVal ConfigPath,ByVal FunctionName)
	Dim FilePath,ConfigContent,SplStr,Splxx,S,S2
	Dim ObjCode,Content
	FunctionName=LCase(PHPTrim(FunctionName))
	If CheckFile(ConfigPath)=False Then
		GetFindFileFunction=""
		Call Echo("�����ļ�������", ConfigPath)
		Exit Function
	End If
	ConfigContent=GetFText(ConfigPath)
	SplStr=Split(ConfigContent,vbCrlf)
	For Each S In SplStr
		If InStr(S,",")>0 Then
			FilePath=Mid(S,1,InStr(S,",")-1)
			If InStr(FilePath,"(")>0 Then
				FilePath=Mid(FilePath,1,InStr(FilePath,"(")-1)
			End If
			S2=LCase(Mid(S,InStrRev(S,",")+1))
			If InStr("|"& S2 &"|","|"& FunctionName &"|")>0 Then
				'Call Echo(S,S2)
				Set ObjCode = New ASPCode 
				ObjCode.SetCountRow = 9999
				ObjCode.SetAspSetType = "||"		
				ObjCode.SetFindFunctionList=FunctionName
				Content=GetFText(FilePath)
				Content = ObjCode.HandleAspCode(Content)				'������� 
				'Call Eerr(FunctionName,ObjCode.FindFunctionContent)
				GetFindFileFunction = ObjCode.getFindFunctionContent
				Set ObjCode=Nothing
				Exit Function
			End If
		End If
	Next
End Function

'���ASP����
Function GetASPCode(ByVal Content)
    GetASPCode = HandleGetAspCode(Content, "") 
End Function
 
'�������Asp���� C = HandleGetAspCode(C,"|��һ��|ȥASP��ʼ������ǩ|ȥע�Ͳ���|(ÿ�в�Ϊ��|ȥ����)|(ȫ��ΪASP|Ĭ��ASP�Լ��)|������Execute����|")
'�Ժ��ټ�ǿ���ɽ�ȡֻ���������룬��ڶ��Σ����һ�� 20150329
Function HandleGetAspCode(ByVal Content, SType)
    Dim SplStr, Sx, S, C, I, YesASP, SYHCount, Wc, AspCode, TempAspCode, vbCrlfYes 
    YesASP = False                                                               '��ASP Ĭ��Ϊ��
    SYHCount = 0                                                                 '˫����Ĭ��Ϊ0
    SplStr = Split(Content, vbCrLf)                                              '�ָ���
	
	'20150328
	If InStr("|" & SType & "|", "|ȫ��ΪASP|") > 0 Or InStr("|" & SType & "|", "|Ĭ��ASP�Լ��|") > 0 Then
		YesASP = True                                                               '��ASP Ĭ��Ϊ�� 
	End If
    'ѭ������
    For Each S In SplStr
        'ѭ��ÿ���ַ�
        AspCode = "" 
        For I = 1 To Len(S)
            Sx = Mid(S, I, 1) 
            'Asp��ʼ
            If Sx = "<" And YesASP = False And Wc = "" Then
                If Mid(S, I + 1, 1) = "%" Then
                    YesASP = True                                                      'ASPΪ��
                    Sx = "<" & "%" 
                    I = I + 1 
                    If InStr("|" & SType & "|", "|ȥASP��ʼ������ǩ|") = False Then
                        AspCode = AspCode & Sx 
                    End If 
                End If 
            'ASP����
            ElseIf Sx = "%" And Mid(S, I + 1, 1) = ">" And YesASP = True And Wc = "" Then
                YesASP = False                                                                  'ASPΪ��
                Sx = "%" & ">" 
                I = I + 1 
                If InStr("|" & SType & "|", "|ȥASP��ʼ������ǩ|") = False Then
                    C = C & Sx & vbCrLf 
                End If 
                If InStr("|" & SType & "|", "|��һ��|") > 0 Or InStr("|" & SType & "|", "|��һ�δ���|") > 0 Or InStr("|" & SType & "|", "|��ȡ��һ��|") > 0 Or InStr("|" & SType & "|", "|1|") > 0 Then
                    HandleGetAspCode = C & AspCode 
                    Exit Function 
                End If 
            'ASPΪ��
            ElseIf YesASP = True Then
                '�����ı�
                If(Sx = """" Or Wc <> "") Then
                    '˫�����ۼ�
                    If Sx = """" Then SYHCount = SYHCount + 1 
                    Wc = Wc & Sx
				    '�ж��Ƿ�"�����
                    If SYHCount Mod 2 = 0 Then
                        If Mid(S, I + 1, 1) <> """" Then 
                            AspCode = AspCode & Wc                                          '���������ۼ�
                            SYHCount = 0 : Wc = ""                                  '���
               			End If
                    End If 
                ElseIf Sx = "'" Then                                                            'ע�����˳�
                    If InStr("|" & SType & "|", "|ȥע�Ͳ���|") > 0 Then
                        Exit For 
                    End If 
                    AspCode = AspCode & Mid(S, I) 
                    Exit For 
                Else
                    AspCode = AspCode & Sx 
                End If 

            End If 
        Next 
        If YesASP = True Then			'
            vbCrlfYes = True 
            If TrimVbCrlf(AspCode) = "" Then
                If InStr("|" & SType & "|", "|ÿ�в�Ϊ��|") > 0 Or InStr("|" & SType & "|", "|ȥ����|") > 0 Then
                    vbCrlfYes = False 
                End If 
            End If 
            If vbCrlfYes = True Then
                If InStr("|" & SType & "|", "|������Execute����|") > 0 Then
                    AspCode = TrimVbCrlf(AspCode) : TempAspCode = LCase(AspCode) 
                    C = C & AspCode & " : " 
                    If Left(TempAspCode, 3) = "if " And Right(TempAspCode, 5) <> " then" Then
                        C = C & " End If : " 
                    End If 
                Else
					
        			AspCode = RTrim(AspCode)            'ȥ���ұ߿ո�
                    C = C & AspCode & vbCrlf 
                End If 
            End If 
        End If 
    Next
	If InStr("  " & C,vbCrlf)>0 Then C = Left(C,Len(C)-2) 
    HandleGetAspCode = C 
End Function
 
'ɾ��ASP��ע�� (��)
Function DelAspNote(ByVal Content)
    Dim SplStr, I, YesASP, YesWord, Sx, S, Wc, AspCode, SYHCount 
    Dim YesFunction                                                 '�����Ƿ�Ϊ��
    YesASP = False                                                  '��ASP Ĭ��Ϊ��
    YesFunction = False                                             '�Ǻ��� Ĭ��Ϊ��
    YesWord = False                                                 '�ǵ��� Ĭ��Ϊ��
    SYHCount = 0                                                    '˫����Ĭ��Ϊ0
    SplStr = Split(Content, vbCrLf)                                 '�ָ���
    'ѭ������
    For Each S In SplStr
        'ѭ��ÿ���ַ�
        For I = 1 To Len(S)
            Sx = Mid(S, I, 1) 
            'Asp��ʼ
            If Sx = "<" And Wc = "" Then                            '����ı�����Ϊ�� WcΪ������� ��"<%" �ų� �޸���20140412
                If Mid(S, I + 1, 1) = "%" Then
                    YesASP = True                             'ASPΪ��
                    Sx = "<" & "%" 
                    I = I + 1                                 '��1�����ܼ�2��Ҫ��Ȼ<%function Test() �ͽ�ȡ����
                End If 
            'ASP����
            ElseIf Sx = "%" And Mid(S, I + 1, 1) = ">" And Wc = "" Then'WcΪ�������
                YesASP = False                'ASPΪ��
                Sx = "%" & ">" 
                I = I + 1                     '���ܼ�2��ֻ�ܼ�1����Ϊ���ﶨ��ASPΪ�٣���������һ����ʾ����� 'ASP����Ϊ��
            End If 
            If YesASP = True Then
                '�����ı�
                If(Sx = """" Or Wc <> "") Then
                    '˫�����ۼ�
                    If Sx = """" Then SYHCount = SYHCount + 1 
                    Wc = Wc & Sx 
                    '�ж��Ƿ�"�����
                    If SYHCount Mod 2 = 0 Then
                        If Mid(S, I + 1, 1) <> """" Then
                            AspCode = AspCode & Wc '���������ۼ�
                            SYHCount = 0 : Wc = "" '���
                        End If 
                    End If 
                ElseIf Sx = "'" Then          'ע�����˳�
                    Exit For 
                Else
                    AspCode = AspCode & Sx 
                End If 
            Else
                AspCode = AspCode & Sx 
            End If 
            DoEvents 
        Next 
        AspCode = RTrim(AspCode)   'ȥ���ұ߿ո�
        AspCode = AspCode & vbCrLf 
        DoEvents 
    Next 
    If AspCode <> "" Then AspCode = Left(AspCode, Len(AspCode) - 2) 
    DelAspNote = AspCode 
End Function

'Ѱ��ASP�����б� 20140811
'nSub��nFunction ��Ϊ��ͳ���õģ�Ĭ��Ϊ�վͺ�  
'Call FindAspFunction(Content,0,0,"(ȫ��ΪASP|Ĭ��ASP�Լ��)|��������|���ܱ���")
Function FindAspFunction(Content, nSub, nFunction, SType)
    Dim SplStr, I, YesASP, YesWord, Sx, S, Wc, Zc, S1, AspCode, SYHCount
	Dim UpWord																	 '��һ���� 
    Dim TempS, DimList 
    Dim YesFunction                                                              '�����Ƿ�Ϊ�� 
    YesASP = False                                                               '��ASP Ĭ��Ϊ��
    YesFunction = False                                                          '�Ǻ��� Ĭ��Ϊ��
    YesWord = False                                                              '�ǵ��� Ĭ��Ϊ��
    SYHCount = 0                                                                 '˫����Ĭ��Ϊ0
    SplStr = Split(Content, vbCrLf)                                              '�ָ���
    If nSub = "" Then nSub = 0                                                   'Ϊ����Ĭ��Ϊ��
    If nFunction = "" Then nFunction = 0                                         'Ϊ����Ĭ��Ϊ�� 
	
	'20150328
	If InStr("|" & SType & "|", "|ȫ��ΪASP|") > 0 Or InStr("|" & SType & "|", "|Ĭ��ASP�Լ��|") > 0 Then
		YesASP = True                                                               '��ASP Ĭ��Ϊ�� 
	End If
    'ѭ������
    For Each S In SplStr
        'ѭ��ÿ���ַ�
        For I = 1 To Len(S)
            Sx = Mid(S, I, 1) 
            'Asp��ʼ
            If Sx = "<" And Wc = "" Then                            '����ı�����Ϊ�� WcΪ������� ��"<%" �ų� �޸���20140412
                If Mid(S, I + 1, 1) = "%" Then
                    YesASP = True                                                                   'ASPΪ��
                    I = I + 1                                                                       '��1�����ܼ�2��Ҫ��Ȼ<%function Test() �ͽ�ȡ����
                End If 
            'ASP����
            ElseIf Sx = "%" And Mid(S, I + 1, 1) = ">" And Wc = "" Then'WcΪ�������
                YesASP = False                                                       'ASPΪ��
                I = I + 1                                                            '���ܼ�2��ֻ�ܼ�1����Ϊ���ﶨ��ASPΪ�٣���������һ����ʾ����� 'ASP����Ϊ��
            End If 
            If YesASP = True Then
                '�����ı�
                If(Sx = """" Or Wc <> "") Then
                    '˫�����ۼ�
                    If Sx = """" Then SYHCount = SYHCount + 1 
                    Wc = Wc & Sx 
                    '�ж��Ƿ�"�����
                    If SYHCount Mod 2 = 0 Then
                        If Mid(S, I + 1, 1) <> """" Then
                            S1 = Right(Replace(Mid(S, 1, I - Len(Wc)), " ", ""), 1) '����������Ҫ�������
                            If YesFunction = True Then AspCode = AspCode & Wc       '���������ۼ�
                            SYHCount = 0 : Wc = ""                                  '���
                        End If 
                    End If 
                ElseIf Sx = "'" Then                                                 'ע�����˳�
                    If YesFunction = True Then AspCode = AspCode & Mid(S, I) 
                    Exit For 
                '��ĸ
                ElseIf CheckABC(Sx) = True Or(Sx = "_" And Zc <> "") Or Zc <> "" Then
                    Zc = Zc & Sx 
                    S1 = LCase(Mid(S & " ", I + 1, 1)) 
                    If InStr("abcdefghijklmnopqrstuvwxyz0123456789", S1) = 0 And Not(S1 = "_" And Zc <> "") Then'����ж�
                        TempS = Mid(S, I + 1) 
                        If InStr("|function|sub|", "|" & LCase(Zc) & "|") Then
                            '������ʼ
                            If YesFunction = False And LCase(UpWord) <> "end" Then
                                YesFunction = True 
                                If LCase(Zc) = "sub" Then nSub = nSub + 1 Else nFunction = nFunction + 1 
                                DimList = GetFunDimName(TempS) 
                            ElseIf YesFunction = True And LCase(UpWord) = "end" Then'�����һ������
                                AspCode = AspCode & Zc & vbCrLf 
                                If InStr("|" & SType & "|", "|���ܱ���|") > 0 Then AspCode = AspCode & "'[NOHandle]" & EncCode(DimList) & vbCrLf & vbCrLf 
                                YesFunction = False 
                            End If 
                        ElseIf YesFunction = True And LCase(Zc) = "dim" Then
                            DimList = DimList & "," & GetDimName(TempS) 
                        ElseIf YesFunction = True And InStr("|" & SType & "|", "|��������|") > 0 Then 
                            Zc = ReplaceDim2(DimList, Zc)
                        End If 
                        UpWord = Zc                                           '��ס��ǰ����
                        If YesFunction = True Then AspCode = AspCode & Zc 
                        Zc = "" 
                    End If 
                ElseIf YesFunction = True Then
                    AspCode = AspCode & Sx 
                End If 
            End If 
            DoEvents 
        Next 
        AspCode = RTrim(AspCode)  'ȥ���ұ߿ո�
        If YesFunction = True Then
            AspCode = AspCode & vbCrLf                                 'Asp����
        End If 
        DoEvents 
    Next 
    FindAspFunction = AspCode 
End Function


'ASP��������ĸ��д (������)
Function FirstLetterUppercase(Content)
    Dim SplStr, I, YesASP, YesWord, Sx, S, Wc, Zc, S1, AspCode, SYHCount 
    Dim YesFunction                                                      '�����Ƿ�Ϊ��

    YesASP = False                                                       '��ASP Ĭ��Ϊ��
    YesFunction = False                                                  '�Ǻ��� Ĭ��Ϊ��
    YesWord = False                                                      '�ǵ��� Ĭ��Ϊ��
    SYHCount = 0                                                         '˫����Ĭ��Ϊ0
    SplStr = Split(Content, vbCrlf)                                      '�ָ���
    'ѭ������
    For Each S In SplStr
        'ѭ��ÿ���ַ�
        For I = 1 To Len(S)
            Sx = Mid(S, I, 1) 
            'Asp��ʼ
            If Sx = "<" And Wc = "" Then                            '����ı�����Ϊ�� WcΪ������� ��"<%" �ų� �޸���20140412
                If Mid(S, I + 1, 1) = "%" Then
                    YesASP = True                                                                   'ASPΪ��
                    I = I + 1                                                                       '��1�����ܼ�2��Ҫ��Ȼ<%function Test() �ͽ�ȡ����
                    Sx = "<%" 
                End If 
            'ASP����
            ElseIf Sx = "%" And Mid(S, I + 1, 1) = ">" And Wc = "" Then'WcΪ�������
                YesASP = False                                                       'ASPΪ��
                I = I + 1                                                            '���ܼ�2��ֻ�ܼ�1����Ϊ���ﶨ��ASPΪ�٣���������һ����ʾ����� 'ASP����Ϊ��
                AspCode = AspCode & "%" & ">" 
            End If 
            If YesASP = True Then
                '�����ı�
                If(Sx = """" Or Wc <> "") Then
                    '˫�����ۼ�
                    If Sx = """" Then SYHCount = SYHCount + 1 
					Wc = Wc & Sx
                    '�ж��Ƿ�"�����
                    If SYHCount Mod 2 = 0 Then
                        If Mid(S, I + 1, 1) <> """" Then 
                            S1 = Right(Replace(Mid(S, 1, I - Len(Wc)), " ", ""), 1) '����������Ҫ�������
                            If YesFunction = True Then AspCode = AspCode & Wc       '���������ۼ�
                            SYHCount = 0 : Wc = ""                                  '���
						End If
                    End If 
                ElseIf Sx = "'" Then                                                 'ע�����˳�
                    If YesFunction = True Then AspCode = AspCode & Mid(S, I) 
                    Exit For 
                '��ĸ
                ElseIf CheckABC(Sx) = True Or(Sx = "_" And Zc <> "") Or Zc <> "" Then
                    Zc = Zc & Sx 
                    S1 = LCase(Mid(S & " ", I + 1, 1)) 
                    If InStr("abcdefghijklmnopqrstuvwxyz0123456789", S1) = 0 And Not(S1 = "_" And Zc <> "") Then'����ж�
                        AspCode = AspCode & UCase(Left(Zc, 1)) & Mid(Zc, 2) 
                        Zc = "" 
                    End If 
                Else
                    AspCode = AspCode & Sx 
                End If 
            End If 
            DoEvents 
        Next 
        AspCode = Rtrim(AspCode)   'ȥ���ұ߿ո�
        If YesFunction = True Then
            AspCode = AspCode & vbCrlf                                 'Asp����
        End If 
        AspCode = AspCode & vbCrlf 
        DoEvents 
    Next 
    FirstLetterUppercase = AspCode 
End Function 

'�ַ���Сд�����ʾ 20150329
Function ContentLUShow(Content)
	Dim I,S,C
    For I = 1 To Len(Content)
        S = Mid(Content, I, 1) 
		S = IIF(PHPRnd(0,1)="0",LCase(S),UCase(S))
		C=C & S
	Next
	ContentLUShow = C
End Function
'ASPתVB���� 20150727
function ASPToVB(content)
	'�ж��Ƿ��Ƴ� '��ʼ'���� �м����� 
	content= deleteStrCut(content,vbCrlf & "'��ʼ",vbCrlf & "'����",1,0)
	'�ж��Ƿ��Ƴ� '��ʼ'���� �м����� 
	content= deleteStrCut(content,vbCrlf & "'VB������ Start", vbCrlf & "'VB������ End",1,0)
	'Content = getStrCut(Content,"<" & "%","%" & ">",2)
	Content = Replace(Content,"Response.End()","Response.End")
	Content = Replace(Content,"Server."&"MapPath(Path)","App"&".Path & ""\"" & Path")
	Content = Replace(Content,"Server."&"MapPath(""/"")","App."&"Path & ""\""")
	Content = Replace(Content,"Server."&"MapPath(""\"")","App."&"Path & ""\""")
	Content = Replace(Content,"Server."&"MapPath("".\"")","App."&"Path & "".\""")
	Content = Replace(Content,"Server."&"MapPath(""./"")","App."&"Path & "".\""")
	'20150614
	Content = Replace(Content,""" & Request."&"ServerVariables(""HTTP_HOST"") & ""","127.0.0.1")
	Content = Replace(Content,vbTab,"    ")			'�滻Tab			 
	Content = Replace(Content,"request(""Debug"")"," 1=2 and ""11""")			'���ι���			
	Content = Replace(Content,"Request(""gl"")"," 1=2 and ""11""")			'���ι��� 		
	Content = Replace(Content,"Request."&"QueryString(""Debug"")"," 1=2 and ""11""")			'���ι��� 
	ASPToVB = content
end function
'aspתVB.net����
function ASPToVBNET(content)
	dim splstr,i,s,noSpaceS,s2,c,LCaseS,functionName
	dim leftS,noteS,centerS,tempCenterS
	splstr=split(content,vbcrlf)
	for each s in splstr
		LCaseS=phptrim(lcase(s)):noSpaceS=phptrim(s)
			's=centerS
		if instr(Lcase(s)," doerror ")>0 and instr(Lcase(s),"call ")=false then
			s=RegExp_Replace(s, " doError ", " call doError(") & ")"
			'call echo("s",s)
		end if
		
		if left(LCaseS,4)="sub " then
			s=functionParamtoNet(s)						'�������������
		elseif left(LCaseS,9)="function " then
			s=functionParamtoNet(s)						'�������������
			s2=mid(s,instr(Lcase(s),"function ") + 9)
			functionName=phptrim( mid(s2,1,instr(s2,"(")-1))
			s = s & vbcrlf & functionName & "="""""
		elseif left(LCaseS,4)="set " then
			s=mid(s, instr(lcase(s),"set ")+3)
		elseif left(LCaseS,4)="dim " then
			s=dimAddDefaultValue(s)
			
		elseif left(LCaseS,1)="." then
			leftS=mid(s,1,instr(s,".")-1)
			noteS=""
			if instr(s,"'")>0 then
				noteS=mid(s,instr(s,"'"))
			end if
			centerS=mid(s,instr(s,"."))
			if instr(s,"'")>0 then
				centerS=mid(centerS,1,instr(centerS,"'")-1)
			end if
			tempCenterS=centerS
			centerS=leftS & "call " & mid(centerS,1,instr(centerS," ")) & "(" & mid(centerS,instr(centerS," ")) & ")" & noteS
			if instr(tempCenterS,"=")=false and instr(tempCenterS,"(")=false  then
				s=centerS
				'call echo(s,centerS)
			end if
		
		
		elseif left(LCaseS,2)="if" then
			leftS=mid(s,1,instr(lcase(s),"if")-1)
			noteS=""
			if instr(s,"'")>0 then
				noteS=mid(s,instr(s,"'"))
			end if
			centerS=mid(s,instr(lcase(s),"if"))
			if instr(s,"'")>0 then
				centerS=mid(centerS,1,instr(centerS,"'")-1)
			end if
			if right(RTrimVBTab(lcase(centerS)),5)<>" then" then
				centerS=centerS & " :end if  "
			end if
			centerS = leftS & centerS & noteS
			
		elseif left(LCaseS,4)="wend" then
			s= "end While"
			
		end if 
		
		c=c & s & vbcrlf
	next
	ASPToVBNET=c
end function
'���������Ĭ��ֵ��ָ��
function dimAddDefaultValue(dimList)  
	dim splstr,s,c,startStr,dimValue,tempDimList,noteS
	tempDimList=dimList
	startStr=mid(dimList,1,instr(Lcase(dimList),"dim ")+3)
	dimList=mid(dimList,len(startStr)) 
	splstr=split(dimList,",")
	for each s in splstr			
		noteS=""
		if instr(s,":")>0 then
			noteS=mid(s,instr(s,":"))
			s=mid(s,1,instr(s,":")-1)
			'call echo("s",s)
		elseif instr(s,"'")>0 then
			noteS=mid(s,instr(s,"'"))
			s=mid(s,1,instr(s,"'")-1)
			'call echo("s",s)
		end if
		
		if instr(lcase("|c|content|html|htmlstr|strhtml|cssstr|strcss|StyleName|parentUrl|parentParentUrl|parentParentParentUrl|szRet|Url|UrlFileName|urlList|UrlParam|WebSite|FanCharSet|s1|s2|s3|c1|c2|c3|c4|c5|En1|En2|En3|En4|s|temp|temp1|temp2|temp3|yinghaoLabel|parentName|valueStr|valueStr1|valueStr2|valueStr3|noDanYinShuangYinStr|PubAHrefList|PubATitleList|yinghaoLabel|parentName|valueStr|nLen|ParamList|ParamNameList|ParamList|Str_unicode|valueLabel|domainName|labelName|"), "|" & phptrim(lcase(s)) & "|")>0 or right(phptrim(lcase(s)),3)="str" then
			dimValue= dimValue & s & "=""""" & vbCrlf
		end if
		if c<>"" then c=c & ","
		c=c & s & noteS
	next
	dimAddDefaultValue=tempDimList & vbcrlf & dimValue
end function
'��������תNet������(20151021)
function functionParamtoNet(content)
	dim leftStr,rightStr,valueStr,splstr,s,c,LCaseS
	leftStr=mid(content,1,instr(content,"("))
	rightStr=mid(content,instr(content,")"))
	valueStr=mid(content,instr(content,"(")+1)
	valueStr=mid(valueStr,1,instr(valueStr,")")-1)
	
	splstr=split(valueStr,",")
	for each s in splstr
		s=phptrim(s)
		LCaseS=lcase(s)
		if instr(LCaseS,"byval")=false and instr(LCaseS,"byref")=false then
			s=" byref " & s
		end if
		if c<>"" then c=c & ","
		c=c & s
	next
	'call echo("leftStr",leftStr)
	'call echo("rightStr",rightStr)
	'call echo("valueStr",valueStr)
	functionParamtoNet = leftStr & c & rightStr
end function

'call echo("����",GetBeforeNStr("aa bb cc", "����", 2)) 
'call echo("����",GetBeforeNStr("""a a"" ""b b"" ""c  c""", "����", 2))
'call echo("����",GetBeforeNStr(" + - * / \ ", "����", 2)) 
'call echo("����",GetBeforeNStr(" 1 222.22 3 44", "����", 2)) 
'call echo("����",GetBeforeNStr(" aa - 333 ""a b c""", "ȫ��", 2))
'�����N�����ʻ������� (20050810)
function GetBeforeNStr(content,sType,nNumb)
    dim splStr, sx, s, c, i, sYHCount, s1, s2, tempZc, nI 
    dim wc                                                        '�����ı��洢����
	dim ArrayWC(999)											  '�����ı���������
	dim ArrayWCCount											  '�����ı�������������
    dim zc                                                        '���ʴ洢����
	dim ArrayZC(999)											  '���ʴ洢���� ����
	dim ArrayZCCount											  '���ʴ洢���� ��������
    dim nc                                                        'Ϊ�����ۼ�
	dim ArrayNC(999)											  'Ϊ�����ۼ� ����
	dim ArrayNCCount											  'Ϊ�����ۼ� ��������
    dim fc                                                        '����
	dim ArrayFC(999)											  '���� ����
	dim ArrayFCCount											  '���� ��������
	
	dim ArrayCountStr(999)											  '����������
	dim nArrayCount											  	  '��������

	
    dim yesOK                                                     '�Ƿ�OK
    dim tempS 
    dim upWord                                                    '��һ������
    dim upWord2                                                   '����һ������
    dim endCode                                                   '��ǰ���ַ����������

    dim beforeStr                                                 'ǰһ���ַ�
    dim afterStr                                                  '��һ���ַ�
    dim rowC                                                      'ÿ�д���
    dim tempRow                                                   'ÿ����������
    dim downRow                                                   '��һ�д���
     
    dim noteCode 
	
    sYHCount = 0                                                  '˫����Ĭ��Ϊ0
	
	
    ArrayWCCount=0											  '�����ı�������������
    ArrayZCCount=0											  '���ʴ洢���� ��������
    ArrayNCCount=0											  'Ϊ�����ۼ� ��������
    ArrayFCCount=0											  '���� ��������	
	nArrayCount=0											  '��������
	
	
	

    splStr = split(content, vbCrLf)                               '�ָ���
    'ѭ������
    for nI = 0 to uBound(splStr)
        s = splStr(nI) 
        tempS = s 
        rowC = "" : tempRow = ""         '���ÿ��ASP������ݴ������д���
        noteCode = ""                    'Ĭ��ע�ʹ���Ϊ��
        downRow = ""                     '��һ�д���
        if(nI + 1) <= uBound(splStr) then
            downRow = splStr(nI + 1)  
        end if 
        nc = ""                          '����Ϊ��

        'ѭ��ÿ���ַ�
        for i = 1 to len(s)
            sx = mid(s, i, 1) 
            beforeStr = right(replace(mid(s, 1, i - 1), " ", ""), 1)                       '��һ���ַ�
            afterStr = left(replace(mid(s, i + 1), " ", ""), 1)                            '��һ���ַ�
            endCode = mid(s, i + 1)                                                        '��ǰ�ַ���������� һ��

            '�����ı�
            if(sx = """" or wc <> "") then
                '˫�����ۼ�
                if sx = """" then sYHCount = sYHCount + 1 
                '�ж��Ƿ�"�����
                if sYHCount mod 2 = 0 then
                    if mid(s, i + 1, 1) <> """" then
                        wc = wc & sx 
                        s1 = right(replace(mid(s, 1, i - len(wc)), " ", ""), 1) '����������Ҫ�������

                        '������������
                        wc = right(wc, len(wc) - 1) 
                        wc = left(wc, len(wc) - 1) 
                        wc = replace(wc, """""", "\""") 
                        wc = """" & wc & """" 
						
						
    ArrayWCCount=ArrayWCCount+1											  '�����ı�������������						
	ArrayWC(ArrayWCCount)=wc											  '�����ı���������		
	nArrayCount=nArrayCount+1											  '��������		
	ArrayCountStr(nArrayCount)=wc										  '����������

                        rowC = rowC & wc                                        '���������ۼ�
                        sYHCount = 0 : wc = ""                                  '���
                    else
                        wc = wc & sx 
                    end if 
                else
                    wc = wc & sx 
                end if 

            '+-*\=&   �ַ����⴦��
            elseIf inStr(".&=,+-*/:()><", sx) > 0 and nc = "" then
                if zc <> "" then
                    tempZc = zc 
                    upWord2 = upWord                '��¼����һ������
                    upWord = lCase(tempZc)          '��¼��һ����������   ΪСд
                    rowC = rowC & zc 
                    zc = ""                         '�����ĸ����
                end if  
                upWord2 = upWord                                         '��¼����һ������
                upWord = sx 
				
    ArrayFCCount=ArrayFCCount+1											  '���� ��������	
	ArrayFC(ArrayFCCount)=sx											  '���� ����
	nArrayCount=nArrayCount+1											  '��������
	ArrayCountStr(nArrayCount)=sx										  '���������� 
			
            elseIf sx = "'" then
                noteCode = "//" & mid(s, i + 1) 
                exit for 
            '��ĸ
            elseIf checkABC(sx) = true or sx = "_" or zc <> "" then
                zc = zc & sx 
                yesOK = true 
                s1 = mid(s & " ", i + 1, 1) 
                s2 = mid(zc, 1, 1) 
                if checkABC(s1) <> true and s1 <> "_" then
                    yesOK = false 
                end if 
                '������������������
                if checkNumber(s1) = true and checkABC(s2) = true then
                    yesOK = true 
                end if 
                if yesOK = false then
                    'Remע��
                    if lCase(zc) = "rem" then
                        sx = mid(s, i + 1) : i = i + len(sx) 
                        zc = zc & sx 
                    end if 
 

    ArrayZCCount=ArrayZCCount+1											  '���ʴ洢���� ��������
	ArrayZC(ArrayZCCount)=zc											  '���ʴ洢���� ����
	nArrayCount=nArrayCount+1											  '��������
	ArrayCountStr(nArrayCount)=zc										  '����������
	
            'ע�����˳�
                    tempZc = zc 

                    upWord2 = upWord                '��¼����һ������
                    upWord = lCase(tempZc)          '��¼��һ����������   ΪСд
                    rowC = rowC & zc 
                    zc = ""                         '�����ĸ����
                end if 
            'Ϊ����
            elseIf checkNumber(sx) = true or nc <> "" then
                nc = nc & sx 
                if afterStr <> "." and checkNumber(afterStr) = false then
                    rowC = rowC & nc 
					

    ArrayNCCount=ArrayNCCount+1											  'Ϊ�����ۼ� ��������
	ArrayNC(ArrayNCCount)=nc											  'Ϊ�����ۼ� ����
	nArrayCount=nArrayCount+1											  '��������
	ArrayCountStr(nArrayCount)=nc										  '����������
					
					
                    nc = "" 
                end if 
            else
                rowC = rowC & sx 
            end if 
            tempRow = tempRow & sx 
        next 
        c = c & rowC 
    next 

	
	if sType="����" then
		if ubound(ArrayCountStr)>=nNumb then
			GetBeforeNStr=ArrayZC(nNumb)
		end if	
	elseif sType="����" then
		if ubound(ArrayCountStr)>=nNumb then
			GetBeforeNStr=ArrayWC(nNumb)
		end if	
	elseif sType="����" then
		if ubound(ArrayCountStr)>=nNumb then
			GetBeforeNStr=ArrayFC(nNumb)
		end if	
	elseif sType="����" then
		if ubound(ArrayCountStr)>=nNumb then
			GetBeforeNStr=ArrayNC(nNumb)
		end if	
	elseif sType="ȫ��" then
		if ubound(ArrayCountStr)>=nNumb then
			GetBeforeNStr=ArrayCountStr(nNumb)	
		end if	
	else
		GetBeforeNStr=c
	end if
end function


'����ַ�����ĵ�һ�γ��ֵ�Dim������   call rw(getStrDim("  dim a, b,        c,d   "  & vbcrlf &" ss    'sdfasdf"))
function getStrDim(byval content)
	content=replace(replace(content,vbcrlf,":"),vbtab," ")
	if instr(content,":")>0 then
		content=mid(content,1,instr(content,":")-1)
	end if
	if instr(content,"'")>0 then
		content=mid(content,1,instr(content,"'")-1)
	end if
	content=phptrim(content)
	if left(content,3)="dim" then
		content=mid(content,4)
	end if
	content=replace(content," ","")
	dim splstr,s,c
	if instr(content,"(")>0 then
		splstr=split(content,",")
		for each s in splstr
			if s <>"" then
				if c<>"" then c=c & ","
				if instr(s,"(")>0 then
					s=mid(s,1,instr(s,"(")-1)
				end if
				c=c & s
			end if
		next
		content=c
	end if 
	getStrDim=content
end function

'��ú����ַ�����ı����� call rw(getFunctionStrDim("aaa(ByVal Content,a,b,c,d)"))
function getFunctionStrDim(byval content)
	dim splstr,s,c,lCaseS
	if instr(content,")")>0 then
		content=mid(content,1,instr(content,")")-1)
	end if
	if instr(content,"(")>0 then
		content=mid(content,instr(content,"(")+1)
	end if
	content=replace(content,","," ")
	splstr=split(content," ")
	for each s in splstr
		lCaseS=lcase(s)
		if lCaseS<>"" and lCaseS<> "byval" and lCaseS<>"byref" then
			if c<>"" then c=c & ","
			c=c & s
		end if
	next
	getFunctionStrDim=c
end function

%>