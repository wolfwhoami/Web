<% 
'���ٲ�����վSql Ϊ��ֲ(20151029)

'��Ʒ���׷��SQL����
'SqlGetDidSidTidSQl(Did,Sid,Tid)
'Sql =  GetWhereAnd(Sql,AddSql)
'д���ֲ������ݿⷽ����һ���ǲ���ȫ�����ݿ⣬��һ���Ǵ�����������ݿ�  20150723

'================ ���� ==========================
'���ʹ���С����Ϊ�Զ�����
Function getDidSidTidSQl(did, sid, tid)
    Dim sql, PrefixSql                                                              'ǰ׺SQL
    PrefixSql = " Where " 
    If did <> "" Then
        sql = sql & PrefixSql & "BigClassName='" & did & "'" 
        PrefixSql = " And " 
    End If 
    If sid <> "" Then
        sql = sql & PrefixSql & "SmallClassName='" & sid & "'" 
        PrefixSql = " And " 
    End If 
    If tid <> "" Then
        sql = sql & PrefixSql & "ThreeClassName='" & tid & "'" 
    End If 
    getDidSidTidSQl = sql 
End Function 
'���������
Function checkBigClass(did)
    checkBigClass = conn.Execute("Select Count(*) From [BigClass] Where BigClassName='" & did & "'")(0) 
End Function 
'���С�����
Function checkSmallClass(did, sid)
    Dim sql, addSql 
    sql = "Select Count(*) From [SmallClass]" 
    addSql = getDidSidTidSQl(did, sid, "") 
    sql = GetWhereAnd(sql, addSql) 
    checkSmallClass = conn.Execute(sql)(0) 
End Function 
'����������
Function checkThreeClass(did, sid, tid)
    Dim sql, addSql 
    sql = "Select Count(*) From [ThreeClass]" 
    addSql = getDidSidTidSQl(did, sid, tid) 
    sql = GetWhereAnd(sql, addSql) 
    checkThreeClass = conn.Execute(sql)(0) 
End Function 
'����Ʒ��Ϣ����
Function checkProduct(did, sid, tid)
    Dim sql 
    sql = "Select Count(*) From [Product]" 
    If did <> "" Then sql = GetWhereAnd(sql, "BigClassName='" & did & "'") 
    If sid <> "" Then sql = GetWhereAnd(sql, "SmallClassName='" & sid & "'") 
    If tid <> "" Then sql = GetWhereAnd(sql, "ThreeClassName='" & tid & "'") 
    checkProduct = conn.Execute(sql)(0) 
End Function 
'�Զ������ı���Ϣ�����жϣ�
Function autoAddMainInfo(title, ShowTitle, content)
    Call HandleAutoAddMainInfo(title, ShowTitle, False, content) 
End Function 
'�����Զ������ı�����
Function handleAutoAddMainInfo(title, ShowTitle, OnHtml, content)
    Dim sql 
    sql = "Select * From [MainInfo] Where Title='" & title & "'" 
    If UserId <> "" Then sql = GetWhereAnd(sql, " And UserId=" & UserId)            'ָ���û�
    If CheckSql(sql) = False Then Call eerr("Sql", sql) 
    rs.Open sql, conn, 1, 3 
    If rs.EOF Then
        rs.AddNew 
        rs("Title") = title 
        rs("ShowTitle") = ShowTitle 
        rs("Content") = content 
        rs("OnHtml") = OnHtml 
        rs.Update 
    End If : rs.Close 
End Function 
'�Զ����Ӵ��ࣨ���жϣ�
Function autoAddBigClass(did)
    Dim folderName, nSort 
    If conn.Execute("Select Count(*) From [BigClass] Where BigClassName='" & did & "'")(0) = 0 Then
        folderName = PinYin(did, 3) 
        nSort = conn.Execute("Select Count(*) From [SmallClass]")(0) + 1 
        conn.Execute("Insert Into[BigClass](BigClassName,FolderName,Sort) Values('" & did & "', '" & folderName & "'," & nSort & ")") 
        autoAddBigClass = "��" & did & "����������ɹ�" 
    Else
        autoAddBigClass = "��" & did & "�������Ѵ���" 
    End If 
