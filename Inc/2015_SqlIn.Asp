<% 
'--------��Ȩ˵��------------------
'Author:С��
'QQ:313801120
'E-Mail:313801120@qq.com
'--------���岿��------------------
sub SqlIn()
    dim StrIn, splStr, i, j 
    '�Զ�����Ҫ���˵��ִ�,�� "|" �ָ�
    StrIn = "'|;|and|(|)|exec|insert|select|delete|update|count|*|chr|mid|master|truncate|char|declare" 
    splStr = split(StrIn, "|")                                                      '--------Post����------------------
    if request.queryString <> "" then
        for each j in request.queryString
            for i = 0 to uBound(splStr)
                if inStr(lCase(request.queryString), splStr(i)) <> 0 then
                    call saveSqlInInfo(splStr(i)) 
                    call eerr("Postע��", "���IP[" & getIP & "]�ѱ���¼") 
                end if 
            next 
        next 
    end if 

    '--------Get����------------------
    if request.form <> "" then
        for each j in request.queryString
            for i = 0 to uBound(splStr)
                if inStr(lCase(request.queryString), splStr(i)) <> 0 then
                    call saveSqlInInfo(splStr(i)) 
                    call eerr("Getע��", "���IP[" & getIP & "]�ѱ���¼") 
                end if 
            next 
        next 
    end if 
    '--------Cookies����------------------
    '�ȿ���
end sub 
'����Sqlinע��
function saveSqlInInfo(str)
    dim fileName, OperatingNow, OperatingIP, myFile, MeLoadFile, fso, f 
    fileName = server.mapPath("./SqlIn.Txt") 
    OperatingNow = now() 
    OperatingIP = request.serverVariables("Remote_Addr") 
    str = OperatingNow & " - " & OperatingIP & "   " & str 
    set fso = createObject("Scripting.FileSystemObject")
        if fso.fileExists(fileName) then
            set myFile = fso.openTextFile(fileName, 1)
                set f = fso.GetFile(fileName)
                    if f.size > 0 then MeLoadFile = myFile.ReadAll 
                set f = nothing 
            set myFile = nothing 
            set myFile = fso.createTextFile(fileName, true)
                myFile.WriteLine(MeLoadFile & vbCrLf & str) 
            set myFile = nothing 
        else
            set myFile = fso.createTextFile(fileName, true)
                myFile.WriteLine(str) 
            set myFile = nothing 
        end if 
    set fso = nothing 
end function 
%> 



