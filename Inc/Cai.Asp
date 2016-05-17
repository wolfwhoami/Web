<% 
'Cai�ɼ�����(2014)

'��òɼ�����
Function getHttpPage(ByVal httpurl, ByVal Char_Set)
    getHttpPage = handleGetHttpPage(httpurl, Char_Set)(0) 
End Function 
'������òɼ�����
Function handleGetHttpPage(ByVal httpurl, ByVal Char_Set)
    On Error Resume Next
    Dim startTime, nStatus, nTime, content, splType, webFileSize 
    startTime = Now() 
    splType = "|-*ypia=|" 
    Char_Set = handleStrCharSet(Char_Set) 
    If IsNull(httpurl) = True Or Len(httpurl) < 7 Or httpurl = "$False$" Then
        handleGetHttpPage = Split("" & splType & -1 & splType & nTime & splType & webFileSize, splType) 
        Exit Function 
    End If
	
    Dim http 
    Set http = CreateObject("MSXML2.XMLHTTP")
        Call http.Open("GET", httpurl, False) 
        http.send 
        If http.readyState <> 4 Then
            Set http = Nothing 
            handleGetHttpPage = Split("" & splType & http.readyState & splType & nTime & splType & webFileSize, splType) 
            Exit Function 
        End If 

        content = bytesToBstr(http.responseBody, Char_Set) 
        nStatus = http.Status 
        nTime = DateDiff("s", startTime, Now()) 
        webFileSize = strLength(content) 

        handleGetHttpPage = Split(content & splType & nStatus & splType & nTime & splType & webFileSize, splType) 

    Set http = Nothing 
End Function 
'�������url״̬
Function getHttpUrlState(httpurl)
    getHttpUrlState = handleGetHttpPage(httpurl, "")(1) 
End Function 
'�������url�ķ���������
function getHttpUrlServerName(httpurl)
	getHttpUrlServerName=""			'����php���õ�
end function

'��òɼ����� (����)
Function getURLContent(httpurl, Char_Set)
    getURLContent = getHttpPage(httpurl, Char_Set) 
End Function 
'��òɼ����� (����)
Function getHttpUrl(httpurl, Char_Set)
    getHttpUrl = getHttpPage(httpurl, Char_Set) 
End Function 
Function bytesToBstr(body, Cset)
    Dim ObjStream 
    If isNul(body) Then Exit Function                                               'Ϊ�����˳�
    Set ObjStream = CreateObject("ADODB.Stream")
        ObjStream.Type = 1 
        ObjStream.Mode = 3 
        ObjStream.Open 
        Call ObjStream.Write(body) 
        ObjStream.Position = 0 
        ObjStream.Type = 2 
        ObjStream.Charset = Cset 
        bytesToBstr = ObjStream.ReadText 
        ObjStream.Close 
    Set ObjStream = Nothing 
End Function 
'��ȡ�ַ��� ����20160114
'c=[A]abbccdd[/A]
'0=abbccdd
'1=[A]abbccdd[/A]
'3=[A]abbccdd
'4=abbccdd[/A]
'��ȡ�ַ���
Function strCut(ByVal content, ByVal startStr, ByVal endStr, ByVal cutType)
    Dim s1, s1Str, s2, s3, c, tempContent, tempStartStr, tempEndStr 
    tempStartStr = startStr 
    tempEndStr = endStr 
    tempContent = content 
    cutType = "|" & cutType & "|" 
    '�����ִ�Сд
    If InStr(cutType, "|lu|") > 0 Then
        content = LCase(content) 
        startStr = LCase(startStr) 
        endStr = LCase(endStr) 
    End If 
    If InStr(content, startStr) = False Or InStr(content, endStr) = False Then
        c = "" 
        Exit Function 
    End If 
    If InStr(cutType, "|1|") > 0 Then
        s1 = InStr(content, startStr) 
        s1Str = Mid(content, s1 + Len(startStr)) 
        s2 = s1 + InStr(s1Str, endStr) + Len(startStr) + Len(endStr) - 1                'ΪʲôҪ��1
    Else
        s1 = InStr(content, startStr) + Len(startStr) 
        s1Str = Mid(content, s1) 
        'S2 = InStr(S1, content, EndStr)
        s2 = s1 + InStr(s1Str, endStr) - 1 
    End If 
    s3 = s2 - s1 
    If s3 >= 0 Then
        c = Mid(tempContent, s1, s3) 
    Else
        c = "" 
    End If 
    If InStr(cutType, "|3|") > 0 Then
        c = tempStartStr & c 
    End If 
    If InStr(cutType, "|4|") > 0 Then
        c = c & tempEndStr 
    End If 
    strCut = c 
