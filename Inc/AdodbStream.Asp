<% 
'AdodbStream Adodb.Stream���������ȫ (2013,9,27)

'����ļ�����
Function checkCode(ByVal fileName)
	checkCode=getFileCharset(fileName)
End Function
'����ļ�����
Function getFileCharset(ByVal fileName)
    On Error Resume Next 
    Dim ObjStream, bintou 
    Call HandlePath(fileName)                                                       '�������·��
    Set ObjStream = CreateObject("ADODB.Stream")
        ObjStream.Type = 1 
        ObjStream.Mode = 3 
        ObjStream.Open 
        ObjStream.Position = 0 
        Call ObjStream.loadFromFile(fileName) 
        bintou = ObjStream.read(2)                                                      '�Զ����Ʒ�ʽ���������ַ�����(��̫̫)
        If TypeName(bintou) = "Null" Then getFileCharset = "gb2312" : Exit Function 
        If AscB(MidB(bintou, 1, 1)) = &HEF And AscB(MidB(bintou, 2, 1)) = &HBB Then
            getFileCharset = "utf-8" 
        ElseIf AscB(MidB(bintou, 1, 1)) = &HFF And AscB(MidB(bintou, 2, 1)) = &HFE Then
            getFileCharset = "unicode" 
        Else
            getFileCharset = "gb2312" 
        End If 
        ObjStream.Close 
    Set ObjStream = Nothing 
    If Err Then doError Err.Description, "getFileCharset������ļ����� ����������FileName=" & fileName 

End Function
'����ļ�����Senior
Function seniorCheckCode(ByVal fileName)
    '��ʱ�������ã���Ϊ�������ǻ�Ҫ����20150119
    'CheckCode = CheckFileCode(FileName)            '����ļ�����(������ ����׼)
    'Exit Function
    'On Error Resume Next
    Dim ObjStream, bintou 
    Call HandlePath(fileName)                                                       '�������·��
    Set ObjStream = CreateObject("ADODB.Stream")
        ObjStream.Type = 1 
        ObjStream.Mode = 3 
        ObjStream.Open 
        ObjStream.Position = 0 
        Call ObjStream.loadFromFile(fileName) 
        bintou = ObjStream.read(2)                                                      '�Զ����Ʒ�ʽ���������ַ�����(��̫̫)
        If TypeName(bintou) = "Null" Then seniorCheckCode = CheckFileCode(fileName) : Exit Function '�Ľ�2015019
        'N1 = AscB(MidB(bintou, 1, 1)) : N2 = AscB(MidB(bintou, 2, 1))
        'N = N1 & N2
        If AscB(MidB(bintou, 1, 1)) = &HEF And AscB(MidB(bintou, 2, 1)) = &HBB Then
            seniorCheckCode = "UTF-8" 
        ElseIf AscB(MidB(bintou, 1, 1)) = &HFF And AscB(MidB(bintou, 2, 1)) = &HFE Then
            seniorCheckCode = "UNICODE" 
        Else
            seniorCheckCode = CheckFileCode(fileName)                                       '��һ�ֳ�ǿ����ļ����뷽��
        End If 
        'CAll Rw(FileName & " >> Char_Set=" & CheckCode & " Code=" & N1  & "["& Chr(N1) &"]" &  "," & N2 & "["& Chr(N2) &"]" &"(utf-8(239,187),unicode(255,254)<br>")
        ObjStream.Close 
    Set ObjStream = Nothing 
    If Err Then doError Err.Description, "CheckCode������ļ����� ����������FileName=" & fileName 
