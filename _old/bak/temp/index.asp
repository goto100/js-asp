<html>
<head>
<meta http-equiv="Content-Language" content="en-us">
<title>
CAPTCHA -- Example !!!</title>
</head>
<body>
<p align="center"><b><font face="Tahoma">The ASP CAPTCHA Project</font></b></p>
<p align="center"><b><font face="Tahoma" size="1">version 0.1</font></b></p>
<p align="center"><b><font face="Tahoma" size="1">
--------------------------------------------------------</font></b></p>
<p><b><font face="Tahoma" size="2">What is CAPTCHA ?????</font></b></p>
<p><font face="Tahoma" size="2"><b>CAPTCHA</b> is an acronym for <b>&quot;Completely 
Automated Public Turing Test to Tell Computers and Humans Apart&quot;</b>. <br>
As the name suggests, it's a test to distinguish the degree of being human. As 
defined on the CAPTCHA home page at the Carnegie Melon University School of 
Computer Science's Web site:<br>
<br>
<b>CAPTCHA</b> is a program that can generate and grade tests that:<br>
• Most humans can pass.<br>
• Current computer programs can't pass.</font></p>
<p align="center"><b><font face="Tahoma" size="1">
--------------------------------------------------------</font></b></p>
<p><b><font face="Tahoma" size="2">The ASP Implementation !!!</font></b></p>
<p><font face="Tahoma" size="2">(*) This <b>ASP </b>implementation uses 2 
libraries for generation of Captcha's</font></p>
<blockquote>
	<p><font face="Tahoma" size="2">[*] GD by Thomas Boutell., GD is copyright 
	2005 Boutell.com, Inc.</font></p>
	<p><font face="Tahoma" size="2">[*] ActiveX Wrapper for GD by Trevor 
	Herselman in his code <br>
	</font><font face="Tahoma" size="1">
	<a href="http://www.planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=9202&lngWId=4">
	http://www.planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=9202&amp;lngWId=4</a></font></p>
</blockquote>
<p><font face="Tahoma" size="2">(*) Here GD library., bgd.dll is deployed in 
WINDOWS/SYSTEM32 directory</font></p>
<p><font face="Tahoma" size="2">(*) Then the ActiveX wrapper is compiled as 
GDLibrary.dll and DLL 
Registration using regsvr32 is done.</font></p>
<blockquote>
	<p><font face="Tahoma" size="2">[note] Compiling the ActiveX may have some 
	issues like ADO Dependencies., As originally the ActiveX wrapper references 
	Microsoft ActiveX Data Objects 2.8 Library. But it works well with&nbsp; 
	Microsoft ActiveX Data Recordet 2.7 Library.</font></p>
	<p><font face="Tahoma" size="2">[note] The ActiveX may need a reference to 
	Microsoft ActiveX Data Objects 2.5 Library also.</font></p>
	</blockquote>
<p><font face="Tahoma" size="2">(*) Then the ActiveX wrapper is compiled and 
	DLL Registration using regsvr32 is done.</font></p>
