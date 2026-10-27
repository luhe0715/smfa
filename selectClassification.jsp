<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/netmarkets/jsp/util/beginPopup.jspf"%>
<%@ taglib prefix="mvc" uri="http://www.ptc.com/windchill/taglib/mvc"%>
<%@taglib uri="http://www.ptc.com/windchill/taglib/wrappers" prefix="w"%>
<style type="text/css">
.formTableButton{
     width: 70px;
     height: 30px;
     border-width: 0px;
     border-radius: 3px;
     background: #4682B4;
     cursor: pointer;
     outline: none;
     font-family: Microsoft YaHei;
     color: white;
     font-size: 15px;
     float:right;
     margin-right: 10%;
}
</style>
<%
String seq = request.getParameter("seq");
%>
<script type="text/javascript">
	PTC.jca.table.Utils.reload('ext.gwc.part.createpart.builder.ClassificationBuilder', null, true);
</script>
<div style="width: 550px; height: 550px; ">
	<div style="overflow:auto; width: 500px; height: 500px; ">
		<jsp:include page="${mvc:getComponentURL('ext.gwc.part.createpart.builder.ClassificationBuilder')}" />
	</div>
	<input type="button" name="selectOK" id="selectOK" class="formTableButton" onclick="selectItemsReturn();" value="确定"/>
</div>
<script type="text/javascript">

function selectItemsReturn(){
	var table = PTC.jca.table.Utils.getTable('ext.gwc.part.createpart.builder.ClassificationBuilder');
	var selected = table.getSelectionModel().getSelections();
	
	var seq = '<%=seq%>';
	var seqs = [];
	var select_displayName ;
	var select_name ;
	if(selected.length > 0){
		select_displayName = selected[0].data.displayName;
 		select_name = selected[0].data.name;
 
 		/* if(select_name.length != 5 || select_name == "anker"){
  			alert("【"+select_displayName+"】不是小类，请重新选择!");
  			return;
 		}*/
		if (seq.length > 1) {
			seqs = seq.split(",");
			for (var i = 0; i < seqs.length; i++) {
				var openerClsDisplayName = window.opener.document.getElementById("clsDisplayName" + seqs[i]);
				var openerClsName = window.opener.document.getElementById("clsName" + seqs[i]);
				var partName = window.opener.document.getElementById("partName" + seqs[i]);
				var partNameDefault = select_displayName.substring(select_displayName.indexOf("_")+1,select_displayName.length);
				openerClsDisplayName.value = select_displayName;
				openerClsName.value = select_name;
				//partName.value = partNameDefault;
				getCSMAutonamingValues(select_name,"",partName);
				setClsAttrs(select_name, select_displayName);
			}
		} else {
			var openerClsDisplayName = window.opener.document.getElementById("clsDisplayName" + seq);
			var openerClsName = window.opener.document.getElementById("clsName" + seq);
			var partName = window.opener.document.getElementById("partName" + seq);
			var partNameDefault = select_displayName.substring(select_displayName.indexOf("_")+1,select_displayName.length);
			openerClsDisplayName.value = select_displayName;
			openerClsName.value = select_name;
			//partName.value = partNameDefault;
			getCSMAutonamingValues(select_name,"",partName);
			setClsAttrs(select_name, select_displayName);
		}
	}
	window.close();
}

	/**
	*获取分类自动命名特性
	*/
	function getCSMAutonamingValues(clsInternalNname,nameSpace,partNameObj){
  	try{  		
 			 		var url = "ptc1/GetCSMAutonamingConfigController";
					var options = {
						 asynchronous : false,
						 method : "post",
						 parameters : {
							 clsInternalNname : clsInternalNname,
							 nameSpace : nameSpace
						 }
					 };
					 var resp = requestHandler.doRequest(url, options);				
					 if(resp.readyState==4 && resp.status==200){
							var responseText = resp.responseText;
							var jsonObj = JSON.parse(responseText);
							var error=jsonObj.error;		
							if(error){
								alert(error);								
							}else{
								var autoNamingValue = jsonObj.lwcTypePropruleForAutoNaming;
								/* 未配置自动命名内容时保留用户已填写的物料名称，避免被空值覆盖。 */
								if(autoNamingValue !== null && autoNamingValue !== undefined
										&& String(autoNamingValue).replace(/^\s+|\s+$/g, "") !== ""){
									partNameObj.value = autoNamingValue;
								}
								var isEdit = jsonObj.lwcTypePropenforceAutoNamingRule;		
								if("true"  == isEdit){
									partNameObj.readOnly=true;
									partNameObj.style.backgroundColor="#dddddd";
								}else{
									partNameObj.readOnly=false;
									partNameObj.style.backgroundColor="#ffffff";
								}				
							}							
					 }
   	}catch(e){
   		alert("getCSMAutonamingValues: "+e);
   	}
  }


