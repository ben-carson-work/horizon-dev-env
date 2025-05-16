<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.cl.database.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pkg" class="com.vgs.snapp.dataobject.DOExtensionPackage" scope="request"/>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<div id="store-config">
<v:widget caption="Store settings">
  <v:widget-block>
    <v:form-field caption="@Common.DataSource">
  	  <snp:dyncombo field="DataSourceId" clazz="store-field" entityType="<%=LkSNEntityType.DataSource%>"/>
  	</v:form-field>
  	<v:form-field caption="Package directory" hint="Local folder where to search for published packages">
  	  <v:input-text field="PackageDirectory" clazz="store-field"/>
  	</v:form-field>
  	<v:form-field caption="Application directory" hint="Local folder where to search for published POSs/Boards">
  	  <v:input-text field="AppDirectory" clazz="store-field"/>
  	</v:form-field>
  	<v:form-field caption="WAR directory" hint="Local folder where to search for published WARs">
  	  <v:input-text field="WarDirectory" clazz="store-field"/>
  	</v:form-field>
  	<v:form-field caption="WAR puplic path" hint="Public path/domain for WAR downloads (ie: http://repository.vgs.com/install/)">
  	  <v:input-text field="WarPublicPath" clazz="store-field"/>
  	</v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Jira settings">
  <v:widget-block>
    <v:form-field caption="@Common.URL" hint="Jira Url (https://support.vgs.cloud)">
  	  <v:input-text field="JiraUrl" clazz="store-field"/>
	</v:form-field>
	<v:form-field caption="@Common.UserName">
	  <v:input-text field="JiraUser" clazz="store-field"/>
	</v:form-field>
	<v:form-field caption="@Product.Token">
	  <v:input-text field="JiraPassword" clazz="store-field"/>
	</v:form-field>
	<v:form-field caption="Project code">
	  <v:input-text field="JiraProjectCode" clazz="store-field"/>
	</v:form-field>
	<v:form-field caption="Project id">
	  <v:input-text field="JiraProjectId" clazz="store-field"/>
	</v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="SVN settings">
  <v:widget-block>
    <v:form-field caption="@Common.URL" hint="SVN Url (https://svn.vgs.cloud/svn/VGS)">
      <v:input-text field="SvnUrl" clazz="store-field"/>
    </v:form-field>
	  <v:form-field caption="@Common.UserName">
	    <v:input-text field="SvnUser" clazz="store-field"/>
	  </v:form-field>
	  <v:form-field caption="@Common.Password">
	    <v:input-text type="password" field="SvnPassword" clazz="store-field"/>
	  </v:form-field>
  </v:widget-block>
</v:widget>

<v:grid>
  <thead>
    <v:grid-title caption="Branches"/>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td width="20%">Label <v:hint-handle hint="ie: 8.11.1.X"/></td>
      <td width="80%">Path <v:hint-handle hint="ie: branches/SnApp 8.11.1"/></td>
    </tr>
  </thead>
  <tbody id="tbody-branch">
  </tbody>
  <tbody>
    <tr>
      <td colspan="100%">
        <v:button id="btn-add-branch" caption="@Common.Add"/>
        <v:button id="btn-del-branch" caption="@Common.Remove"/>
      </td>
    </tr>
  </tbody>
</v:grid>
</div>

<div id="store-templates" class="hidden">
  <v:grid>
    <tr class="tr-branch">
      <td><v:grid-checkbox/></td>
      <td><v:input-text field="BranchDesc" clazz="store-field" placeholder="8.11.1.X"/></td>
      <td><v:input-text field="BranchPath" clazz="store-field" placeholder="branches/SnApp 8.11.1"/></td>
    </tr>
  </v:grid>
</div>

<script>

$(document).ready(function() {
  var $cfg = $("#store-config");
  var doc = <%=pkg.ConfigDoc.getString()%> || {};
  $cfg.docToView({"doc":doc});
  $cfg.find("#tbody-branch").docToGrid({"doc":doc.BranchList, "template":$("#store-templates .tr-branch").clone()});
  
  $cfg.find("#btn-add-branch").click(_addBranch);
  $cfg.find("#btn-del-branch").click(_delBranch);
  
  function _addBranch() {
    $cfg.find("#tbody-branch").append($("#store-templates .tr-branch").clone());
  }
  
  function _delBranch() {
    $cfg.find("#tbody-branch .cblist:checked").closest("tr").remove();
  }
});

function getExtensionPackageConfigDoc() {
  var $cfg = $("#store-config");
  var doc = $cfg.find(".store-field").viewToDoc();
  doc.BranchList = $cfg.find(".tr-branch").gridToDoc({fieldSelector:".store-field"});
  return doc;
}

</script>