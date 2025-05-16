<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccessPointMultiEditDlg" scope="request"/>

<%
QueryDef qdefTag = new QueryDef(QryBO_Tag.class);
qdefTag.addSelect(QryBO_Tag.Sel.TagId, QryBO_Tag.Sel.TagName);
qdefTag.addFilter(QryBO_Tag.Fil.EntityType, LkSNEntityType.AccessPoint.getCode());
qdefTag.addSort(QryBO_Tag.Sel.TagName);
%>
<fieldset>
  <legend><v:itl key="@Category.Category"/></legend>
  <%
    request.setAttribute("dsCategory", pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.Workstation));
  %>
  <v:combobox idFieldName="CategoryId" captionFieldName="AshedCategoryName" lookupDataSetName="dsCategory" name="CategoryId"/>
</fieldset>

<fieldset>
	<legend><v:itl key="@AccessPoint.Controller"/></legend>
	<%
		QueryDef qdefWks = new QueryDef(QryBO_Workstation.class);
		// Select
		qdefWks.addSelect(QryBO_Workstation.Sel.WorkstationId);
		qdefWks.addSelect(QryBO_Workstation.Sel.WorkstationName);
		// Where
		qdefWks.addFilter(QryBO_Workstation.Fil.WorkstationType, LkSNWorkstationType.POS.getCode());
		qdefWks.addFilter(QryBO_Workstation.Fil.LicenseId, pageBase.getSession().getLicenseId());
		//Sort
		qdefWks.addSort(QryBO_Workstation.Sel.WorkstationName);
		
		// Exec
	  JvDataSet dsWks = pageBase.execQuery(qdefWks);
	%>
  <v:combobox idFieldName="WorkstationId" captionFieldName="WorkstationName" lookupDataSet="<%=dsWks%>" name="AptControllerWorkstationId"/>
  <br/>
  
  <label><input type="checkbox" name="RemoveControllerWks"><v:itl key="@Common.Remove"/></label>
</fieldset>

<fieldset>
  <legend><v:itl key="@AccessPoint.EntryControl"/></legend>
  <select name="AptEntryControl">
    <option/>
	  <% for (LookupItem status : LkSN.AccessPointControl.getItems()) { %>
	    <option value="<%=status.getCode()%>"><%=status.getDescription()%></option>
	  <% } %>
  </select>
</fieldset>

<fieldset>
  <legend><v:itl key="@AccessPoint.ExitControl"/></legend>
  <select name="AptExitControl">
    <option/>
    <% for (LookupItem status : LkSN.AccessPointControl.getItems()) { %>
      <option value="<%=status.getCode()%>"><%=status.getDescription()%></option>
    <% } %>
  </select>
</fieldset>

<fieldset>
  <legend><v:itl key="@AccessPoint.ReentryControl"/></legend>
  <select name="AptReentryControl">
    <option/>
    <% for (LookupItem status : LkSN.AccessPointReentryControl.getItems()) { %>
      <option value="<%=status.getCode()%>"><%=status.getDescription()%></option>
    <% } %>
  </select>
</fieldset>

<fieldset>
  <legend><v:itl key="@AccessPoint.CounterMode"/></legend>
  <select name="AptCounterMode">
    <option/>
    <% for (LookupItem status : LkSN.AccessPointCounterMode.getItems()) { %>
      <option value="<%=status.getCode()%>"><%=status.getDescription()%></option>
    <% } %>
  </select>
</fieldset>

<fieldset>
  <legend><v:itl key="@AccessPoint.DoubleReadDelay"/></legend>
  <input type="number" name="AptDoubleReadDelay">
</fieldset>

<fieldset>
  <legend><v:itl key="@Event.QueueControl"/></legend>
  <input type="checkbox" name="QueueControl">
</fieldset>

<fieldset>
  <legend><v:itl key="@Common.Tags"/></legend>
  <v:form-field id="AptTags" caption="" checkBoxField="Tags">
     <v:multibox field="AptTagIDs" lookupDataSet="<%=pageBase.execQuery(qdefTag)%>" idFieldName="TagId" captionFieldName="TagName"/>
       <div id="tag-operation-type-container">
         <label><input type="radio" name="TagOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
         <label><input type="radio" name="TagOperation" value="remove"><v:itl key="@Common.Remove"/></label>
       </div>
  </v:form-field>
</fieldset>

<style>
  fieldset select {
    width: 98%;
  }
</style>