End Function 
'�Զ�����С�ࣨ���жϣ�
Function autoAddSmallClass(did, sid)
    Dim folderName, nSort 
    If conn.Execute("Select Count(*) From [SmallClass] Where BigClassName='" & did & "' And  SmallClassName='" & sid & "'")(0) = 0 Then
        folderName = PinYin(sid, 3) 
        nSort = conn.Execute("Select Count(*) From [SmallClass] Where BigClassName='" & did & "'")(0) + 1 
        conn.Execute("Insert Into[SmallClass](BigClassName,SmallClassName,FolderName,Sort) Values('" & did & "','" & sid & "', '" & folderName & "'," & nSort & ")") 
        autoAddSmallClass = "��" & did & "������С��ɹ�" 
    Else
        autoAddSmallClass = "��" & did & "��С���Ѵ���" 
    End If 
End Function 
'�Զ������������ࣨ���жϣ�
Function autoAddThreeClass(did, sid, tid)
    Dim folderName, nSort 
    If conn.Execute("Select Count(*) From [ThreeClass] Where BigClassName='" & did & "' And  SmallClassName='" & sid & "' And ThreeClassName='" & tid & "'")(0) = 0 Then
        folderName = PinYin(sid, 3) 
        nSort = conn.Execute("Select Count(*) From [SmallClass] Where BigClassName='" & did & "' And  SmallClassName='" & sid & "'")(0) + 1 
        conn.Execute("Insert Into[ThreeClass](BigClassName,SmallClassName,ThreeClassName,FolderName,Sort) Values('" & did & "','" & sid & "','" & tid & "', '" & folderName & "'," & nSort & ")") 
        autoAddThreeClass = "��" & sid & "����������ɹ�" 
    Else
        autoAddThreeClass = "��" & sid & "�������Ѵ���" 
    End If 
End Function 
'�Զ��������£����жϣ�
Function autoAddArticle(did, sid, tid, title, content)
    autoAddArticle = AutoAddArticleAction("", did, sid, tid, title, "", content) 
End Function 
'�Զ������ļ������жϣ�
Function autoAddArticleAction(action, did, sid, tid, title, SortID, content)
    Dim addSql, sql, NewTitle,Splxx
    Dim BigImage, SmallImage, NewBigImage, NewSmallImage 
    Dim WebKeywords, WebDescription, NewWebKeywords, NewWebDescription, OriginalTitleYes, newAritcleID 

    BigImage = RParam(action, "BigImage")                                           '��ͼ��ַ
    SmallImage = RParam(action, "SmallImage")                                       'Сͼ��ַ
    BigImage = HandleHttpUrl(Replace(BigImage, "[$��ʽ����$]", WebSkins)) 
    SmallImage = HandleHttpUrl(Replace(SmallImage, "[$��ʽ����$]", WebSkins)) 

    WebKeywords = RParam(action, "Keywords")                                        '��վ�ؼ���
    WebDescription = RParam(action, "Description")                                  '��վ����
    WebKeywords = HandleHttpUrl(Replace(WebKeywords, "[$��ʽ����$]", WebSkins)) 
    WebDescription = HandleHttpUrl(Replace(WebDescription, "[$��ʽ����$]", WebSkins)) 

    OriginalTitleYes = LCase(RParam(action, "OriginalTitleYes"))                    '�Ƿ�Ϊԭ����
	
	dim memberprice			'��Ա��
	dim price				'�۸�
    memberprice =RParam(action, "memberprice")			'��Ա��
    price =RParam(action, "price")						'�۸�
	
	

    title = Trim(title) 
    addSql = addSql & getDidSidTidSQl(did, sid, tid) 
    If title <> "" Then addSql = addSql & " And Title='" & title & "'" 
    sql = "Select * From [Product]" & GetWhereAnd(sql, addSql) 
    RsTemp.Open sql, conn, 1, 3 
    If RsTemp.EOF Then
        If OriginalTitleYes = "true" Then
            NewTitle = title 
        Else
            NewTitle = did & "-" & sid & "-" & tid & "-" & title 
        End If 
        RsTemp.AddNew 
        RsTemp("BigClassName") = did 
        RsTemp("SmallClassName") = sid 
        RsTemp("ThreeClassName") = tid 
        RsTemp("WebTitle") = title 
        RsTemp("Title") = NewTitle 


        'FileName = HtmlFileName(NewTitle & "-" & GetRnd(11))            '�ļ����������

        NewBigImage = Replace(BigImage, "[id]", SortID) 
        NewSmallImage = Replace(SmallImage, "[id]", SortID) 
        If NewBigImage <> "" Then RsTemp("BigFiles") = NewBigImage 
        If NewSmallImage <> "" Then RsTemp("SmallFiles") = NewSmallImage 

        NewWebKeywords = Replace(WebKeywords, "[id]", NewTitle) 
        NewWebDescription = Replace(WebDescription, "[id]", NewTitle) 

        RsTemp("WebKeywords") = NewWebKeywords 
        RsTemp("WebDescription") = NewWebDescription 

        RsTemp("Content") = content
		
		call echo(action,memberprice)
		'�۸�
		if price<>"" then
			if instr(price,"-")>0 then
				splxx=split(price,"-")
        		RsTemp("price") = PHPRand(cint(splxx(0)),cint(splxx(1)))
			end if 
		end if
		'��Ա��
		if memberprice<>"" then
			if instr(memberprice,"-")>0 then
				splxx=split(memberprice,"-")
        		RsTemp("memberprice") = PHPRand(cint(splxx(0)),cint(splxx(1)))
			end if 
		end if

        RsTemp.Update 
        newAritcleID = RsTemp(0) 
        RsTemp.Close 

        RsTemp.Open "Select * From [Product] where id=" & newAritcleID, conn, 1, 3 
        If Not RsTemp.EOF Then
            RsTemp("FileName") = "article" & newAritcleID 
            RsTemp.Update 
        End If 

        autoAddArticleAction = True 
    Else
        autoAddArticleAction = False 
    End If : RsTemp.Close 