End Function 
'��������������
Function readFile(ByVal fileName, ByVal Char_Set)
    On Error Resume Next 
    If Char_Set = "1" Or UCase(Char_Set) = "GB2312" Then
        Char_Set = "GB2312" 
    ElseIf Char_Set = "0" Or UCase(Char_Set) = "UTF-8" Then
        Char_Set = "UTF-8" 
    ElseIf Char_Set = "2" Or UCase(Char_Set) = "UNICODE" Then
        Char_Set = "UNICODE" 
    Else
        Char_Set = checkCode(fileName) 
        If Char_Set = "" Then Exit Function 
    End If 
    Dim str, stm, f, fso 
    Call HandlePath(fileName)                                                       '�������·��
	if checkfile(fileName)=false then 
		readFile=""
		exit function
	end if
    Set stm = CreateObject("ADODB.Stream")
        stm.Type = 2                                                                    '�Ա�ģʽ��ȡ
        stm.Mode = 3 
        stm.Charset = Char_Set 
        stm.Open 
        Set fso = CreateObject("Scripting.FileSystemObject")
            Set f = fso.GetFile(fileName)
                If f.Size > 0 Then
                    Call stm.loadFromFile(fileName) 
                End If 
                str = stm.ReadText 
                stm.Close 
            Set stm = Nothing 
            readFile = str 
            If Err Then doError Err.Description, "ReadFile���������������� ����������FileName=" & fileName 
        Set fso = Nothing 
    Set stm = Nothing 
End Function 
'��������������  (����)
Function getStext(fileName)
    getStext = readFile(fileName, "")
End Function
'��UTF-8�������ļ�����
function getFTextUTF(fileName)
	 getFTextUTF=readFile(fileName,"utf-8")
end function
'д������
Function writeToFile(ByVal fileName, ByVal content, ByVal Char_Set)
    On Error Resume Next 
    If Char_Set = "1" Or UCase(Char_Set) = "GB2312" Then
        Char_Set = "GB2312" 
    ElseIf Char_Set = "0" Or UCase(Char_Set) = "UTF-8" Then
        Char_Set = "UTF-8" 
    ElseIf Char_Set = "2" Or UCase(Char_Set) = "UNICODE" Then
        Char_Set = "UNICODE" 
    Else
        Char_Set = "GB2312" 
    End If 
    'Call Echo("Char_Set",Char_Set)
    Dim stm 
    Call HandlePath(fileName)                                                       '�������·��
    Set stm = CreateObject("ADODB.Stream")
        stm.Type = 2                                                                    '�Ա�ģʽ��ȡ
        stm.Mode = 3 
        stm.Charset = Char_Set 
        stm.Open 
        Call stm.WriteText(content) 
        Call stm.SaveToFile(fileName, 2) 
        stm.Flush 
        stm.Close 
        writeToFile = fileName & "д��ɹ�" 
    Set stm = Nothing 
    If Err Then doError Err.Description, "WriteToFile��������д������ ����������FileName=" & fileName & "��Content�ַ�" & Len(content) 
End Function
'����gb2312�ļ� 
function createFileGBK(byval fileName, byval content)
	call writeToFile(fileName,content,"gb2312")
end function
'����UTF-8�ļ���20151201��
function createFileUTF(byval fileName, byval content)
	call writeToFile(fileName,content,"utf-8")
end function
'��UTF��GB2312
'�Զ���ñ��벢���ж�Html�����Ƿ�������ļ�����һ�£�һ�����˳�����
Function getUGText(ByVal path)
    Dim Char_Set, FanCharSet, TempCharSet 
    Dim IsContent 
    Char_Set = checkCode(path) 
    IsContent = False 
    '���δ���������ȡ����
    If Char_Set = "utf-8" Then
        FanCharSet = "gb2312" 
    ElseIf Char_Set = "gb2312" Then
        FanCharSet = "utf-8" 
    End If 
    TempCharSet = FanCharSet 
    If FanCharSet <> "" Then
        If CheckStr(LCase(getUGText), "<meta [^>]*charset *= *" & FanCharSet) = True Then
            getUGText = readFile(path, TempCharSet) 
            IsContent = True 
        End If 
    End If 
    'û�ж������������ļ����������������
    If IsContent = False Then
        getUGText = readFile(path, Char_Set) 
    End If 
