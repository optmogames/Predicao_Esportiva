Set digita = CreateObject("WScript.Shell")
Set driver = CreateObject("SeleniumWrapper.WebDriver")

Public Function Load(id, tipo)
	Set element = Nothing
	For j = 0 To 30
		If tipo = 1 Then
			Set element = driver.findElementById(id, 0, False)
		ElseIf tipo = 2 Then
			Set element = driver.findElementByXPath(id, 0, False)
		ElseIf tipo = 3 Then
			On Error Resume Next
			If InStr(driver.getBodyText(), id) > 1 Then
				WScript.Sleep(4000)
				Exit For
			Else
				WScript.Sleep 1000			
			End If
		End If
		If element Is Nothing Then
			WScript.Sleep 1000	
		Else
			Exit For
		End If
		If j = 30 Then
			erro = 1                
		End If
	Next
	If erro = 1 Then
		Exit Function
	End If	
End Function

Dim navegador
Do While 1 = 1
	navegador = InputBox ("1 - Chrome" & vbCrLf & "2 - Internet Explorer" & vbCrLf & "3 - FireFox", "SELECIONE O NAVEGADOR", 0)	
	If navegador = 1 Or navegador = 2 Or navegador = 3 Then
		Exit Do	
	Else	
		MsgBox "Navegador nao selecionado" & vbCrLf & "Escolha um navegador!", ,"ALERTA!!"
	End If
Loop

Dim link
link = "https://www.betfair.com/exchange/plus/football/competition/13"


'carrega driver com o navegador e link do site
If navegador = 1 Then		
	driver.start "Chrome", link
ElseIf navegador = 2 Then
	driver.start "IE64", link
ElseIf navegador = 3 Then
	driver.start "firefox", link
End If

'carrega página
driver.Open "/"

Call Load("A seguir", 3)

driver.windowMaximize




Set con = CreateObject("ADODB.Connection") 
Set rs = CreateObject("ADODB.Recordset")

'define a conexão com o banco de dados
con.Open ("DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=D:\Projeto\tcc\Odds_BetFair.accdb")

For n = 0 to 1000
	texto = driver.getBodyText	
	texto = Split(texto, "igualado")(1)
	texto = Split(texto, "Aviso: ")(0)
	
	For i = 1 to UBound(Split(texto, ":"))
		
		
		
		jogo = 0
		corresp = 0
		campo1 = 0
		campox = 0
		campo2 = 0
		
		linha = Split(texto, ":")(i)
		
		On Error Resume Next
		jogo = Split(linha, vbCrLf)(1) & " X " & Split(linha, vbCrLf)(2)
		On Error Resume Next
		corresp = Split(linha, vbCrLf)(3)
		On Error Resume Next
		campo1 = Split(linha, vbCrLf)(4) & " / " & Split(linha, vbCrLf)(5) & " - "& Split(linha, vbCrLf)(6) & " / " & Split(linha, vbCrLf)(7)
		On Error Resume Next
		campox = Split(linha, vbCrLf)(8) & " / " & Split(linha, vbCrLf)(9) & " - "& Split(linha, vbCrLf)(10) & " / " & Split(linha, vbCrLf)(11)
		On Error Resume Next
		campo2 = Split(linha, vbCrLf)(12) & " - " & Split(linha, vbCrLf)(13) & " - "& Split(linha, vbCrLf)(14) & " / " & Split(linha, vbCrLf)(15)
		
		'insere na base
		str = "INSERT INTO brasileirao (JOGO, CORRESPONDIDO, CAMPO_1, CAMPO_X, CAMPO_2) " _
		& "VALUES " _
		& "('"& jogo &"', " _
		& "'"& corresp &"', " _
		& "'"& campo1 &"', " _
		& "'"& campox &"', " _
		& "'"& campo2 &"')"
		
		con.Execute str
		
		str = ""
		
		'MsgBox "para"
		
		'driver.setClipBoard(Split(texto, ":")(i))
	Next
	WScript.Sleep 5000
Next









