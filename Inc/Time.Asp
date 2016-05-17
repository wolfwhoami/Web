<% 
'Time ʱ������� (2013,9,27)

'ʱ�䴦��
Function format_Time(timeStr, nType)
    Dim y, m, d, h, mi, s 
    format_Time = "" 
    If IsDate(timeStr) = False Then Exit Function 
    y = CStr(Year(timeStr)) 
    m = CStr(Month(timeStr)) 
    If Len(m) = 1 Then m = "0" & m 
    d = CStr(Day(timeStr))                                                          '��vb.net��Ҫ������  D = CStr(CDate(timeStr).Day)
    If Len(d) = 1 Then d = "0" & d 
    h = CStr(Hour(timeStr)) 
    If Len(h) = 1 Then h = "0" & h 
    mi = CStr(Minute(timeStr)) 
    If Len(mi) = 1 Then mi = "0" & mi 
    s = CStr(Second(timeStr)) 
    If Len(s) = 1 Then s = "0" & s 
    Select Case nType
        Case 1
            'yyyy-mm-dd hh:mm:ss
            format_Time = y & "-" & m & "-" & d & " " & h & ":" & mi & ":" & s 
        Case 2
            'yyyy-mm-dd
            format_Time = y & "-" & m & "-" & d 
        Case 3
            'hh:mm:ss
            format_Time = h & ":" & mi & ":" & s 
        Case 4
            'yyyy��mm��dd��
            format_Time = y & "��" & m & "��" & d & "��" 
        Case 5
            'yyyymmdd
            format_Time = y & m & d 
        Case 6
            'yyyymmddhhmmss
            format_Time = y & m & d & h & mi & s 
        Case 7
            'mm-dd
            format_Time = m & "-" & d 
        Case 8
            'yyyy��mm��dd��
            format_Time = y & "��" & m & "��" & d & "��" & " " & h & ":" & mi & ":" & s 
        Case 9
            'yyyy��mm��dd��Hʱmi��S�� ����
            format_Time = y & "��" & m & "��" & d & "��" & " " & h & "ʱ" & mi & "��" & s & "�룬" & GetDayStatus(h, 1) 
        Case 10
            'yyyy��mm��dd��Hʱ
            format_Time = y & "��" & m & "��" & d & "��" & h & "ʱ" 
        Case 11
            'yyyy��mm��dd��Hʱmi��S��
            format_Time = y & "��" & m & "��" & d & "��" & " " & h & "ʱ" & mi & "��" & s & "��" 
        Case 12
            'yyyy��mm��dd��Hʱmi��
            format_Time = y & "��" & m & "��" & d & "��" & " " & h & "ʱ" & mi & "��" 
        Case 13
            'yyyy��mm��dd��Hʱmi�� ����
            format_Time = m & "��" & d & "��" & " " & h & ":" & mi & " " & GetDayStatus(h, 0) 
        Case 14
            'yyyy��mm��dd��
            format_Time = y & "/" & m & "/" & d 
        Case 15
            'yyyy��mm�� ��1��
            format_Time = y & "��" & m & "�� ��" & GetCountPage(d, 7) & "��" 
    End Select
End Function 
'��õ�ǰʱ�ڻ����Լ���
function getHandleDate(numb)
	if numb="" then
		numb=0 
	end if
	getHandleDate=format_Time(now()+numb,2)	
end function
'��õ�ǰ��״̬
Function getDayStatus(h, SType)
    Dim c 
    If Left(h, 1) = "0" Then
        h = Right(h, 1) 
    End If 
    h = CInt(h) 
    If h >= 0 And h <= 5 Then
        c = "�賿" 
    ElseIf h >= 6 And h <= 8 Then
        c = "����" 
    ElseIf h >= 9 And h <= 12 Then
        c = "����" 
    ElseIf h >= 13 And h <= 18 Then
        c = "����" 
    ElseIf h >= 19 And h <= 24 Then
        c = "����" 
    Else
        c = "��ҹ" 
    End If 
    If SType = 1 Then c = "<b>" & c & "</b>" 
    getDayStatus = c 
End Function 
'ʱ�����
Function printTimeValue(vv)
    On Error Resume Next 
    Dim v, c, n 
    v = vv : c = "" 
    If v >= 86400 Then
        n = v Mod 86400 
        v = Fix(v / 60 / 60 / 24)        '�������ǳ�24������60����Ϊһ����24��Сʱ��С�������ɵX  20150119
        c = c & v & "��" 
        v = n 
    End If 
    If v >= 3600 Then
        n = v Mod 3600 
        v = Fix(v / 60 / 60) 
        c = c & v & "Сʱ" 
        v = n 
    End If 

    If v >= 60 Then
        n = v Mod 60 
        v = Fix(v / 60) 
        c = c & v & "��" 
        v = n 
    End If 
    If v >= 0 Then
        c = c & v & "��" 
    End If 
    If Err.Number <> 0 Then MsgBox(vv) 
    printTimeValue = c 
End Function 
'������ʱ  (�ʴ���Сʱ�������ʾ)
Function printAskTime(vv)
    On Error Resume Next 
    Dim v, c, n 
    v = vv 
    c = "" 
    If v >= 3600 Then
        n = v Mod 3600 
        v = Fix(v / 60 / 60) 
        c = c & v & "Сʱ" 
        v = n 
        printAskTime = c : Exit Function 
    End If 
    If v >= 60 Then
        n = v Mod 60 
        v = Fix(v / 60) 
        c = c & v & "����" 
        v = n 
        printAskTime = c : Exit Function 
    End If 
    If v >= 0 Then
        c = c & v & "����" 
        printAskTime = c : Exit Function 
    End If 
End Function 
'���ʱ��
Function getTimerSet()
    Dim n 
    n = FormatNumber((Timer() - PubTimer) * 1000, 2, - 1) / 1000 
    getTimerSet = toNumber(n, 3) 
End Function 
'����ʱ��
Function calculationTimer(PubTimer)
    Dim n 
    n = FormatNumber((Timer() - PubTimer) * 1000, 2, - 1) / 1000 
    calculationTimer = toNumber(n, 3) 
End Function 

'���ʱ��
Function getTimer()
    getTimer = "<br>------------------------------------<br>ҳ��ִ��ʱ�䣺" & getTimerSet() & " ��" 
End Function 
'���ʱ��
Function VBGetTimer()
    Dim n 
    n = DateDiff("s", PubTimer, Now()) 
    n = printTimeValue(n) 
    VBGetTimer = vbCrLf & "------------------------------------" & vbCrLf & "����ʱ�䣺" & n 
End Function 
'��õ�����
Function VBEchoTimer()
    Dim n 
    n = DateDiff("s", PubTimer, Now()) 
    n = printTimeValue(n) 
    VBEchoTimer = "����ʱ�䣺" & n 
End Function 
'���ʱ�������
Function VBRunTimer(startTime)
    Dim n 
    n = DateDiff("s", startTime, Now()) 
    n = printTimeValue(n) 
    VBRunTimer = "����ʱ�䣺" & n 
End Function 
%>  
