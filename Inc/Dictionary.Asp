<% 
'Dictionary �ֵ� (2013,9,27)
 
'��ʼ 
Dim AspD, AspHelpTitle, AspHelpContent 
Set AspD = CreateObject("Scripting.Dictionary")
AspD.Add "Abs", "�������ֵľ���ֵ" 
AspD.Add "Sqr", "������ֵ����ʽ��ƽ����" 
AspD.Add "Sgn", "���ر�ʾ���ַ��ŵ�����" 
AspD.Add "Rnd", "����һ��������ɵ�����" 
AspD.Add "Log", "����ָ����ֵ����Ȼ����" 
AspD.Add "Exp", "����e��ָ������" 
AspD.Add "Sin", "����ָ�����ȵ�����ֵ" 
AspD.Add "Cos", "����ָ�����ȵ�����ֵ" 
AspD.Add "Tan", "����ָ�����ȵ�����ֵ" 
AspD.Add "Atn", "����ָ����ֵ�ķ�����ֵ" 
AspD.Add "Int", "����ָ�����ֵ���������" 
AspD.Add "Round", "�Բ�����ָ����λ��������������" 
AspD.Add "Fix", "����ָ����ֵ����������" 
AspD.Add "Now", "���ص�ǰ������ʱ��" 
AspD.Add "Date", "���ص�ǰ��ϵͳ����" 
AspD.Add "Time", "���ص�ǰ��ϵͳʱ��" 
AspD.Add "Year", "��ָ���ı���ʽ����ȡ���" 
AspD.Add "Month", "��ָ���ı���ʽ����ȡ�·�" 
AspD.Add "Day", "��ָ������ʽ����ȡ����" 
AspD.Add "Hour", "��ָ���ı���ʽ����ȡ����ֵ" 
AspD.Add "Minute", "��ָ���ı���ʽ����ȡ������" 
AspD.Add "Second", "��ָ���ı���ʽ����ȡ����" 
AspD.Add "DateAdd", "��ָ������������ָ��ʱ������������ֵ" 
AspD.Add "DateDiff", "������������֮���ʱ����" 
AspD.Add "DatePart", "���ظ��������е�ĳһ����" 
AspD.Add "DateSerial", "�����ṩ�������յ���ֵ����һ��Date�����͵�����" 
AspD.Add "DateValue", "��ָ�����ַ���ת��ΪDate�����͵�����" 
AspD.Add "MonthName", "����ָ�������ַ��ش������·ݵ��ַ���" 
AspD.Add "Weekday", "���ش���һ����ĳһ�������" 
AspD.Add "WeekdayName", "�����ܴη��ش������ܴε��ַ���" 
AspD.Add "TimeSerial", "�����ṩ��ʱ�������ֵ����һ��Date�����͵�����" 
AspD.Add "TimeValue", "��ָ�����ַ���ת��ΪDate�����͵�����" 
AspD.Add "CBool", "������ʽת��ΪBoolean������" 
AspD.Add "CByte", "������ʽת��ΪByte������" 
AspD.Add "CDbl", "������ʽת��ΪDouble������" 
AspD.Add "Chr", "��ANSI�ַ����루����ת��Ϊ��Ӧ���ַ�" 
AspD.Add "CInt", "������ʽת��ΪInteger��ֵ������" 
AspD.Add "CLng", "������ʽת��ΪLong��ֵ������" 
AspD.Add "Cstr", "������ʽת��ΪString������" 
AspD.Add "CCur", "������ʽת��ΪCurrency������" 
AspD.Add "CDate", "�����ڱ���ʽת��ΪDate������" 
AspD.Add "CSng", "������ʽת��ΪSingle��ֵ������" 
AspD.Add "Asc", "�������ַ�������ĸ���Ӧ��ANSI�ַ����루����" 
AspD.Add "Oct", "���ذ˽��Ƶ��ַ���" 
AspD.Add "Hex", "����ʮ�����Ƶ��ַ���" 
AspD.Add "FormatNumber", "��ʽ��ָ������ֵ����ʽ" 
AspD.Add "FormatDateTime", "��ʽ��ָ��������ʱ�����ʽ" 
AspD.Add "FormatCurrency", "��ʽ��ָ���Ļ��ұ���ʽ" 
AspD.Add "FormatPercent", "��ʽ��ĳһ��ֵΪ�ٷ���" 
AspD.Add "IsArray", "�ж�ĳһ�����Ƿ�Ϊ�������" 
AspD.Add "IsDate", "�ж�ĳһ�����Ƿ�Ϊ���߿���ת��Ϊ���ڱ���ʽ" 
AspD.Add "IsEmpty", "�жϱ����Ƿ�Ϊ��" 
AspD.Add "IsNull", "�жϱ���ʽ���Ƿ������Ч����" 
AspD.Add "IsNumeric", "�жϱ���ʽ��ֵ�Ƿ�Ϊ����" 
AspD.Add "Is_object_", "�жϱ���ʽ��ֵ�Ƿ�Ϊĳһ����" 
AspD.Add "VarType", "����ָ��������������" 
AspD.Add "TypeName", "����ָ�����������͵���Ϣ" 
AspD.Add "MsgBox", "����������ʾ��Ϣ�ĶԻ���" 
AspD.Add "InputBox", "�������������ݵĶԻ���" 
AspD.Add "ScriptEngine", "����һ��������ǰ��ʹ�õĽű����Ե��ַ���" 
AspD.Add "ScriptEngineBuildVersion", "������ʹ�õĽű�����ı���汾��" 
AspD.Add "ScriptEngineMajorVersion", "������ʹ�õĽű���������汾��" 
AspD.Add "ScriptEngineMinorVersion", "������ʹ�ýű�����Ĵΰ汾��" 
AspD.Add "Array", "���������Ĳ�������һ������" 
AspD.Add "UBound", "����������������±�" 
AspD.Add "LBound", "�����������С�����±�" 
AspD.Add "Filter", "����һ���������а����������������ַ���" 
AspD.Add "InStr", "����ĳ�ַ�����ָ���ַ����е�һ�γ��ֵ�λ��" 
AspD.Add "InStrRev", "����ĳ�ַ�����ָ���ַ����дӽ�β����ĳ���λ��" 
AspD.Add "Join", "�������е��ַ�������Ϊһ���ַ���" 
AspD.Add "LCase", "���ַ����е���ĸȫ��ת��ΪСд��ʽ" 
AspD.Add "Left", "���ַ��������ȡָ����Ŀ���ַ�" 
AspD.Add "Len", "�����ַ����ĳ��Ȼ��ߴ洢ĳһ��������Ҫ���ֽ���" 
AspD.Add "Ltrim", "���ز���ǰ���ո���ַ���" 
AspD.Add "Replace", "���ַ�����ָ���ַ����滻Ϊ��������" 
AspD.Add "Right", "���ַ������Ҳ��ȡָ����Ŀ���ַ�" 
AspD.Add "Rtrim", "ɾ���ַ����ĺ����ո�" 
AspD.Add "Mid", "���ַ�����ָ��λ�û�ȡָ�����ȵ��ַ���" 
AspD.Add "Split", "���ذ���ָ����Ŀ���ַ�����һά����" 
AspD.Add "StrComp", "������ָ�����ַ������бȽ�" 
AspD.Add "StrReverse", "��ָ���ַ����������в������������к���ַ���" 
AspD.Add "String", "������ָ����Ŀ��ĳһ�ַ���ɵ��ַ���" 
AspD.Add "Trim", "ɾ���ַ�����ǰ���ͺ����ո�" 
AspD.Add "Space", "������ָ����Ŀ�Ŀո���ɵ��ַ���" 
AspD.Add "UCase", "���ַ����е���ĸȫ��ת��Ϊ��д��ʽ" 
AspD.Add "LoadPicture", "����һ��ͼƬ����" 
AspD.Add "Create_object_", "����������һ������" 
AspD.Add "Get_object_", "��ָ���ļ��л��һ��Automation����" 
AspD.Add "RGB", "���ش���ĳһ��ɫ������" 
AspHelpTitle = AspD.keys 
AspHelpContent = AspD.Items 
'���ASP���ú�������˵��
Function ASPHelpTip(ByVal FunName, ByVal Content)
	Dim I, S, C 
	For I = 0 To AspD.Count - 1
		If LCase(AspHelpTitle(I)) = LCase(FunName) Then
			If LCase(FunName) = "chr" Then
				S = Left(Content, InStr(Content, ")") - 1) 
				S = Replace(S, "(", "") 
				C = vbCrlf & "Chr(" & S & ")=" 
				If CheckNumber(S) = True Then    '�ж�Chr �����Ƿ�Ϊ����
					If S = "10" Or S = "13" Then
						C = C & "(�س���)" 
					ElseIf S = "32" Then
						C = C & "(�ո�)" 
					ElseIf S = "0" Then
						C = C & "(�жϳ���,ִֹͣ��)" 
					Else
						C = C & "(" & Chr(S) & ")" 
					End If 
					C = Replace(C, "'", "&#x27;") 
				Else
					C = C & S 
				End If 
			End If 
			ASPHelpTip = AspHelpContent(I) & C 
			Exit For 
		End If 
	Next 
