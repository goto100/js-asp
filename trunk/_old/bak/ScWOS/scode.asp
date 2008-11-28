<!-- #include file = "config/scode.asp" -->
<script language="VBScript" runAt="server">
function getFileName
	if Request.ServerVariables("Http_Referer") <> "" then
		dim fileName
		fileName = Request.ServerVariables("Http_Referer")
		fileName = Mid(fileName, InStrRev(fileName, "/") + 1)
		getFileName = Left(fileName, InStrRev(fileName, ".") - 1)
	else getFileName = ""
	end if
end function

dim fileName
fileName = getFileName()

Dim Buf(), DigtalStr
Dim Lines(), LineCount
Dim CursorX, CursorY, DirX, DirY

Randomize
Call CreatValidCode(nameSpace)

Sub CDGen_Reset()
	LineCount = 0
	CursorX = 0
	CursorY = 0

	DirX = 0
	DirY = 1
End Sub

Sub CDGen_Clear()
	Dim i, j
	ReDim Buf(nPixelHeight - 1, nCharCount * nPixelWidth - 1)

	For j = 0 To nPixelHeight - 1
		For i = 0 To nCharCount * nPixelWidth - 1
			Buf(j, i) = 0
		Next
	Next
End Sub

Sub CDGen_PSet(X, Y)
	Buf(Y, X) = 1
End Sub

Sub CDGen_Line(X1, Y1, X2, Y2)
	Dim DX, DY, DeltaT, i

	DX = X2 - X1
	DY = Y2 - Y1
	If Abs(DX) > Abs(DY) Then DeltaT = Abs(DX) Else DeltaT = Abs(DY)
	For i = 0 To DeltaT
		CDGen_PSet X1 + DX * i / DeltaT, Y1 + DY * i / DeltaT
	Next
End Sub

Sub CDGen_FowardDraw(nLength)
	nLength = Sgn(nLength) * Abs(nLength) * (1 - nLengthRandom / 100 + Rnd * nLenghtRandom * 2 / 100)
	ReDim Preserve Lines(3, LineCount)
	Lines(0, LineCount) = CursorX
	Lines(1, LineCount) = CursorY
	CursorX = CursorX + DirX * nLength
	CursorY = CursorY + DirY * nLength
	Lines(2, LineCount) = CursorX
	Lines(3, LineCount) = CursorY
	LineCount = LineCount + 1
End Sub

Sub CDGen_SetDirection(nAngle)
	Dim DX, DY

	nAngle = Sgn(nAngle) * (Abs(nAngle) - nAngleRandom + Rnd * nAngleRandom * 2) / 180 * 3.1415926
	DX = DirX
	DY = DirY
	DirX = DX * Cos(nAngle) - DY * Sin(nAngle)
	DirY = DX * Sin(nAngle) + DY * Cos(nAngle)
End Sub

Sub CDGen_MoveToMiddle(nActionIndex, nPercent)
	Dim DeltaX, DeltaY

	DeltaX = Lines(2, nActionIndex) - Lines(0, nActionIndex)
	DeltaY = Lines(3, nActionIndex) - Lines(1, nActionIndex)
	CursorX = Lines(0, nActionIndex) + Sgn(DeltaX) * Abs(DeltaX) * nPercent / 100
	CursorY = Lines(1, nActionIndex) + Sgn(DeltaY) * Abs(DeltaY) * nPercent / 100
End Sub

Sub CDGen_MoveCursor(nActionIndex)
	CursorX = Lines(0, nActionIndex)
	CursorY = Lines(1, nActionIndex)
End Sub

Sub CDGen_Close(nActionIndex)
	ReDim Preserve Lines(3, LineCount)
	Lines(0, LineCount) = CursorX
	Lines(1, LineCount) = CursorY
	CursorX = Lines(0, nActionIndex)
	CursorY = Lines(1, nActionIndex)
	Lines(2, LineCount) = CursorX
	Lines(3, LineCount) = CursorY
	LineCount = LineCount + 1
End Sub

