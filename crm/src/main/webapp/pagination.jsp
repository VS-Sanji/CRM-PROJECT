<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <%--引入jquery库--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>

    <%--引人bootstrap框架--%>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">

    <%--引入pagination分页插件--%>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>


    <title>演示pagination分页插件</title>
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
    <div id="page">page</div>
</body>
</html>