End Function 
'�����û������ֵ
Function HandleWrite(Jc)
	Dim S 
	S = Left(Jc, Len(Jc) - 1) 
	S = Right(S, Len(S) - 1) 
	S = LCase(Trim(S)) 
	If S = "adodb.connection" Then
		Jc = """Adodb.Connection""" 
	ElseIf S = "adodb.recordset" Then
		Jc = """Adodb.RecordSet""" 
	End If 
	HandleWrite = Jc 
End Function 
'����     
'�����뷱��ת�� �÷� JianTiTabFanTi("�հڰܰ���������",2)2Ϊ����
Function JianTiTabFanTi(Path, Content, SType)
	Dim JianStr, FanStr, JianS, FanS, I, S, C 
	C = GetFText(Path) & vbCrlf 
	SType = Cstr(SType)    '�ַ����� 
	JianStr = StrCut(C, "����" & vbCrlf, vbCrlf, 2) 
	FanStr = StrCut(C, "����" & vbCrlf, vbCrlf, 2)  
	If 1 = 2 Then
		If Len(Content) * 2 < Len(JianStr) Then
			For I = 1 To Len(Content)
				S = Mid(Content, I, 1) 
				'����ת����
				If SType = "2" And InStr(JianStr, S) > 0 Then
					JianS = Mid(JianStr, InStr(JianStr, S), 1) 
					FanS = Mid(FanStr, InStr(JianStr, S), 1) 
					Content = Replace(Content, JianS, FanS) 
					Call Echo("", "") 
				ElseIf InStr(FanStr, S) > 0 Then
					JianS = Mid(JianStr, InStr(FanStr, S), 1) 
					FanS = Mid(FanStr, InStr(FanStr, S), 1) 
					Content = Replace(Content, FanS, JianS) 
				End If 
			Next 
			JianTiTabFanTi = Content 
			Exit Function 
		End If 
	End If 
	For I = 1 To Len(JianStr)
		JianS = Mid(JianStr, I, 1) 
		FanS = Mid(FanStr, I, 1) 
		'����ת����
		If SType = "2" Then
			Content = Replace(Content, JianS, FanS) 
		Else
			Content = Replace(Content, FanS, JianS) 
		End If 
	Next 
	JianTiTabFanTi = Content 
End Function 
'������滻
Function JiYiCiReplace(Path, Content)
	Dim SplStr, Splxx, I, S, C 
	SplStr = Split(GetFText(Path), vbCrlf) 
	For Each S In SplStr
		If InStr(S, ",") And Left(Trim(S), 1) <> "#" Then
			Splxx = Split(S, ",") 
			If UBound(Splxx) >= 1 Then
				Content = Replace(Content, Splxx(0), Splxx(1)) 
			End If 
		End If 
	Next 
	JiYiCiReplace = Content 
End Function
'�滻�ַ�
Function CiReplace(THContent, Content)
    Dim SplStr, Splxx, I, S, C
    SplStr = Split(THContent, vbCrLf)
    For Each S In SplStr
        If InStr(S, ",") And Left(Trim(S), 1) <> "#" Then
            Splxx = Split(S, ",")
            If UBound(Splxx) >= 1 Then
                Content = Replace(Content, Splxx(0), Splxx(1))
            End If
        End If
    Next
    CiReplace = Content
End Function

%> 