/* 根据选择分类,在父页面中创建对应的属性元素 */
function setClsAttrs(clsName, clsDisplayName){
	var options = {
		       asynchronous: false,
		       parameters: {
		    	   actionType : "getClsAttrs",
		    	   clsName : clsName,
		    	   clsDisplayName : clsName,
		       }
			};
	var url = "netmarkets/jsp/ext/gwc/part/createpart/ajaxHandler.jsp";
	var response = requestHandler.doRequest(url, options);
	var resText = response.responseText;
	
	var seq = '<%=seq%>';
	var seqs = [];
	if(resText.indexOf("查询成功") >0){
		resText = resText.substring(resText.indexOf("'message':")+10,resText.lastIndexOf("@"));
		var dataJson = eval('(' + resText + ')'); 	
		
		if (seq.length > 1) {
			seqs = seq.split(",");
			for (var r = 0; r < seqs.length; r++) {
				seq = seqs[r];
				getHTML(dataJson, seq);
			}
		} else {
			getHTML(dataJson, seq);
		}
	}
}

/* 色号的内部名由分类属性动态返回；同时兼容常见内部名和中英文显示名称。 */
function isMaterialColorClassificationAttr(attrName, attrDisplayName){
	var normalizedName = String(attrName || "")
			.replace(/_en$/i, "").replace(/[^a-z0-9]/gi, "").toLowerCase();
	var normalizedDisplayName = String(attrDisplayName || "")
			.replace(/[\s:：*]/g, "").toLowerCase();
	return normalizedName == "horncolornumber"
			|| normalizedName == "horncolorno"
			|| normalizedName == "horncolorcode"
			|| normalizedName == "horncolournumber"
			|| normalizedName == "horncolourno"
			|| normalizedName == "horncolourcode"
			|| normalizedName == "hornmaterialcolornumber"
			|| normalizedName == "hornmaterialcolorno"
			|| normalizedName == "hornmaterialcolorcode"
			|| normalizedName == "hornmaterialcolournumber"
			|| normalizedName == "hornmaterialcolourno"
			|| normalizedName == "hornmaterialcolourcode"
			|| normalizedDisplayName == "色号"
			|| normalizedDisplayName == "colornumber"
			|| normalizedDisplayName == "colorno"
			|| normalizedDisplayName == "colorcode";
}

/*
 * 分类属性由所选分类动态返回。中文属性内部名为 horn_xxx，
 * 对应英文属性内部名为 horn_xxx_en；按内部名动态配对，不依赖显示名称。
 */