</p>
<p><font face="Tahoma" size="2">(*) Then Create a folder 'Captcha' in 'wwwroot'., 
then copy the .asp files there and point your browser to the index.asp</font></p>
</p>
<p align="center"><b><font face="Tahoma" size="1">
<br>
--------------------------------------------------------<br>
&nbsp;</font></b></p>
<p align="left"><b><font face="Tahoma" size="2">Implementation Examples</font></b></p>
<p><font face="Tahoma" size="2">(*) This <b>ASP </b>implementation has 4 types 
of Captcha's</font></p>
<p><font face="Tahoma" size="2">[1]&nbsp; <a href="CType1.asp">Captcha Type 1 -- 
Only Numbers </a></font></p>
<p><font face="Tahoma" size="2">[2] <a href="CType2.asp">Captcha Type 2 -- Only 
Alphabets</a></font></p>
<p><font face="Tahoma" size="2">[3] <a href="CType3.asp">Captcha Type 3 -- 
Alphanumeric</a></font></p>
<p><font face="Tahoma" size="2">[4] <a href="CType4.asp">Captcha Type 4 -- 
Alphanumeric with other Symbols</a><br>
<br>
&nbsp;</font></p>
<p align="center"><b><font face="Tahoma" size="1">
--------------------------------------------------------</font></b></p>
<p align="left"><b><font face="Tahoma" size="2">Captcha Application</font></b></p>
<p align="left"><font face="Tahoma" size="2">CAPTCHA TESTS have several 
applications for practical security, including (but not limited to):<br>
<br>
Online Polls: In November 1999, http://www.slashdot.com released an online poll 
asking which was the best graduate school in computer science (a dangerous 
question to ask over the web!). As is the case with most online polls, IP 
addresses of voters were recorded in order to prevent single users from voting 
more than once. However, students at Carnegie Mellon found a way to stuff the 
ballots using programs that voted for CMU thousands of times. CMU's score 
started growing rapidly. The next day, students at MIT wrote their own program 
and the poll became a contest between voting &quot;bots&quot;. MIT finished with 21,156 
votes, Carnegie Mellon with 21,032 and every other school with less than 1,000. 
Can the result of any online poll be trusted? Not unless the poll requires that 
only humans can vote.<br>
<br>
Free Email Services: Several companies (Yahoo!, Microsoft, etc.) offer free 
email services. Most of these suffer from a specific type of attack: &quot;bots&quot; that 
sign up for thousands of email accounts every minute. This situation can be 
improved by requiring users to prove they are human before they can get a free 
email account. Yahoo!, for instance, uses a CAPTCHA test of our design to 
prevent bots from registering for accounts.<br>
<br>
Search Engine Bots: It is sometimes desirable to keep web pages unindexed to 
prevent others from finding them easily. There is an html tag to prevent search 
engine bots from reading web pages. The tag, however, doesn't guarantee that 
bots won't read a web page; it only serves to say &quot;no bots, please&quot;. Search 
engine bots, since they usually belong to large companies, respect web pages 
that don't want to allow them in. However, in order to truly guarantee that bots 
won't enter a web site, CAPTCHA tests are needed.<br>
<br>
Worms and Spam: CAPTCHA tests also offer a plausible solution against email 
worms and spam: &quot;I will only accept an email if I know there is a human behind 
the other computer.&quot; A few companies are already marketing this idea.<br>
<br>
Preventing Dictionary Attacks: Pinkas and Sander have also suggested using 
CAPTCHA tests to prevent dictionary attacks in password systems. The idea is 
simple: prevent a computer from being able to iterate through the entire space 
of passwords.<br>
<br>
(Excerpts from <a href="http://www.captcha.net/">http://www.captcha.net/</a>)
</font></p>
<p align="center"><b><font face="Tahoma" size="1">
--------------------------------------------------------</font></b></p>
<p align="left"><b><font face="Tahoma" size="2">Final Words</font></b></p>
<p align="left"><font face="Tahoma" size="2">I would like to thank Mr. Trevor 
Herselman for his ActiveX Wrapper and Mr. Thomas Boutell for his great GD 
library. Without them this Project is nothing.</font></p>
<p align="left"><font face="Tahoma" size="2">I owe you one :-))</font></p>
<p align="center"><b><font face="Tahoma" size="1">
--------------------------------------------------------</font></b></p>
<p align="left"><b><font face="Tahoma" size="2">About Me</font></b></p>
<p align="left"><font face="Tahoma" size="2">Im Shyam Sundar C S from 
Coimbatore., Tamil Nadu, India. Im studying BE Computer Science and Engg. I 
mostly play with programming in my computer.</font></p>
<p align="center"><b><font face="Tahoma" size="1">
--------------------------------------------------------</font></b></p>
<p align="left"><b><font face="Tahoma" size="2">Contact NFO</font></b></p>
<p align="left"><font face="Tahoma" size="2">Email: <b>csshyamsundar </b>AT<b> 
yahoo </b>DOT<b> ie </b><i>or</i> <b>csshyamsundar </b>AT<b> msn </b>DOT<b> com
</b><i>or</i> <b>csshyamsundar </b>AT<b> gmail </b>DOT<b> com</b></font></p>
<p align="left">&nbsp;</p>
<p align="left">&nbsp;</p>
<p align="left">&nbsp;</p>
<p align="left">&nbsp;</p>
	<p>&nbsp;</p>
</body>
</html>