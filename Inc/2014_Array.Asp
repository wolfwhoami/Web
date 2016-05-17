<% 
'���ݴ���������


'������������
Function contentNameSort(content, sType)
    Dim splStr, arrayStr(99), fileName, isOther,otherStr, id, c,s,i,left1
    splStr = Split(content, vbCrLf) 
    For Each s In splStr
		if s <>"" then
			fileName = getStrFileName(s)
			isOther=true
			left1=left(fileName,1)
			If InStr(fileName, "��") > 0 Then 
				id = Replace(Left(fileName, 2), "��", "")
				if isNumber(id) then
					arrayStr(id) = arrayStr(id) & s & vbCrLf 
					isOther=false
				end if
			end if
			
			if InStr(sType, left1) = False and isOther=true then
				otherStr = otherStr & s & vbCrLf 
			End If 
		end if
    Next 
    For i = 0 To UBound(arrayStr)
        c = c & arrayStr(i) 
    Next 
    contentNameSort = c & otherStr 
End Function


'ɾ��������#���б�(20150818)
Function remoteContentJingHao(content, splType)
    Dim splStr, s, c 
    splStr = Split(content, splType) 
    For Each s In splStr
        If Left(phpTrim(s), 1) <> "#" And Left(phpTrim(s), 1) <> "_" Then
            If c <> "" Then c = c & splType 
            c = c & s 
        End If 
    Next 
    remoteContentJingHao = c 
End Function 
'ɾ��������#�Ż����_���б�(20150818)
Function remoteArrayJingHao(splStr)
    Dim s, c, splType 
    splType = "[|-|_]" 
    For Each s In splStr
        If Left(phpTrim(s), 1) <> "#" And Left(phpTrim(s), 1) <> "_" Then
            If c <> "" Then c = c & splType 
            c = c & s 
        End If 
    Next 
    splStr = Split(c, splType) 
    remoteArrayJingHao = splStr 
End Function 

'ÿ���ַ���ָ��ֵ
Function getEachStrAddValue(content, valueStr)
    Dim i, s, c 
    For i = 1 To Len(content)
        s = Mid(content, i, 1) 
        c = c & s & valueStr 
    Next 
    getEachStrAddValue = c 
End Function 
'���ֵ��������λ�� 20150708
Function getValueInArrayID(splStr, valueStr)
    Dim i 
    getValueInArrayID = -1 
    For i = 0 To UBound(splStr)
        If splStr(i) = valueStr Then
            getValueInArrayID = i 
            Exit For 
        End If 
    Next 
End Function 
'�ж�ֵ�Ƿ���������
Function checkValueInArray(splStr, valueStr)
    Dim i 
    checkValueInArray = False 
    For i = 0 To UBound(splStr)
        If splStr(i) = valueStr Then
            checkValueInArray = True 
            Exit For 
        End If 
    Next 
End Function 

'ɾ���ظ�����  20141220
Function deleteRepeatArray(splStr)
    Dim SplType, s, c 
    SplType = "[|-|_]" 
    For Each s In splStr
        If s <> "" Then
            If InStr(SplType & c & SplType, SplType & s & SplType) = False Then
                c = c & s & SplType 
            End If 
        End If 
    Next 
    If c <> "" Then c = Left(c, Len(c) - Len(SplType)) 
    splStr = Split(c, SplType) 
    deleteRepeatArray = splStr 
End Function 
'ɾ���ظ����� �Զ��ָ����� 20150724
Function deleteRepeatContent(content, splType)
    Dim splStr, s, c 
    splStr = Split(content, splType) 
    For Each s In splStr
        If s <> "" Then
            If InStr(splType & c & splType, splType & s & splType) = False Then
                If c <> "" Then c = c & splType 
                c = c & s 
            End If 
        End If 
    Next 
    deleteRepeatContent = c 
End Function 

'�����������
Function getArrayCount(content, SplC)
    Dim splStr 
    If InStr(content, SplC) > 0 Then
        splStr = Split(content, SplC) 
        getArrayCount = UBound(splStr) + 1 
    Else
        getArrayCount = 0 
    End If 