function getPairedClassificationAttrKeys(dataJson){
	var sourceKeys = [];
	var configuredKeys = dataJson["attrNamesAry"];
	var sourceKeyMap = {};
	var pairByBaseName = {};
	var baseNameOrder = [];
	var orderedKeys = [];
	var hasMaterialAttr = false;

	/* 接口提供属性顺序时优先使用；否则使用本次分类数据中的属性顺序。 */
	if(configuredKeys && configuredKeys.length){
		for(var configuredIndex = 0; configuredIndex < configuredKeys.length; configuredIndex++){
			var configuredKey = configuredKeys[configuredIndex];
			var configuredAttrArray = dataJson[configuredKey];
			if(configuredAttrArray && configuredAttrArray.length
					&& configuredAttrArray[0]["attrName"] && !sourceKeyMap["$" + configuredKey]){
				sourceKeys.push(configuredKey);
				sourceKeyMap["$" + configuredKey] = true;
			}
		}
	}
	/* attrNamesAry 可能不完整，继续补入当前分类实际返回的其余属性。 */
	for(var key in dataJson){
		if(dataJson.hasOwnProperty && !dataJson.hasOwnProperty(key)){
			continue;
		}
		var candidateArray = dataJson[key];
		if(candidateArray && candidateArray.length && candidateArray[0]["attrName"]
				&& !sourceKeyMap["$" + key]){
			sourceKeys.push(key);
			sourceKeyMap["$" + key] = true;
		}
	}

	/* “材质大类/材质细分类型/色号”仅在当前分类包含“材质”属性时显示。 */
	for(var sourceIndex = 0; sourceIndex < sourceKeys.length; sourceIndex++){
		var sourceAttrArray = dataJson[sourceKeys[sourceIndex]];
		if(!sourceAttrArray || !sourceAttrArray.length){
			continue;
		}
		var sourceAttrName = sourceAttrArray[0]["attrName"] || sourceKeys[sourceIndex];
		var sourceBaseName = /_en$/i.test(sourceAttrName)
				? sourceAttrName.substring(0, sourceAttrName.length - 3) : sourceAttrName;
		if(sourceBaseName.toLowerCase() == "horn_material"){
			hasMaterialAttr = true;
			break;
		}
	}

	for(var i = 0; i < sourceKeys.length; i++){
		var attrArray = dataJson[sourceKeys[i]];
		if(!attrArray || !attrArray.length){
			continue;
		}
		var attrName = attrArray[0]["attrName"] || sourceKeys[i];
		var isEnglish = /_en$/i.test(attrName);
		var baseName = isEnglish ? attrName.substring(0, attrName.length - 3) : attrName;
		var normalizedBaseName = baseName.toLowerCase();
		var attrDisplayName = attrArray[0]["attrDisplayName"] || "";
		if(!hasMaterialAttr && (normalizedBaseName == "horn_materialcategories"
				|| normalizedBaseName == "horn_materialsubtype"
				|| isMaterialColorClassificationAttr(attrName, attrDisplayName))){
			continue;
		}
		var baseNameKey = "$" + normalizedBaseName;
		if(!pairByBaseName[baseNameKey]){
			pairByBaseName[baseNameKey] = {};
			baseNameOrder.push(baseNameKey);
		}
		/* 只调整当前分类实际返回的材质属性，整组中英文一起移到末尾。 */
		if(normalizedBaseName == "horn_materialcategories"){
			pairByBaseName[baseNameKey].materialOrder = 0;
		}else if(normalizedBaseName == "horn_materialsubtype"){
			pairByBaseName[baseNameKey].materialOrder = 1;
		}else if(isMaterialColorClassificationAttr(attrName, attrDisplayName)){
			pairByBaseName[baseNameKey].materialOrder = 2;
		}
		if(isEnglish){
			pairByBaseName[baseNameKey].englishKey = sourceKeys[i];
		}else{
			pairByBaseName[baseNameKey].chineseKey = sourceKeys[i];
		}
	}

	var normalBaseNameOrder = [];
	var materialBaseNameOrder = [[], [], []];
	for(var pairIndex = 0; pairIndex < baseNameOrder.length; pairIndex++){
		var pairKey = baseNameOrder[pairIndex];
		var materialOrder = pairByBaseName[pairKey].materialOrder;
		if(materialOrder === undefined){
			normalBaseNameOrder.push(pairKey);
		}else{
			materialBaseNameOrder[materialOrder].push(pairKey);
		}
	}
	baseNameOrder = normalBaseNameOrder.concat(materialBaseNameOrder[0],
			materialBaseNameOrder[1], materialBaseNameOrder[2]);

	for(var j = 0; j < baseNameOrder.length; j++){
		var attrPair = pairByBaseName[baseNameOrder[j]];
		if(attrPair.chineseKey){
			orderedKeys.push(attrPair.chineseKey);
		}else{
			orderedKeys.push(null);
		}
		if(attrPair.englishKey){
			orderedKeys.push(attrPair.englishKey);
		}else{
			/* 单语言属性补空位，避免后续中英文配对整体错位。 */
			orderedKeys.push(null);
		}
	}
	return orderedKeys;
}
		
