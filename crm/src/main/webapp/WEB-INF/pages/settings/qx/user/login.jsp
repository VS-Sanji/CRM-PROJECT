<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(function (){
		//给整个浏览器窗口加上一个键盘按下事件
		$(window).keydown(function (e){
			//判断是否是回车键
			if (e.keyCode==13){
				//是回车键则模拟登录按钮单击事件发生，发送ajax请求
				$("#loginBtn").click();
			}
		})

		//给”登录“按钮添加鼠标单击事件
		$("#loginBtn").click(function (){
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());
			var isRemPwd = $("#isRemPwd").prop("checked");
			//表单验证
			if (loginAct==""){
				alert("用户名不能为空");
				return;
			}
			if (loginPwd==""){
				alert("密码不能为空");
				return;
			}

			//显示验证信息（方式一）
			// $("#msg").text("正在努力验证...")

			//发送异步请求
			$.ajax({
				url:'settings/qx/user/login.do',
				data:{
					loginAct:loginAct,
					loginPwd:loginPwd,
					isRemPwd:isRemPwd
				},
				type:'post',
				dataType:'json',
				success:function(data){
					if (data.code=="1"){
						//校验成功跳转到业务主页面
						window.location.href = "workbench/index.do";
					}else {
						//显示提示信息
						$("#msg").html(data.message);
					}
				},
				//显示验证信息（方式二）
				beforesend:function (){ //当ajax向后台发送请求之前，会自动执行该函数
										//该函数的返回值能够决定ajax是否真正向后台发送请求
										//如果该函数返回true，则ajax会真正向后台发送请求；否则，如果该函数返回false，则ajax放弃发送请求，即使调用了ajax异步请求
					$("#msg").text("正在努力验证...");
					return true;
				}

			})
		})
	})
</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2019&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input id="loginAct" class="form-control" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input id="loginPwd" class="form-control" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<input id="isRemPwd" type="checkbox"> 十天内免登录
						</label>
						&nbsp;&nbsp;
						<span id="msg"></span>
					</div>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>