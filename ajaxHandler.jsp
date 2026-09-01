<%@page import="com.alibaba.fastjson.JSONObject"%>
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