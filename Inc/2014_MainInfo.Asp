<% 
'��ȡ�����ı���ʾ����[MainInfo]
Function ReadMainInfoShowTitle(Title)
    Dim AddSql 
    AddSql = "Select * From [MainInfo] Where Title='" & Title & "' And Recommend<>0 " 
    If UserId <> "" Then AddSql = AddSql & " And UserId=" & UserId 
    Rs.Open AddSql & " Order By Sort,ID", Conn, 1, 1 
    If Not Rs.EOF Then
        ReadMainInfoShowTitle = Rs("ShowTitle") 
    End If : Rs.Close 
End Function
 
'��ȡ�����ļ�����[MainInfo]
Function ReadMainInfo(Title)
    Dim AddSql 
    AddSql = "Select * From [MainInfo] Where Title='" & Title & "' And Recommend<>0 " 
    If UserId <> "" Then AddSql = AddSql & " And UserId=" & UserId 
    AddSql = AddSql & " Order By Sort,ID" 
    Rs.Open AddSql, Conn, 1, 1 
    If Not Rs.EOF Then
        ReadMainInfo = Rs("Content") 
    End If : Rs.Close 
End Function
 
'���ݱ�����MainInfo��ID
Function ReadMainId(Title)
    Dim AddSql 
    AddSql = "Select * From [MainInfo] Where Title='" & Title & "' And Recommend<>0 " 
    If UserId <> "" Then AddSql = AddSql & " And UserId=" & UserId 
    Rs.Open AddSql, Conn, 1, 1 
    If Not Rs.EOF Then
        ReadMainId = Rs("Id") 
    End If : Rs.Close 
End Function
 
'����ı����ݲ���
Function GetMainParam(ByVal TableName, ByVal FieldName, ByVal AddSql)
    Dim Sql, FileName, Url 
    Sql = "Select * From [" & TableName & "] " & AddSql 
    TempRs.Open Sql, Conn, 1, 1 
    If Not TempRs.EOF Then
        '�������ƻ����ַ
        If FieldName = "[url]" Then
            FileName = Trim(TempRs("FileName")) 
            If FileName = "" Then FileName = "MainInfo" & TempRs("Id") '�ļ�����Ϊ����ʹ��Ĭ��
            Url = GetHandleFileName(FileName) 
            Url = WebDebug(Url, "act=MainInfo&Id=" & TempRs("Id")) '����
            GetMainParam = Url 
        ElseIf FieldName <> "" Then
            GetMainParam = TempRs(FieldName) 
        End If 
    End If : TempRs.Close 
End Function
 
%> 