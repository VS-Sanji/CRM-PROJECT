<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<%--引入pagination分页插件--%>
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>

<script type="text/javascript">

	$(function(){

		/*给创建按钮添加单击事件*/
		$("#createActivityBtn").click(function (){

			/*使用js代码弹出模态窗口，可以在弹出之前做一些初始化工作*/
			//再次打开，重置表单
			$("#createActivityForm").get(0).reset();

			/*弹出创建市场活动的模态窗口*/
			$("#createActivityModal").modal("show");
		})


		//给保存按钮加单击事件
		$("#saveCreateActivityBtn").click(function (){
			//收集参数
			var owner = $("#create-marketActivityOwner").val();
			var name = $.trim($("#create-marketActivityName").val());
			var startDate = $("#create-startTime").val();
			var endDate = $("#create-endTime").val();
			var cost = $.trim($("#create-cost").val());
			var description = $.trim($("#create-describe"));

			//表单验证
			if (owner==""){
				alert("所有者不能为空");
				return;
			}
			if (name==""){
				alert("名称不能为空")
				return;
			}
			if (startDate!=""&&endDate!=""){
				//js是弱类型语言，直接可用<,>,==,!=等来判断大小关系
				//这里直接用字符串来比，比较每个字符
				if (startDate>endDate){
					alert("起始时间不能晚于结束时间")
					return;
				}
			}

			/*
            正则表达式
            1.语言，语法：定义字符串的匹配模式，可以用来判断指定的具体字符串是否符合匹配模式
            2.语法通则：
				1）//：在js中定义一个正则表达式 var regExp=/......./;
				2)^:匹配字符串的开头位置
            	  $:匹配字符串的结尾
            	3）[]:匹配指定字符集中的一位字符。 var regExp=/^[abc]$/;
            								  var regExp=/^[a-z0-9]$/;
            	4){}：匹配次数。 var regExp=/^[abc]{5}$/;
				  {m}:匹配m次
		          {m，n}：匹配m次到n次
				  {m，}：匹配m次或者更多次
				5）特殊符号：
					\d:匹配一位数字，相当于[0-9]
					\D:匹配一位非数字
					\w:匹配所有字符，包括字母，数字，下划线
					\W：匹配非字符，除了字母，数字，下划线之外的字符

					*：匹配0次或者多次，相当于{0，}
					+：匹配一次或者多次，相当于{1，}
					？：匹配0次或者1次，相当于{0，1}
					*/

			var  regExp = /^(([1-9]\d*)|0)$/;
			if (!regExp.test(cost)){
				alert("成本只能为未非负数");
				return;
			}

			//发送请求
			$.ajax({
				url:'workbench/activity/saveCreateActivity.do',
				data:{
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				type:'post',
				dataType:'json',
				success:function (data){
					if (data.code=="1"){
						//关闭模态窗口
						$("#createActivityModal").modal("hide");
						//刷新市场活动列，显示第一页数据，保持每页显示条数不变（保留）

					}else {
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#createActivityModal").modal("show");//可以不写
					}
				}
			})
		})

		//打开市场活动页面即查一次数据,按需求给定初始参数
		queryActivityByConditionForPage(1,10);

		//输入条件后，点击查询按钮，查询数据
		$("#queryActivityBtn").click(function(){
			queryActivityByConditionForPage();
		})


		function queryActivityByConditionForPage(pageNo,pageSize){
			//当市场活动主页面加载完成，查询所有数据的第一页以及所有数据的总条数，默认每页显示10条
			/*获取参数，发送异步请求，实现整个页面刷新完成即查出市场活动*/
			var name = $("#query-name").val();
			var owner = $("#query-owner").val();
			var startDate = $("#query-startDate").val();
			var endDate = $("#query-endDate").val();
/*			var pageNo = 1;
			var pageSize = 10;*/
			//发请求
			$.ajax({
				url:'workbench/activity/queryActivityByConditionForPage.do',
				data:{
					name:name,
					owner:owner,
					startDate:startDate,
					endDate:endDate,
					pageNo:pageNo,
					pageSize:pageSize
				},
				type:'post',
				dataType:'json',
				success:function (data){
					//显示总条数
					$("#totalCountB").text(data.totalCount);

					//显示第一页的市场活动信息
					//遍历数据，拼接字符串，将字符串放到tbody中
					//定义空字符串
					var htmlStr = "";
					$.each(data.retList,function (index,obj){
						htmlStr += "<tr class=\"active\">"
						htmlStr += "<td><input type=\"checkbox\" value='"+obj.id+"'/></td>"
						htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.html';\">"+obj.name+"</a></td>"
						htmlStr += "<td>"+obj.owner+"</td>"
						htmlStr += "<td>"+obj.startDate+"</td>"
						htmlStr += "<td>"+obj.endDate+"</td>"
								</tr>
					})

					$("#activityBody").html(htmlStr);
				}

			})
		}

	});
</script>


<script type="text/javascript">
		//页面加载完再对容器调用函数
		$(function (){
			$(".mydate").datetimepicker({
				language:'zh-CN',//语言
				format:'yyyy-mm-dd',//格式，这个格式和java中有所差异，要按照插件要求的来
				minView:'month',//最小视图，要想选到天则填写month，想选到时则选day，依此类推
				initialDate:new Date(),//初始化显示的日期
				autoclose:true//设置选择完日期或者时间后，是否自动关闭日历
			})
		})

		(function($){
			$.fn.datetimepicker.dates['zh-CN'] = {
				days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
				daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
				daysMin:  ["日", "一", "二", "三", "四", "五", "六", "日"],
				months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
				monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
				today: "今天",
				suffix: [],
				meridiem: ["上午", "下午"]
			};
		}(jQuery));
	</script>

	<script type="text/javascript">
		$(function (){
			$("#page").bs_pagination({
				currentPage:1,  //当前页号，相当于之前用的pageNo，用户选的

				//这三个数据必须保持数学关系统一
				rowsPerPage:10, //每页显示条数，相当于pageSize，用户选的
				totalPages:100, //总页数，必填参数，计算出来的
				totalRows:1000, //总条数，数据库中查出来的

				visiblePageLinks:5, //最多可以显示的卡片数
				showGoToPage:true,  //控制是否显示 ”跳转到第几页“，默认是true
				showRowsPerPage:true, //是否显示 ”每页显示条数“ 部分，默认true
				showRowsInfo:false,  //是否显示记录的信息，默认是true

				//可以在此获取一些切换信息，如每次返回切换页号之后的pageNo和pageSize
				//event:切换事件本身,用的不多
				//pageObj:翻页对象，即封装了各种翻页信息的对象，其中有pageNo，pageSize，、、、等等信息
				/*
                pageObj对象，各种信息
                {
                currentPage:1,  //当前页号，相当于之前用的pageNo，用户选的

                //这三个数据必须保持数学关系统一
                rowsPerPage:10, //每页显示条数，相当于pageSize，用户选的
                totalPages:100, //总页数，必填参数，计算出来的
                totalRows:1000, //总条数，数据库中查出来的

                visiblePageLinks:5, //最多可以显示的卡片数
                showGoToPage:true,  //控制是否显示 ”跳转到第几页“，默认是true
                showRowsPerPage:true, //是否显示 ”每页显示条数“ 部分，默认true
                showRowsInfo:false,  //是否显示记录的信息，默认是true

                //可以在此获取一些切换信息，如每次返回切换页号之后的pageNo和pageSize
                //event:切换事件本身,用的不多
                //pageObj:翻页对象，即封装了各种翻页信息的对象，其中有pageNo，pageSize，、、、等等信息
                onChangePage:function (event,pageObj){//当用户每次切换页号的时候都会执行这个函数
                    //js代码
                    alert("zhanhuinimasile")
                }
            }
                 */
				onChangePage:function (event,pageObj){//当用户每次切换页号的时候都会执行这个函数
					//js代码
					alert("zhanhuinimasile")
				}
			});
		});
	</script>

</head>


<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="createActivityForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-startTime">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-endTime">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
					</form>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="saveCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="query-endDate">
				    </div>
				  </div>
				  
				  <button type="submit" class="btn btn-default" id="queryActivityBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createActivityModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>2020-10-10</td>--%>
<%--                            <td>2020-10-20</td>--%>
                        </tr>
					</tbody>
				</table>
				<%--创建分页插件的容器--%>
				<div id="pagination"></div>

			</div>
			
<%--			<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;" id="totalCountB">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>