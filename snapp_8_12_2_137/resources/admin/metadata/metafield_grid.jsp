<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.QryBO_MetaField.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>


<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_MetaField.class);
// Select
qdef.addSelect(
    Sel.IconName,
    Sel.MetaFieldId,
    Sel.MetaFieldCode,
    Sel.MetaFieldName,
    Sel.FieldType,
    Sel.FieldDataType,
    Sel.FieldDataFormat,
    Sel.FullTextIndex,
    Sel.UniqueIndex,
    Sel.Encrypted,
    Sel.Engravable,
    Sel.AutoPopulate,
    Sel.MetaFieldGroupId,
    Sel.MetaFieldGroupName);
//Where
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getParameter("FullText"));
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
//qdef.addSort(Sel.FieldType);
qdef.addSort(Sel.MetaFieldName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid id="metafield-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.MetaField%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="33%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="33%">
      <v:itl key="@Common.Type"/>
    </td>
    <td width="34%">
      <v:itl key="@Common.MetaFieldGroup"/><br/>
      <v:itl key="@Common.Options"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox name="MetaFieldId" dataset="ds" fieldname="MetaFieldId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <a href="javascript:asyncDialogEasy('metadata/metafield_dialog', 'id=<%=ds.getField(Sel.MetaFieldId).getHtmlString()%>')" class="list-title"><%=ds.getField(Sel.MetaFieldName).getHtmlString()%></a><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.MetaFieldCode).getHtmlString()%></span>
    </td>
    <td>
      <%
      LookupItem fieldType = LkSN.MetaFieldType.findItemByCode(ds.getField(Sel.FieldType)); 
      LookupItem fieldDataType = LkSN.MetaFieldDataType.findItemByCode(ds.getField(Sel.FieldDataType)); 
      LookupItem fieldDataFormat = LkSN.MetaFieldDataFormat.findItemByCode(ds.getField(Sel.FieldDataFormat));
      
      String sFieldType = (fieldType == null) ? "" : fieldType.getHtmlDescription(pageBase.getLang());
      String sFieldDataType = (fieldDataType == null) ? "" : fieldDataType.getHtmlDescription(pageBase.getLang());
      if (fieldDataFormat != null)
        sFieldDataType += " (" + fieldDataFormat.getHtmlDescription(pageBase.getLang()) + ")";
      %>
      <%=sFieldDataType%><br/>
      <span class="list-subtitle"><%=sFieldType%></span>
    </td>
    <td>
      <% if (ds.getField(Sel.MetaFieldGroupName).isNull()) { %>
        &mdash;<br/>
      <% } else { %>
        <a href="javascript:asyncDialogEasy('metadata/metafieldgroup_dialog', 'id=<%=ds.getField(Sel.MetaFieldGroupId).getHtmlString()%>')" class="list-title"><%=ds.getField(Sel.MetaFieldGroupName).getHtmlString()%></a><br/>
      <% } %>  
      <span class="list-subtitle">
      <%
      String[] options = new String[0];
      if (ds.getField(Sel.FullTextIndex).getBoolean())
        options = JvArray.add(pageBase.getLang().Common.FullTextIndex.getText(), options);
      if (ds.getField(Sel.UniqueIndex).getBoolean())
        options = JvArray.add(pageBase.getLang().Common.UniqueIndex.getText(), options);
      if (ds.getField(Sel.Encrypted).getBoolean())
        options = JvArray.add(pageBase.getLang().Common.Encrypted.getText(), options);
      if (ds.getField(Sel.Engravable).getBoolean())
        options = JvArray.add(pageBase.getLang().Common.MetaFieldEngravable.getText(), options);
      if (ds.getField(Sel.AutoPopulate).getBoolean())
        options = JvArray.add(pageBase.getLang().Common.MetaFieldAutoPopulate.getText(), options);
      %>
      <%=JvString.escapeHtml(JvArray.arrayToString(options, ", "))%>
      </span>
    </td>
  </v:grid-row>
</v:grid>
