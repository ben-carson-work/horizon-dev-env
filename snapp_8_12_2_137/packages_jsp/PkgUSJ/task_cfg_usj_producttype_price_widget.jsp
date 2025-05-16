<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>

<%
JvDocument cfg = (JvDocument)request.getAttribute("cfg");
request.setAttribute("cfgftp", cfg.getChildNode("FtpConfig"));
boolean canEdit = pageBase.getRights().SettingsCustomForms.getBoolean();
%>

<v:alert-box type="info"><%=pageBase.getLang().Task.ProductTypePriceExport_Description.getText()%></v:alert-box>
<v:widget caption="@Task.ProductTypePriceExportSettings">
  <v:widget-block>
    <v:form-field caption="@Task.ProductTypePriceExport_FileNamePrefix" mandatory="true" hint="@Task.ProductTypePriceExport_FileNamePrefix_Hint">
      <v:input-text field="cfg.FileNamePrefix"/>
    </v:form-field> 
    <v:form-field caption="@Task.DateInterval" mandatory="true" hint="@Task.ProductTypePriceExport_DateInterval_Hint">
      <v:input-text field="cfg.DateInterval" placeholder="1"/>
    </v:form-field>    
    <v:form-field caption="@Common.Tags" mandatory="true" hint="@Task.ProductTypePriceExport_Tag_Hint">
     <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
     <v:multibox field="cfg.TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" allowNull="false" />
    </v:form-field>
    <% JvDataSet dsMetaFields = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
    <v:form-field caption="@Common.MetaField" hint="@Task.ProductTypePriceExport_Metafield_Hint">
      <v:combobox field="cfg.MetaFieldId" lookupDataSet="<%=pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS()%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" allowNull="true"/>
    </v:form-field>   
  </v:widget-block>
</v:widget>

<v:widget caption="FTP Settings">
  <v:widget-block>
    <jsp:include page="/resources/admin/common/ftp_config_widget.jsp"></jsp:include>
  </v:widget-block>
</v:widget> 

<script>

function saveTaskConfig(reqDO) {
  var config = {
    FtpConfig: getFtpConfig(),
    FileNamePrefix: $("#cfg\\.FileNamePrefix").val(),
    DateInterval: $("#cfg\\.DateInterval").val(),
    TagIDs: $("#cfg\\.TagIDs").val(),
    MetaFieldId: $("#cfg\\.MetaFieldId").val(),
  };
  
  reqDO.TaskConfig = JSON.stringify(config);    
}
</script>