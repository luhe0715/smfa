<%@page import="wt.folder.Folder"%>
<%@page import="com.ptc.netmarkets.model.NmOid"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ include file="/netmarkets/jsp/components/beginWizard.jspf"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>批量创建零部件</title>
</head>
<%
	String baseHref = new wt.httpgw.URLFactory().getBaseHREF();
	NmOid folderOid = commandBean.getPageOid();
%>
<style type="text/css">
	.formTable {
		margin-left: 10px;
		border-collapse: collapse;
		width: 98%;
	}
	.clsAttrTable {
		border:none;
	}
	.typeAttrTable {
		border:none;
	}

	table.formTable th{
		height:90px;
		text-align: center;
		vertical-align: middle;
		background-color: #dedede;
	}

	table.formTable td{
		height:90px;
		text-align: center;
		vertical-align: middle;
		background-color: #FFF8DC;
	}

	table.clsAttrTable td{
		height:28px;
		text-align: left;
		padding-left: 10px;
	}

	table.typeAttrTable td{
		height:28px;
		text-align: left;
		padding-left: 10px;
	}

	.seq{
		width: 25px;
	}

	.partName{
		width: 120px;
	}

	.classification{
		width: 180px;
	}

	.classificationAttr_td{
		/* 	width: 1100px; */
	}

	.clsAttrTable input,select{
		width: 100px;
	}

	/* 单一外观的可编辑下拉框：输入区和箭头位于同一个边框内。 */
	.materialCombobox{
		position: relative;
		display: inline-block;
		box-sizing: border-box;
		width: 100px;
		height: 21px;
		border: 1px solid #a9a9a9;
		background-color: #ffffff;
		vertical-align: middle;
	}

	.clsAttrTable .materialCombobox input{
		box-sizing: border-box;
		width: 100%;
		height: 100%;
		margin: 0;
		padding: 1px 20px 1px 3px;
		border: 0;
		outline: none;
		background-color: #ffffff;
	}

	.materialComboArrow{
		position: absolute;
		right: 0;
		top: 0;
		box-sizing: border-box;
		width: 18px;
		height: 19px;
		border-left: 1px solid #a9a9a9;
		background-color: #f3f3f3;
		color: #333333;
		font-size: 10px;
		line-height: 18px;
		text-align: center;
		cursor: pointer;
		user-select: none;
	}

	.materialComboDropdown{
		position: absolute;
		left: -1px;
		top: 20px;
		z-index: 10000;
		display: none;
		box-sizing: border-box;
		min-width: 100px;
		max-height: 180px;
		overflow-x: hidden;
		overflow-y: auto;
		border: 1px solid #a9a9a9;
		background-color: #ffffff;
		white-space: nowrap;
	}

	.materialComboOption{
		min-height: 20px;
		padding: 2px 5px;
		color: #000000;
		line-height: 20px;
		cursor: pointer;
	}

	.materialComboOption:hover{
		background-color: #1e6bd6;
		color: #ffffff;
	}

	.typeAttrTable input,select{
		width: 100px;
	}

	#toolbar_footer>input{
		margin-left: 10px;
		width: 70px; /* 宽度 */
		height: 30px; /* 高度 */
		border-width: 0px; /* 边框宽度 */
		border-radius: 3px; /* 边框半径 */
		background: #4682B4; /* 背景颜色 #A4A4A4*/
		cursor: pointer; /* 鼠标移入按钮范围时出现手势 */
		outline: none; /* 不显示轮廓线 */
		font-family: Microsoft YaHei; /* 设置字体 */
		color: white; /* 字体颜色 */
		font-size: 15px; /* 字体大小 */
	}
	[type=button]{
		margin-left: 10px;
	}

	[type=text]{
		width: 100px;
	}

	#toolbar_top{
		/*  	margin-left: 10px;  */
		/*   	text-align: right;  */
		/*   	vertical-align: middle; */
		/*   	float: right; */
		/* 修复按钮不靠边问题,未更新生产 */
	}

	#toolbar_footer{
		text-align: center;
		vertical-align: middle;
	}

	input[type=checkbox] {
		zoom: 180%;
	}

