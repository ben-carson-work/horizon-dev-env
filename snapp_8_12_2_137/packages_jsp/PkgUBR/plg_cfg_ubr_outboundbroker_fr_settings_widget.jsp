<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<%
JvDocument settings = (JvDocument)request.getAttribute("settings"); 
%>

<v:widget caption="Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="HTTP Method" mandatory="true">
      <v:lk-combobox lookup="<%=LkSN.HTTPMethodType%>" field="settings.HTTPMethodType" allowNull="false"/>
    </v:form-field>
    <v:form-field caption="URL" hint="FR API end-point" mandatory="true">
      <v:input-text field="settings.URL" placeholder="Ex. http://127.0.0.1:8080/face/frobid"/><br/>
    </v:form-field>
    <v:form-field caption="Biz ID" hint="Value required by FR APIs" mandatory="true">
      <v:input-text field="settings.BizID"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Header parameters" icon="bkoact-info.png">  
  <div class="tab-content">
	  <v:grid id="header-key-value-grid" style="margin-bottom:10px">
	    <thead>
	      <tr>
	        <td><v:grid-checkbox header="true"/></td>
	        <td width="50%"><v:itl key="Key"/></td>
	        <td width="50%"><v:itl key="Value"/></td>             
	      </tr>
	    </thead>
	    <tbody id="header-key-value-body">
	    </tbody>
	    <tbody>
	      <tr>
	        <td colspan="100%">
	          <v:button fa="plus" caption="@Common.Add" onclick="addKeyValue(1)"/>
	          <v:button fa="minus" caption="@Common.Remove" onclick="removeKeyValue(1)"/>
	        </td>
	      </tr>
	    </tbody>
	  </v:grid>
  </div>


	<div id="key-value-template" class="v-hidden">
    <input type="text" class="form-control keyTemplate"/>
	  <input type="text" class="form-control valueTemplate"/>
	</div>
</v:widget>

<v:widget caption="Query parameters" icon="bkoact-info.png">  
  <div class="tab-content">
    <v:grid id="query-key-value-grid" style="margin-bottom:10px">
      <thead>
        <tr>
          <td><v:grid-checkbox header="true"/></td>
          <td width="50%"><v:itl key="Key"/></td>
          <td width="50%"><v:itl key="Value"/></td>             
        </tr>
      </thead>
      <tbody id="query-key-value-body">
      </tbody>
      <tbody>
        <tr>
          <td colspan="100%">
            <v:button fa="plus" caption="@Common.Add" onclick="addKeyValue(2)"/>
            <v:button fa="minus" caption="@Common.Remove" onclick="removeKeyValue(2)"/>
          </td>
        </tr>
      </tbody>
    </v:grid>
  </div>
</v:widget>

<script>

$(document).ready(function() {
  var settings = <%=settings.getJSONString()%>;
  
  if (settings.HeaderList != undefined) {
    for (var i=0; i<settings.HeaderList.length; i++) {
      var header = settings.HeaderList[i];
      addKeyValue(1, header.Key, header.Value);
    }
    for (var i=0; i<settings.QueryList.length; i++) {
      var query = settings.QueryList[i];
      addKeyValue(2, query.Key, query.Value);
    }
  }
});
	
function addKeyValue(type, key, value) {
	var tr;
	if (type == 1)
	  tr = $("<tr class='grid-row'/>").appendTo("#header-key-value-body");
	else
		tr = $("<tr class='grid-row'/>").appendTo("#query-key-value-body");

  var tdCB = $("<td/>").appendTo(tr);
  var tdKey = $("<td/>").appendTo(tr);
  var tdValue = $("<td/>").appendTo(tr);

  tdCB.append("<input type='checkbox' class='cblist'>");
    
  $("#key-value-template .keyTemplate").clone().appendTo(tdKey).val(key);
  $("#key-value-template .valueTemplate").clone().appendTo(tdValue).val(value);
}	

function removeKeyValue(type) {
	if (type == 1) {
	  if ($("#header-key-value-grid tbody .cblist:checked").length == 0)
	   showMessage(itl("@Common.NoElementWasSelected"));
	  else
	   $("#header-key-value-grid tbody .cblist:checked").closest("tr").remove();
	}
	else {
		if ($("#query-key-value-grid tbody .cblist:checked").length == 0)
	    showMessage(itl("@Common.NoElementWasSelected"));
	  else
	    $("#query-key-value-grid tbody .cblist:checked").closest("tr").remove();
	}
}  

function getPluginSettings() {
	var headerList = [];
	var queryList = [];

	var headers = $("#header-key-value-grid tbody#header-key-value-body tr");
	for (var i=0; i<headers.length; i++) {
		headerList.push({
	    "Key": $(headers[i]).find(".keyTemplate").val(),
		  "Value": $(headers[i]).find(".valueTemplate").val()
		});	
	}
	
	var queries = $("#query-key-value-grid tbody#query-key-value-body tr");
	for (var i=0; i<queries.length; i++) {
		queryList.push({
		  "Key": $(queries[i]).find(".keyTemplate").val(),
		  "Value": $(queries[i]).find(".valueTemplate").val()
		}); 
	}
	
  return {
	  HTTPMethodType: $("#settings\\.HTTPMethodType").val(),
	  URL: $("#settings\\.URL").val(),
	  BizID: $("#settings\\.BizID").val(),
	  HeaderList: headerList,
	  QueryList: queryList
  };
}

</script>