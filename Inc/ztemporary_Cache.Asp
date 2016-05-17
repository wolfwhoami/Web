<%
'*---------- Cache���� ---------*'

' AddCache array(dhIn,"",ShowHtml,"˵��Index")
CONST CACHEPREFIX = "CACHE_" '����ǰ׺,����Ϊ��

'˵����
'         1,����ĸ�ʽΪApplication(CACHEPREFIX & key) = array("����key","����ʱ��","��������","����˵��","����ʱ��")
'           2,����key�����ִ�Сд

' AddCache array(dhIn,"",SHtml,"˵��Index")

'���ӻ���,����黺���Ƿ���ڣ�����������൱�ڸ��»���
'varAry :   ��������ʽΪ:array("����key","����ʱ��","��������","����˵��")
'           ����key ��application()��ʽ��ͬ
'           ����ʱ�䣺��λ��,����Ϊ����,��ʾ��������,����Ϊ�գ��ջ���������Ĭ��Ϊ20���ӹ���
'           �������ݣ��������ݣ���֧�ֶԶ���Ļ���
'           ����˵������������˵��
Function AddCache(varAry)
	Dim c,ary(4)
	If Not IsArray(varAry) Then
		Response.Write "Error:AddCache(varAry)�������󣬲�����������"
		Response.End()
	End If
	If UBound(varAry) <> 3 Then
		Response.Write "Error:AddCache(varAry)�����������鳤�ȴ���"
		Response.End()
	End If
	If varAry(0) = "" Then
		Response.Write "Error:AddCache(varAry)����key����Ϊ��"
		Response.End()
	End If
	If varAry(1) = "" or Not IsNumeric(varAry(1)) Then varAry(1) = 1200
	Application.Lock()
	Application(CACHEPREFIX & varAry(0)) = array(varAry(0),varAry(1),varAry(2),varAry(3),DateAdd("s",varAry(1),Now()))
	Application.UnLock()
End Function

' ���ĳ�������Ƿ����,���ڷ���True���򷵻�False
' key : ����key
Function CheckCache(key)
	Dim k
	For Each k In Application.Contents
		If LCase(k) = LCase(CACHEPREFIX & key) Then CheckCache = True : Exit Function
	Next
	CheckCache = False
End Function

' ���ĳ������
Function RemoveCache(key)
	Application.Lock()
	Application.Contents.Remove(CACHEPREFIX & key)
	Application.UnLock()
End Function

'���»���,������治��������������Ը���֮ǰ����CheckCache(key)���
'varAry :   ��������ʽΪ:array("����key","����ʱ��","��������","����˵��")
'           ����key ��application()��ʽ��ͬ
'           ����ʱ�䣺��λ��,����Ϊ����,��ʾ��������,����Ϊ�գ��ջ���������Ĭ��Ϊ20���ӹ���
'           �������ݣ��������ݣ���֧�ֶԶ���Ļ���
'           ����˵������������˵��
' ע��   �� ���������varAryĳ��ֵ�����ø�ֵΪnull���ɣ�
'           ��UpdateCache(array("key",null,"����",null)),���ǲ����¹���ʱ���˵��
Function UpdateCache(varAry)
	Dim app
	app = GetCache(varAry(0))
	If Not IsNull(varAry(1)) Then app(1) = varAry(1)
	If Not IsNull(varAry(2)) Then app(2) = varAry(2)
	If Not IsNull(varAry(3)) Then app(3) = varAry(3)
	If app(1) = "" or Not IsNumeric(app(1)) Then app(1) = 1200
	Application.Lock()
	Application(CACHEPREFIX & app(0)) = array(app(0),app(1),app(2),app(3),DateAdd("s",app(1),Now()))
	Application.UnLock()
End Function

' ��ӡcache����������
Function PrintCache(key)
    Dim App, I, T
    If CheckCache(key) Then
        App = GetCache(key)
        Response.Write "<pre>{" & Chr(10)
        Response.Write Chr(32) & "��������" & Chr(32) & ":" & Chr(32) & CACHEPREFIX & App(0) & Chr(10)
        Response.Write Chr(32) & "����key " & Chr(32) & ":" & Chr(32) & App(0) & Chr(10)
        Response.Write Chr(32) & "����ʱ��" & Chr(32) & ":" & Chr(32) & App(1) & Chr(10)
        Response.Write Chr(32) & "����ʱ��" & Chr(32) & ":" & Chr(32) & App(4) & Chr(10)
        Response.Write Chr(32) & "�Ƿ���" & Chr(32) & ":" & Chr(32) & App(5) & Chr(10)
        Response.Write Chr(32) & "����˵��" & Chr(32) & ":" & Chr(32) & App(3) & Chr(10)
        ' ����
        Response.Write Chr(32) & "��������" & Chr(32) & ":" & Chr(32)
        T = VarType(App(2))
        If InStr(",0,1,2,3,4,5,6,7,8,11,", "," & T & ",") > 0 Then
            Response.Write App(2)
        Else
            Response.Write TypeName(App(2))
        End If
        Response.Write Chr(10)
        
        Response.Write "}</pre>" & Chr(10)
    Else
        Response.Write "�����ڸû���"
    End If
 End Function
 
' ��ȡ����
' �������飬��ʽΪ��array("����key","����ʱ��","��������","����˵��","����ʱ��",�Ƿ����True|False)
' �������������������Ի�ȡ֮ǰ����CheckCache(key)���
Function GetCache(key)
    Dim App, IsExp
    App = Application(CACHEPREFIX & key)
    IsExp = False
    If DateDiff("s", Now(), App(4)) <= 0 Then IsExp = True
    GetCache = Array(App(0), App(1), App(2), App(3), App(4), IsExp)
End Function
 
' ==========================
'   �����������
' ==========================
Function HcShow(key)
    Dim App, I, T
    If CheckCache(key) Then
        App = GetCache(key)
        ' Response.Write chr(32) & "��������" & chr(32) & ":" & chr(32)
        T = VarType(App(2))
        If InStr(",0,1,2,3,4,5,6,7,8,11,", "," & T & ",") > 0 Then
            HcShow = App(2)
        Else
            HcShow = TypeName(App(2))
        End If
    Else
        HcShow = "�����ڸû���"
    End If
End Function

' �����ٶ���
Sub Br(Str)
    Response.Write Str & "<br />" & vbCrLf
End Sub

' ���ȫ������
Function RemoveAllCache()
    Application.Lock
    Application.Contents.RemoveAll
    Application.Unlock
End Function
%>