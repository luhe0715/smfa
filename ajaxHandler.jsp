<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@page import="com.alibaba.fastjson.JSONArray"%>
<%@page import="ext.gwc.part.createpart.util.BatchCreatePartHelper"%>
<%@page import="com.ptc.windchill.csm.common.CsmConstants"%>
<%@page import="com.ptc.core.meta.common.AttributeTypeIdentifier"%>
<%@page import="java.util.Set"%>
<%@page import="wt.facade.classification.ClassificationFacade"%>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%@page import="org.apache.commons.logging.Log"%>
<%@page import="com.ptc.netmarkets.model.NmOid"%>
<%@page import="wt.folder.Folder"%>
<%@page import="wt.fc.Persistable"%>
<%@page import="wt.fc.ReferenceFactory"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="ext.pi.core.PIPersistableHelper"%>
<%@page import="ext.gwc.part.createpart.rule.CreatePartPropUtil"%>
<%@page import="wt.folder.FolderHelper"%>
<%@page import="wt.fc.PersistenceHelper"%>
<%@page import="wt.inf.container.WTContainerRef"%>
<%@page import="wt.part.WTPart"%>
<%@page import="wt.part.Source"%>
<%@page import="wt.part.QuantityUnit"%>
<%@page import="wt.part.PartType"%>
<%@page import="wt.pom.Transaction"%>
<%@ page language="java" isThreadSafe="true" contentType="text/html;charset=UTF-8"%>
<%!
private static JSONArray readPartData(String tableDatas) {
	JSONArray parts = JSONArray.parseArray(tableDatas);
	if(parts == null || parts.isEmpty()){
		throw new IllegalArgumentException("没有可创建的部件数据");
	}
	return parts;
}

private static String resolvePartName(JSONObject part, Map<String, Object> classificationAttrs) {
	String name = part.getString("partName");
	String prefix = "自动生成的(";
	if(name != null && name.startsWith(prefix) && name.endsWith(")")){
		String attrName = name.substring(prefix.length(), name.length() - 1);
		Object value = "CSM_NODE_NAME".equalsIgnoreCase(attrName)
				? part.getString("clsDisplayName") : classificationAttrs.get(attrName);
		return value == null ? "" : value.toString();
	}
	return name;
}

/*
 * 继续使用原组件的属性类型转换及 OIR 初始化，但不调用其直接保存的 createParts。
 * 路径字符串不能唯一定位不同容器下的 /Default；必须在保存前绑定实际文件夹对象。
 */
private static class FolderAwareBatchCreatePartHelper extends BatchCreatePartHelper {
	private Map<String, Object> readAttrs(JSONObject part, String prefix) throws Exception {
		Map<String, Object> attrs = new LinkedHashMap<String, Object>();
		int count = part.getIntValue(prefix + "AttrsNumber");
		for(int i = 0; i < count; i++){
			JSONObject attr = part.getJSONArray(prefix + "Attr" + i).getJSONObject(0);
			attrs.put(attr.getString("attrName"), parseValueByType(attr));
		}
		return attrs;
	}

	private String createInFolder(String tableDatas, Folder folder) throws Exception {
		JSONArray parts = readPartData(tableDatas);
		WTContainerRef containerRef = WTContainerRef.newWTContainerRef(folder.getContainer());
		boolean usingOIR = CreatePartPropUtil.isUsingOIR();
		String view = CreatePartPropUtil.getPartView();
		Transaction transaction = new Transaction();
		try{
			transaction.start();
			for(int i = 0; i < parts.size(); i++){
				JSONObject partData = parts.getJSONObject(i);
				Map<String, Object> typeAttrs = readAttrs(partData, "type");
				Map<String, Object> classificationAttrs = readAttrs(partData, "cls");
				Map<String, Object> attrs = new LinkedHashMap<String, Object>();
				/* 初始化属性前先确定容器，防止相同名称的 Default 柜串到站点域。 */
				attrs.put("containerReference", containerRef);
				attrs.putAll(typeAttrs);
				attrs.put(CreatePartPropUtil.getPartClfAttr(), partData.getString("clsName"));
				attrs.putAll(classificationAttrs);
				attrs.put("view", view);
				attrs.put("name", resolvePartName(partData, classificationAttrs));
				attrs.put("containerReference", containerRef);
				/* 目录由 FolderHelper 按对象赋值，不经过通用属性的路径解析。 */
				attrs.remove("folder");
				attrs.remove("folder.id");
				attrs.putIfAbsent("source", Source.getSourceDefault());
				attrs.putIfAbsent("defaultUnit", QuantityUnit.getQuantityUnitDefault());
				attrs.putIfAbsent("partType", PartType.getPartTypeDefault());
				String typeName = partData.getString("partSoftType");
				if(typeName == null || typeName.trim().length() == 0){
					typeName = "wt.part.WTPart";
				}else{
					typeName = typeName.substring(typeName.lastIndexOf('|') + 1);
				}
				WTPart part = (WTPart) PIPersistableHelper.service.newPersistable(typeName, attrs, usingOIR);
				part.setContainerReference(containerRef);
				FolderHelper.assignLocation(part, folder);
				part = (WTPart) PersistenceHelper.manager.save(part);
				Folder savedFolder = FolderHelper.service.getFolder(part);
				if(savedFolder == null || !PersistenceHelper.getObjectIdentifier((Persistable) folder)
						.equals(PersistenceHelper.getObjectIdentifier((Persistable) savedFolder))){
					throw new IllegalStateException("保存目录与所选文件夹不一致，本次批量创建已撤销");
				}
			}
			transaction.commit();
			transaction = null;
			return "success";
		}finally{
			if(transaction != null){
				transaction.rollback();
			}
		}
	}
}
%>
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
	String message;
	try{
		if(folderOid == null || folderOid.trim().length() == 0){
			throw new IllegalArgumentException("无法确定创建目录，请从目标文件夹重新打开批量创建");
		}
		folderOid = folderOid.trim();
		if(folderOid.indexOf("~")>=0){
			folderOid = folderOid.substring(0, folderOid.indexOf("~"));
		}
		Object target = NmOid.newNmOid(folderOid).getRefObject();
		if(!(target instanceof Folder)){
			throw new IllegalArgumentException("创建位置不是文件夹，请从目标文件夹重新打开批量创建");
		}
		Folder folder = (Folder) target;
		folderOid = new ReferenceFactory().getReferenceString((Persistable) folder);
		message = new FolderAwareBatchCreatePartHelper().createInFolder(tableDatas, folder);
	}catch(Exception e){
		logger.error("批量创建部件失败，目标目录：" + folderOid, e);
		message = "Error: " + e.getLocalizedMessage();
	}
	if(message != null && message.contains("Error")){
		out.write("@'state':'创建失败','message':"+message+"@");
	}else{
		out.write("@'state':'创建成功','message':"+message+"@");
	}
}
%>