End Function 
'���Html�����Ƿ������˱���(��ǰҳû�е��ù�20150119)
Function checkContentCharset(ByVal content, ByVal Char_Set)
    content = LCase(content) 
    Char_Set = LCase(Char_Set) 
    checkContentCharset = True 
    If InStr(content, "<meta ") > 0 Then
        Dim i, s, TempS, LalType, LalStr 
        For i = 1 To Len(content)
            s = Mid(content, i, 1) 
            If s = "<" Then
                TempS = LCase(Mid(content, i)) 
                LalType = LCase(Mid(TempS, 1, InStr(TempS, " "))) 
                If LalType = "<meta " Then
                    LalStr = Mid(TempS, 1, InStr(TempS, ">")) 
                    If InStr(LalStr, "charset") > 0 Then
                        If InStr(LalStr, Char_Set) = 0 Then checkContentCharset = False 
                    End If 
                End If 
            End If 
        Next 
    End If 
End Function 
'�����ļ������ȡ
Function checkFileCode(filePath)
    Dim splStr, c, content, ToPath, YuanStr, s, nLen 
    YuanStr = BinaryReadFile(filePath) 

    'If Len(YuanStr) > 500 Then
    'YuanStr = Right(YuanStr, Len(YuanStr) - 30)
    'End If
    'ֻ��ȡ2500���ַ�
    If Len(YuanStr) > 2500 Then
        YuanStr = Right(YuanStr, 2500) 
    End If 
    nLen = Len(YuanStr) 
    ToPath = filePath & "_Temp" 
    splStr = Split("GB2312|UTF-8|UNICODE", "|") 
    For Each s In splStr
        content = readFile(filePath, s) 
        Call WriteToFile(ToPath, content, s) 
        c = BinaryReadFile(ToPath) 
        c = Right(c, nLen) 
        If YuanStr = c Then
            checkFileCode = s 
            Call deleteFile(ToPath)                                                         'ɾ�������ʱ�ļ�
            Exit For 
        End If 
    Next 
    Call deleteFile(ToPath)                                                         'ɾ�������ʱ�ļ�
End Function 
'����ļ����������� 20150312
Function getFileBinaryContent(filePath)
    Dim stream 
    Call HandlePath(filePath)                                                       '�������·��
    Set stream = CreateObject("ADODB.Stream")
        stream.Mode = 3 
        stream.Type = 1 
        stream.Open 
        Call stream.loadFromFile(filePath) 
        getFileBinaryContent = stream.read 
        stream.Close 
    Set stream = Nothing 
'Response.BinaryWrite Stream.Read            '��ʾ�������ļ�����
End Function 
'��ȡ�������ļ����������ַ�ʽ
Function binaryReadFile(filePath)
    Dim i, nR, c, stm 
    Call HandlePath(filePath)                                                       '�������·��
    Set stm = CreateObject("ADODB.Stream")
        stm.Mode = 3 
        stm.Type = 1 
        stm.Open 
        Call stm.loadFromFile(filePath) 
        c = "" : i = 0 : nR = 1 
        While i < stm.Size
            c = c & AscB(stm.read(nR)) 
            i = i + nR 
            DoEvents 
        Wend 
    Set stm = Nothing 
    binaryReadFile = c 
End Function 
'��ȡ�������ļ�������
Function readBinary(filePath, pass)
    Dim i, nR, c, stm 
    If pass = "" Then pass = 0                                                      '���Ϊ����Ϊ��20150119
    Call HandlePath(filePath)                                                       '�������·��
    Set stm = CreateObject("ADODB.Stream")
        stm.Mode = 3 
        stm.Type = 1 
        stm.Open 
        Call stm.loadFromFile(filePath) 
        c = "" : i = 0 : nR = 1                                                         'ÿ�ζ�ȡ�ַ���
        While i < stm.Size
            c = c &(AscB(stm.read(nR)) + pass) & "|" 
            i = i + nR 
        Wend 
        If c <> "" Then c = Left(c, Len(c) - 1) 
    Set stm = Nothing 
    readBinary = c 
End Function 
'���ܱ���������ļ�
Function decSaveBinary(filePath, content, pass)
    Dim splStr, buf(), i 
    If pass = "" Then pass = 0                                                      '���Ϊ����Ϊ��20150119
    splStr = Split(content, "|") 
    ReDim buf(UBound(splStr)) 
    For i = 0 To UBound(splStr)
        buf(i) = CByte(CInt(splStr(i)) - pass) 
    Next 
    Call WriteBinary(filePath, buf) 
