<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <%--首先引入jquery库，因为这是最被依赖的,要保证被依赖程度高的首先引入--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <%--其次引入bootstrap框架，插件是依赖于bootstrap框架运行的--%>
    <link ref="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap
    .min.css"></link>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <%--datatimepicker插件--%>
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<%--    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>--%>
-
    <title>演示bs_datetimepicker插件</title>
    <script type="text/javascript">
        //页面加载完再对容器调用函数
        $(function (){
            $("#date").datetimepicker({
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
</head>
<body>
    <input id="date" type="text">
</body>
</html>
