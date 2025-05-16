<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>

<%
JvDocument cfg = (JvDocument)request.getAttribute("cfg");
request.setAttribute("cfgftp", cfg.getChildNode("FtpConfig"));
%>

<jsp:include page="../csv_import_alert_box.jsp"/>
<v:widget caption="@Common.Parameters">
  <v:widget-block>
    <v:form-field caption="@Common.Status">
      <v:lk-combobox field="cfg.ProductStatus" lookup="<%=LkSN.ProductStatus%>" clazz="producttype-field"/>
    </v:form-field>
    <v:form-field caption="@Category.Category" id="DefaultCategoryId">
      <v:combobox field="cfg.CategoryId" lookupDataSet="<%=pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.ProductType)%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName" allowNull="true" clazz="producttype-field"/>
    </v:form-field>
    <v:form-field caption="@SaleChannel.SaleChannels">
      <v:multibox 
          field="cfg.SaleChannelIDs"
          lookupDataSet="<%=pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS((LookupItem)null)%>"
          idFieldName="SaleChannelId" 
          captionFieldName="SaleChannelName"
          clazz="producttype-field"/>
    </v:form-field>
    <v:form-field caption="@Performance.PerformanceTypes">
      <v:multibox 
          field="cfg.PerformanceTypeIDs"
          lookupDataSet="<%=pageBase.getBL(BLBO_PerformanceType.class).getDS(new String[0])%>"
          idFieldName="PerformanceTypeId" 
          captionFieldName="PerformanceTypeName"
          clazz="producttype-field"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="FTP Settings">
  <v:widget-block>
    <jsp:include page="/resources/admin/common/ftp_config_widget.jsp"></jsp:include>
    <v:form-field caption="Backup folder" hint="Directory where processed files will be moved to, a relative path to the folder where original file is or an absolute path ca be used">
  		<v:input-text field="cfg.BackupFolder"/>
  	</v:form-field>    
  </v:widget-block>
</v:widget>  
  
<script>
function saveTaskConfig(reqDO) {
  var config = {
    FtpConfig: getFtpConfig(),
    ProductStatus: $("#cfg\\.ProductStatus").val(),
    CategoryId: $("#cfg\\.CategoryId").val(),
	  SaleChannelIDs: $("#cfg\\.SaleChannelIDs").val(),
	  PerformanceTypeIDs: $("#cfg\\.PerformanceTypeIDs").val(),
    BackupFolder: $("#cfg\\.BackupFolder").val(),
  };
  
  reqDO.TaskConfig = JSON.stringify(config); 
}
</script>
