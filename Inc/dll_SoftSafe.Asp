<%
'dll�ⲿ����Ŷ��  ASPС���� �������������������ֵ���ظ��������ݣ�������� ����չ��
Class dllSoftSafe

'������Ϣ 

	private FrmName						'��������
	
	'��ʼ��
	Private Sub Class_Initialize()
		
	End Sub
	'�������� ����ֹ
	Private Sub Class_Terminate()
	
	End Sub
	'���ô�������
	Public Property Let setFrmName(Str)
		 FrmName=Str
	End Property
	'��ô�������
	Public Property Get getFrmName()
		getFrmName = FrmName
	End Property
	
	'�Ƿ�Ϊ���ݿ�����
	function isAccessPass(byval MDBPath,AccessPass)
		isAccessPass=false
        If CheckFile(MDBPath) = False Then
            Call MBInfo("����", "û�����ݿ�"): Exit function
        End If
        '���ݿ�����
        AccessPass = FileCreateDate(MDBPath)
        AccessPass = Format_Time(AccessPass, 4) & "313801120"
        If (CheckAccessPass(MDBPath, AccessPass)) = False Then
            Call MBInfo("����", "���ݿ��������" & AccessPass): Exit function
        End If
		isAccessPass=true
	end function 


	Function CheckFile(ByVal FileName)
		On Error Resume Next
		Dim Fso
		Call HandlePath(FileName)'�������·��
		Set Fso = CreateObject("Scripting.FileSystemObject")
			CheckFile = Fso.FileExists(FileName)
		Set Fso = Nothing
		If Err Then doError Err.Description, "CheckFile ����ļ� ����������FileName=" & FileName
	End Function
	Function FileCreateDate(FileName)
		FileCreateDate = GetFileCreateDate(FileName)
	End Function 
	Function Format_Time(s_Time, n_Flag)
		Dim Y, M, D, H, Mi, S
		Format_Time = ""
		If IsDate(s_Time) = False Then Exit Function
		Y = Cstr(Year(s_Time))
		M = Cstr(Month(s_Time))
		If Len(M) = 1 Then M = "0" & M
		D = Cstr(Day(s_Time))
		If Len(D) = 1 Then D = "0" & D
		H = Cstr(Hour(s_Time))
		If Len(H) = 1 Then H = "0" & H
		Mi = Cstr(Minute(s_Time))
		If Len(Mi) = 1 Then Mi = "0" & Mi
		S = Cstr(Second(s_Time))
		If Len(S) = 1 Then S = "0" & S
		Select Case n_Flag
			Case 1
						'yyyy-mm-dd hh:mm:ss
				Format_Time = Y & "-" & M & "-" & D & " " & H & ":" & Mi & ":" & S
			Case 2
						'yyyy-mm-dd
				Format_Time = Y & "-" & M & "-" & D
			Case 3
						'hh:mm:ss
				Format_Time = H & ":" & Mi & ":" & S
			Case 4
						'yyyy��mm��dd��
				Format_Time = Y & "��" & M & "��" & D & "��"
			Case 5
						'yyyymmdd
				Format_Time = Y & M & D
			Case 6
						'yyyymmddhhmmss
				Format_Time = Y & M & D & H & Mi & S
			Case 7
						'mm-dd
				Format_Time = M & "-" & D
			Case 8
						'yyyy��mm��dd��
				Format_Time = Y & "��" & M & "��" & D & "��" & " " & H & ":" & Mi & ":" & S
			Case 9
						'yyyy��mm��dd��Hʱmi��S�� ����
				Format_Time = Y & "��" & M & "��" & D & "��" & " " & H & "ʱ" & Mi & "��" & S & "�룬" & GetDayStatus(H, 1)
			Case 10
						'yyyy��mm��dd��Hʱ
				Format_Time = Y & "��" & M & "��" & D & "��" & H & "ʱ"
			Case 11
						'yyyy��mm��dd��Hʱmi��S��
				Format_Time = Y & "��" & M & "��" & D & "��" & " " & H & "ʱ" & Mi & "��" & S & "��"
			Case 12
						'yyyy��mm��dd��Hʱmi��
				Format_Time = Y & "��" & M & "��" & D & "��" & " " & H & "ʱ" & Mi & "��"
			Case 13
						'yyyy��mm��dd��Hʱmi�� ����
				Format_Time = M & "��" & D & "��" & " " & H & ":" & Mi & " " & GetDayStatus(H, 0)
			Case 14
						'yyyy��mm��dd��
				Format_Time = Y & "/" & M & "/" & D
			Case 15
						'yyyy��mm�� ��1��
				Format_Time = Y & "��" & M & "�� ��" & GetCountPage(D, 7) & "��"
		End Select
	End Function 
	Function CheckAccessPass(MDBPath, AccessPass)
		On Error Resume Next
		Dim Conn
		CheckAccessPass = True
		Set Conn = CreateObject("Adodb.Connection")
			Conn.Open "Provider = Microsoft.Jet.OLEDB.4.0;Jet OLEDB:Database PassWord = '" & AccessPass & "';Data Source = " & MDBPath
			Conn.Close
			If Err <> 0 Then
				Err.Clsoe
				CheckAccessPass = False
			End If
	End Function 
	Function HandlePath(Path)'Pathǰ�治��ByVal �ض��壬������Ϊ����ǰ�溯�������ʹ�����·����������
		Path = Replace(Path, "/", "\")
		Path = Replace(Path, "\\", "\")
		Path = Replace(Path, "\\", "\")
		dim isDir'ΪĿ¼
		isDir = false
		if right(Path, 1) = "\" then
			isDir = true
		end if
		If InStr(Path, ":") = 0 Then
			If Left(Path, 1) = "\" Then
				Path = Server.MapPath("\") & "\" & Path
			Else
				Path = Server.MapPath(".\") & "\" & Path
			End If
		End If
		Path = Replace(Path, "/", "\")
		Path = Replace(Path, "\\", "\")
		Path = Replace(Path, "\\", "\")
		path = FullPath(Path)
		if isDir = true then
			Path = Path & "\"
		end if
		HandlePath = Path
	End Function 
	Function GetFileCreateDate(ByVal FileName)
		On Error Resume Next
		Dim Fso, OpenFile
		Call HandlePath(FileName)'�������·��
		Set Fso = CreateObject("Scripting.FileSystemObject")
			If Fso.FileExists(FileName) = True Then
				Set OpenFile = Fso.GetFile(FileName)
					GetFileCreateDate = OpenFile.DateCreated
				Set OpenFile = Nothing
			End If
		Set Fso = Nothing
		If Err Then doError Err.Description, "GetFileCreateDate ����ļ�����ʱ�� ����������FileName=" & FileName
	End Function 
	Function GetDayStatus(H, SType)
		Dim C
		If Left(H, 1) = "0" Then
			H = Right(H, 1)
		End If
		H = CInt(H)
		If H >= 0 And H <= 5 Then
			C = "�賿"
		ElseIf H >= 6 And H <= 8 Then
			C = "����"
		ElseIf H >= 9 And H <= 12 Then
			C = "����"
		ElseIf H >= 13 And H <= 18 Then
			C = "����"
		ElseIf H >= 19 And H <= 24 Then
			C = "����"
		Else
			C = "��ҹ"
		End If
		If SType = 1 Then C = "<b>" & C & "</b>"
		GetDayStatus = C
	End Function 
	Function GetCountPage(nCount, nPageSize)
		'�Ѹ���ת����ȷ���м���20150502
		if nCount < 0 then
			nCount = nCount * - 1
		end if
		if nPageSize < 0 then
			nPageSize = nPageSize * - 1
		end if
		GetCountPage = Fix(nCount / nPageSize)
		If InStr(nCount / nPageSize, ".") > 0 Then GetCountPage = GetCountPage + 1
	End Function 
	Function FullPath(ByVal Path)
		Dim SplStr, S, C
		Path = Replace(Path, "/", "\")
		SplStr = Split(Path, "\")
		For Each S In SplStr
			S = Trim(S)
			If S <> "" And S <> "." Then
				If InStr(C, "\") > 0 And S = ".." Then
					C = Mid(C, 1, InStrRev(C, "\") - 1)
				Else
					If C <> "" And Right(C, 1) <> "\" Then C = C & "\"
					C = C & S
				End If
			End If
		Next
		FullPath = C
	End Function
	
	
	
	Sub DoError(S, Msg)
		'On Error Resume Next
		Dim nRnd, C
		Randomize
		nRnd = CLng(Rnd() * 29252888)
		C = "<br />"
		C = C & "<div style=""width:100%; font-size:12px;;line-height:150%"">"
		C = C & "  <label onClick=""ERRORDIV" & nRnd & ".style.display=(ERRORDIV" & nRnd & ".style.display=='none'?'':'none')"">"
		C = C & "  <span style=""background-color:#820222;color:#FFFFFF;height:23px;font-size:14px;cursor:pointer"">�� ���� ��ʾ��Ϣ ERROR ��</span><br />"
		C = C & "  </label>"
		C = C & "  <div id=""ERRORDIV" & nRnd & """ style=""width:100%;border:1px solid #820222;padding:5px;overflow:hidden;"">"
		C = C & " <span style=""color:#FF0000;"">��������</span> " & S & "<br />"
		C = C & " <span style=""color:#FF0000;"">������Ϣ</span> " & Msg & "<br />"
		C = C & "  </div>"
		C = C & "</div>"
		C = C & "<br />"
		Response.Write(C)
		Response.End()'��ֹ������ֹͣ
	End Sub	
	Function Rw(Str)
		Response.Write(Str)
	End Function
	Function MsgBox(ByVal Content)
		Content = Replace(Replace(Content, Chr(10), "\n"), Chr(13), "\n")
		Response.Write("<script>alert('" & Content & "');</script>")
	End Function
	function MBInfo(title, content)
		MBInfo = MsgBox(title)
	End function
End Class


Dim testOBJ : Set testOBJ = New dllSoftSafe	'������
dim AccessPass
'call ddlCD.handAction("1+2*6+2=")
'call ddlCD.rw(ddlCD.handAction("ask 35915100"))

select case request("act")
	case "handle" : call testOBJ.rw(testOBJ.isAccessPass(request("MDBPath"),AccessPass))
	case else:Default()
end select

'Ĭ��
sub Default()
%>
<form id="form1" name="form1" method="post" action="?act=handle">
  ��������
  <input name="MDBPath" type="text" id="MDBPath" value="<%="\VB����\Data\Access.Mdb"%>" />
  <input type="submit" name="button" id="button" value="�ύ" />
</form>
<%end sub%>