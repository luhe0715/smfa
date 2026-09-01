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
								partNameObj.value=	jsonObj.lwcTypePropruleForAutoNaming;	
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

/*
 * 分类属性由所选分类动态返回。中文属性内部名为 horn_xxx，
 * 对应英文属性内部名为 horn_xxx_en；按内部名动态配对，不依赖显示名称。
 */
function getPairedClassificationAttrKeys(dataJson){
	var sourceKeys = [];
	var configuredKeys = dataJson["attrNamesAry"];
	var pairByBaseName = {};
	var baseNameOrder = [];
	var orderedKeys = [];

	/* 接口提供属性顺序时优先使用；否则使用本次分类数据中的属性顺序。 */
	if(configuredKeys && configuredKeys.length){
		for(var configuredIndex = 0; configuredIndex < configuredKeys.length; configuredIndex++){
			if(dataJson[configuredKeys[configuredIndex]]){
				sourceKeys.push(configuredKeys[configuredIndex]);
			}
		}
	}else{
		for(var key in dataJson){
			if(dataJson.hasOwnProperty && !dataJson.hasOwnProperty(key)){
				continue;
			}
			var candidateArray = dataJson[key];
			if(candidateArray && candidateArray.length && candidateArray[0]["attrName"]){
				sourceKeys.push(key);
			}
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
		var baseNameKey = "$" + baseName.toLowerCase();
		if(!pairByBaseName[baseNameKey]){
			pairByBaseName[baseNameKey] = {};
			baseNameOrder.push(baseNameKey);
		}
		if(isEnglish){
			pairByBaseName[baseNameKey].englishKey = sourceKeys[i];
		}else{
			pairByBaseName[baseNameKey].chineseKey = sourceKeys[i];
		}
	}

	for(var j = 0; j < baseNameOrder.length; j++){
		var attrPair = pairByBaseName[baseNameOrder[j]];
		if(attrPair.chineseKey){
			orderedKeys.push(attrPair.chineseKey);
		}
		if(attrPair.englishKey){
			orderedKeys.push(attrPair.englishKey);
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
		
		var htmls = "<td "+tdStyle+">"+attrDisplayName + ":</td><td>";
		if(ruleTypes.indexOf("DiscreteSetConstraint")>=0){				/* 合法值列表,枚举值列表约束,创建下拉列表 */
			htmls += "<select name='selectList' seq='"+seq+"' id='"+attrName+"' attrDataType='"+attrDataType+"' ";
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
			htmls += "<select name='selectList' seq='"+seq+"' id='"+attrName+"' attrDataType='"+attrDataType+"' ";
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
			htmls += "<input type='text' seq='"+seq+"' id='"+attrName+"' attrDataType='"+attrDataType+"' attrDefaultValue='"+attrDefaultValue+"' "; 
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