End Function 
'�Զ��������²��Զ���������
Function autoAddBigClassAndArticle(did, topNumb)
    Dim i 
    Call AutoAddBigClass(did) 
    For i = 1 To topNumb
        Call AutoAddArticle(did, "", "", did & "����-" & i, did & "����-" & i) 
    Next 
End Function 







'�����վģ��·�� 20150114
Function getWebTemplate()
    Dim rs 
    Set rs = CreateObject("Adodb.RecordSet")
        rs.Open "Select * From [WebSite]", conn, 1, 1 
        If Not rs.EOF Then
            getWebTemplate = rs("WebTemplate") 
        End If : rs.Close 
End Function
'�����վ��ʽ·�� 20150114
Function getWebSkins()
    Dim rs 
    Set rs = CreateObject("Adodb.RecordSet")
        rs.Open "Select * From [WebSite]", conn, 1, 1 
        If Not rs.EOF Then
            getWebSkins = rs("WebSkins") 
        End If : rs.Close 
End Function
'�����վ�ز� 20150713
Function getWebImages()
    Dim rs 
    Set rs = CreateObject("Adodb.RecordSet")
        rs.Open "Select * From [WebSite]", conn, 1, 1 
        If Not rs.EOF Then
            getWebImages = rs("WebImages") 
        End If : rs.Close 
End Function

'��ò�Ʒ��Ϣϸ��ҳ�Ƿ��Html�ļ�ǰ׺ 230141215
Function detailPageAddHtmlPrefix(ByVal fileName)
    fileName = HandleHttpUrl(fileName) 
    If InStr(fileName, "/") = False Then
        fileName = "/Html/" & fileName 
    Else
        fileName = ReplaceN(GetWebFolderName() & fileName, "//", "/", 3) 
        'Call Echo("FileName",FileName)

    End If 
    If Left(fileName, 1) <> "/" Then fileName = "/" & fileName 
    detailPageAddHtmlPrefix = fileName                                              'ǰ�滹�Ǽ�һ��/��
End Function 
'��ô������ļ������� ����תƴ��
Function getHandleFolderName(folderName)
    folderName = PinYin2(folderName) 
    folderName = Replace(Replace(folderName, "/", "\"), " ", "") 
    folderName = Replace(Replace(folderName, "\\", "\"), "\\", "\") 
    getHandleFolderName = folderName 
End Function 



'���Main��Ϣ��ַ
Function getMainInfoUrl(title)
    Dim fileName, url 
    rs.Open "Select * From [MainInfo] Where Title='" & title & "'", conn, 1, 1 
    If Not rs.EOF Then
        '�Զ���ģ��
        If Trim(rs("TemplatePath")) <> "" Then
            TemplatePath = WebTemplate & rs("TemplatePath") 
        Else
            TemplatePath = WebTemplate & "Main_Model.Html" 
        End If 


        '������20150209
        url = Trim(rs("FileName")) 

        If CheckMakeHtmlFile(url) = True Then
            fileName = GetHandleFileName(url) 
            url = detailPageAddHtmlPrefix(rs("FolderName")) & "/" & url 
            url = GetHandleUrl(url)                                                         '����URL
        End If 

        url = WebDebug(url, "act=MainInfo&Id=" & rs("Id"))                          '����
    End If : rs.Close 
    getMainInfoUrl = url 
End Function 
'���Main��Ϣ��ַ  (��ֵ����)
Function getMainUrl(title)
    getMainUrl = getMainInfoUrl(title) 
End Function 
'��õ������ӵ�ַ ��õ����ļ���ַ ��õ������� ��õ���С��  ������������ ����С������ ��������
Function getNavUrl(did, sid)
    Dim url, folderName, TempRs 

    Set TempRs = CreateObject("Adodb.RecordSet")
        TempRs.Open "Select * From [NavBigClass] Where BigClassName='" & did & "'", conn, 1, 1 
        If Not TempRs.EOF Then
            folderName = Trim(TempRs("FolderName")) 
            url = GetWebFolderName & "/" & TempRs("FolderName") & "/" & TempRs("FileName") 
            url = GetHandleUrl(url)                                                         '����URL
            '׷���ж�20141226
            If CheckMakeHtmlFile(TempRs("FileName")) = False Then
                url = TempRs("FileName") 
            End If 

            url = WebDebug(url, "act=Nav&NavDid=" & did)                                '����
        End If : TempRs.Close 
        If sid <> "" Then
            TempRs.Open "Select * From [NavSmallClass] Where BigClassName='" & did & "' And SmallClassName='" & sid & "'", conn, 1, 3 
            If Not TempRs.EOF Then
                If TempRs("FolderName") = "" Then
                    url = "/" & folderName & "/" 
                Else
                    url = "/" & TempRs("FolderName") & "/" 
                End If 
                If TempRs("FileName") = "" Then
                    TempRs("FileName") = HtmlFileName(TempRs("SmallClassName")) 
                    TempRs.Update 
                End If 
                url = GetWebFolderName & url & TempRs("FileName") 
                url = GetHandleUrl(url)                                                         '����URL
                'Call Echo("Url", Url)
                '׷���ж�20141226
                If CheckMakeHtmlFile(TempRs("FileName")) = False Then
                    url = TempRs("FileName") 
                End If 

                url = WebDebug(url, "act=Nav&NavDid=" & did & "&NavSid=" & sid)         '����
            'Call Echo("Url", Url)
            End If : TempRs.Close 
        End If 
        getNavUrl = url 
    'Call Echo("GetNavUrl", GetNavUrl)
End Function
'��õ������ӵ�ַ������ ��õ����ļ���ַ ��õ������� ��õ���С��
Function getNavTarget(did, sid)
    If sid <> "" Then
        TempRs.Open "Select * From [NavSmallClass] Where BigClassName='" & did & "' And SmallClassName='" & sid & "'", conn, 1, 1 
        If Not TempRs.EOF Then
            getNavTarget = TempRs("Target") 
        End If : TempRs.Close 
        Exit Function 
    End If 
    TempRs.Open "Select * From [NavBigClass] Where BigClassName='" & did & "'", conn, 1, 1 
    If Not TempRs.EOF Then
        getNavTarget = TempRs("Target") 
    End If : TempRs.Close 
End Function 
'���BigClass�������ʹ����ļ���
Function getBigClassFolderName(did)
    Dim TempRs 
    Set TempRs = CreateObject("Adodb.RecordSet")
        TempRs.Open "Select * From [BigClass] Where BigClassName='" & did & "'", conn, 1, 1 
        If Not TempRs.EOF Then

            getBigClassFolderName = "/" & TempRs("FolderName") & "/" & TempRs("FileName") 
            getBigClassFolderName = GetHandleUrl(getBigClassFolderName)                     '����URL

            '׷���ж�20141226
            If CheckMakeHtmlFile(TempRs("FileName")) = False Then
                getBigClassFolderName = TempRs("FileName") 
            End If 

            Call WebDebug(getBigClassFolderName, "act=CreateClass&ProDid=" & TempRs("BigClassName") & "&page=1") '����
        End If : TempRs.Close 
End Function
'������һ����  (����)
Function getBigClassFileName(did)
    getBigClassFileName = getBigClassFolderName(did) 
End Function 
'������һ����  (����)
Function getBigClassUrl(did)
    getBigClassUrl = getBigClassFolderName(did) 
End Function 
'������С���ļ���
Function getSmallClassFolderName(did, sid)
    Dim url, RootFolder, DirName, TempRs 
    Set TempRs = CreateObject("Adodb.RecordSet")

        TempRs.Open "Select * From [BigClass] Where BigClassName='" & did & "'", conn, 1, 1 
        If Not TempRs.EOF Then

            RootFolder = "/" & TempRs("FolderName") & "/" 

            'If CheckMakeHtmlFile(TempRs("FileName"))=True Then
            'GetSmallClassFolderName = "/" & TempRs("FolderName") & "/"
            'GetSmallClassFolderName = GetHandleUrl(GetSmallClassFolderName)    '����URL
            'Else
            'GetSmallClassFolderName = TempRs("FileName")
            'End If
            getSmallClassFolderName = RootFolder 
            Call WebDebug(getSmallClassFolderName, "act=CreateClass&ProDid=" & TempRs("BigClassName")) '����
        End If : TempRs.Close 
        If sid <> "" Then
            TempRs.Open "Select * From [SmallClass] Where BigClassName='" & did & "' And SmallClassName='" & sid & "'", conn, 1, 1 
            If Not TempRs.EOF Then


                DirName = Trim(Replace(TempRs("FolderName"), "\", "/")) 
                If Left(DirName, 1) <> "/" Then
                    RootFolder = RootFolder & "/" & DirName & "/" 
                Else
                    RootFolder = "/" & TempRs("FolderName") & "/" 
                End If 

                'If CheckMakeHtmlFile(TempRs("FileName"))=True Then
                'GetSmallClassFolderName = GetSmallClassFolderName & "/" & TempRs("FolderName") & "/" & TempRs("FileName")
                'GetSmallClassFolderName = GetHandleUrl(GetSmallClassFolderName)    '����URL
                'Else
                'GetSmallClassFolderName = TempRs("FileName")
                'End If
                If CheckMakeHtmlFile(TempRs("FileName")) = True Then
                    RootFolder = RootFolder & TempRs("FileName") 
                    RootFolder = "/" & GetWebFolderName() & GetHandleUrl(RootFolder) '����URL         '�Ľ�
                Else
                    RootFolder = "/" & GetWebFolderName() & TempRs("FileName")       '�Ľ�
                    '�жϵ��ļ�����Ϊ��ַ�� �򷵻���ַ  �˺����ǻ��С��Ŀ¼�� �Ľ� 20150107
                    If GetWebSite(TempRs("FileName")) <> "" Then
                        RootFolder = TempRs("FileName") 
                    End If 
                End If 

                getSmallClassFolderName = RootFolder 

                Call WebDebug(getSmallClassFolderName, "act=CreateClass&ProDid=" & did & "&ProSid=" & TempRs("SmallClassName")) '����
            End If : TempRs.Close 
        End If 
End Function
'������һ����   (����)
Function getSmallClassFileName(did, sid)
    getSmallClassFileName = getSmallClassFolderName(did, sid) 
End Function 
'������һ����   (����)
Function getSmallClassUrl(did, sid)
    getSmallClassUrl = getSmallClassFolderName(did, sid) 
End Function 
'������������ļ���
Function getThreeClassFolderName(did, sid, tid)
    Dim RootFolder, DirName 
    'Call Echo("��ʾ",Did & ">>" & Sid & ">>" & Tid)
    TempRs.Open "Select * From [BigClass] Where BigClassName='" & did & "'", conn, 1, 1 
    If Not TempRs.EOF Then

        RootFolder = "/" & TempRs("FolderName") & "/" 

        'If CheckMakeHtmlFile(TempRs("FileName"))=True Then
        'GetThreeClassFolderName = "/" & TempRs("FolderName") & "/"
        'GetThreeClassFolderName = GetHandleUrl(GetThreeClassFolderName)    '����URL
        'Else
        'GetThreeClassFolderName = TempRs("FileName")
        'End If
        getThreeClassFolderName = RootFolder 
        Call WebDebug(getThreeClassFolderName, "act=CreateClass&ProDid=" & TempRs("BigClassName")) '����
    End If : TempRs.Close 
    If sid <> "" Then
        TempRs.Open "Select * From [SmallClass] Where BigClassName='" & did & "' And SmallClassName='" & sid & "'", conn, 1, 1 
        If Not TempRs.EOF Then

            'If CheckMakeHtmlFile(TempRs("FileName"))=True Then
            'GetThreeClassFolderName = GetThreeClassFolderName & "/" & TempRs("FolderName") & "/"
            'GetThreeClassFolderName = GetHandleUrl(GetThreeClassFolderName)    '����URL
            'Else
            'GetThreeClassFolderName = TempRs("FileName")
            'End If

            DirName = Trim(Replace(TempRs("FolderName"), "\", "/")) 
            If Left(DirName, 1) <> "/" Then
                RootFolder = RootFolder & "/" & DirName & "/" 
            Else
                RootFolder = "/" & TempRs("FolderName") & "/" 
            End If 

            getThreeClassFolderName = RootFolder 
            Call WebDebug(getThreeClassFolderName, "act=CreateClass&ProDid=" & did & "&ProSid=" & TempRs("SmallClassName")) '����
        End If : TempRs.Close 
    End If 
    If tid <> "" Then
        TempRs.Open "Select * From [ThreeClass] Where BigClassName='" & did & "' And SmallClassName='" & sid & "' And ThreeClassName='" & tid & "'", conn, 1, 1 
        If Not TempRs.EOF Then

            DirName = Trim(Replace(TempRs("FolderName"), "\", "/")) 
            If Left(DirName, 1) <> "/" Then
                RootFolder = RootFolder & "/" & DirName & "/" 
            Else
                RootFolder = "/" & TempRs("FolderName") & "/" 

                '�жϵ��ļ�����Ϊ��ַ�� �򷵻���ַ  �˺����ǻ������Ŀ¼�� �Ľ� 20150107
                If GetWebSite(TempRs("FileName")) <> "" Then
                    RootFolder = TempRs("FileName") 
                End If 

            End If 
            'Call Echo(TempRs("FileName"), CheckMakeHtmlFile(TempRs("FileName")))
            'If CheckMakeHtmlFile(TempRs("FileName"))=True Then
            'GetThreeClassFolderName = GetThreeClassFolderName & "/" & TempRs("FolderName") & "/" & TempRs("FileName")
            'GetThreeClassFolderName = GetHandleUrl(GetThreeClassFolderName)    '����URL
            'Else
            'GetThreeClassFolderName = TempRs("FileName")
            'End If

            If CheckMakeHtmlFile(TempRs("FileName")) = True Then
                RootFolder = RootFolder & TempRs("FileName") 
                RootFolder = GetHandleUrl(RootFolder)                                           '����URL
            Else
                RootFolder = TempRs("FileName") 
            End If 

            getThreeClassFolderName = RootFolder 
            Call WebDebug(getThreeClassFolderName, "act=CreateClass&ProDid=" & did & "&ProSid=" & sid & "&ProTid=" & TempRs("ThreeClassName")) '����
        End If : TempRs.Close 
    End If 
End Function 
'������һ����   (����)
Function getThreeClassFileName(did, sid, tid)
    getThreeClassFileName = getThreeClassFolderName(did, sid, tid) 
End Function 
'������һ����   (����)
Function getThreeClassUrl(did, sid, tid)
    getThreeClassUrl = getThreeClassFolderName(did, sid, tid) 
End Function 
'��ò�Ʒ���͵�URL��ַ������������С��������
Function getClassUrl(did, sid, tid)
    Dim url 
    If tid <> "" Then
        url = getThreeClassFolderName(did, sid, tid) 
    ElseIf sid <> "" Then
        url = getSmallClassFolderName(did, sid) 
    Else
        url = getBigClassFolderName(did) 
    End If 
    url = Trim(Replace(url, "\", "/")) 
    If Left(url, 1) <> "/" And GetWebSite(url) = "" Then url = "/" & url 
    getClassUrl = url 
End Function 
'��ò�Ʒ���͵�URL��ַ������������С�������� ������
Function getClassUrl_Nav(did, sid, tid)
    Dim url 
    url = getClassUrl(did, sid, tid) 
    url = Mid(url, 2) 
    If Right(url, 1) = "/" Then url = Left(url, Len(url) - 1) 
    getClassUrl_Nav = url 
End Function 
'��ò�Ʒ���ӵ�ַ
Function getProductUrl(addSql)
    TempRs.Open "Select * From [Product] " & addSql, conn, 1, 1 
    If Not TempRs.EOF Then
        getProductUrl = GetHandleUrl(TempRs("FileName")) 
        Call WebDebug(getProductUrl, "act=CreateArticle&ID=" & TempRs("Id"))        '����
    End If : TempRs.Close 
End Function 
'�Զ�������Ʒ�ļ����� ���ظ�    ������2014,03,28
Function aotuGetProductFileName(ByVal title)
    Dim YesOK, fileName, TempTitle 
    TempTitle = title 
    title = Md5(TempTitle, 2) & Md5(TempTitle, 4) 
    YesOK = True 
    While YesOK
        TempRs.Open "Select * From [Product] Where Title='" & title & "'", conn, 1, 1 
        If TempRs.EOF Then
            YesOK = False 
            aotuGetProductFileName = title 
        Else
            TempTitle = TempTitle & "1" 
            title = Md5(TempTitle, 2) & Md5(TempTitle, 4) 
        End If : TempRs.Close 
        'Call Echo(TempTitle,Title) : Doevents
    Wend 
End Function 
'��Ʒ��һҳ
Function upPage(id)
    Dim add, did, sid, tid, sql, url, Target, title, AHttpUrl 
    RsTemp.Open "Select * From [Product] Where ID=" & id, conn, 1, 1 
    If Not RsTemp.Eof Then
        did = RsTemp("BigClassName") 
        sid = RsTemp("SmallClassName") 
        tid = RsTemp("ThreeClassName") 
    End If : RsTemp.Close 

    If tid <> "" Then
        add = "BigClassName='" & did & "' And SmallClassName='" & sid & "' And ThreeClassName='" & tid & "' And" 
    ElseIf sid <> "" Then
        add = "BigClassName='" & did & "' And SmallClassName='" & sid & "' And" 
    Else
        add = "BigClassName='" & did & "' And " 
    End If 
    sql = "Select * from [Product] where " & add & "  Id < " & id & " order by Id  desc" 

    RsTemp.Open sql, conn, 1, 1 
    If Not RsTemp.Eof Then

        url = RsTemp("FileName") 
        If CheckRemoteUrl(url) = False Then
            url = GetHandleUrl(RsTemp("FileName")) 
            Call WebDebug(url, "act=CreateArticle&ID=" & RsTemp("Id"))                  '����
        End If 

        Target = "_top" 
        title = RsTemp("Title") 
        AHttpUrl = "<a " & AHref(url, title, Target) & ">��һƪ��" 

        upPage = AHttpUrl & CutStr(title, 100, "...") & "</a><br>" 
    Else
        upPage = InfoColor("��һƪ��û��<br>", SysStyle(0)) & "" 
    End If 
    RsTemp.Close 
End Function 
'��Ʒ��һҳ
Function downPage(id)
    Dim add, did, sid, tid, sql, url, Target, title, AHttpUrl 
    RsTemp.Open "Select * From [Product] Where ID=" & id, conn, 1, 1 
    If Not RsTemp.EOF Then
        did = RsTemp("BigClassName") 
        sid = RsTemp("SmallClassName") 
        tid = RsTemp("ThreeClassName") 
    End If : RsTemp.Close 

    If tid <> "" Then
        add = "BigClassName='" & did & "' And SmallClassName='" & sid & "' And ThreeClassName='" & tid & "' And" 
    ElseIf sid <> "" Then
        add = "BigClassName='" & did & "' And SmallClassName='" & sid & "' And" 

    Else
        add = "BigClassName='" & did & "' And " 
    End If 
    sql = "select * from Product where " & add & "  Id > " & id & " order by Id  asc" 
    RsTemp.Open sql, conn, 1, 1 
    If Not RsTemp.EOF Then

        url = RsTemp("FileName") 
        If CheckRemoteUrl(url) = False Then
            url = GetHandleUrl(RsTemp("FileName")) 
            Call WebDebug(url, "act=CreateArticle&ID=" & RsTemp("Id"))                  '����
        End If 

        Target = "_top" 
        title = RsTemp("Title") 
        AHttpUrl = "<a " & AHref(url, title, Target) & ">��һƪ��" 

        downPage = AHttpUrl & CutStr(title, 100, "...") & "</a><br>" 

    Else
        downPage = InfoColor("��һƪ��û��<br>", SysStyle(0)) 
    End If 
    RsTemp.Close 
End Function 

'�����������Html�ļ�����
Function getHandleFileName(ByVal fileName)
    '��������ļ�·��
    If fileName = "" Or fileName = "/" Or fileName = "\" Then
        getHandleFileName = "/Index.Html" 
    Else
        getHandleFileName = fileName & ".Html" 
    End If 
End Function 



'����HTML�ļ����ƴ���
Function htmlFileName(ByVal fileName)
    htmlFileName = handleSaveFileName(fileName, True) 
End Function 
'�������ܱ�����ļ�����(20150902)
Function handleSaveFileName(ByVal fileName, isToPinYin)
    Dim ZD, i, s 
    fileName = Trim(fileName) 
    If CheckMakeHtmlFile(fileName) = True Then
        ZD = ":*?""<>|.," 
        For i = 1 To Len(ZD)
            s = Mid(ZD, i, 1) 
            fileName = Replace(fileName, s, "") 
        Next 
        If isToPinYin = True Then
            fileName = Trim(PinYin2(fileName)) 
        End If 
    End If 
    'If FileName = "" Then FileName = GetDefaultFileName()            '�ļ�����Ϊ������Ĭ���ļ����� ����Ҫ
    handleSaveFileName = Left(fileName, 100)                                        '��ȡ100���ַ�
End Function 

'����Ƿ���Դ����ļ�
Function checkMakeHtmlFile(ByVal fileName)
    Dim url 
    fileName = Trim(LCase(Replace(fileName, "\", "/"))) : url = fileName 
    If InStr(fileName, "/") > 0 Then
        fileName = Trim(Mid(fileName, InStrRev(fileName, "/") + 1)) 
    End If 
    checkMakeHtmlFile = True 
    If Left(url, 7) = "http://" Or Left(url, 4) = "www." Or Left(url, 4) = "url:" Or Left(url, 5) = "/url:" Or Left(fileName, 1) = "#" Or Left(fileName, 11) = "javascript:" Then
        checkMakeHtmlFile = False 
    End If 
End Function 
'��ʾ�����޸���� 2014 12 12
'�÷���
'Url = ""& adminDir &"MainInfo.Asp?act=ShowEdit&Id=" & Id & "&n=" & GetRnd(11)
'Content = DisplayOnlineEditDialog(Url, Content)
'���������޸�
'MainContent = DisplayOnlineEditDialog(""& adminDir &"NavManage.Asp?act=EditNavBig&Id=" & TempRs("Id") & "&n=" & GetRnd(11), MainContent)
Function displayOnlineEditDialog(url, content)
    displayOnlineEditDialog = HandleDisplayOnlineEditDialog(url, content, "", "") 
End Function 
'�����޸Ŀ������Ӷ�   S = DisplayOnlineED2(Url, S, "<li|<a ")
Function displayOnlineED2(url, content, ReplaceStr)
    displayOnlineED2 = HandleDisplayOnlineEditDialog(url, content, "", ReplaceStr) 
End Function 
%> 