End Function 
'�����ʾ���� randomShow("1,2,3,4,5,6,7,8,9", ",", 2)
Function randomShow(content, SplType,NSwitch)
    Dim splStr, s, c, n, i 
    Randomize 
    For i = 1 To NSwitch
        splStr = Split(content, SplType) 
        For Each s In splStr
            n = CInt(Rnd * 100) 
            If n > 50 Then
                c = c & s & SplType 
            Else
                c = s & SplType & c 
            End If			        
        Next 
        If c <> "" Then c = Left(c, Len(c) - Len(SplType)) 
        content = c 
        c = "" 
    Next 
    'Call Echo("C",C)
    randomShow = content 
End Function 
'���������ʾ ArrayRandomShow("1,2,3,4,5,6,7,8,9", 2)
Function arrayRandomShow(ByVal splStr, NSwitch)
    Dim s, c, n, i, SplType 
    SplType = "[|-|_]" 
    Randomize 
    For i = 1 To NSwitch
        For Each s In splStr
            n = CInt(Rnd * 100) 
            If n > 50 Then
                c = c & s & SplType 
            Else
                c = s & SplType & c 
            End If 
        'Call Echo(S,N)
        Next 
        If c <> "" Then c = Left(c, Len(c) - Len(SplType)) 
        splStr = Split(c, SplType) : c = "" 
    Next 
    arrayRandomShow = splStr 
End Function 
'��ӡ��������
Sub printArray(splStr)
    Dim i, s 
    For i = 0 To UBound(splStr)
        s = splStr(i) 
        Call echo(i, s) 
    Next 
End Sub 
'��ʾ��������  (��������)
Sub echoArray(splStr)
    Call PrintArray(splStr) 
End Sub 
'���ش��Һ���ַ�����Shuffle=ϴ��  2014 12 02
Function str_Shuffle(content)
    Dim i, s, c, n 
    Randomize 
    For i = 1 To Len(content)
        s = Mid(content, i, 1) 
        If c = "" Then
            c = s 
        ElseIf Len(c) = 1 Then
            n = CInt(Rnd * 100) 
            If n > 50 Then
                c = c & s 
            Else
                c = s & c 
            End If 
        Else
            n = CInt(Rnd * Len(c)) + 1 
            c = Mid(c, 1, n) & s & Mid(c, n + 1) 
        End If 
    Next 
    str_Shuffle = c 
End Function 
'�ַ�����
Function characterUpset(content)
    characterUpset = str_Shuffle(content) 
End Function 
'���ַ���ת��Ϊ����   PHP���õ�����ʱ����   �������뼸���ַ��ָ������  ��  abcefg,2     0=ab 1=ce 2=fg
Function str_Split(content, Split_Length)
    Dim i, s, c, n, ArrStr(99), nArray 
    If Split_Length <= 0 Then Split_Length = 1 
    n = 0 : nArray = 0 
    For i = 1 To Len(content)
        s = Mid(content, i, 1) 
        c = c & s 
        n = n + 1 
        If n = Split_Length Then
            ArrStr(nArray) = c 
            c = "" : n = 0 
            nArray = nArray + 1 
        End If 
    Next 
    str_Split = ArrStr 
End Function 
'�Ƴ���ֵ����
Function removeNullValueArray(content, SplType)
    removeNullValueArray = HandleArray(content, SplType, "nonull") 
End Function 
'�Ƴ��ظ�����
Function removeRepeatValueArray(content, SplType)
    removeRepeatValueArray = HandleArray(content, SplType, "norepeat") 
End Function 
'��������
Function handleArray(content, SplType, SType)
    Dim splStr, s, c, OKYes 
    SType = "|" & LCase(SType) & "|" 
    splStr = Split(content, SplType) 
    For Each s In splStr
        OKYes = True 
        If InStr(SType, "|nonull|") > 0 And OKYes = True Then
            If s = "" Then OKYes = False 
        End If 
        If InStr(SType, "|norepeat|") > 0 And OKYes = True Then
            If InStr(SplType & c & SplType, SplType & s & SplType) > 0 Then OKYes = False 
        End If 
        If OKYes = True Then c = c & s & SplType 
    Next 
    If c <> "" Then c = Left(c, Len(c) - Len(SplType)) 
    handleArray = c 
