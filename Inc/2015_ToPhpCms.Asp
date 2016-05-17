<% 
'��phpcmsͨ��   �ҵĺ�̨


'��ʾ�����б�
Function XY_PHP_NavList(action)
    XY_PHP_NavList = XY_PHP_GeneralList(action, "nav", "Select * From [v9_category] where parentid=0 and ismenu=1 order by listorder asc") 
End Function 

'��ʾϸ���б�
Function XY_PHP_DetailList(action)
    XY_PHP_DetailList = XY_PHP_GeneralList(action, "detail", "Select top 6 * From [v9_picture]") 
End Function 

'ͨ����Ϣ�б�
Function XY_PHP_GeneralList(action, sType, sql)
    Dim did, sid, tid, title, topNumb, cutStrNumb, addSql 
    Call HandleFunParameter(action, did, sid, tid, title, topNumb, cutStrNumb, addSql) '�����ô��������
    Dim defaultStr, i, j, s, c, startStr, endStr, url 
    Dim noFollow                                                                    '��׷�� 20141222
    defaultStr = GetDefaultValue(action)                                            '���Ĭ������
    Dim modI                                                                        '��ѭ��20150112
    noFollow = Trim(LCase(RParam(action, "noFollow")))                              '��׷��

    rs.Open sql, conn, 1, 1 
    'Call eerr("Sql��"& Rs.RecordCount &"��", Sql)
    For i = 1 To rs.RecordCount
        If rs.EOF Then Exit For 
        '��������
        If sType = "nav" Then
            url = sType & "_" & rs("catid") & ".html" 
            did = rs("catname") 
            title = rs("catname") 
        '�����¡�
        ElseIf sType = "detail" Then
            url = sType & "_" & rs("ID") & ".html" 
            did = "" 
            title = rs("title") 
        End If 
        '��ַ�ж�
        If url = WEBURLFILEPATH Then
            startStr = "[list-focus]" : endStr = "[/list-focus]" 
        Else
            startStr = "[list-" & i & "]" : endStr = "[/list-" & i & "]" 
        End If 
        '��ַ��ǰ׺
        url = WEBURLPREFIX & url 
        '��[list-mod2]  [/list-mod2]    20150112
        For modI = 6 To 2 Step - 1
            If InStr(defaultStr, startStr) = False And i Mod modI = 0 Then
                startStr = "[list-mod" & modI & "]" : endStr = "[/list-mod" & modI & "]" 
                If InStr(defaultStr, startStr) > 0 Then
                    Exit For 
                End If 
            End If 
        Next 

        'û������Ĭ��
        If InStr(defaultStr, startStr) = False Then
            startStr = "[list]" : endStr = "[/list]" 
        End If 

        If InStr(defaultStr, startStr) > 0 And InStr(defaultStr, endStr) > 0 Then
            s = StrCut(defaultStr, startStr, endStr, 2) 
            For j = 1 To 3
                s = ReplaceValueParam(s, "ni", i)                                               '����Ϊi����Ϊi����imgurl��ͻ [$i$]
                s = ReplaceValueParam(s, "���-1", i - 1)                                       '����Ϊi����Ϊi����imgurl��ͻ [$i$]
                s = ReplaceValueParam(s, "���", i)                                             '����Ϊi����Ϊi����imgurl��ͻ [$i$]
                s = ReplaceValueParam(s, "bigclassname", did) 
                s = ReplaceValueParam(s, "title", title) 
                s = ReplaceValueParam(s, "url", url) 
            Next 


            '��ʼλ�ü�Dialog����
            startStr = "[list-" & i & " startdialog]" : endStr = "[/list-" & i & " startdialog]" 
            If InStr(defaultStr, startStr) > 0 And InStr(defaultStr, endStr) > 0 Then
                s = StrCut(defaultStr, startStr, endStr, 2) & s 
            End If 
            '����λ�ü�Dialog����
            startStr = "[list-" & i & " enddialog]" : endStr = "[/list-" & i & " enddialog]" 
            If InStr(defaultStr, startStr) > 0 And InStr(defaultStr, endStr) > 0 Then
                s = s & StrCut(defaultStr, startStr, endStr, 2) 
            End If 
            c = c & s 
        End If 
    rs.MoveNext : Next : rs.Close 

    '��ʼ���ݼ�Dialog����
    startStr = "[dialog start]" : endStr = "[/dialog start]" 
    If InStr(defaultStr, startStr) > 0 And InStr(defaultStr, endStr) > 0 Then
        c = StrCut(defaultStr, startStr, endStr, 2) & c 
    End If 
    '�������ݼ�Dialog����
    startStr = "[dialog end]" : endStr = "[/dialog end]" 
    If InStr(defaultStr, startStr) > 0 And InStr(defaultStr, endStr) > 0 Then
        c = c & StrCut(defaultStr, startStr, endStr, 2) 
    End If 
    XY_PHP_GeneralList = c
End Function


'����ı����� ����Ǹ�ʲô�õã�����20150121
Function XY_PHP_SinglePage(Action)
	XY_PHP_SinglePage=XY_PHP_GetFieldValue(Action,"select * from [v9_page]","content")
End Function
'��õ����ֶ�����
function XY_PHP_GetFieldValue(Action,sql,fieldName)
	rs.open sql,conn,1,1
	if not rs.eof then
		XY_PHP_GetFieldValue=rs(fieldName)
	else
		XY_PHP_GetFieldValue=GetDefaultValue(Action)
	end if:rs.close
end function
%> 















