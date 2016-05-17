<% 
'ɾ�����ֶ����ǩ <R#��������BlockName��վ���� start#>  <R#��������BlockName��վ���� end#>
'��ģ�崦��



'��ģ������
Function XY_ReadTemplateModule(action)
    Dim moduleId, filePath, c, i 
    Dim sourceList                                                                  'Դ�����б� 20150109
    Dim replaceList                                                                 '�滻�����б�
    Dim splSource, splReplace, sourceStr, replaceStr 
    filePath = RParam(action, "File") 
    moduleId = RParam(action, "ModuleId") 
    sourceList = RParam(action, "SourceList") 
    replaceList = RParam(action, "ReplaceList") 
    'Call Echo(SourceList,ReplaceList)

    If moduleId = "" Then moduleId = RParam(action, "ModuleName")                   '�ÿ�����
    filePath = filePath & ".html" 
    'Call Echo("FilePath",FilePath)
    'Call Echo("ModuleId",ModuleId)
    c = readTemplateModuleStr(filePath, "", moduleId) 
    '���滻��20160331
    If sourceList <> "" And replaceList <> "" Then
        splSource = Split(sourceList, "[Array]") 
        splReplace = Split(replaceList, "[Array]") 
        For i = 0 To UBound(splSource)
            sourceStr = splSource(i) 
            replaceStr = splReplace(i) 
            c = Replace(c, sourceStr, replaceStr) 
        Next 
    End If 
    XY_ReadTemplateModule = c 
End Function 

'��ģ������
Function readTemplateModuleStr(filePath, defaultContent, moduleId)
    Dim startStr, endStr, content 
    startStr = "<!--#Module " & moduleId & " start#-->" 
    endStr = "<!--#Module " & moduleId & " end#-->" 
    'FilePath = ReplaceGlobleLable(FilePath)                '�滻ȫ����ǩ        '������2014 12 11

    '�ļ������ڣ���׷��ģ��·�� 20150616 ��VB��������
    If checkFile(filePath) = False Then
        filePath = webTemplate & filePath 
    End If 

    If defaultContent <> "" Then
        content = defaultContent 
    ElseIf checkFile(filePath) = True Then
        content = getFText(filePath) 
    Else
        content = code                                                                  'Ĭ��������ָ������
    End If 
    'Call Die("��ʾ" & ModuleId & "," & Content)
    'Call Eerr(filepath & checkfile(filepath), Content)
    If InStr(content, startStr) > 0 And InStr(content, endStr) > 0 Then
        readTemplateModuleStr = strCut(content, startStr, endStr, 2) 
    Else
        readTemplateModuleStr = "ģ��[" & moduleId & "]������,·��=" & filePath 
    End If 
End Function 
'��ģ���Ӧ����
Function findModuleStr(content, valueStr)
    Dim startStr, endStr, YuanStr, replaceStr, i, Block, BlockFile, action 
    For i = 1 To 9
        startStr = "[$�������� " : endStr = "$]" 
        If InStr(valueStr, startStr) > 0 And InStr(valueStr, endStr) > 0 Then
            action = strCut(valueStr, startStr, endStr, 2) 
            Block = RParam(action, "Block") 
            BlockFile = RParam(action, "File") 
            If InStr(vbCrLf & ReadBlockList & vbCrLf, vbCrLf & Block & vbCrLf) = False Then
                ReadBlockList = ReadBlockList & Block & vbCrLf 
            End If 
            '���ļ����� ���������
            If BlockFile <> "" Then
                content = getFText(BlockFile) 
            End If 
            YuanStr = startStr & action & endStr 
            replaceStr = "" 

            startStr = "<R#��������" & Block & " start#>" : endStr = "<R#��������" & Block & " end#>" 
            If InStr(content, startStr) > 0 And InStr(content, endStr) > 0 Then
                replaceStr = strCut(content, startStr, endStr, 2) 
            Else
                startStr = "<!--#��������" & Block : endStr = "#-->" 
                If InStr(content, startStr) > 0 And InStr(content, endStr) > 0 Then
                    replaceStr = strCut(content, startStr, endStr, 2) 
                End If 
            End If 
            'Call Eerr(YuanStr,ReplaceStr)
            valueStr = Replace(valueStr, YuanStr, replaceStr) 
        'Call Echo("ValueStr",ValueStr)
        Else
            'û��ģ��Ҫ������ ���˳�
            Exit For 
        End If 
    Next 
    findModuleStr = valueStr 