End Function 
'����ת�ַ�(20151124)
Function arrayToString(splStr, addtoStr)
    Dim s, c 
    For Each s In splStr
        If s <> "" Then
            c = c & s & addtoStr 
        End If 
    Next 
    arrayToString = c 
End Function 
'������������ 20141217
Function testArrayData()
    Dim aData 
    aData = Array(3, 2, 4, 1, 6, 0) 
    Call ResponseArray(aData, "ԭ��˳��") 
    Call ResponseArray(SelectSort(aData), "ѡ������") 
    Call ResponseArray(QuickSort(aData), "��������") 
    Call ResponseArray(InsertSort(aData), "��������") 
    Call ResponseArray(BubbleSort(aData), "ð������") 
    Call ResponseArray(ReQuickSort(aData), "��������") 
    Response.Write "<b>�� �� ֵ��</b>" & Max(aData) & "<hr>" 
    Response.Write "<b>�� С ֵ��</b>" & Min(aData) & "<hr>" 
End Function 
'===================================
'ѡ������
'===================================
Function selectSort(a_Data)
    Dim i, j, k 
    Dim bound, t 
    bound = UBound(a_Data) 

    For i = 0 To bound - 1
        k = i 
        For j = i + 1 To bound
            If a_Data(k) > a_Data(j) Then
                k = j 
            End If 
        Next 
        t = a_Data(i) 
        a_Data(i) = a_Data(k) 
        a_Data(k) = t 
    Next 
    selectSort = a_Data 
End Function 
'===================================
'��������
'===================================
Function quickSort(a_Data)
    Dim i, j 
    Dim bound, t 
    bound = UBound(a_Data) 
    For i = 0 To bound - 1
        For j = i + 1 To bound
            If a_Data(i) > a_Data(j) Then
                t = a_Data(i) 
                a_Data(i) = a_Data(j) 
                a_Data(j) = t 
            End If 
        Next 
    Next 
    quickSort = a_Data 
End Function 
'===================================
'ð������
'===================================
Function bubbleSort(a_Data)
    Dim bound 
    bound = UBound(a_Data) 
    Dim bSorted, i, t 
    bSorted = False 
    Do While bound > 0 And bSorted = False
        bSorted = True 
        For i = 0 To bound - 1
            If a_Data(i) > a_Data(i + 1) Then
                t = a_Data(i) 
                a_Data(i) = a_Data(i + 1) 
                a_Data(i + 1) = t 
                bSorted = False 
            End If 
        Next 
        bound = bound - 1 
    Loop 

    bubbleSort = a_Data 
End Function 
'===================================
'��������
'===================================
Function insertSort(a_Data)
    Dim bound 
    bound = UBound(a_Data) 
    Dim i, j, t 

    For i = 1 To bound
        t = a_Data(i) 
        j = i 
        Do While t < a_Data(j - 1) And j > 0
            a_Data(j) = a_Data(j - 1) 
            j = j - 1 
        Loop 
        a_Data(j) = t 
    Next 
    insertSort = a_Data 
End Function 
'===================================
'��������-��������
'===================================
Function reQuickSort(a_Data)
    Dim i, Bound, TempArr 
    a_Data = quickSort(a_Data) 
    TempArr = quickSort(a_Data) 
    Bound = UBound(a_Data) 
    For i = 0 To Bound
        a_Data(i) = TempArr(Bound - i) 
    Next 
    reQuickSort = a_Data 
End Function 
'���鷴��
Function arrayReverse()
    arrayReverse = reQuickSort(a_Data) 
End Function 
'===================================
'�������
'===================================
Sub responseArray(a_Data, str)
    Dim s, i 
    s = "" 
    Response.Write "<b>" & str & "��</b>" 
    For i = 0 To UBound(a_Data)
        s = s & a_Data(i) & "," 
    Next 
    s = Left(s, Len(s) - 1) 
    Response.Write s 
    Response.Write "<hr>" 
