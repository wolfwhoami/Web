<?php 


define('WEBPATH', $_SERVER ['DOCUMENT_ROOT'].DIRECTORY_SEPARATOR);				//网站主目录
 

//系统核心程序
require_once './PHP2/ImageWaterMark/Include/ASP.php';
require_once './PHP2/ImageWaterMark/Include/sys_FSO.php';
require_once './PHP2/ImageWaterMark/Include/sys_Url.php';
require_once './PHP2/ImageWaterMark/Include/sys_Cai.php';
require_once './PHP2/ImageWaterMark/Include/Conn.php';
require_once './PHP2/ImageWaterMark/Include/MySqlClass.php';
//引用inc
require_once './PHP2/Web/Inc/2014_Array.php';
require_once './PHP2/Web/Inc/2014_Author.php';
require_once './PHP2/Web/Inc/2014_Css.php';
require_once './PHP2/Web/Inc/2014_Js.php'; 
require_once './PHP2/Web/Inc/2015_APGeneral.php';
require_once './PHP2/Web/Inc/2015_Color.php';
require_once './PHP2/Web/Inc/2015_Formatting.php';
require_once './PHP2/Web/Inc/2015_Param.php';
require_once './PHP2/Web/Inc/2015_ToMyPHP.php';
require_once './PHP2/Web/Inc/2015_NewWebFunction.php';
require_once './PHP2/Web/Inc/2016_SaveData.php'; 
require_once './PHP2/Web/Inc/2016_WebControl.php'; 
require_once './PHP2/Web/Inc/ASPPHPAccess.php'; 
//require_once './PHP2/Web/Inc/2015_ToPhpCms.php';
require_once './PHP2/Web/Inc/Cai.php';
require_once './PHP2/Web/Inc/Check.php';
require_once './PHP2/Web/Inc/Common.php'; 
require_once './PHP2/Web/Inc/Incpage.php';
require_once './PHP2/Web/Inc/Print.php';
require_once './PHP2/Web/Inc/StringNumber.php';
require_once './PHP2/Web/Inc/Time.php';
require_once './PHP2/Web/Inc/URL.php';;
require_once './PHP2/Web/Inc/EncDec.php';
require_once './PHP2/Web/Inc/IE.php';
require_once './PHP2/Web/Inc/html.php';
require_once './PHP2/Web/Inc/2016_Log.php'; 
require_once './PHP2/Web/Inc/SystemInfo.php'; 
require_once './Web/setAccess.php';
require_once './Web/function.php';
require_once './Web/config.php';
  
//end 引用inc


if(1==2){
?><!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<meta name="keywords" content="keywords" />
<meta name="description" content="description" />
<title>phpViewTest.php</title> 
<script src="\VB工程\Template\ModuleTemplate\_jquery.js"></script>
<script src="\VB工程\Template\ModuleTemplate\runAction.js"></script>
<link href="\VB工程\Template\ModuleTemplate\_style.css" rel="stylesheet" type="text/css" />
</head>
<body>
<?php
}


require_once './VB工程/atemp.php';
?>