Sub CDGen_CloseToMiddle(nActionIndex, nPercent)
	Dim DeltaX, DeltaY

	ReDim Preserve Lines(3, LineCount)
	Lines(0, LineCount) = CursorX
	Lines(1, LineCount) = CursorY
	DeltaX = Lines(2, nActionIndex) - Lines(0, nActionIndex)
	DeltaY = Lines(3, nActionIndex) - Lines(1, nActionIndex)
	CursorX = Lines(0, nActionIndex) + Sgn(DeltaX) * Abs(DeltaX) * nPercent / 100
	CursorY = Lines(1, nActionIndex) + Sgn(DeltaY) * Abs(DeltaY) * nPercent / 100
	Lines(2, LineCount) = CursorX
	Lines(3, LineCount) = CursorY
	LineCount = LineCount + 1
End Sub

Sub CDGen_Flush(X0, Y0)
	Dim MaxX, MinX, MaxY, MinY
	Dim DeltaX, DeltaY, StepX, StepY, OffsetX, OffsetY
	Dim i

	MaxX = MinX = MaxY = MinY = 0
	For i = 0 To LineCount - 1
		If MaxX < Lines(0, i) Then MaxX = Lines(0, i)
		If MaxX < Lines(2, i) Then MaxX = Lines(2, i)
		If MinX > Lines(0, i) Then MinX = Lines(0, i)
		If MinX > Lines(2, i) Then MinX = Lines(2, i)
		If MaxY < Lines(1, i) Then MaxY = Lines(1, i)
		If MaxY < Lines(3, i) Then MaxY = Lines(3, i)
		If MinY > Lines(1, i) Then MinY = Lines(1, i)
		If MinY > Lines(3, i) Then MinY = Lines(3, i)
	Next
	DeltaX = MaxX - MinX
	DeltaY = MaxY - MinY
	If DeltaX = 0 Then DeltaX = 1
	If DeltaY = 0 Then DeltaY = 1
	MaxX = MinX
	MaxY = MinY
	If DeltaX > DeltaY Then
		StepX = (nPixelWidth - 2) / DeltaX
		StepY = (nPixelHeight - 2) / DeltaX
		OffsetX = 0
		OffsetY = (DeltaX - DeltaY) / 2
	Else
		StepX = (nPixelWidth - 2) / DeltaY
		StepY = (nPixelHeight - 2) / DeltaY
		OffsetX = (DeltaY - DeltaX) / 2
		OffsetY = 0
	End If
	For i = 0 To LineCount - 1
		Lines(0, i) = Round((Lines(0, i) - MaxX + OffsetX) * StepX, 0)
		If Lines(0, i) < 0 Then Lines(0, i) = 0
		If Lines(0, i) >= nPixelWidth - 2 Then Lines(0, i) = nPixelWidth - 3
		Lines(1, i) = Round((Lines(1, i) - MaxY + OffsetY) * StepY, 0)
		If Lines(1, i) < 0 Then Lines(1, i) = 0
		If Lines(1, i) >= nPixelHeight - 2 Then Lines(1, i) = nPixelHeight - 3
		Lines(2, i) = Round((Lines(2, i) - MinX + OffsetX) * StepX, 0)
		If Lines(2, i) < 0 Then Lines(2, i) = 0
		If Lines(2, i) >= nPixelWidth - 2 Then Lines(2, i) = nPixelWidth - 3
		Lines(3, i) = Round((Lines(3, i) - MinY + OffsetY) * StepY, 0)
		If Lines(3, i) < 0 Then Lines(3, i) = 0
		If Lines(3, i) >= nPixelHeight - 2 Then Lines(3, i) = nPixelHeight - 3
		CDGen_Line Lines(0, i) + X0 + 1, Lines(1, i) + Y0 + 1, Lines(2, i) + X0 + 1, Lines(3, i) + Y0 + 1
	Next
End Sub

