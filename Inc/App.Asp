<!--#Include File="Config.Asp"-->
<% 
'ѡ����
Select Case Request("act")
	Case "ViewInfo" : ViewInfo()			'�鿴��Ϣ
	Case "ViewList" : ViewList()			'�鿴�б�
	Case "ViewList2" : ViewList2()			'�鿴�б�2
	Case "test" : mytest()					'����
End Select
'����
Sub mytest()
	Dim UserName,UserName2,PassWord
	UserName=Rf("username")
	UserName2=Rq("username") 
	PassWord=Rf("userpass")
	Rw("UserName=" & UserName & vbCrlf)
	Rw("UserName2=" & UserName2 & vbCrlf)
	Rw("PassWord=" & PassWord)
End Sub

'�鿴�б�
Sub ViewList2()
	Dim IPList,nIPCount,Mobile,MobileList,nMobileType,nMobile,nComputer,S,I,IP
	Response.Addheader "Content-Type","text/html; charset=utf-8"
	Dim nArticleCount,nAddArticle,C,Path,Content,SplStr
	 
	Call OpenConn()
	nArticleCount=Conn.Execute("Select Count(*) From [Product]")(0)
	
	For I=0 To 50
		nAddArticle=Conn.Execute("Select Count(*) From [Product] Where UpDateTime=#"& Date()-I &"#")(0)
		C = C &  "ʱ��(" & Format_Time(Now-I,2) & ")" & vbCrlf & "��������("& nAddArticle &"/" & nArticleCount & ")" & vbCrlf
		Content = GetFText("\Admin\Data\Stat\" & Format_Time(Now()-I,2) & ".txt")
		SplStr=Split(Content,"��ǰ��")
		nMobile=0			'Ĭ���ֻ������
		nComputer=0			'Ĭ�ϵ��������
		nIPCount = 0		'����IP����
		nMobileType = 0		'�ֻ�������
		
		For Each S In SplStr
			If InStr(S,"IP:")>0 Then
				If InStr(S,vbCrlf & "IE: U" & vbCrlf)>0 Then
					nMobile = nMobile + 1
					Mobile = Mid(S,InStr(S,"XP=")+3)
					Mobile = Mid(Mobile,1,InStr(Mobile,vbCrlf)-2)
					If InStr(vbCrlf & MobileList & vbCrlf, vbCrlf & Mobile & vbCrlf)=0 Then
						MobileList = MobileList & Mobile & vbCrlf
						nMobileType = nMobileType + 1
					End If
				Else
					nComputer = nComputer + 1
				End If
				IP = Mid(S,InStr(S,"IP:")+3)
				IP = Mid(IP,1,InStr(IP,vbCrlf)-2)
				If InStr(vbCrlf & IPList & vbCrlf, vbCrlf & IP & vbCrlf)=0 Then
					IPList = IPList & IP & vbCrlf
					nIPCount = nIPCount + 1
				End If
			End If
		Next
		
		C=C & "LogDate="& Format_Time(Now()-I,2) &"" & vbCrlf 		'��־ʱ��
		C=C & "AddArticle="& nAddArticle &"" & vbCrlf 				'����������
		C=C & "ArticleSum="& nArticleCount &"" & vbCrlf 			'��������
		C=C & "WebBrowseSum="& (nComputer + nMobile) &"" & vbCrlf 	'��ҳ�������
		C=C & "ComputerSum="& nComputer &"" & vbCrlf 				'���������
		C=C & "MobileSum="& nMobile &"" & vbCrlf 					'�ֻ������
		C=C & "IndependentIP="& nIPCount &"" & vbCrlf 				'����IP��
		C=C & "IndependentMobileType="& nMobileType &"" & vbCrlf 	'�����ֻ�������
		C=C & "MobileTypeList="& MobileList &"" & vbCrlf 			'�����ֻ����б�		
		C=C & "-----------" & vbCrlf
	Next
	Response.Write(C)
End Sub
'�鿴�б�
Sub ViewList()
	Dim IPList,nIPCount,Mobile,MobileList,nMobileType,nMobile,nComputer,S,I,IP
	Response.Addheader "Content-Type","text/html; charset=utf-8"
	Dim nArticleCount,nAddArticle,C,Path,Content,SplStr
	Call OpenConn()
	nArticleCount=Conn.Execute("Select Count(*) From [Product]")(0)

	
	For I=0 To 50
		nAddArticle=Conn.Execute("Select Count(*) From [Product] Where UpDateTime=#"& Date()-I &"#")(0)
		C = C &  "ʱ��(" & Format_Time(Now-I,2) & ")" & vbCrlf & "��������("& nAddArticle &"/" & nArticleCount & ")" & vbCrlf
		Content = GetFText("\Admin\Data\Stat\" & Format_Time(Now()-I,2) & ".txt")
		SplStr=Split(Content,"��ǰ��")
		nMobile=0			'Ĭ���ֻ������
		nComputer=0			'Ĭ�ϵ��������
		nIPCount = 0		'����IP����
		nMobileType = 0		'�ֻ�������
		For Each S In SplStr
			If InStr(S,"IP:")>0 Then
				If InStr(S,vbCrlf & "IE: U" & vbCrlf)>0 Then
					nMobile = nMobile + 1
					Mobile = Mid(S,InStr(S,"XP=")+3)
					Mobile = Mid(Mobile,1,InStr(Mobile,vbCrlf)-2)
					If InStr(vbCrlf & MobileList & vbCrlf, vbCrlf & Mobile & vbCrlf)=0 Then
						MobileList = MobileList & Mobile & vbCrlf
						nMobileType = nMobileType + 1
					End If
				Else
					nComputer = nComputer + 1
				End If
				IP = Mid(S,InStr(S,"IP:")+3)
				IP = Mid(IP,1,InStr(IP,vbCrlf)-2)
				If InStr(vbCrlf & IPList & vbCrlf, vbCrlf & IP & vbCrlf)=0 Then
					IPList = IPList & IP & vbCrlf
					nIPCount = nIPCount + 1
				End If
			End If
		Next
		C=C & "��ҳ�����("& nComputer + nMobile &")��" & vbCrlf
		C=C &"IE���("& nComputer &")��" & vbCrlf
		C=C & "�ֻ����("& nMobile &")��" & vbCrlf
		C=C & "����IP��Ϊ("& nIPCount &")��" & vbCrlf 
		C=C & "-----------" & vbCrlf
	Next
	Response.Write(C)
End Sub

'�鿴��Ϣ
Sub ViewInfo()
	Dim IPList,nIPCount,Mobile,MobileList,nMobileType,nMobile,nComputer,S,I,IP
	Response.Addheader "Content-Type","text/html; charset=utf-8"
	Dim nArticleCount,nAddArticle,C,Path,Content,SplStr
	Call OpenConn()
	nArticleCount=Conn.Execute("Select Count(*) From [Product]")(0)
	nAddArticle=Conn.Execute("Select Count(*) From [Product] Where UpDateTime>=#"& Date() &"#")(0)
	

	
	C = "ʱ��(" & Format_Time(Now,2) & ")" & vbCrlf & "��������("& nAddArticle &"/" & nArticleCount & ")" & vbCrlf
	Content = GetFText("\Admin\Data\Stat\" & Format_Time(Now(),2) & ".txt")
	SplStr=Split(Content,"��ǰ��")
	nMobile=0			'Ĭ���ֻ������
	nComputer=0			'Ĭ�ϵ��������
	nIPCount = 0		'����IP����
	nMobileType = 0		'�ֻ�������
	For Each S In SplStr
		If InStr(S,"IP:")>0 Then
			If InStr(S,vbCrlf & "IE: U" & vbCrlf)>0 Then
				nMobile = nMobile + 1
				Mobile = Mid(S,InStr(S,"XP=")+3)
				Mobile = Mid(Mobile,1,InStr(Mobile,vbCrlf)-2)
				If InStr(vbCrlf & MobileList & vbCrlf, vbCrlf & Mobile & vbCrlf)=0 Then
					MobileList = MobileList & Mobile & vbCrlf
					nMobileType = nMobileType + 1
				End If
			Else
				nComputer = nComputer + 1
			End If
			IP = Mid(S,InStr(S,"IP:")+3)
			IP = Mid(IP,1,InStr(IP,vbCrlf)-2)
			If InStr(vbCrlf & IPList & vbCrlf, vbCrlf & IP & vbCrlf)=0 Then
				IPList = IPList & IP & vbCrlf
				nIPCount = nIPCount + 1
			End If
		End If
	Next
	C=C & "��ҳ�����("& nComputer + nMobile &")��" & vbCrlf
	C=C &"IE���("& nComputer &")��" & vbCrlf
	C=C & "�ֻ����("& nMobile &")��" & vbCrlf
	C=C & "����IP��Ϊ("& nIPCount &")��" & vbCrlf
	C=C & "��ͬ�ֻ�������Ϊ("& nMobileType &")��" & vbCrlf
	C=C & "��ͬ�ֻ��б���"& vbCrlf &  MobileList
	Response.Write(C)
End Sub
%>