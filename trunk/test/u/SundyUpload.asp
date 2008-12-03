<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script language="vbscript" runat="server">
Dim SundyUpload_SourceData
Class SundyUpload
  Dim objForm,objFile,Version,objProgress
    Dim xmlPath,CharsetEncoding
  Public Function Form(strForm)
    strForm=lcase(strForm)
    If NOT objForm.exists(strForm) Then
      Form=""
    Else
      Form=objForm(strForm)
    End If
  End Function

  Public Function File(strFile)
    strFile=lcase(strFile)
    If NOT objFile.exists(strFile) Then
      Set File=new FileInfo
    Else
      Set File=objFile(strFile)
    End If
  End Function
  
    Public Sub UploadInit(progressXmlPath,charset)
    Dim RequestData,sStart,Crlf,sInfo,iInfoStart,iInfoEnd,tStream,iStart,theFile
        Dim iFileSize,sFilePath,sFileType,sFormValue,sFileName
        Dim iFindStart,iFindEnd
        Dim iFormStart,iFormEnd,sFormName
      
        Version="Upload Width Progress Bar Version 1.0"
        Set objForm=Server.CreateObject("Scripting.Dictionary")
        Set objFile=Server.CreateObject("Scripting.Dictionary")
        If Request.TotalBytes<1 Then Exit Sub
        Set tStream = Server.CreateObject("adodb.stream")
        Set SundyUpload_SourceData = Server.CreateObject("adodb.stream")
        SundyUpload_SourceData.Type = 1
        SundyUpload_SourceData.Mode =3
        SundyUpload_SourceData.Open
        
        Dim TotalBytes
        Dim ChunkReadSize
        Dim DataPart, PartSize
        Dim objProgress
        
        TotalBytes = Request.TotalBytes     ' 总大小
        ChunkReadSize = 64 * 1024    ' 分块大小64K
        BytesRead = 0
        xmlPath = progressXmlPath
        CharsetEncoding = charset
        If CharsetEncoding = "" Then
          CharsetEncoding = "utf-8"
        End If
        Set objProgress = New Progress
        objProgress.ProgressInit(xmlPath)
        objProgress.UpdateProgress Totalbytes,0
        '循环分块读取
        Do While BytesRead < TotalBytes
            '分块读取
            PartSize = ChunkReadSize
            If PartSize + BytesRead > TotalBytes Then PartSize = TotalBytes - BytesRead
            DataPart = Request.BinaryRead(PartSize)
            BytesRead = BytesRead + PartSize
    
            SundyUpload_SourceData.Write DataPart
            
            objProgress.UpdateProgress Totalbytes,BytesRead 
        Loop
        'SundyUpload_SourceData.Write  Request.BinaryRead(Request.TotalBytes)
        SundyUpload_SourceData.Position=0
        RequestData =SundyUpload_SourceData.Read 
    
        iFormStart = 1
        iFormEnd = LenB(RequestData)
        Crlf = chrB(13) & chrB(10)
        sStart = MidB(RequestData,1, InStrB(iFormStart,RequestData,Crlf)-1)
        iStart = LenB (sStart)
        iFormStart=iFormStart+iStart+1
        While (iFormStart + 10) < iFormEnd 
            iInfoEnd = InStrB(iFormStart,RequestData,Crlf & Crlf)+3
            tStream.Type = 1
            tStream.Mode =3
            tStream.Open
            SundyUpload_SourceData.Position = iFormStart
            SundyUpload_SourceData.CopyTo tStream,iInfoEnd-iFormStart
            tStream.Position = 0
            tStream.Type = 2
            tStream.Charset =CharsetEncoding
            sInfo = tStream.ReadText
            tStream.Close
            '取得表单项目名称
            iFormStart = InStrB(iInfoEnd,RequestData,sStart)
            iFindStart = InStr(22,sInfo,"name=""",1)+6
            iFindEnd = InStr(iFindStart,sInfo,"""",1)
            sFormName = lcase(Mid (sinfo,iFindStart,iFindEnd-iFindStart))
            '如果是文件
            If InStr (45,sInfo,"filename=""",1) > 0 Then
                Set theFile=new FileInfo
                '取得文件名
                iFindStart = InStr(iFindEnd,sInfo,"filename=""",1)+10
                iFindEnd = InStr(iFindStart,sInfo,"""",1)
                sFileName = Mid (sinfo,iFindStart,iFindEnd-iFindStart)
                theFile.FileName=getFileName(sFileName)
                theFile.FilePath=getFilePath(sFileName)
                '取得文件类型
                iFindStart = InStr(iFindEnd,sInfo,"Content-Type: ",1)+14
                iFindEnd = InStr(iFindStart,sInfo,vbCr)
                theFile.FileType =Mid (sinfo,iFindStart,iFindEnd-iFindStart)
                theFile.FileStart =iInfoEnd
                theFile.FileSize = iFormStart -iInfoEnd -3
                theFile.FormName=sFormName
                If NOT objFile.Exists(sFormName) Then
                    objFile.add sFormName,theFile
                End If
            Else
                '如果是表单项目
                tStream.Type =1
                tStream.Mode =3
                tStream.Open
                SundyUpload_SourceData.Position = iInfoEnd 
                SundyUpload_SourceData.CopyTo tStream,iFormStart-iInfoEnd-3
                tStream.Position = 0
                tStream.Type = 2
                tStream.Charset = CharsetEncoding
                sFormValue = tStream.ReadText 
                tStream.Close
                If objForm.Exists(sFormName) Then
                    objForm(sFormName)=objForm(sFormName)&", "&sFormValue          
                Else
                    objForm.Add sFormName,sFormValue
                End If
            End If
            iFormStart=iFormStart+iStart+1
        Wend
        RequestData=""
        Set tStream = Nothing      
    End Sub
    Private Sub Class_Initialize 
        
    End Sub
    
    Private Sub Class_Terminate  
      If Request.TotalBytes>0 Then
            objForm.RemoveAll
            objFile.RemoveAll
            Set objForm=Nothing
            Set objFile=Nothing
            SundyUpload_SourceData.Close
            Set SundyUpload_SourceData = Nothing
      End If
        Set objProgress = Nothing
        Set objFso = Server.CreateObject("Scripting.FileSystemObject")
        If objFso.FileExists(xmlPath) Then
          objFso.DeleteFile(xmlPath)
        End If
        Set objFso = Nothing
    End Sub
 
    Private Function GetFilePath(FullPath)
        If FullPath <> "" Then
          GetFilePath = left(FullPath,InStrRev(FullPath, ""))
        Else
          GetFilePath = ""
        End If
    End Function
 
    Private Function GetFileName(FullPath)
        If FullPath <> "" Then
          GetFileName = mid(FullPath,InStrRev(FullPath, "\")+1)
        Else
          GetFileName = ""
        End If
    End Function
End Class

Class FileInfo
  Dim FormName,FileName,FilePath,FileSize,FileType,FileStart
  Private Sub Class_Initialize 
    FileName = ""
    FilePath = ""
    FileSize = 0
    FileStart= 0
    FormName = ""
    FileType = ""
  End Sub
  
    Public Function SaveAs(FullPath)
        Dim dr,ErrorChar,i
        SaveAs=True
  'Response.Write fullpath & ".....................<br>"
  'FileName="ss.txt"
        If trim(fullpath)="" or FileStart=0 or fileName="" or right(fullpath,1)="/" Then Exit Function
  'Response.Write "2........................<br>"
        Set dr=CreateObject("Adodb.Stream")
        dr.Mode=3
        dr.Type=1
        dr.Open
        SundyUpload_SourceData.position=FileStart
        SundyUpload_SourceData.copyto dr,FileSize
        dr.SaveToFile FullPath,2
        dr.Close
        Set dr=Nothing 
        SaveAs=False
    End Function
End Class

Class Progress
  Dim objDom,xmlPath
    Dim startTime
  Private Sub Class_Initialize

    End Sub
    
    Public Sub ProgressInit(xmlPathTmp)
      Dim objRoot,objChild
        Dim objPI

        xmlPath = xmlPathTmp
        Set objDom = Server.CreateObject("Microsoft.XMLDOM")
        Set objRoot = objDom.createElement("progress")
        objDom.appendChild objRoot
        
        Set objChild = objDom.createElement("totalbytes")
        objChild.Text = "0"
        objRoot.appendChild objChild
        Set objChild = objDom.createElement("uploadbytes")
        objChild.Text = "0"
        objRoot.appendChild objChild
        Set objChild = objDom.createElement("uploadpercent")
        objChild.Text = "0%"
        objRoot.appendChild objChild
        Set objChild = objDom.createElement("uploadspeed")
        objChild.Text = "0"
        objRoot.appendChild objChild
        Set objChild = objDom.createElement("totaltime")
        objChild.Text = "00:00:00"
        objRoot.appendChild objChild
        Set objChild = objDom.createElement("lefttime")
        objChild.Text = "00:00:00"
        objRoot.appendChild objChild
        
        Set objPI = objDom.createProcessingInstruction("xml","version='1.0' encoding='utf-8'")
        objDom.insertBefore objPI, objDom.childNodes(0)
        objDom.Save xmlPath
        Set objPI = Nothing
        Set objChild = Nothing
        Set objRoot = Nothing
        Set objDom = Nothing
    End Sub
    
    Sub UpdateProgress(tBytes,rBytes)
      Dim eTime,currentTime,speed,totalTime,leftTime,percent
        If rBytes = 0 Then
            startTime = Timer
            Set objDom = Server.CreateObject("Microsoft.XMLDOM")
            objDom.load(xmlPath)
            objDom.selectsinglenode("//totalbytes").text=tBytes
            objDom.save(xmlPath)
        Else
          speed = 0.0001
          currentTime = Timer
        eTime = currentTime - startTime
            If eTime>0 Then speed = rBytes / eTime
            totalTime = tBytes / speed
            leftTime = (tBytes - rBytes) / speed
            percent = Round(rBytes *100 / tBytes)
            'objDom.selectsinglenode("//uploadbytes").text = rBytes
            'objDom.selectsinglenode("//uploadspeed").text = speed
            'objDom.selectsinglenode("//totaltime").text = totalTime
            'objDom.selectsinglenode("//lefttime").text = leftTime
            objDom.selectsinglenode("//uploadbytes").text = FormatFileSize(rBytes) & " / " & FormatFileSize(tBytes)
            objDom.selectsinglenode("//uploadpercent").text = percent
            objDom.selectsinglenode("//uploadspeed").text = FormatFileSize(speed) & "/sec"
            objDom.selectsinglenode("//totaltime").text = SecToTime(totalTime)
            objDom.selectsinglenode("//lefttime").text = SecToTime(leftTime)
            objDom.save(xmlPath)        
        End If
    End Sub

    private Function SecToTime(sec)
        Dim h:h = "0"
        Dim m:m = "0"
        Dim s:s = "0"
        h = round(sec / 3600)
        m = round( (sec mod 3600) / 60)
        s = round(sec mod 60)
        If LEN(h)=1 Then h = "0" & h
        If LEN(m)=1 Then m = "0" & m
        If LEN(s)=1 Then s = "0" & s
        SecToTime = (h & ":" & m & ":" & s)
    End Function
        
    private Function FormatFileSize(fsize)
        Dim radio,k,m,g,unitTMP
        k = 1024
        m = 1024*1024
        g = 1024*1024*1024
        radio = 1
        If Fix(fsize / g) > 0.0 Then
            unitTMP = "GB"
            radio = g
        ElseIf Fix(fsize / m) > 0 Then
            unitTMP = "MB"
            radio = m
        ElseIf Fix(fsize / k) > 0 Then
            unitTMP = "KB"
            radio = k
        Else
            unitTMP = "B"
            radio = 1
        End If
        If radio = 1 Then
            FormatFileSize = fsize & "&nbsp;" & unitTMP
        Else
            FormatFileSize = FormatNumber(fsize/radio,3) & unitTMP
        End If
    End Function

    Private Sub Class_Terminate  
      Set objDom = Nothing
    End Sub
End Class
</script>





<script language="javascript">
//启动进度条
function startProgress(xmlPath){
  displayProgress();
    setProgressDivPos();
    setTimeout("DisplayProgressBar('" + xmlPath + "')",500);
}

function DisplayProgressBar(xmlPath){
    var xmlDoc = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xmlDoc.async = false;
    xmlDoc.load(xmlPath);
    if (xmlDoc.parseError.errorCode!=0){
        var error = xmlDoc.parseError;
        alert(error.reason)
        setTimeout("DisplayProgressBar('" + xmlPath + "')",1000);
        return;
    }
    var root = xmlDoc.documentElement;   //根节点
    var totalbytes = root.childNodes(0).text;
    var uploadbytes = root.childNodes(1).text;
    var percent = root.childNodes(2).text;
    ProgressPercent.innerHTML = percent + "%";
    ProgressBar.style.width = percent + "%";
    uploadSize.innerHTML = uploadbytes;
  uploadSpeed.innerHTML = root.childNodes(3).text;
    totalTime.innerHTML = root.childNodes(4).text;
    leftTime.innerHTML = root.childNodes(5).text;
    if (percent<100){
      setTimeout("DisplayProgressBar('" + xmlPath + "')",1000);
    }
}

function displayProgress(){
    var objProgress = document.getElementById("Progress");
  objProgress.style.display = "";
}
function closeProgress(){
    var objProgress = document.getElementById("Progress");
  objProgress.style.display = "none";
}
function setProgressDivPos(){
    var objProgress = document.getElementById("Progress");
    objProgress.style.top = document.body.scrollTop+(document.body.clientHeight-document.getElementById("Progress").offsetHeight)/2
    objProgress.style.left = document.body.scrollLeft+(document.body.clientWidth-document.getElementById("Progress").offsetWidth)/2;
}
</script>
<style type="text/css">
.progress {
    position: absolute;
    padding: 4px;
    top: 50;
    left: 400;
    font-family: Verdana, Helvetica, Arial, sans-serif;
    font-size: 12px;
    width: 250px;
    height:100px;
    background: #FFFBD1;
    color: #3D2C05;
    border: 1px solid #715208;
    /* Mozilla proprietary */
    -moz-border-radius: 5px;
    /*-moz-opacity: 0.95; */
}
.progress table,.progress td{
  font-size:9pt;
}

.Bar{
  width:100%;
    height:15px;
    background-color:#CCCCCC;
    border: 1px inset #666666;
    margin-bottom:4px;
}

.ProgressPercent{
    font-size: 9pt;
    color: #000000;
    height: 15px;
    position: absolute;
    z-index: 20;
    width: 100%;
    text-align: center;
}
.ProgressBar{
  background-color:#91D65C;
    width:1px;
    height:15px;
}
</style>
<div id="Progress" style="display:none;" class="progress">
    <div class="bar">
        <div id="ProgressPercent" class="ProgressPercent">0%</div>
        <div id="ProgressBar" class="ProgressBar"></div>
    </div>
    <table border="0" cellspacing="0" cellpadding="2">
        <tr>
            <td>已经上传</td>
            <td>:</td>
            <td id="uploadSize"></td>
        </tr>
        <tr>
            <td>上传速度</td>
            <td>:</td>
            <td id="uploadSpeed">&nbsp;</td>
        </tr>
        <tr>
            <td>共需时间</td>
            <td>:</td>
            <td id="totalTime">&nbsp;</td>
        </tr>
        <tr>
            <td>剩余时间</td>
            <td>:</td>
            <td id="leftTime">&nbsp;</td>
        </tr>
    </table>
</div>

