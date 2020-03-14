<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>InfectStatisticWeb</title>
<script src="dist/echarts.min.js"></script>
<script src="dist/china.js"></script>
<link href="css/firstPage.css" rel="stylesheet">
</head>
<body>

	<% if (request.getAttribute("overall") == null) { %>
		<jsp:forward page="Servlet" />
		%>
	<%
	}
	%>
	<script type="text/javascript">
	console.log(<%=request.getAttribute("overall") %>)
	</script>
	
	 <!-- 为ECharts准备一个具备大小（宽高）的Dom -->
	<div id="overall" style="width: 800px;height:200px;">
	<% JSONObject obj = (JSONObject)request.getAttribute("overall"); %>
		<div class="overallItem">现有确诊:<%=obj.get("currentConfirmedCount").toString() %></div>
		<div class="overallItem">累计确诊::<%=obj.get("confirmedCount").toString() %></div>
		<div class="overallItem">累计治愈::<%=obj.get("curedCount").toString() %></div>
		<div class="overallItem">累计死亡::<%=obj.get("deadCount").toString() %></div>
	</div>
    <div id="map" style="width: 800px;height:600px;"></div>
    <div id="lineChart" style="width: 800px;height:600px;"></div>
    
    <script type="text/javascript">
    var myChart = echarts.init(document.getElementById('map'));
    var option = {
        title: {
            text: '全国疫情地图',
            left: 'center'
        },
        backgroundColor: '#f7f7f7',
        tooltip: {
        	formatter: function(params) {
        		return `地区：`+ params.name +` <br/>确诊：` + (params.value || 0) + `人<br/>死亡：`
        		+ (params.data && params.data.deadCount || 0) + `人`;
        	},
        },
        visualMap: [
            { 
                type: 'piecewise', 
                pieces: [
                    {gt: 10000},            // (1500, Infinity]
                    {gt: 1000, lte: 9999},  // (900, 1500]
                    {gt: 100, lte: 999},  // (310, 1000]
                    {gt: 10, lte: 99},   // (200, 300]
                    {gt: 0, lte: 9},       // (10, 200]
                ]
            }
        ],
        series: [{
            type: 'map',
            map: 'china',
            label: {
            	show: true
            },
            data: <%= request.getAttribute("data") %>
        }]
    };
    myChart.setOption(option);
    </script>
    
    <script type="text/javascript">
    var lineChart = echarts.init(document.getElementById('lineChart'),'infographic');
    lineChart.setOption({
                  //设置标题
                  title: {
                      text: name + '疫情趋势'
                  },
                  //数据提示框
                  tooltip: {
                      trigger: 'axis',
                  },
                  legend: {
                      data: ['确诊','疑似','治愈','死亡']
                  },
                  xAxis: {
                      data:[]
                  },
                  yAxis: {},
                  series: [
                      {
                          name: '确诊',
                          type: 'line',
                          data:[]
                      },
                      {
                          name: '疑似',
                          type: 'line',
                          data:[]
                      },
                      {
                          name: '治愈',
                          type: 'line',
                          data:[]
                      },
                      {
                          name: '死亡',
                          type: 'line',
                          data:[]
                      }
                  ]
              },true);
    </script>
    
</body>
</html>