</style>
<body>
<div id="window_body">
	<div id="header">
		<br/>
	</div>
	<div id="main" >
		<div id="toolbar_top">
			<input type="button" value="帮助" onClick="helper();" />
		</div>
		<table id="formTable" class="formTable" border="1">
			<tr>
				<th>选择</th>
				<th>物料名称*</th>
				<th>类型选择</th>
				<th>类型属性</th>
				<th>分类选择*</th>
				<th>分类属性</th>
			</tr>
			<tr id="row1">
				<td class="seq"><input type="checkbox" id="seq1" name="seq" value="1" /></td>
				<td class="partName"><input type="text" id="partName1" name="partName1" required="required"/></td>
				<td class="classification">
					<input type="text" id="partSoftDisplayType1" name="partSoftDisplayType1" disabled="disabled" />
					<input type="hidden" id="partSoftType1" name="partSoftType1" />
					<input type="button" onClick="choosePartSoftType(1);" value="选择类型" />
				</td>
				<td class="classificationAttr_td"></td>
				<td class="classification">
					<input type="text" id="clsDisplayName1" name="clsDisplayName1" disabled="disabled" required="required" />
					<input type="hidden" id="clsName1" name="clsName1" />
					<input type="button" onClick="chooseClassification(1);" value="选择分类" />
				</td>
				<td class="classificationAttr_td"></td>
			</tr>
		</table>
		<div id="toolbar_footer" class="toolbar_footer">
			<input type="button" onClick="selectAll();" value="全选" />
			<input type="button" onClick="setAllPartSoftType();" value="选择类型" title="勾选任意列设置物料软类型" />
			<input type="button" onClick="setAllClassification();" value="选择分类" title="勾选任意列设置物料分类" />
			<input type="button" onClick="addRow(1);" value="添加行" />
			<input type="button" onClick="delRow();" value="删除行" title="勾选任意列删除"/>
			<input type="button" onClick="addRow(5);" value="添加5行" />
			<input type="button" onClick="resetRow();" value="清除内容" title="勾选任意列清除内容" />
			<input type="button" onClick="submitTable();" value="提交" />
		</div>
	</div>