Sub CDGen_Char(cChar, X0, Y0)
	CDGen_Reset
	Select Case cChar
	Case "0"
		CDGen_SetDirection -60                            
		CDGen_FowardDraw -0.7                             
		CDGen_SetDirection -60                            
		CDGen_FowardDraw -0.7                             
		CDGen_SetDirection 120                            
		CDGen_FowardDraw 1.5                              
		CDGen_SetDirection -60                            
		CDGen_FowardDraw 0.7                              
		CDGen_SetDirection -60                            
		CDGen_FowardDraw 0.7                              
		CDGen_Close 0                                     
	Case "1"
		CDGen_SetDirection -90                            
		CDGen_FowardDraw 0.5                              
		CDGen_MoveToMiddle 0, 50                          
		CDGen_SetDirection 90                             
		CDGen_FowardDraw -1.4                             
		CDGen_SetDirection 30                             
		CDGen_FowardDraw 0.4                              
	Case "2"
		CDGen_SetDirection 45                             
		CDGen_FowardDraw -0.7                             
		CDGen_SetDirection -120                           
		CDGen_FowardDraw 0.4                              
		CDGen_SetDirection 60                             
		CDGen_FowardDraw 0.6                              
		CDGen_SetDirection 60                             
		CDGen_FowardDraw 1.6                              
		CDGen_SetDirection -135                           
		CDGen_FowardDraw 1.0                              
	Case "3"
		CDGen_SetDirection -90                            
		CDGen_FowardDraw 0.8                              
		CDGen_SetDirection 135                            
		CDGen_FowardDraw 0.8                              
		CDGen_SetDirection -120                           
		CDGen_FowardDraw 0.6                              
		CDGen_SetDirection 80                             
		CDGen_FowardDraw 0.5                              
		CDGen_SetDirection 60                             
		CDGen_FowardDraw 0.5                              
		CDGen_SetDirection 60                             
		CDGen_FowardDraw 0.5                              
	Case "4"
		CDGen_SetDirection 20                             
		CDGen_FowardDraw 0.8                              
		CDGen_SetDirection -110                           
		CDGen_FowardDraw 1.2                              
		CDGen_MoveToMiddle 1, 60                          
		CDGen_SetDirection 90                             
		CDGen_FowardDraw 0.7                              
		CDGen_MoveCursor 2                                
		CDGen_FowardDraw -1.5                             
	Case "5"
		CDGen_SetDirection 90                             
		CDGen_FowardDraw 1.0                              
		CDGen_SetDirection -90                            
		CDGen_FowardDraw 0.8                              
		CDGen_SetDirection -90                            
		CDGen_FowardDraw 0.8                              
		CDGen_SetDirection 30                             
		CDGen_FowardDraw 0.4                              
		CDGen_SetDirection 60                             
		CDGen_FowardDraw 0.4                              
		CDGen_SetDirection 30                             
		CDGen_FowardDraw 0.5                              
		CDGen_SetDirection 60                             
		CDGen_FowardDraw 0.8                              
	Case "6"
		CDGen_SetDirection -60                            
		CDGen_FowardDraw -0.7                             
		CDGen_SetDirection -60                            
		CDGen_FowardDraw -0.7                             
		CDGen_SetDirection 120                            
		CDGen_FowardDraw 1.5                              
		CDGen_SetDirection 120                            
		CDGen_FowardDraw -0.7                             
		CDGen_SetDirection 120                            
		CDGen_FowardDraw 0.7                              
		CDGen_SetDirection 120                            
		CDGen_FowardDraw -0.7                             
		CDGen_SetDirection 120                            
		CDGen_FowardDraw 0.5                              
		CDGen_CloseToMiddle 2, 50                         
	Case "7"
		CDGen_SetDirection 180                            
		CDGen_FowardDraw 0.3                              
		CDGen_SetDirection 90                             
		CDGen_FowardDraw 0.9                              
		CDGen_SetDirection 120                            
		CDGen_FowardDraw 1.3                              
	Case "8"
		CDGen_SetDirection -60                            
		CDGen_FowardDraw -0.8                             
		CDGen_SetDirection -60                            
		CDGen_FowardDraw -0.8                             
		CDGen_SetDirection 120                            
		CDGen_FowardDraw 0.8                              
		CDGen_SetDirection 110                            
		CDGen_FowardDraw -1.5                             
		CDGen_SetDirection -110                           
		CDGen_FowardDraw 0.9                              
		CDGen_SetDirection 60                             
		CDGen_FowardDraw 0.8                              
		CDGen_SetDirection 60                             
		CDGen_FowardDraw 0.8                              
		CDGen_SetDirection 60                             
		CDGen_FowardDraw 0.9                              
		CDGen_SetDirection 70                             
		CDGen_FowardDraw 1.5	                            
		CDGen_Close 0                                     
	Case "9"
		CDGen_SetDirection 120                            
		CDGen_FowardDraw -0.7                             
		CDGen_SetDirection -60                            
		CDGen_FowardDraw -0.7                             
		CDGen_SetDirection -60                            
		CDGen_FowardDraw -1.5                              
		CDGen_SetDirection -60                            
		CDGen_FowardDraw -0.7                             
		CDGen_SetDirection -60                            
		CDGen_FowardDraw -0.7                              
		CDGen_SetDirection 120                            
		CDGen_FowardDraw 0.7                             
		CDGen_SetDirection -60                            
		CDGen_FowardDraw 0.5                              
		CDGen_CloseToMiddle 2, 50                         

	Case "A"
		CDGen_SetDirection -(Rnd * 20 + 150)              
		CDGen_FowardDraw Rnd * 0.2 + 1.1                  
		CDGen_SetDirection Rnd * 20 + 140                 
		CDGen_FowardDraw Rnd * 0.2 + 1.1                  
		CDGen_MoveToMiddle 0, 30                          
		CDGen_CloseToMiddle 1, 70                         
	Case "B"
		CDGen_SetDirection -(Rnd * 20 + 50)               
		CDGen_FowardDraw Rnd * 0.4 + 0.8                  
		CDGen_SetDirection Rnd * 20 + 110                 
		CDGen_FowardDraw Rnd * 0.2 + 0.6                  
		CDGen_SetDirection -(Rnd * 20 + 110)              
		CDGen_FowardDraw Rnd * 0.2 + 0.6                  
		CDGen_SetDirection Rnd * 20 + 110                 
		CDGen_FowardDraw Rnd * 0.4 + 0.8                  
		CDGen_Close 0                                     
	Case "C"
		CDGen_SetDirection -60                            
		CDGen_FowardDraw -0.7                             
		CDGen_SetDirection -60                            
		CDGen_FowardDraw -0.7                             
		CDGen_SetDirection 120                            
		CDGen_FowardDraw 1.5                              
		CDGen_SetDirection 120                            
		CDGen_FowardDraw -0.7                             
		CDGen_SetDirection 120                            
		CDGen_FowardDraw 0.7                              
	End Select
	CDGen_Flush X0, Y0