End Function 
'��ý�ȡ����,20150305
Function getStrCut(ByVal content, ByVal startStr, ByVal endStr, ByVal cutType)
    getStrCut = strCut(content, startStr, endStr, cutType) 
End Function 
'��ȡ�ַ� CutStr(Content,22,"null")
Function cutStr(ByVal content, ByVal cutNumb, ByVal MoreStr)
    Dim i, s, n 
    n = 0 
    cutNumb = CInt(cutNumb)                                                         'ת������������    ׷����20141107
    If MoreStr = "" Then MoreStr = "..." 
    If LCase(MoreStr) = "none" Or LCase(MoreStr) = "null" Then MoreStr = "" 
    cutStr = content 
    For i = 1 To Len(content)
        s = Asc(Mid(CStr(content), i, 1)) 
        If s < 0 Then s = s + 65536 
        If s < 255 Then n = n + 1 
        If s > 255 Then n = n + 2 
        If n >= cutNumb Then cutStr = Left(content, i) & MoreStr : Exit Function 
    Next 
End Function 
'��ȡ���ݣ������ִ�Сд 20150327  C=CutStrNOLU(c,"<heAd",">")
Function cutStrNOLU(content, startStr, endStr)
    Dim s, LCaseContent, nStartLen, nEndLen, NewStartStr 
    startStr = LCase(startStr) 
    endStr = LCase(endStr) 
    LCaseContent = LCase(content) 

    If InStr(LCaseContent, startStr) > 0 Then
        nStartLen = InStr(LCaseContent, startStr) 
        s = Mid(content, nStartLen) 
        LCaseContent = Mid(s, Len(startStr) + 1) 
        NewStartStr = Mid(s, 1, Len(startStr) + 1)                                      '��ÿ�ʼ�ַ�

        LCaseContent = Replace(LCaseContent, "<", "&lt;") 
        'Call eerr("111",LCaseContent)

        nEndLen = InStr(LCaseContent, endStr) 
        Call echo("nEndLen", nEndLen) 

        s = Mid(content, nStartLen, nEndLen + Len(startStr)) 
        'Call Echo(nStartLen,nEndLen)
        'Call Echo("S",S)
        cutStrNOLU = s 
    End If 
End Function 