End Function 

'����Leftģ����ʽ        �������ַ� ' ���ظ��ƻ���������������� \|*|\ ���洦��
Function XY_ReadColumeSetTitle(action)
    Dim startStr, endStr, Style, title, valueStr, MoreClass, MoreUrl, MoreStr, aStr,c
    action = handleInModule(action, "start") 
    Style = RParam(action, "style") 
    title = RParam(action, "Title") 
    'Call Echo("ContentHeight",ContentHeight)
    'ValueStr = RParam(Action,"value")
    '����ģ��������
    valueStr = moduleFindContent(action, "value") 
    'Call Eerr("ValueStr",ValueStr)
    valueStr = findModuleStr(code, valueStr)                                        '��ģ���Ӧ����

    MoreClass = RParam(action, "MoreClass") 
    MoreUrl = PHPTrim(RParam(action, "MoreUrl")) 
    MoreStr = RParam(action, "MoreStr") 
    valueStr = handleInModule(valueStr, "end") 
    c = readColumeSetTitle(action, Style, title, valueStr) 

    If MoreClass = "" Then MoreClass = "more"                                       'More����Ϊ�� ����Ĭ�ϴ���
    'If MoreUrl="" Then MoreUrl="#"                    'More������ַΪ�� ����Ĭ��#����
    'More������ʽ����Ϊ�գ���Ϊû����ʽ���Ͳ�����More�������
    If MoreUrl <> "" And MoreStr <> "" Then
        'AStr = "<a href='"& MoreUrl &"' class='"& MoreClass &"'>"& MoreStr &"</a>"
        aStr = "<a " & AHref(MoreUrl, title, "") & " class='" & MoreClass & "'>" & MoreStr & "</a>" 
        c = Replace(c, "<!--#AMore#-->", aStr) 
    End If 
	XY_ReadColumeSetTitle=c
End Function 

'����Ŀ��������������ֵ
Function readColumeSetTitle(action, id, ColumeTitle, ColumeContent)
    Dim TitleWidth                                                                  '�������
    Dim TitleHeight                                                                 '����߶�
    Dim ContentHeight                                                               '���ݸ߶�
    Dim ContentWidth                                                                '���ݿ���
    Dim ContentCss 

    TitleWidth = RParam(action, "TitleWidth")                                       '��ñ���߶�    ��Ӧ��20150715
    TitleHeight = RParam(action, "TitleHeight")                                     '��ñ������
    ContentWidth = RParam(action, "ContentWidth")                                   '������ݿ���
    ContentHeight = RParam(action, "ContentHeight")                                 '������ݸ߶�

    '�����
    TitleWidth = Trim(TitleWidth) 
    '�Զ���px��λ�����ӻ���Ч�� 20150115
    If Right(TitleHeight, 1) <> "%" And Right(TitleHeight, 2) <> "px" And TitleHeight <> "" And TitleHeight <> "auto" Then
        TitleHeight = TitleHeight & "px" 
    End If 
    If Right(TitleWidth, 1) <> "%" And Right(TitleWidth, 2) <> "px" And TitleWidth <> "" And TitleWidth <> "auto" Then
        TitleWidth = TitleWidth & "px" 
    End If 
    '���ݸ�
    ContentHeight = Trim(ContentHeight) 
    '�Զ���px��λ�����ӻ���Ч�� 20150115
    If Right(ContentHeight, 1) <> "%" And Right(ContentHeight, 2) <> "px" And ContentHeight <> "" And ContentHeight <> "auto" Then
        ContentHeight = ContentHeight & "px" 
    End If 
    '���ݿ�
    ContentWidth = Trim(ContentWidth) 
    '�Զ���px��λ�����ӻ���Ч�� 20150115
    If Right(ContentWidth, 1) <> "%" And Right(ContentWidth, 2) <> "px" And ContentWidth <> "" And ContentWidth <> "auto" Then
        ContentWidth = ContentWidth & "px" 
    End If 

    If ContentHeight <> "" Then
        ContentCss = "height:" & ContentHeight & ";" 
    End If 
    If ContentWidth <> "" Then
        ContentCss = ContentCss & "width:" & ContentWidth & ";" 
    End If 

    Dim content 
    content = readColumn(id) 
    '�����
    If TitleWidth <> "" Then
        content = Replace(content, "<div class=""tvalue"">", "<div class=""tvalue"" style='width:" & TitleWidth & ";'>") 
    End If 
    '���ݸ�
    If ContentCss <> "" Then
        content = Replace(content, "<div class=""ccontent"">", "<div class=""ccontent"" style='" & ContentCss & "'>") 
    End If 
    'call echo(ContentWidth,ContentCss)

    content = Replace(content, "��Ŀ����", ColumeTitle) 
    content = Replace(content, "��Ŀ����", ColumeContent) 
    readColumeSetTitle = content 