End Sub

Sub CDGen_Blur()
	Dim i, j

	For j = 1 To nPixelHeight - 2
		For i = 1 To nCharCount * nPixelWidth - 2
			If Buf(j, i) = 0 Then
				If ((Buf(j, i - 1) Or Buf(j + 1, i)) And 1) <> 0 Then

					Buf(j, i) = 2
				End If
			End If
		Next
	Next
End Sub

Sub CDGen_NoisyDot()
	Dim i, j, NoisyDot, CurDot

	For j = 0 To nPixelHeight - 1
		For i = 0 To nCharCount * nPixelWidth - 1
			If Buf(j, i) <> 0 Then
				NoisyDot = Int(Rnd * Rnd * nMaxSaturation)
				Select Case nColorNoisyDotOdds
				Case 0
					CurDot = nMaxSaturation
				Case 1
					CurDot = 0
				Case Else
					CurDot = NoisyDot
				End Select
				If Rnd < nColorNoisyDotOdds Then Buf(j, i) = CurDot Else Buf(j, i) = nMaxSaturation
			Else
				NoisyDot = Int(Rnd * nMaxSaturation)
				Select Case nBlankNoisyDotOdds
				Case 0
					CurDot = 0
				Case 1
					CurDot = nMaxSaturation
				Case Else
					CurDot = NoisyDot
				End Select
				If Rnd < nBlankNoisyDotOdds Then Buf(j, i) = CurDot Else Buf(j, i) = 0
			End If
		Next
	Next
End Sub

Sub CDGen()
	Dim i, Ch

	DigtalStr = ""
	CDGen_Clear
	For i = 0 To nCharCount - 1
		Ch = Mid(cCharSet, Int(Rnd * Len(cCharSet)) + 1, 1)
		DigtalStr = DigtalStr + Ch
		CDGen_Char Ch, i * nPixelWidth, 0
	Next
	CDGen_Blur
	CDGen_NoisyDot
End Sub

