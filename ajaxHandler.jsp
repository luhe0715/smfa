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
	 * 来源：selectData v1.0.xlsx / selectData，选取 4 个分类共 25 条代表性记录。
	 * H1001/H1002 验证多细分、多色号；R0504/R1110 验证无色号及分类隔离。
	 */
	String[][] mockMaterialData = ext.horn.utils.HornHelper.service.getMaterialList();
/*
	String[][] mockMaterialData = new String[][]{
		{"H1001", "PC+ABS", "LG PC+ABS GN5001", ""},
		{"H1001", "PC+ABS", "LG PC+ABS GN5001RFZ", "Y0700"},
		{"H1001", "PC+ABS", "LG PC+ABS GN5001RFZ", "R2060"},
		{"H1001", "PC+ABS", "LG PC+ABS GN5001RFG", "W4023"},
		{"H1001", "PC+ABS", "SABIC PC+ABS CY4000M", "7M2B2242"},
		{"H1001", "PC+ABS", "SABIC PC+ABS CY4000M", "7M1A4447"},
		{"H1001", "ABS", "奇美 ABS 757", "WT1"},
		{"H1001", "ABS", "奇美 ABS 757", "GY27"},
		{"H1002", "PC+ABS", "LG PC+ABS GN5001", ""},
		{"H1002", "PC+ABS", "LG PC+ABS GN5001RFZ", "Y0700"},
		{"H1002", "PC+ABS", "LG PC+ABS GN5001RFZ", "R2060"},
		{"H1002", "ABS", "奇美 ABS 757", "WT1"},
		{"R0504", "SUS", "SUS304", ""},
		{"R0504", "AL", "AL5052", ""},
		{"R0504", "SUS", "SUS304 3/4H", ""},
		{"R0504", "SUS", "SUS316", ""},
		{"R0504", "钕铁硼", "钕铁硼 NdFeB,N52", ""},
		{"R1110", "A=A", "A=A", ""},
		{"R1110", "A=A", "A=A,BC坑,耐破12kgf/cm²,边压>5.6kN/m", ""},
		{"R1110", "K=K", "K=K,BC坑,耐破15kgf/cm²,边压>6.5kN/m", ""},
		{"R1110", "K=K", "K=K,BC坑,耐破18kgf/cm²,边压>7.5kN/m", ""},
		{"R1110", "K=K", "K=K,BC坑,耐破22kgf/cm²,边压>10kN/m", ""},
		{"R1110", "K3K", "K3K,B坑,耐破 ≥18 kgf/cm²,边压>7.5N/m(ECT44)", ""},
		{"R1110", "A3A", "A3A,B坑,耐破 ≥14 kgf/cm²,边压>5.6N/m(ECT32)", ""},
		{"R1110", "B3B", "B3B,B坑,耐破 ≥10 kgf/cm²,边压>4.5kN/m", ""}
	};*/
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
