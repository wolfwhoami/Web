<%

Class xmlZIP
    Dim zipPathDir, zipPathFile, zipFileExt 
    Dim starTime, endTime 
    Dim pubXmlZipDir                                                                'xml���Ŀ¼
    Dim pubIsEchoMsg                                                                '�Ƿ���Դ�ӡ��Ϣ
    Dim webRootPathDir                                                              '��վ��Ŀ¼·��

    Sub run(thisWebRootPathDir, xmlZipDir, isEchoMsg, xmlFileName)
        pubXmlZipDir = xmlZipDir & "/"                                                  'xmlĿ¼
        pubIsEchoMsg = isEchoMsg                                                        '�Ƿ����
        '��ΪĬ�ϵ�ǰ�ļ���
        webRootPathDir = thisWebRootPathDir                                             '������
        'call echo("webRootPathDir",webRootPathDir)

        zipPathDir = Server.MapPath("./") & "\" 

        '�ڴ˸���Ҫ����ļ��е�·��
        'ZipPathDir="D:\MYWEB\WEBINFO"
        '���ɵ�xml�ļ�
        zipPathFile = xmlFileName 
        If zipPathFile = "" Then
            zipPathFile = "update.xml" 
        End If 
        '�����д�����ļ���չ��
        zipFileExt = "db;bak" 
        If Right(zipPathDir, 1) <> "\" Then zipPathDir = zipPathDir & "\" 

        Response.Write("����·����" & zipPathDir & zipPathFile & "<hr>") 
        '��ʼ���
        CreateXml(zipPathDir & zipPathFile) 
    End Sub 
    '����Ŀ¼�ڵ������ļ��Լ��ļ���
    Sub loadData(dirPath)
        Dim xmlDoc 
        Dim fso                                                                         'fso����
        Dim objFolder                                                                   '�ļ��ж���
        Dim objSubFolders                                                               '���ļ��м���
        Dim objSubFolder                                                                '���ļ��ж���
        Dim objFiles                                                                    '�ļ�����
        Dim objFile                                                                     '�ļ�����
        Dim objStream 
        Dim pathname, xFolder, xFPath, xFile, xPath, xStream 
        Dim pathNameStr 

        If pubIsEchoMsg = True Then
            Response.Write("==========" & dirPath & "==========<br>") 
        End If 
        Set fso = Server.CreateObject("Scripting.FileSystemObject")
            Set objFolder = fso.GetFolder(dirPath)                                          '�����ļ��ж���

                If pubIsEchoMsg = True Then
                    Response.Write dirPath 
                    Response.flush 
                End If 
                Set xmlDoc = Server.CreateObject("Microsoft.XMLDOM")
                    xmlDoc.load(Server.MapPath(zipPathFile)) 
                    xmlDoc.async = False 
                    'д��ÿ���ļ���·��
                    Set xFolder = xmlDoc.SelectSingleNode("//root").AppendChild(xmlDoc.CreateElement("folder"))
                        Set xFPath = xFolder.AppendChild(xmlDoc.CreateElement("path"))
                            xFPath.text = Replace(dirPath, webRootPathDir, "") 'zipPathDir  ע��
                            Set objFiles = objFolder.files
                                For Each objFile In objFiles
                                    If LCase(dirPath & objFile.Name) <> LCase(Request.ServerVariables("PATH_TRANSLATED")) And LCase(dirPath & objFile.Name) <> LCase(dirPath & zipPathFile) Then
                                        If ext(objFile.Name) Then
                                            pathNameStr = dirPath & "" & objFile.Name 
                                            If pubIsEchoMsg = True Then
                                                Response.Write "---<br/>" 
                                                Response.Write pathNameStr & "" 
                                                Response.flush 
                                            End If 
                                            '================================================

                                            'д���ļ���·�����ļ�����
                                            Set xFile = xmlDoc.SelectSingleNode("//root").AppendChild(xmlDoc.CreateElement("file"))
                                                Set xPath = xFile.AppendChild(xmlDoc.CreateElement("path"))
                                                    'call echo(zipPathDir,webRootPathDir)
                                                    xPath.text = Replace(pathNameStr, webRootPathDir, "") 'zipPathDir  ע��
                                                    '�����ļ��������ļ����ݣ���д��XML�ļ���
                                                    Set objStream = Server.CreateObject("ADODB.Stream")
                                                        objStream.Type = 1 
                                                        objStream.Open() 
                                                        objStream.loadFromFile(pathNameStr) 
                                                        objStream.position = 0 
                                                        Set xStream = xFile.AppendChild(xmlDoc.CreateElement("stream"))
                                                            xStream.SetAttribute "xmlns:dt", "urn:schemas-microsoft-com:datatypes" 
                                                            '�ļ����ݲ��ö��Ʒ�ʽ���
                                                            xStream.dataType = "bin.base64" 
                                                            xStream.nodeTypedValue = objStream.read() 
                                                        Set objStream = Nothing 
                                                    Set xPath = Nothing 
                                                Set xStream = Nothing 
                                            Set xFile = Nothing 
                                            '================================================

                                        End If 
                                    End If 
                                Next 
                                If pubIsEchoMsg = True Then
                                    Response.Write "<p>" 
                                End If 
                                xmlDoc.Save(Server.MapPath(zipPathFile)) 
                            Set xFPath = Nothing 
                        Set xFolder = Nothing 
                    Set xmlDoc = Nothing 
                    '���������ļ��ж���
                    Set objSubFolders = objFolder.subFolders
                        '���õݹ�������ļ���
                        For Each objSubFolder In objSubFolders
                            pathname = dirPath & objSubFolder.Name & "\" 
                            loadData(pathname) 
                        Next 
                    Set objFolder = Nothing 
                Set objSubFolders = Nothing 
            Set fso = Nothing 
    End Sub
    '����һ���յ�XML�ļ���Ϊд���ļ���׼��
    Sub createXml(filePath)
        '����ʼִ��ʱ��
        starTime = Timer() 
        Dim xmlDoc, root 
        Set xmlDoc = Server.CreateObject("Microsoft.XMLDOM")
            xmlDoc.async = False 
            Set root = xmlDoc.createProcessingInstruction("xml", "version='1.0' encoding='UTF-8'")
                xmlDoc.appendChild(root) 
                xmlDoc.appendChild(xmlDoc.CreateElement("root")) 
                If InStr(filePath, ":") = False Then filePath = Server.MapPath(filePath) 
                xmlDoc.Save(filePath) 
            Set root = Nothing 
        Set xmlDoc = Nothing 
        'call eerr(ZipPathDir & "inc/",pubXmlZipDir)
        'call echo(ZipPathDir & "newweb/http���X�Xwww��thinkphp��cn�X/web/",pubXmlZipDir)
        loadData(pubXmlZipDir) 
        '�������ʱ��
        endTime = Timer() 
        Response.Write("ҳ��ִ��ʱ�䣺" & FormatNumber((endTime - starTime), 3) & "��") 
    End Sub 
    '�ж��ļ������Ƿ�Ϸ�
    Function ext(fileName)
        ext = True 
        Dim temp_ext, e 
        temp_ext = Split(zipFileExt, ";") 
        For e = 0 To UBound(temp_ext)
            If Mid(fileName, InStrRev(fileName, ".") + 1) = temp_ext(e) Then ext = False 
        Next 
    End Function 
End Class 
%>