Function HSBToRGB(vH, vS, vB)
	Dim aRGB(3), RGB1st, RGB2nd, RGB3rd
	Dim nH, nS, nB
	Dim lH, nF, nP, nQ, nT

	vH = (vH Mod 360)
	If vS > 100 Then
		vS = 100
	ElseIf vS < 0 Then
		vS = 0
	End If
	If vB > 100 Then
		vB = 100
	ElseIf vB < 0 Then
		vB = 0
	End If
	If vS > 0 Then
		nH = vH / 60
		nS = vS / 100
		nB = vB / 100
		lH = Int(nH)
		nF = nH - lH
		nP = nB * (1 - nS)
		nQ = nB * (1 - nS * nF)
		nT = nB * (1 - nS * (1 - nF))
		Select Case lH
		Case 0
			aRGB(0) = nB * 255
			aRGB(1) = nT * 255
			aRGB(2) = nP * 255
		Case 1
			aRGB(0) = nQ * 255
			aRGB(1) = nB * 255
			aRGB(2) = nP * 255
		Case 2
			aRGB(0) = nP * 255
			aRGB(1) = nB * 255
			aRGB(2) = nT * 255
		Case 3
			aRGB(0) = nP * 255
			aRGB(1) = nQ * 255
			aRGB(2) = nB * 255
		Case 4
			aRGB(0) = nT * 255
			aRGB(1) = nP * 255
			aRGB(2) = nB * 255
		Case 5
			aRGB(0) = nB * 255
			aRGB(1) = nP * 255
			aRGB(2) = nQ * 255
		End Select
	Else
		aRGB(0) = (vB * 255) / 100
		aRGB(1) = aRGB(0)
		aRGB(2) = aRGB(0)
	End If
	HSBToRGB = ChrB(Round(aRGB(2), 0)) & ChrB(Round(aRGB(1), 0)) & ChrB(Round(aRGB(0), 0))
End Function

Sub CreatValidCode(nameSpace)
	Dim i, j, CurColorHue

	Response.Expires = -9999
	Response.AddHeader "pragma", "no-cache"
	Response.AddHeader "cache-ctrol", "no-cache"
	Response.ContentType = "image/bmp"

	Call CDGen

	Session("wos" & nameSpace & FileName & "SecCode") = DigtalStr

	Dim PicWidth, PicHeight, FileSize, PicDataSize
	PicWidth = nCharCount * nPixelWidth
	PicHeight = nPixelHeight
	PicDataSize = PicWidth * PicHeight * 3
	FileSize = PicDataSize + 54

	Response.BinaryWrite ChrB(66) & ChrB(77) & _
		ChrB(FileSize Mod 256) & ChrB((FileSize \ 256) Mod 256) & ChrB((FileSize \ 256 \ 256) Mod 256) & ChrB(FileSize \ 256 \ 256 \ 256) & _
		ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & _
		ChrB(54) & ChrB(0) & ChrB(0) & ChrB(0)

	Response.BinaryWrite ChrB(40) & ChrB(0) & ChrB(0) & ChrB(0) & _
		ChrB(PicWidth Mod 256) & ChrB((PicWidth \ 256) Mod 256) & ChrB((PicWidth \ 256 \ 256) Mod 256) & ChrB(PicWidth \ 256 \ 256 \ 256) & _
		ChrB(PicHeight Mod 256) & ChrB((PicHeight \ 256) Mod 256) & ChrB((PicHeight \ 256 \ 256) Mod 256) & ChrB(PicHeight \ 256 \ 256 \ 256) & _
		ChrB(1) & ChrB(0) & _
		ChrB(24) & ChrB(0) & _
		ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & _
		ChrB(PicDataSize Mod 256) & ChrB((PicDataSize \ 256) Mod 256) & ChrB((PicDataSize \ 256 \ 256) Mod 256) & ChrB(PicDataSize \ 256 \ 256 \ 256) & _
		ChrB(18) & ChrB(11) & ChrB(0) & ChrB(0) & _
		ChrB(18) & ChrB(11) & ChrB(0) & ChrB(0) & _
		ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0) & _
		ChrB(0) & ChrB(0) & ChrB(0) & ChrB(0)

	If nColorHue = -1 Then
		CurColorHue = Int(Rnd * 360)
	ElseIf nColorHue = -2 Then
		CurColorHue = 0
	Else
		CurColorHue = nColorHue
	End If
	For j = 0 To nPixelHeight - 1
		For i = 0 To Len(DigtalStr) * nPixelWidth - 1
			If nColorHue = -2 Then
				Response.BinaryWrite HSBToRGB(CurColorHue, 0, 100 - Buf(nPixelHeight - 1 - j, i))
			Else
				Response.BinaryWrite HSBToRGB(CurColorHue, Buf(nPixelHeight - 1 - j, i), 100)
			End If
		Next
	Next
End Sub
</script>
