<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<!--#include file=".common/common.asp" -->
<!--#include file=".class/controllers/HuanController.asp" -->
<%
HuanController.START_TIME = new Date;
HuanController.PATH_DEPTH = 0;
HuanController.NAME_SPACE = "huan:";
HuanController.MAIN_DB_PATH = Server.MapPath("/../database/huan.mdb");
%>