End Function 

'����Ŀģ��
Function readColumn(id)
    Dim templateFilePath, startStr, endStr, s 
    'Call Echo("WebTemplate",WebTemplate)
    templateFilePath = webTemplate & "\Template_Left.html" 
    startStr = "/*columnlist" & id & "Start*/" 
    endStr = "/*columnlist" & id & "End*/" 
    s = readTemplateFileModular(templateFilePath, startStr, endStr) 
    If s = "[$NO$]" Then
        s = "Left��ʽID[" & id & "]������" 
    End If 
    readColumn = s 
End Function 


'��ģ���ز�
Function readTemplateSource(id)
    Dim templateFilePath, startStr, endStr, s 
    templateFilePath = webTemplate & "\TemplateSource.html" 
    startStr = "<!--#sourceHtml" & id & "Start#-->" 
    endStr = "<!--#sourceHtml" & id & "End#-->" 
    s = readTemplateFileModular(templateFilePath, startStr, endStr) 
    If s = "[$NO$]" Then
        s = "ģ����ԴID[" & id & "]������" 
    End If 
    readTemplateSource = s 
End Function 



'��ģ���ļ���ĳģ��
Function readTemplateFileModular(templateFilePath, startStr, endStr)
    Dim content 
    readTemplateFileModular = "" 
    content = getFText(templateFilePath) 
    If InStr(content, startStr) > 0 And InStr(content, endStr) > 0 Then
        readTemplateFileModular = strCut(content, startStr, endStr, 2) 
    Else
        readTemplateFileModular = "[$NO$]" 
    End If 
End Function 

'���ļ�ģ���ز�
Function readTemplateFileSource(templateFilePath, id)
    Dim startStr, endStr, s, c 
    startStr = "<!--#sourceHtml" & Replace(id, ".html", "") & "Start#-->" 
    endStr = "<!--#sourceHtml" & Replace(id, ".html", "") & "End#-->" 
    s = readTemplateFileModular(templateFilePath, startStr, endStr) 
    If s = "[$NO$]" Then
        '��һ����ȡ���ı��������б�(20150815)
        c = getStrCut(pubCode, startStr, endStr, 2) 
        If c <> "" Then
            readTemplateFileSource = c 
            'call rwend(c)
            Exit Function 
        End If 
        c = getftext(templateFilePath) 
        '���� <!--#TemplateSplitStart#-->  �ͷ��ص�ǰȫ������
        If InStr(c, "<!--#DialogStart#-->") > 0 Then
            readTemplateFileSource = c 
            Exit Function 
        End If 

        s = "ģ����ԴID[" & id & "]������,·��TemplateFilePath=" & handlePath(templateFilePath) 
    End If 
    readTemplateFileSource = s 
End Function 
'�����ļ�չʾ�б���Դ
Function readArticleListStyleSource(id)
    Dim filePath 
    filePath = getWebImages() & "\����չʾ��ʽ\" & id 
    If checkFile(filePath) = False Then
        filePath = webTemplate & "\Resources\" & id 
    End If 
    'call echo(checkfile(filePath),filePath)
    readArticleListStyleSource = readTemplateFileSource(filePath, id) 

End Function 
'�����ļ���Ϣ�б���Դ
Function readArticleInfoStyleSource(id)
    Dim filePath 
    filePath = getWebImages() & "\������Ϣչʾ��ʽ\" & id 
    If checkFile(filePath) = False Then
        filePath = webTemplate & "\Resources\" & id 
    End If 
    readArticleInfoStyleSource = readTemplateFileSource(filePath, id) 
End Function 


%>   