'��ȡTD�ַ�
Function setCutTDStr(ByVal content, ByVal TDWidth, ByVal MoreColor)
    Dim i, s, c, n, EndNumb, YesMore 
    content = CStr(content & "") 
    If content = "" Then setCutTDStr = content : Exit Function 
    If TDWidth = "" Then setCutTDStr = content : Exit Function                      'TDWidthΪ�գ���Ϊ�Զ�
    n = 0 : YesMore = False 
    EndNumb = Int(TDWidth / 6.3) 
    For i = 1 To Len(content)
        s = Mid(content, i, 1) 
        If n >= EndNumb Then
            YesMore = True 
            Exit For 
        Else
            c = c & s 
        End If 
        If Asc(s) < 0 Then
            n = n + 2 
        Else
            n = n + 1 
        End If 
    Next 
    If YesMore = True Then
        '��Ҫ����Title�����HTML
        c = "<span Title=""" & displayHtml(content) & """ style=""background-color:" & MoreColor & ";"">" & c & "</span>" 
    End If 
    setCutTDStr = c 
End Function 
'��ȡTD�ַ� (����)
Function cutTDStr(content, TDWidth)
    cutTDStr = setCutTDStr(content, TDWidth, "#FBE3EF") 
End Function 
'�ָ��ַ�
Function getArrayList(ByVal content, ByVal startStr, ByVal endStr, ByVal StartType, ByVal EndType, ByVal sType)
    'on error resume next
    If IsNull(content) = True Or IsNull(startStr) = True Or IsNull(endStr) = True Then
        getArrayList = "" 
        Exit Function 
    End If 
    Dim c, Rep, Matches, TheMatch 
    content = Replace(Replace(content, Chr(10), "�����С�"), Chr(13), "�����С�") '�滻������
    Set Rep = CreateObject("VBscript.RegExp")
        Rep.IgnoreCase = True 
        Rep.Global = True 
        Rep.pattern = "(" & startStr & ").+?(" & endStr & ")" 
        Set Matches = Rep.Execute(content)
            For Each TheMatch In Matches
                c = c & "$Array$" & TheMatch.Value 
            Next 
        Set Matches = Nothing 
        If c = "" Then
            getArrayList = "" 
            Exit Function 
        End If 
        c = Right(c, Len(c) - 7) 
        If StartType = False Then
            Rep.pattern = startStr 
            c = Rep.Replace(c, "") 
        End If 
        If EndType = False Then
            Rep.pattern = endStr 
            c = Rep.Replace(c, "") 
        End If 
    Set Rep = Nothing 
    If sType = "1" Or sType = "ȥ���ַ�" Or sType = True Then
        c = Replace(c, """", "") 
        c = Replace(c, "'", "") 
        c = Replace(c, " ", "") 
        c = Replace(c, "(", "") 
        c = Replace(c, ")", "") 
    End If 
    getArrayList = c 
End Function 
'�ָ��ַ� �������ַ� (����)
Function getArray(content, startStr, endStr, StartType, EndType)
    getArray = getArrayList(content, startStr, endStr, StartType, EndType, "") 
End Function 
'�ָ��ַ� ȥ���ַ� (����)
Function getArray1(content, startStr, endStr, StartType, EndType)
    getArray1 = getArrayList(content, startStr, endStr, StartType, EndType, "ȥ���ַ�") 
End Function 
'��ȡָ���ָ�ֵ
Function getSplit(ByVal content, ByVal splStr, ByVal n)
    Dim splxx 
    splxx = Split(content, splStr) 
    getSplit = splxx(n) 
End Function 
'��÷�������
Function getSplitCount(ByVal content, ByVal splStr)
    Dim splxx 
    splxx = Split(content, splStr) 
    getSplitCount = UBound(splxx) 
    If getSplitCount > 0 Then getSplitCount = getSplitCount + 1                     '��Ϊ�ռ�һ
End Function 

'���� ��Ϊ��������VB��������
Function agent(ByVal httpurl)
    'On Error Resume Next
    Server.ScriptTimeout = 999 
    '----------
    '��ȡԶ������
    Dim http 
    Set http = CreateObject("WinHttp.WinHttpRequest.5.1")

        http.Open "GET", httpurl, False 
        If Request.ServerVariables("HTTP_REFERER") <> "" Then
            http.SetRequestHeader "Referer", Request.ServerVariables("HTTP_REFERER") 
        End If 
        If Request.Cookies <> "" Then
            http.SetRequestHeader "Cookie", Request.Cookies 
        End If 
        http.SetRequestHeader "User-Agent", Request.ServerVariables("HTTP_USER_AGENT") 
        http.SetRequestHeader "X-Forwarded-For", Request.ServerVariables("REMOTE_ADDR") & ", " & Request.ServerVariables("LOCAL_ADDR") 
        http.SetRequestHeader "Connection", "Close" 
        http.SetRequestHeader "Nuclear-Atk", "http://" & Request.ServerVariables("HTTP_HOST") & Request.ServerVariables("SCRIPT_NAME") & "?" & Request.QueryString 
        http.SetRequestHeader "Nuclear-Atk-Host", Request.ServerVariables("HTTP_HOST") 
        http.send 

        Response.Status = http.Status & " " & http.StatusText                           '�հ�Զ��HTTP״̬����״̬�����ı�
        Response.ContentType = http.GetResponseHeader("Content-Type")                   '�հ�Զ����������
        Response.BinaryWrite http.responseBody                                          '�������������
End Function

%>    
