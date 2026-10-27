<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@page import="com.alibaba.fastjson.JSONArray"%>
<%@page import="ext.gwc.part.createpart.util.BatchCreatePartHelper"%>
<%@page import="com.ptc.windchill.csm.common.CsmConstants"%>
<%@page import="com.ptc.core.meta.common.AttributeTypeIdentifier"%>
<%@page import="java.util.Set"%>
<%@page import="wt.facade.classification.ClassificationFacade"%>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%@page import="org.apache.commons.logging.Log"%>
<%@ page language="java" isThreadSafe="true" contentType="text/html;charset=UTF-8"%>
<%
Log logger = LogFactory.getLog(this.getClass());
String actionType = request.getParameter("actionType");

if("getClsAttrs".equals(actionType)){
	String clsName = request.getParameter("clsName");
	String clsDisplayName = request.getParameter("clsDisplayName");
	JSONObject json = new BatchCreatePartHelper().getClsAttrs(clsName, clsDisplayName);
	String jsonStr = json.toJSONString();
	out.write("@'state':'查询成功','message':"+jsonStr+"@");
}else if("getTypeAttrs".equals(actionType)){
	String typeName = request.getParameter("typeName");
	String typeDisplayName = request.getParameter("typeDisplayName");
	JSONObject json = new BatchCreatePartHelper().getTypeAttrs(typeName, typeDisplayName);
	String jsonStr = json.toJSONString();
	out.write("@'state':'查询成功','message':"+jsonStr+"@");
}else if("getMaterialLinkageData".equals(actionType)){
	/*
	 * 材质三级联动模拟接口，数据结构依次为：分类、材质大类、材质细分类型、色号。
	 * 这里只保留 Excel 中少量代表性案例；R1110 的 5 个材质大类全部保留，用于验证分类过滤。
	 */
	String[][] mockMaterialData = new String[][]{
		{"R1110", "K=K (BC坑)", "", ""},
		{"R1110", "单坑(B坑)", "", ""},
		{"R1110", "K3K（E坑）", "", ""},
		{"R1110", "A3B", "", ""},
		{"R1110", "B3B", "", ""},
		{"头戴耳机", "PP", "台塑 PP 3015", ""},
		{"头戴耳机", "PC+ABS", "亚仑 PC+ABS AL3620", "BK296"},
		{"头戴耳机", "PC+ABS", "SABIC PC+ABS CY4000M", "7M2B2242"},
		{"头戴耳机", "PC+ABS", "SABIC PC+ABS CY4000M", "7M1A4447"},
		{"头戴耳机", "ABS", "奇美 ABS 757", "WT1"},
		{"头戴耳机", "ABS", "奇美 ABS 757", "GY27"},
		{"TWS耳机", "PC+ABS", "金发 PC+ABS Jh960-6965", "6965 C2B-G1689"},
		{"TWS耳机", "PC+ABS", "LG PC+ABS  GN5001RFZ", "Y0700"},
		{"TWS耳机", "PC+ABS", "LG PC+ABS  GN5001RFZ", "R2060"},
		{"TWS耳机", "PC", "SABIC PC EXL1414", "7G7B4680"},
		{"Dongle", "ABS", "奇美 ABS 757", "BK26"}
	};
	JSONArray data = new JSONArray();
	for(int i = 0; i < mockMaterialData.length; i++){
		JSONObject item = new JSONObject();
		item.put("classification", mockMaterialData[i][0]);
		item.put("horn_MaterialCategories", mockMaterialData[i][1]);
		item.put("horn_MaterialSubType", mockMaterialData[i][2]);
		item.put("colorNumber", mockMaterialData[i][3]);
		data.add(item);
	}
	JSONObject result = new JSONObject();
	result.put("success", true);
	result.put("data", data);
	result.put("message", "查询成功");
	response.setContentType("application/json;charset=UTF-8");
	out.write(result.toJSONString());
}else if("submitTable".equals(actionType)){
	String tableDatas = request.getParameter("tableDatas");
	String folderOid = request.getParameter("folderOid");
	if(folderOid.indexOf("~")>=0){
		folderOid = folderOid.substring(0, folderOid.indexOf("~"));
	}
	//System.out.println("tableDatas="+tableDatas);
	String message = new BatchCreatePartHelper().createParts(tableDatas, folderOid);
	if(message != null && message.contains("Error")){
		out.write("@'state':'创建失败','message':"+message+"@");
	}else{
		out.write("@'state':'创建成功','message':"+message+"@");
	}
}
%>
