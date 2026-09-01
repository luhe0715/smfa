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
	 * 材质联动模拟接口。
	 * 后台正式接口完成后，仅需将此分支替换为真实查询，前端继续使用相同返回结构。
	 */
	String[][] mockMaterialData = new String[][]{
		{"PP", "PP3015"},
		{"PP", "PP242"},
		{"PA", "PA6 1010C2"},
		{"PA", "PA66101F"},
		{"ABS", "ABS 757"},
		{"ABS", "ABS757"},
		{"PC", "PC2805"},
		{"PC", "PC 2805"},
		{"单粉卡", "200g单粉卡"},
		{"单粉卡", "300g单粉卡"},
		{"铜版纸", "128g铜版纸(双铜)"},
		{"铜版纸", "157g铜版纸(双铜)"}
	};
	JSONArray data = new JSONArray();
	for(int i = 0; i < mockMaterialData.length; i++){
		JSONObject item = new JSONObject();
		item.put("horn_MaterialCategories", mockMaterialData[i][0]);
		item.put("horn_MaterialSubType", mockMaterialData[i][1]);
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
