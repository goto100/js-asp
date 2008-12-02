<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="SundyUpload.asp"-->
<%
'此例子文档编码都是UTF-8,如果是其他编码的系统，请将编码转换为相应的编码，不然表单获取数据可能会乱码
Dim objUpload,opt
Dim xmlPath
Dim fileFormName,objFile,counter
opt = request.QueryString("opt")
If opt = "Upload" Then
  xmlPath = Server.MapPath(request.QueryString("xmlPath"))'将虚拟路径转换为实际路径
    Set objUpload=new SundyUpload '建立上传对象
    objUpload.UploadInit xmlPath,"utf-8"
    counter = 1
    Response.Write("普通表单：" & objUpload.Form("normalForm") & "<BR><BR>")'获取表单数据
    For Each fileFormName In objUpload.objFile
      Set objFile=objUpload.objFile(fileFormName)
        fileSize = objFile.FileSize
  strTemp= objFile.FilePath
  Response.Write strTemp
  fileName = mid(strTemp,InStrRev(strTemp, "\")+1)
  'g0=
  f0=replace(replace(replace(now(),":","")," ",""),"-","")&"."&g0
    
        If fileSize > 0 Then
            Response.Write("File Size:" & fileSize & "<BR>")
            Response.Write("File Name:" & objFile.FilePath  & "<BR>")

			t=Split(filename,".")
			t1=t(1)		
			filename=Replace(Replace(Replace(now,":","")," ",""),"-","")&"."&t1
			
           ' Response.Write("File Description:" & objUpload.Form("fileDesc" & counter) & "<BR><BR>")
           objFile.SaveAs Server.MapPath(".") & "\upload\" & fileName
   Response.Write "Save at: "&Server.MapPath(".") & "\upload\" & fileName & "<br><br>"
        End If
        counter = counter + 1
    Next
    
End If
'为上载进度条数据文件（XML文件指定虚拟路径）
'最好是随机的，因为可能多个人同时上载，需要不同的进度数据
'这个路径需要在提交的时候传入上载组件中，以便在上载过程中更改进度数据
'客户端使用Javascript来读取此XML文件，显示进度
xmlPath = "upload/" & Timer & ".xml"
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Sundy Upload Progress Bar Example</title>
<script language="javascript">
function chkFrm(){
  var objFrm = document.frmUpload;
    if (objFrm.file1.value=="" && objFrm.file2.value==""){
      alert("请选择一个文件");
        objFrm.file1.focus();
        return false;
    }
    objFrm.action = "Example.asp?opt=Upload&xmlPath=<%=xmlPath%>";
    startProgress('<%=xmlPath%>');//启动进度条
    return true;
}
</script>
</head>

<body>
<form name="frmUpload" method="post" action="Example.asp" enctype="multipart/form-data" onSubmit="return chkFrm()">
普通表单：<BR><input type="text" name="normalForm" size="40"><BR><BR>
文件1：<BR>
<input type="file" name="file1" size="40"></br>
<input type="text" name="fileDesc1" size="30"><BR><BR>
文件2：<BR>
<input type="file" name="file2" size="40"></br>
<input type="text" name="fileDesc2" size="30"><BR>
文件3：<BR>
<input type="file" name="file3" size="40"></br>
文件4：<BR>
<input type="file" name="file4" size="40"></br>
文件5：<BR>
<input type="file" name="file5" size="40"></br>
<input type="submit" name="btnSubmit" value="submit"/>
</form>
</body>
</html>