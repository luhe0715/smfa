<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/netmarkets/jsp/util/beginPopup.jspf"%>
<%@ taglib prefix="mvc" uri="http://www.ptc.com/windchill/taglib/mvc"%>
<%@taglib uri="http://www.ptc.com/windchill/taglib/wrappers" prefix="w"%>
<%@ taglib uri="http://www.ptc.com/windchill/taglib/picker" prefix="p"%>
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
//String clsName = request.getParameter("clsName");
%>

<div style="width: 550px; height: 550px; ">
	<br/>
	<br/>
	<div>
	<p:typePicker id="selectPartSoftType" label="选择部件类型 : "  mode="SEARCH" >
        <p:pickerParam name="seedType"   value="wt.part.WTPart" />
        <p:pickerParam name="type"    value="BOTH" />
        <p:pickerParam name="displayHierarchy"  value="false" />
        <p:pickerParam name="showRoot"   value="true" />
        <p:pickerParam name="showInstantiable"   value="true" />
     </p:typePicker>
	</div>
	
	<input type="button" name="selectOK" id="selectOK" class="formTableButton" onclick="selectItemsReturn();" value="确定"/>
</div>
<script type="text/javascript">

function selectItemsReturn(){
	var selectObj = document.getElementById("selectPartSoftType");
	var seq = '<%=seq%>';
	var seqs = [];
	var select_displayName ="";
	var select_name ="";
	if(selectObj){
 		select_name = selectObj.value;
 		if(select_name){
 		    if(selectObj.selectedIndex!==undefined){
                select_displayName = selectObj.options[selectObj.selectedIndex].text;
            }else{
 		        //解决只有部件一个大类时，点击确定页面报错问题，update by xzheng 20221216
                select_displayName=document.getElementsByName("createpart$selectPartSoftType$$___selectPartSoftType___textbox")[0].value;
            }
 		}
 		// alert("select_name="+select_name+",select_displayName="+select_displayName);
		if (seq.length > 1) {
			seqs = seq.split(",");
			for (var i = 0; i < seqs.length; i++) {
				var openerTypeDisplayName = window.opener.document.getElementById("partSoftDisplayType" + seqs[i]);
				var openerTypeName = window.opener.document.getElementById("partSoftType" + seqs[i]);
				openerTypeDisplayName.value = select_displayName;
				openerTypeName.value = select_name;
				setTypeAttrs(select_name, select_displayName);
			}
		} else {
			var openerTypeDisplayName = window.opener.document.getElementById("partSoftDisplayType" + seq);
			var openerTypeName = window.opener.document.getElementById("partSoftType" + seq);
            var typeValue = openerTypeName.value;
			openerTypeDisplayName.value = select_displayName;
			openerTypeName.value = select_name;
			setTypeAttrs(select_name, select_displayName);
            if(typeValue != "" && select_name != typeValue){
                var clsNameObj = window.opener.document.getElementById("clsName" + seq);
                var clsDisplayName = window.opener.document.getElementById('clsDisplayName'+seq);
                clsDisplayName.value="";
                clsNameObj.value="";
                var table = window.opener.document.getElementById('formTable');
                table.rows[seq].cells[5].innerHTML = "";
            }
		}
		
		
	}
	window.close();
}

/* 根据选择类型,在父页面中创建对应的属性元素 */
function setTypeAttrs(typeName, typeDisplayName){
	var options = {
		       asynchronous: false,
		       parameters: {
		    	   actionType : "getTypeAttrs",
		    	   typeName : typeName,
		    	   typeDisplayName : typeDisplayName,
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
    var cell = table.rows[index].cells[3];

	cell.innerHTML = "";							//每次先清空
	var innerHTML="<table class='typeAttrTable' id='typeAttrTable"+seq+"'><tr>";
	var tdNum=0;
	var keysArray = dataJson["attrNamesAry"];
	//console.log(keysArray);
	for(var a=0; a<keysArray.length; a++){ 
		var key = keysArray[a];
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
			    console.log(">>>>1");
			    console.log(attrArray[i]["ruleLegalValues"]);

				if(null != attrArray[i]["ruleLegalValues"] && "" != attrArray[i]["ruleLegalValues"] && attrArray[i]["ruleLegalValues"]!==undefined){
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
			}else if(attrDefaultValue && attrDefaultValue=="false"){
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
		if(tdNum%3 == 0){												//每五个属性,换行
			htmls += "</tr><tr>";
		}
		innerHTML += htmls;
		
	} 
	cell.innerHTML = innerHTML+"</tr></table>";
}
</script>

<%@ include file="/netmarkets/jsp/util/end.jspf"%>