</div>
</body>
<%
%>
<script type="text/javascript">
	var materialLinkageData = [];
	var materialClassificationDataName = "classification";
	var materialCategoryAttrName = "horn_MaterialCategories";
	var materialSubTypeAttrName = "horn_MaterialSubType";
	var materialColorDataName = "colorNumber";

	/* 页面进入时调用材质联动接口，并在当前页面缓存结果。 */
	function loadMaterialLinkageData(){
		try{
			var options = {
				asynchronous: false,
				parameters: {
					actionType : "getMaterialLinkageData"
				}
			};
			var url = "netmarkets/jsp/ext/gwc/part/createpart/ajaxHandler.jsp";
			var response = requestHandler.doRequest(url, options);
			var responseJson = JSON.parse(response.responseText);
			if(responseJson && responseJson.success && responseJson.data){
				materialLinkageData = responseJson.data;
			}else if(window.console && window.console.warn){
				window.console.warn("材质联动数据加载失败：" + (responseJson ? responseJson.message : "接口无返回"));
			}
		}catch(e){
			materialLinkageData = [];
			if(window.console && window.console.warn){
				window.console.warn("loadMaterialLinkageData: " + e);
			}
		}
	}

	function normalizeMaterialClassification(value){
		return String(value || "").replace(/^\s+|\s+$/g, "")
				.replace(/\s+/g, "").toLowerCase();
	}

	function addMaterialClassificationCandidate(values, valueMap, value){
		var rawValue = String(value || "").replace(/^\s+|\s+$/g, "");
		if(rawValue === ""){
			return;
		}
		var candidates = [rawValue];
		var codeMatches = rawValue.match(/[a-z]+\d{4}/ig);
		if(codeMatches){
			for(var codeIndex = 0; codeIndex < codeMatches.length; codeIndex++){
				candidates.push(codeMatches[codeIndex]);
			}
		}
		var displayNameWithoutCode = rawValue.replace(
				/^\s*[a-z]+\d{4}\s*[-_－—:：]?\s*/i, "");
		if(displayNameWithoutCode != rawValue){
			candidates.push(displayNameWithoutCode);
		}
		for(var i = 0; i < candidates.length; i++){
			var normalizedValue = normalizeMaterialClassification(candidates[i]);
			if(normalizedValue !== "" && !valueMap["$" + normalizedValue]){
				valueMap["$" + normalizedValue] = true;
				values.push(normalizedValue);
			}
		}
	}

	function getSelectedMaterialClassifications(seq){
		var values = [];
		var valueMap = {};
		var clsNameInput = document.getElementById("clsName" + seq);
		var clsDisplayNameInput = document.getElementById("clsDisplayName" + seq);
		addMaterialClassificationCandidate(values, valueMap,
				clsNameInput ? clsNameInput.value : "");
		addMaterialClassificationCandidate(values, valueMap,
				clsDisplayNameInput ? clsDisplayNameInput.value : "");
		return values;
	}

	function matchesMaterialClassification(itemClassification, classificationValues){
		var normalizedItemClassification = normalizeMaterialClassification(itemClassification);
		for(var i = 0; i < classificationValues.length; i++){
			if(classificationValues[i] == normalizedItemClassification){
				return true;
			}
		}
		return false;
	}

	function getUniqueMaterialValues(attrName, classificationValues, categoryValue, subTypeValue){
		var values = [];
		var valueMap = {};
		for(var i = 0; i < materialLinkageData.length; i++){
			var item = materialLinkageData[i];
			if(!matchesMaterialClassification(item[materialClassificationDataName], classificationValues)){
				continue;
			}
			if(categoryValue !== null && categoryValue !== undefined
					&& item[materialCategoryAttrName] != categoryValue){
				continue;
			}
			if(subTypeValue !== null && subTypeValue !== undefined
					&& item[materialSubTypeAttrName] != subTypeValue){
				continue;
			}
			var value = item[attrName];
			if(value !== null && value !== undefined && value !== "" && !valueMap[value]){
				valueMap[value] = true;
				values.push(value);
			}
		}
		return values;
	}

	function fillMaterialDropdown(dropdown, values){
		while(dropdown.firstChild){
			dropdown.removeChild(dropdown.firstChild);
		}
		for(var i = 0; i < values.length; i++){
			var option = document.createElement("div");
			option.className = "materialComboOption";
			option.setAttribute("data-value", values[i]);
			if(option.textContent !== undefined){
				option.textContent = values[i];
			}else{
				option.innerText = values[i];
			}
			option.onclick = function(event){
				if(dropdown.materialSelectHandler){
					dropdown.materialSelectHandler(this.getAttribute("data-value"));
				}
				event = event || window.event;
				if(event.stopPropagation){
					event.stopPropagation();
				}else{
					event.cancelBubble = true;
				}
			};
			dropdown.appendChild(option);
		}
	}

	function getMaterialAttrControl(attrTable, attrName){
		var controls = attrTable.querySelectorAll("[seq]");
		for(var i = 0; i < controls.length; i++){
			if(controls[i].getAttribute("id") == attrName){
				return controls[i];
			}
		}
		return null;
	}

	function getMaterialColorAttrControl(attrTable){
		var markedControl = attrTable.querySelector("[data-material-color-control='true']");
		if(markedControl){
			return markedControl;
		}
		var controls = attrTable.querySelectorAll("[seq]");
		for(var i = 0; i < controls.length; i++){
			var attrName = String(controls[i].getAttribute("id") || "");
			if(/_en$/i.test(attrName)){
				continue;
			}
			var normalizedName = attrName.replace(/[^a-z0-9]/gi, "").toLowerCase();
			if(normalizedName == "horncolornumber"
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
					|| normalizedName == "hornmaterialcolourcode"){
				return controls[i];
			}
		}
		return null;
	}

	function clearMaterialControl(control){
		if(control){
			control.value = "";
			control.setAttribute("attrDefaultValue", "");
		}
	}

	function copyMaterialControlAttributes(source, target){
		var attrsToCopy = ["id", "name", "seq", "attrDataType", "attrDefaultValue", "required", "unit",
				"data-material-color-control"];
		for(var i = 0; i < attrsToCopy.length; i++){
			var attrValue = source.getAttribute(attrsToCopy[i]);
			if(attrValue !== null){
				target.setAttribute(attrsToCopy[i], attrValue);
			}
		}
		target.className = source.className;
		target.style.cssText = source.style.cssText;
	}

	/* 将原属性控件增强为一个边框内同时支持输入和下拉选择的控件。 */
	function createMaterialCombobox(control){
		var input = control;
		var currentValue = control.value || "";
		if(control.tagName == "SELECT"){
			input = document.createElement("input");
			input.setAttribute("type", "text");
			copyMaterialControlAttributes(control, input);
			input.value = currentValue;
			control.parentNode.replaceChild(input, control);
		}
		input.setAttribute("autocomplete", "off");

		var wrapper = input.parentNode;
		var arrow = null;
		var dropdown = null;
		if(wrapper && wrapper.getAttribute
				&& wrapper.getAttribute("data-material-combobox") == "true"){
			arrow = wrapper.querySelector("[data-material-arrow='true']");
			dropdown = wrapper.querySelector("[data-material-dropdown='true']");
		}else{
			var parent = input.parentNode;
			wrapper = document.createElement("span");
			wrapper.className = "materialCombobox";
			wrapper.setAttribute("data-material-combobox", "true");
			parent.insertBefore(wrapper, input);
			wrapper.appendChild(input);

			arrow = document.createElement("span");
			arrow.className = "materialComboArrow";
			arrow.setAttribute("data-material-arrow", "true");
			arrow.setAttribute("tabindex", "0");
			arrow.innerHTML = "&#9662;";
			wrapper.appendChild(arrow);

			dropdown = document.createElement("div");
			dropdown.className = "materialComboDropdown";
			dropdown.setAttribute("data-material-dropdown", "true");
			wrapper.appendChild(dropdown);
		}
		return {wrapper: wrapper, input: input, arrow: arrow, dropdown: dropdown};
	}

	function getMaterialDropdown(input){
		var wrapper = input ? input.parentNode : null;
		if(!wrapper || !wrapper.querySelector){
			return null;
		}
		return wrapper.querySelector("[data-material-dropdown='true']");
	}

	function hideMaterialDropdowns(exceptDropdown){
		var dropdowns = document.querySelectorAll("[data-material-dropdown='true']");
		for(var i = 0; i < dropdowns.length; i++){
			if(dropdowns[i] != exceptDropdown){
				dropdowns[i].style.display = "none";
			}
		}
	}

	function refreshMaterialSubTypeOptions(seq){
		var attrTable = document.getElementById("clsAttrTable" + seq);
		if(!attrTable){
			return;
		}
		var categoryInput = getMaterialAttrControl(attrTable, materialCategoryAttrName);
		var subTypeInput = getMaterialAttrControl(attrTable, materialSubTypeAttrName);
		var subTypeDropdown = getMaterialDropdown(subTypeInput);
		if(!categoryInput || !subTypeInput || !subTypeDropdown){
			return;
		}
		var subTypes = [];
		if(categoryInput.value !== ""){
			subTypes = getUniqueMaterialValues(materialSubTypeAttrName,
					getSelectedMaterialClassifications(seq), categoryInput.value, null);
		}
		fillMaterialDropdown(subTypeDropdown, subTypes);
	}

	function refreshMaterialColorOptions(seq){
		var attrTable = document.getElementById("clsAttrTable" + seq);
		if(!attrTable){
			return;
		}
		var categoryInput = getMaterialAttrControl(attrTable, materialCategoryAttrName);
		var subTypeInput = getMaterialAttrControl(attrTable, materialSubTypeAttrName);
		var colorInput = getMaterialColorAttrControl(attrTable);
		var colorDropdown = getMaterialDropdown(colorInput);
		if(!categoryInput || !subTypeInput || !colorInput || !colorDropdown){
			return;
		}
		var colors = [];
		if(categoryInput.value !== "" && subTypeInput.value !== ""){
			colors = getUniqueMaterialValues(materialColorDataName,
					getSelectedMaterialClassifications(seq), categoryInput.value, subTypeInput.value);
		}
		fillMaterialDropdown(colorDropdown, colors);
	}

	function bindMaterialCombobox(widget, valueChanged){
		widget.dropdown.materialSelectHandler = function(value){
			widget.input.value = value;
			widget.input.setAttribute("attrDefaultValue", "");
			widget.dropdown.style.display = "none";
			if(valueChanged){
				valueChanged();
			}
			if(widget.input.focus){
				widget.input.focus();
			}
		};

		if(widget.input.getAttribute("materialValueBound") != "true"){
			var inputChanged = function(){
				widget.input.setAttribute("attrDefaultValue", "");
				if(valueChanged){
					valueChanged();
				}
			};
			if(widget.input.addEventListener){
				widget.input.addEventListener("input", inputChanged, false);
			}else if(widget.input.attachEvent){
				widget.input.attachEvent("onkeyup", inputChanged);
			}
			widget.input.setAttribute("materialValueBound", "true");
		}

		if(widget.arrow.getAttribute("materialDropdownBound") != "true"){
			var toggleDropdown = function(event){
				event = event || window.event;
				var willOpen = widget.dropdown.style.display != "block";
				hideMaterialDropdowns(willOpen ? widget.dropdown : null);
				widget.dropdown.style.display = willOpen && widget.dropdown.firstChild ? "block" : "none";
				if(event.stopPropagation){
					event.stopPropagation();
				}else{
					event.cancelBubble = true;
				}
			};
			var arrowKeydown = function(event){
				event = event || window.event;
				var keyCode = event.keyCode || event.which;
				if(keyCode == 13 || keyCode == 32 || keyCode == 40){
					toggleDropdown(event);
				}
			};
			if(widget.arrow.addEventListener){
				widget.arrow.addEventListener("click", toggleDropdown, false);
				widget.arrow.addEventListener("keydown", arrowKeydown, false);
			}else if(widget.arrow.attachEvent){
				widget.arrow.attachEvent("onclick", toggleDropdown);
				widget.arrow.attachEvent("onkeydown", arrowKeydown);
			}
			widget.arrow.setAttribute("materialDropdownBound", "true");
		}

		if(widget.wrapper.getAttribute("materialOutsideClickBound") != "true"){
			var hideOnOutsideClick = function(event){
				event = event || window.event;
				var target = event.target || event.srcElement;
				if(!widget.wrapper.contains(target)){
					widget.dropdown.style.display = "none";
				}
			};
			if(document.addEventListener){
				document.addEventListener("click", hideOnOutsideClick, false);
			}else if(document.attachEvent){
				document.attachEvent("onclick", hideOnOutsideClick);
			}
			widget.wrapper.setAttribute("materialOutsideClickBound", "true");
		}
	}

	/*
	 * 将材质大类、材质细分类型和色号增强为可输入、可下拉选择的组合框。
	 * 候选项按“当前分类 -> 材质大类 -> 材质细分类型 -> 色号”逐级过滤。
	 */
	function initializeMaterialComboboxes(seq){
		var attrTable = document.getElementById("clsAttrTable" + seq);
		if(!attrTable){
			return;
		}
		var categoryControl = getMaterialAttrControl(attrTable, materialCategoryAttrName);
		var subTypeControl = getMaterialAttrControl(attrTable, materialSubTypeAttrName);
		var colorControl = getMaterialColorAttrControl(attrTable);
		if(!categoryControl || !subTypeControl){
			return;
		}

		var categoryValue = categoryControl.value || "";
		var subTypeValue = subTypeControl.value || "";
		var colorValue = colorControl ? (colorControl.value || "") : "";
		var categoryWidget = createMaterialCombobox(categoryControl);
		var subTypeWidget = createMaterialCombobox(subTypeControl);
		var colorWidget = colorControl ? createMaterialCombobox(colorControl) : null;
		var categoryInput = categoryWidget.input;
		var subTypeInput = subTypeWidget.input;
		var colorInput = colorWidget ? colorWidget.input : null;

		categoryInput.value = categoryValue;
		subTypeInput.value = subTypeValue;
		if(colorInput){
			colorInput.value = colorValue;
		}
		fillMaterialDropdown(categoryWidget.dropdown,
				getUniqueMaterialValues(materialCategoryAttrName,
						getSelectedMaterialClassifications(seq), null, null));
		refreshMaterialSubTypeOptions(seq);
		refreshMaterialColorOptions(seq);

		if(colorWidget){
			bindMaterialCombobox(colorWidget, null);
		}
		bindMaterialCombobox(subTypeWidget, function(){
			var currentSeq = subTypeInput.getAttribute("seq");
			var currentTable = document.getElementById("clsAttrTable" + currentSeq);
			clearMaterialControl(currentTable ? getMaterialColorAttrControl(currentTable) : null);
			refreshMaterialColorOptions(currentSeq);
		});
		bindMaterialCombobox(categoryWidget, function(){
			var currentSeq = categoryInput.getAttribute("seq");
			var currentTable = document.getElementById("clsAttrTable" + currentSeq);
			var currentSubType = currentTable
					? getMaterialAttrControl(currentTable, materialSubTypeAttrName) : null;
			var currentColor = currentTable ? getMaterialColorAttrControl(currentTable) : null;
			/* 提交逻辑会在空值时回退默认值，因此变化时同步清空默认值。 */
			clearMaterialControl(currentSubType);
			clearMaterialControl(currentColor);
			refreshMaterialSubTypeOptions(currentSeq);
			refreshMaterialColorOptions(currentSeq);
		});
	}

	loadMaterialLinkageData();

	var x=screen.width+8;
	var y=screen.height+8-30;
	var xx=-4;
	var yy=-4;
	window.resizeTo(x,y);
	window.moveTo(xx,yy);

	var toolbar_top = document.getElementById("toolbar_top");
	var w = document.getElementById('formTable').offsetWidth;
	toolbar_top.style.width = (w)+"px";
	// toolbar_top.style.width = document.getElementById('formTable').style.width;

	/* 提交表格信息 */
	function submitTable(){
		var tableDatas = "";
		var folderOid = '<%=folderOid%>';

		var table = document.getElementById('formTable');
		var rowLength = table.rows.length;
		var checkboxes = document.querySelectorAll('input[type="checkbox"][name="seq"]');
		for (var k = 0; k < checkboxes.length; k++) {
			var i = checkboxes[k].value;
			var partName = document.getElementById('partName'+i).value;
			var clsName = document.getElementById('clsName'+i).value;
			var clsDisplayName = document.getElementById('clsDisplayName'+i).value;
			var partInfo = "{\"partName\":\""+partName+"\",\"clsName\":\""+clsName+"\",\"clsDisplayName\":\""+clsDisplayName+"\","
			if(""==partName ){
				alert("请填写物料名称!");
				return;
			}
			if(""==clsDisplayName){
				alert("请选中物料分类!");
				return;
			}
			//add begin
			var partSoftType = document.getElementById('partSoftType'+i).value;
			if(!partSoftType){
				partSoftType = "";
			}
			partInfo += "\"partSoftType\":\""+partSoftType+"\",";
			//add end
			var clsAttrs = document.querySelectorAll("#clsAttrTable"+i+" [seq]");
			var clsAttrsNumber = clsAttrs.length;
			for(var j=0; j<clsAttrsNumber; j++){
				var tagname = clsAttrs[j].tagName;

				var attrValue = "";
				var attrName = "";
				var attrDataType = "";
				var attrDefaultValue = "";
				if(tagname == 'INPUT'){
					var input = clsAttrs[j];
					var typename = input.type;
					if(typename == 'text'){
						attrValue = input.value;
						attrName = input.getAttribute("id");
						attrDataType = input.getAttribute("attrDataType");
						attrDefaultValue = input.getAttribute("attrDefaultValue");
						if(""==attrValue){
							attrValue = attrDefaultValue;
						}
					}
				}else if(tagname == 'SELECT'){
					var select = clsAttrs[j];
					var index = select.selectedIndex;
					attrValue = select.options[index].value;
					attrName = select.getAttribute("id");
					attrDataType = select.getAttribute("attrDataType");
					attrDefaultValue = select.getAttribute("attrDefaultValue");
					if(""==attrValue){
						attrValue = attrDefaultValue;
					}
				}
				if(!attrValue){
					attrValue="";
				}
				var required = clsAttrs[j].getAttribute("required");
				if("required"==required && ""==attrValue){
					alert("请将必填资料补充完整!");
					return;
				}

				partInfo += "\"clsAttr"+j+"\":[{\"attrValue\":\""+attrValue+"\",\"attrName\":\""+attrName+"\",\"attrDataType\":\""+attrDataType+"\"}],";
				//console.info(partInfo);
			}
			partInfo += "\"clsAttrsNumber\":\""+clsAttrsNumber+"\",";

			//add begin
			var typeAttrs = document.querySelectorAll("#typeAttrTable"+i+" [seq]");
			console.log(typeAttrs);
			var typeAttrsNumber = typeAttrs.length;
			for(var jj=0; jj<typeAttrsNumber; jj++){
				var tagname = typeAttrs[jj].tagName;

				var attrValue = "";
				var attrName = "";
				var attrDataType = "";
				var attrDefaultValue = "";
				if(tagname == 'INPUT'){
					var input = typeAttrs[jj];
					var typename = input.type;
					if(typename == 'text'){
						attrValue = input.value;
						attrName = input.getAttribute("id");
						attrDataType = input.getAttribute("attrDataType");
						attrDefaultValue = input.getAttribute("attrDefaultValue");
						if(""==attrValue){
							attrValue = attrDefaultValue;
						}
					}
				}else if(tagname == 'SELECT'){
					var select = typeAttrs[jj];
					var index = select.selectedIndex;
					attrValue = select.options[index].value;
					attrName = select.getAttribute("id");
					attrDataType = select.getAttribute("attrDataType");
					attrDefaultValue = select.getAttribute("attrDefaultValue");
					if(""==attrValue){
						attrValue = attrDefaultValue;
					}
				}
				var required = typeAttrs[jj].getAttribute("required");
				if("required"==required && ""==attrValue){
					alert("请将必填资料补充完整!");
					return;
				}

				partInfo += "\"typeAttr"+jj+"\":[{\"attrValue\":\""+attrValue+"\",\"attrName\":\""+attrName+"\",\"attrDataType\":\""+attrDataType+"\"}],";
				//console.info(partInfo);
			}
			partInfo += "\"typeAttrsNumber\":\""+typeAttrsNumber+"\"}";

			if(i<rowLength-1){
				partInfo += ",";
			}
			//add end

			tableDatas += partInfo;
		}
		//禁用按钮,防止重复点击
		var buttons = document.querySelectorAll("#toolbar_footer [type='button']");
		for(var b=0;b<buttons.length;b++){
			buttons[b].setAttribute('disabled','true');
			buttons[b].style.backgroundColor  = '#555555';
		}

		tableDatas = "["+tableDatas+"]";
		tableDatas = escapeBackslashes(tableDatas);
		//console.log(tableDatas);
		var options = {
			asynchronous: false,
			parameters: {
				actionType : "submitTable",
				tableDatas : tableDatas,
				folderOid : folderOid
			}
		};
		var url = "netmarkets/jsp/ext/gwc/part/createpart/ajaxHandler.jsp";
		var response = requestHandler.doRequest(url, options);
		var resText = response.responseText;

		if(resText.indexOf("success") >0){
			alert("创建成功!");
			location.reload();
			window.close();
		}else{
			alert(resText.trim());
			for(var b=0;b<buttons.length;b++){
				buttons[b].removeAttribute("disabled");
				buttons[b].style.backgroundColor = '#4682B4';
			}
		}
	}

	/* 设置勾选列的物料软类型 */
	function setAllPartSoftType (){
		var box_val = [];
		box_val = getCheckedRow();
		if(box_val.length == 0){
			alert("请勾选数据");
			return false;
		}
		seq = box_val+"";
		choosePartSoftType(seq);
	}

	/* 选择物料软类型 */
	function choosePartSoftType(seq){
		var clsName = "";
		var clsNameObj = document.getElementById("clsName" + seq);
		if(clsNameObj){
			clsName = clsNameObj.value;
		}
		window.open('netmarkets/jsp/ext/gwc/part/createpart/selectPartSoftType.jsp?seq='+seq + '&clsName='+clsName,'newwindow','height=600,width=550,top=80,left=350,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
	}

	/* 设置勾选列的物料分类 */
	function setAllClassification(){
		var box_val = [];
		box_val = getCheckedRow();//1,2,3
		if(box_val.length == 0){
			alert("请勾选数据");
			return false;
		}
		seq = box_val+"";
		chooseClassification(seq);
	}

	/* 选择物料分类 */
	function chooseClassification(seq){
		var partTypeObj = document.getElementById("partSoftDisplayType" + seq);
		if(partTypeObj){
			var partSoftDisplayType = partTypeObj.value;
			if(partSoftDisplayType == ""){
				alert("请先选择类型");
				return false;
			}
		}
		var partSoftType = "";
		var partSoftTypeObj = document.getElementById("partSoftType" + seq);
		if(partSoftTypeObj){
			partSoftType = partSoftTypeObj.value;
		}
		window.open('netmarkets/jsp/ext/gwc/part/createpart/selectClassification.jsp?seq='+seq + '&partSoftType=' + partSoftType,'newwindow','height=600,width=550,top=80,left=350,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
	}

	/* 增加行 */
	function addRow (rowAmount) {
		var table = document.getElementById('formTable');
		var colLength = table.rows[1].cells.length;		//第一行开始,而不是标题的第0行
		for(var s = 0; s < rowAmount; s++){
			var rowLength = table.rows.length;
			table.insertRow(rowLength);
			table.rows[rowLength].id = 'row'+rowLength;
			for(var i = 0; i < colLength; i++){
				table.rows[rowLength].insertCell(i);
				var cell = table.rows[rowLength].cells[i];
				if(i==0){
					cell.className = 'seq';
					cell.innerHTML="<input type='checkbox' id='seq"+rowLength+"' name='seq' value='"+rowLength+"' />";
				}else if(i==1){
					cell.className = 'partName';
					cell.innerHTML="<input type='text' id='partName"+rowLength+"' name='partName"+rowLength+"' required='required' />";
				}else if(i==2){
					cell.className = 'classification';
					cell.innerHTML="<input type='text' id='partSoftDisplayType"+rowLength+"' name='partSoftDisplayType"+rowLength+"' disabled='disabled' required='required' />"
							+"<input type='hidden' id='partSoftType"+rowLength+"' name='partSoftType"+rowLength+"' />"
							+"<input type='button' onClick='choosePartSoftType("+rowLength+");' value='选择类型' />";
				}else if(i==3){
					cell.className = 'classificationAttr_td';
				}else if(i==4){
					cell.className = 'classification';
					cell.innerHTML="<input type='text' id='clsDisplayName"+rowLength+"' name='clsDisplayName"+rowLength+"' disabled='disabled' required='required' />"
							+"<input type='hidden' id='clsName"+rowLength+"' name='clsName"+rowLength+"' />"
							+"<input type='button' onClick='chooseClassification("+rowLength+");' value='选择分类' />";
				}else if(i==5){
					cell.className = 'classificationAttr_td';
				}
			}
		}
	}

	/* 删除行 */
	function delRow() {
		//删除选中行
		var box_val = [];
		box_val = getCheckedRow();
		if(box_val.length == 0){
			alert("请勾选数据");
			return false;
		}
		var checkboxes = document.querySelectorAll('input[type="checkbox"][name="seq"]');
		if (checkboxes.length == 1 || checkboxes.length == box_val.length) {
			alert("需要保留一条数据不能被删除")
			return;
		}

		for(var i=box_val.length-1; i>=0; i--){				//一定要从后往前删
			var row = document.getElementById('row'+box_val[i]);
			//flashSeq(box_val[i]);
			row.remove();
		}

//从最后一行开始删除
//     var table = document.getElementById('formTable');
//     var rowLength = table.rows.length;
//     var row = document.getElementById('row'+(rowLength-1));
//     if(rowLength < 3){
// 		return;
// 	}
// 	row.remove();
	}

	/* 清除所选行内容 */
	function resetRow(){
		var box_val = [];
		box_val = getCheckedRow();
		if(box_val.length == 0){
			alert("请勾选数据");
			return false;
		}
		var table = document.getElementById('formTable');
		for(var i=0; i<box_val.length; i++){
			var partName = document.getElementById('partName'+box_val[i]);
			var clsDisplayName = document.getElementById('clsDisplayName'+box_val[i]);
			var clsName = document.getElementById('clsName'+box_val[i]);
			partName.value="";
			clsDisplayName.value="";
			clsName.value="";
			var typeDisplayName = document.getElementById("partSoftDisplayType" + box_val[i]);
			var typeName = document.getElementById("partSoftType" + box_val[i]);
			typeDisplayName.value = "";
			typeName.value = "";
			table.rows[box_val[i]].cells[3].innerHTML = "";
			table.rows[box_val[i]].cells[5].innerHTML = "";
		}
	}

	/* 获取勾选行 */
	function getCheckedRow(){
		var boxs = document.getElementsByName("seq");
		var box_val = [];
		for (i in boxs) {
			if (boxs[i].checked){
				box_val.push(boxs[i].value);
			}
		}
		return box_val;
	}

	/* 全选 */
	function selectAll(){
		var boxs = document.getElementsByName("seq");

		var box_val_selected = [];
		box_val_selected = getCheckedRow();
		if(box_val_selected.length == boxs.length){		//若已全选,则取消全选
			for (var i=0; i<boxs.length; i++) {
				boxs[i].checked = false;
			}
		}else{
			for (var i=0; i<boxs.length; i++) {
				boxs[i].checked = true;
			}
		}
	}

	/* 刷新全布局中,与序号有关的属性值*/
	function flashSeq(number){
		var num = parseInt(number);
		var formTable = document.getElementById('formTable');
		var formTableRows = formTable.rows;
		for(var r=(num+1); r<formTableRows.length; r++){
			var formTableRow = formTableRows[r];
			var changeNum = r-1;

			var seq = document.querySelector("[id=seq"+r+"]");
			seq.setAttribute("id","seq"+changeNum);
			seq.setAttribute("value",""+changeNum);

			var partName = document.querySelector("[name=partName"+r+"]");
			partName.setAttribute("id","partName"+changeNum);
			partName.setAttribute("name","partName"+changeNum);

			var clsDisplayName = document.querySelector("[name=clsDisplayName"+r+"]");
			clsDisplayName.setAttribute("id","clsDisplayName"+changeNum);
			clsDisplayName.setAttribute("name","clsDisplayName"+changeNum);

			var clsName = document.querySelector("[name=clsName"+r+"]");
			clsName.setAttribute("id","clsName"+changeNum);
			clsName.setAttribute("name","clsName"+changeNum);

			var chooseCls = document.querySelectorAll("#row"+r+" [value='选择分类']")[0];
			chooseCls.setAttribute("onClick","chooseClassification("+changeNum+");");


			var clsAttrTable = document.querySelector("[id=clsAttrTable"+r+"]");
			if(null != clsAttrTable || "undefined" == typeof(clsAttrTable)){
				//先确定已经生成了"分类属性表";
				var clsAttr = document.querySelectorAll("#clsAttrTable"+r+" [seq]");
				for(var i=0; i<clsAttr.length; i++){
					clsAttr[i].setAttribute("seq",""+changeNum);
				}

				//必需在clsAttr更改之后再进行更改
				clsAttrTable.setAttribute("id","clsAttrTable"+changeNum);
				initializeMaterialComboboxes(changeNum);
			}

			var partSoftType = document.querySelector("[name=partSoftType"+r+"]");
			partSoftType.setAttribute("id","partSoftType"+changeNum);
			partSoftType.setAttribute("name","partSoftType"+changeNum);

			var partSoftDisplayType = document.querySelector("[name=partSoftDisplayType"+r+"]");
			partSoftDisplayType.setAttribute("id","partSoftDisplayType"+changeNum);
			partSoftDisplayType.setAttribute("name","partSoftDisplayType"+changeNum);

			var chooseType = document.querySelectorAll("#row"+r+" [value='选择类型']")[0];
			chooseType.setAttribute("onClick","choosePartSoftType("+changeNum+");");

			formTableRow.setAttribute("id","row"+changeNum);
		}
	}

	/* 指引 */
	function helper(){
		alert("操作指引：\r"
				+"1. 选择表格中物料分类，属性字段加\"*\"为必填项；\r"
				+"2. 创建多个同类型物料，单击表格下方“添加行、多选和选择分类”进行批量创建；\r"
				+"3. 点击“提交”系统在当前文件夹自动生成临时料号，转正式料号需要启动工作流。");
	}

	/*变量值可能包含反斜杠（如用户输入），统一转义：*/
	function escapeBackslashes(str) {
		return str.replace(/\\/g, "\\\\");
	}

</script>

</html>
<%@ include file="/netmarkets/jsp/util/end.jspf"%>