/* 生成html内容 */
function getHTML(dataJson, seq){
	console.log(dataJson);
	var table = window.opener.document.getElementById('formTable');
	var index = 0;
	var formTableRows = table.rows;
	for(var r = 0; r < formTableRows.length; r++){
		var formTableRow = formTableRows[r];
		var id = formTableRow.getAttribute("id")
		if(id){
			if(("row"+seq) == id){
				index = r;
				break;
			}
		}
	}
	var cell = table.rows[index].cells[5];
	cell.innerHTML = "";							//每次先清空
	var innerHTML="<table class='clsAttrTable' id='clsAttrTable"+seq+"'><tr>";
	var tdNum=0;
	var attrKeys = getPairedClassificationAttrKeys(dataJson);
	for(var keyIndex=0; keyIndex<attrKeys.length; keyIndex++){
		var key = attrKeys[keyIndex];
		if(key === null){
			innerHTML += "<td></td><td></td>";
			tdNum++;
			if(tdNum%2 == 0){
				innerHTML += "</tr><tr>";
			}
			continue;
		}
		/* 分类属性信息 */
		var attrName = "";
		var attrDisplayName = "";
		var attrDataType = ""
		var attrDefaultValue = ""
		var attrUnit = ""
		
		/* 分类属性约束信息 */
		var ruleTypes = "";							//拼接所有以设置的约束名称
		var ruleLegalValues = "";					//合法值
		var ruleValueRange = "";
		var ruleValueLength = "";
		var ruleEnumMap = null;
		
		var attrArray = dataJson[key];				//attrArray的长度代表约束的个数
		for(var i=0; i<attrArray.length; i++){
			var ruleTypeName = attrArray[i]["ruleTypeName"];
			ruleTypes += ruleTypeName + ",";
			
			attrDataType = attrArray[i]["attrDataType"];
			attrName = attrArray[i]["attrName"];
			attrDisplayName = attrArray[i]["attrDisplayName"];
			attrUnit = attrArray[i]["attrUnit"];
			
			if("undefined" == typeof(attrUnit)){
				attrUnit = "";
			}
			
			if("DiscreteSetConstraint" == ruleTypeName){
				if(null != attrArray[i]["ruleLegalValues"] && "" != attrArray[i]["ruleLegalValues"] ){
					ruleLegalValues = attrArray[i]["ruleLegalValues"];
				}else{
					ruleEnumMap = attrArray[i]["ruleEnumMap"];
				}
			}else if("RangeConstraint" == ruleTypeName){
				ruleValueRange = attrArray[i]["ruleValueRange"];
			}else if("StringLengthConstraint" == ruleTypeName){
				ruleValueLength = attrArray[i]["ruleValueLength"];
			}
			
			var attrDefaultValueList = attrArray[i]["attrDefaultValueList"];
			if("" == attrDefaultValue && attrDefaultValueList.length >0){	//取一次就够了
				attrDefaultValue = attrDefaultValueList[0];
// 				for(var j=0; j<attrDefaultValueList.length; j++){			//暂时不考虑多值
// 					attrDefaultValue += attrDefaultValueList[j];
// 					if(j<attrDefaultValueList.length-1){
// 						attrDefaultValue += ",";
// 					}
// 				}
			}
		}
		
		/* 包含必填约束,属性名增加*标识 */
		var tdStyle="'style=text-align: right;' ";
		if(ruleTypes.indexOf("ValueRequiredConstraint")>=0){
			attrDisplayName = attrDisplayName+"*";
			tdStyle = "style=\"color:red;\" ";
		}
		
		var materialLinkageMarker = "";
		if(!/_en$/i.test(attrName)
				&& isMaterialColorClassificationAttr(attrName, attrDisplayName)){
			materialLinkageMarker = " data-material-color-control='true' ";
		}
		var htmls = "<td "+tdStyle+">"+attrDisplayName + ":</td><td>";
		if(ruleTypes.indexOf("DiscreteSetConstraint")>=0){				/* 合法值列表,枚举值列表约束,创建下拉列表 */
			htmls += "<select name='selectList' seq='"+seq+"' id='"+attrName+"' attrDataType='"+attrDataType+"' "+materialLinkageMarker;
			if(ruleTypes.indexOf("ValueRequiredConstraint")>=0){			
				htmls += "required='required' >  "
			}else{
				htmls += " >  "
			}
			if("" != ruleLegalValues){
				var legalValues = ruleLegalValues.substring(1,ruleLegalValues.length-1);
				var values = legalValues.split(",");
				for(var i=0; i<values.length; i++){
					var op = "<option value ='"+values[i]+"'>"+values[i]+"</option> ";
					if(attrDefaultValue && values[i] == attrDefaultValue){
						op = "<option value ='"+values[i]+"' selected='true'>"+values[i]+"</option> ";
					}
					htmls += op;
				}
			}else if(null != ruleEnumMap){
				for(var enumKey in ruleEnumMap){ 
					var enumName = enumKey;
					var enumDisplay = ruleEnumMap[enumKey];
					var op = "<option value ='"+enumName+"'>"+enumDisplay+"</option> ";
					if(attrDefaultValue && enumName == attrDefaultValue){
						op = "<option value ='"+enumName+"' selected='true'>"+enumDisplay+"</option> ";
					}
					htmls += op;
				}
			}
			htmls += "</select>"
		}else if(attrDataType.indexOf("Boolean")>=0){					/* 分类属性类型是布尔值,创建下拉列表 */
			htmls += "<select name='selectList' seq='"+seq+"' id='"+attrName+"' attrDataType='"+attrDataType+"' "+materialLinkageMarker;
			if(ruleTypes.indexOf("ValueRequiredConstraint")>=0){
				htmls += "required='required' >  "
			}else{
				htmls += " >  "
			}
			if(attrDefaultValue && attrDefaultValue=="true"){
				htmls += "<option value ='false'>否</option> <option value ='true' selected='true'>是</option>  </select>";
			}else if(attrDefaultValue && attrDefaultValue=="true"){
				htmls += "<option value ='false' selected='true'>否</option> <option value ='true'>是</option>  </select>";
			}else{
				htmls += "<option value =''> </option> <option value ='false'>否</option> <option value ='true'>是</option>  </select>";
			}
		}else{															/* 其余属性类型及约束类型,创建输入框 */
			htmls += "<input type='text' seq='"+seq+"' id='"+attrName+"' attrDataType='"+attrDataType+"' attrDefaultValue='"+attrDefaultValue+"' "+materialLinkageMarker;
			if(attrDefaultValue){
				htmls += "value='"+attrDefaultValue+"' "
			}
			var title = "";
			if(ruleTypes.indexOf("ValueRequiredConstraint")>=0){
				htmls += "required='required' "
			}
			if(ruleTypes.indexOf("StringLengthConstraint")>=0){			//控制输入长度
				htmls += "size='"+ruleValueLength+"' ";
			}
			if(attrDataType.indexOf("FloatingPoint")>=0){
				htmls += "oninput=value=value.replace(/[^\\d.]/g,'') ";	//控制可输入的值类型
				title +="仅数字";
			}
			htmls += "unit='"+attrUnit+"' ";							//单位
			
			if("" != title){
				htmls += "title='"+title+"' ";
			}
			htmls +="/>"+attrUnit;
		}
		htmls += "</td>";
		tdNum++;
		if(tdNum%2 == 0){												//每组中英文属性显示一行
			htmls += "</tr><tr>";
		}
		innerHTML += htmls;
		
	} 
	cell.innerHTML = innerHTML+"</tr></table>";
	/* 分类属性为动态内容，生成完成后再由父页面绑定材质下拉和联动。 */
	if(window.opener && window.opener.initializeMaterialComboboxes){
		window.opener.initializeMaterialComboboxes(seq);
	}
}
</script>

<%@ include file="/netmarkets/jsp/util/end.jspf"%>