End Sub 
'===================================
'���������ֵ
'===================================
Function max(a_Data)
    Dim i, j, Bound, temp 
    a_Data = quickSort(a_Data) 
    Bound = UBound(a_Data) 
    For i = 0 To Bound
        For j = i + 1 To Bound
            If a_Data(j) > a_Data(i) Then
                temp = a_Data(i) 
                a_Data(i) = a_Data(j) 
                a_Data(j) = temp 
            End If 
        Next 
    Next 
    max = a_Data(0) 
End Function 
'===================================
'��������Сֵ
'===================================
Function min(a_Data)
    Dim i, j, Bound, temp 
    a_Data = quickSort(a_Data) 
    Bound = UBound(a_Data) 
    For i = 0 To Bound
        For j = i + 1 To Bound
            If a_Data(j) > a_Data(i) Then
                temp = a_Data(i) 
                a_Data(i) = a_Data(j) 
                a_Data(j) = temp 
            End If 
        Next 
    Next 
    min = a_Data(Bound) 
End Function 




'���Զ�ά������ʾ
Function testTwoDimensionalArray()
    Dim splStr, i 
    splStr = HandleSplitArray("9-g|2-b|3-a|1-��", "|", "-") 
    For i = 0 To UBound(splStr)
        Call echo(splStr(i, 1), splStr(i, 0)) : Doevents 
    Next 
    Call echo("", "�����") 
    Call TwoDimensionalArrayAsc(splStr)                                '��ά����������
    For i = 0 To UBound(splStr)
        Call echo(splStr(i, 1), splStr(i, 0)) : Doevents 
    Next 
    Call echo("", "Desc") 
    Call TwoDimensionalArrayDesc(splStr)                               '��ά���鵹����
    For i = 0 To UBound(splStr)
        Call echo(splStr(i, 1), splStr(i, 0)) : Doevents 
    Next 
End Function 

'�����ָ��ά���� 20150313
Function handleSplitArray(content, SplOneType, SplTowType)
    Dim SplA, SplB, splStr, splxx, i, s, c, j, t, SplType 
    SplType = "[|Array|]" 
    splStr = Split(content, SplOneType) 
    For i = 0 To UBound(splStr)
        If splStr(i) <> "" Then
            splxx = Split(splStr(i), SplTowType) 
            SplA = SplA & splxx(0) & SplType 
            SplB = SplB & splxx(1) & SplType 
        End If 
    Next 
    If SplA <> "" Then SplA = Left(SplA, Len(SplA) - Len(SplType)) 
    If SplB <> "" Then SplB = Left(SplB, Len(SplB) - Len(SplType)) 
    SplA = Split(SplA, SplType) 
    SplB = Split(SplB, SplType) 

    ReDim splStr(UBound(SplA), UBound(SplB)) 
    For i = 0 To UBound(SplA)
        splStr(i, 0) = SplA(i) 
        splStr(i, 1) = SplB(i) 
    Next 
    handleSplitArray = splStr 
End Function 
'��ά���������� 20150313
Function twoDimensionalArrayAsc(splStr)
    Dim i, j, t 
    For i = 0 To UBound(splStr)
        If IsNul(splStr(i, 0)) = False Then
            For j = i To UBound(splStr)
                If splStr(i, 0) > splStr(j, 0) Then
                    t = splStr(i, 0) 
                    splStr(i, 0) = splStr(j, 0) 
                    splStr(j, 0) = t 
                    t = splStr(i, 1) 
                    splStr(i, 1) = splStr(j, 1) 
                    splStr(j, 1) = t 
                End If 
            Next 
        End If 
    Next 
    twoDimensionalArrayAsc = splStr 
End Function 
'��ά���鵹���� 20150313
Function twoDimensionalArrayDesc(splStr)
    Dim i, j, t 
    For i = 0 To UBound(splStr)
        If IsNul(splStr(i, 0)) = False Then
            For j = i To UBound(splStr)
                If splStr(i, 0) < splStr(j, 0) Then
                    t = splStr(i, 0) 
                    splStr(i, 0) = splStr(j, 0) 
                    splStr(j, 0) = t 
                    t = splStr(i, 1) 
                    splStr(i, 1) = splStr(j, 1) 
                    splStr(j, 1) = t 
                End If 
            Next 
        End If 
    Next 
    twoDimensionalArrayDesc = splStr 
End Function 
%> 