End Function 
'����������ļ�   call writeBinary(filePath,Request.BinaryRead (Request.TotalBytes))
Sub writeBinary(filePath, Buf)
    Dim i, aBuf, size, bStream 
    Call HandlePath(filePath)                                                       '�������·��
    '���Ƕ����ƴ����ɶ�����(20151211)
	if typeName(Buf)<>"Byte()" then
		size = UBound(Buf) : ReDim aBuf(size \ 2) 
		For i = 0 To size - 1 Step 2
			aBuf(i \ 2) = ChrW(Buf(i + 1) * 256 + Buf(i))
		Next 
		If i = size Then aBuf(i \ 2) = ChrW(Buf(i)) 
		aBuf = Join(aBuf, "")
	else
		aBuf=Buf
	end if
	
    Set bStream = CreateObject("ADODB.Stream")
        bStream.Type = 1 
        bStream.Open 
        With CreateObject("ADODB.Stream")
            .Type = 2 
            .Open 
            Call.WriteText(aBuf) 
            .Position = 2 
            Call.CopyTo(bStream) 
            .Close 
        End With 
        Call bStream.SaveToFile(filePath, 2) 
        bStream.Close 
    Set bStream = Nothing 
End Sub 



'---------------------------- ���� ----------------------------
'����ļ����� �������ٰ� (��ASPBOX���ù���)  ��Ҫ��
Public Function getFileCharset2(ByVal filePath)
    Dim strFileHead 
    'On Error Resume Next
    If Err Then
        Err.Clear 
    End If 
    Call HandlePath(filePath)                                                       '�������·��
    Dim objStream, LoadBytes 
    Set objStream = CreateObject("ADODB.Stream")
        With objStream
            .Type = 1 
            .Mode = 3 
            .Open 
            .loadFromFile filePath 
            LoadBytes =.read(3) 
            .Close 
        End With 
    Set objStream = Nothing 
    If Err.Number <> 0 Then
        Err.Clear : getFileCharset2 = "" : Exit Function 
    End If 

    strFileHead = BinToHex(LoadBytes) 
    If strFileHead = "EFBBBF" Then
        getFileCharset2 = "UTF-8" 
    Else
        strFileHead = Left(strFileHead, 4) 
        If strFileHead = "FEFF" Then
            getFileCharset2 = "UNICODE BIG" 
        ElseIf strFileHead = "FFFE" Then
            getFileCharset2 = "UNICODE" 
        ElseIf strFileHead = "3C25" Or strFileHead = "3C21" Then
            getFileCharset2 = "GB2312" 
        Else
            getFileCharset2 = "GB2312" 
        End If 
    End If 
    If Err.Number <> 0 Then
        Err.Clear : getFileCharset2 = "" : Exit Function 
    End If 
End Function 
Public Function binToHex(ByVal vStream)
    Dim reVal, i 
    reVal = 0 
    For i = 1 To LenB(vStream)
        reVal = reVal * 256 + AscB(MidB(vStream, i, 1)) 
    Next 
    binToHex = Hex(reVal) 
End Function 



'���԰��ַ������������ת���ַ���ţ �ӱ������︴�ƹ���20160112
function Base64Encode(strData)
    dim objAds,objXd
    set objAds=createobject("adodb.stream")
    objAds.Type=2
    objAds.charset="unicode"
    objAds.mode=3
    call objAds.open()
    call objAds.writeText(strData)
    objAds.Position=0
    objAds.Type=1
    'objAds.Position=2 
    set objXd=createobject("msxml.domdocument")
    call objXd.loadXml("<root/>")
    objXd.DocumentElement.DataType="bin.base64"
    objXd.DocumentElement.NodeTypedValue=objAds.read()
    Base64Encode=objXd.DocumentElement.text
end function
'ת�ɶ�������Byte()
function Base64Decode(strData)
    dim objXd
    set objXd=createobject("msxml.domdocument")
    call objXd.loadXml("<root/>")
    objXd.DocumentElement.DataType="bin.base64"
    objXd.DocumentElement.text=strData
    Base64Decode=objXd.DocumentElement.NodeTypedValue
end function

%> 