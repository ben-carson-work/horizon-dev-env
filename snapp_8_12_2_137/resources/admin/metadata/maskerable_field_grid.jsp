<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
DOMaskingConfig maskingConfig = pageBase.getBL(BLBO_Masking.class).loadMaskingData();
%>

<v:grid entityType="<%=LkSNEntityType.FieldMaskingRule%>">
  <v:grid-title caption="@Common.Fields"/>
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td align="right"></td>
    <td width="100%"><v:itl key="@Common.FieldName"/></td>
  </tr>
  <% String lastDocumentName = null; %>
  <%
  for (DOMaskingFieldConfig field : maskingConfig.MaskingFieldConfigList) {
  %>
    <%
    if (!JvString.isSameText(field.getDocumentName(), lastDocumentName)) {
    %>
      <%
      lastDocumentName = field.getDocumentName();
      %>
      <tr class="group" data-entitytype="" data-entityid="">
        <td colspan="100%">
           <%=field.getDocumentName()%>
        </td>
      </tr>
    <%
    }
    %>      
    <tr class="grid-row">
      <td><v:grid-checkbox name="FieldId" value="<%=field.FieldId.getHtmlString()%>"/></td>
      <td align="right"><v:grid-icon name="fa-ellipsis-h"/></td>
      <td>
        <div class="list-title">
          <a href="javascript:asyncDialogEasy('metadata/maskerable_field_dialog', 'fieldId=<%=field.FieldId.getHtmlString()%>')" class="list-title"><%=field.FieldName.getHtmlString()%></a>
        </div>
      </td>
    </tr>
  <% } %>

</v:grid>
