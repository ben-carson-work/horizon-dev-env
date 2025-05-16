<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSale" scope="request"/>
<jsp:useBean id="sale" class="com.vgs.snapp.dataobject.transaction.DOSale" scope="request"/>
<jsp:useBean id="rightCRUD" class="com.vgs.snapp.library.FtCRUD" scope="request"/>

<% 
boolean canEdit = rightCRUD.canUpdate(); 

String params = "&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Sale.getCode() + "&readonly=" + !canEdit;
if (sale.SaleSurveyMaskIDs.isEmpty())
  params += "&FlatMetaData=true";
%>

<v:page-form id="sale-mask-form" trackChanges="true">

<v:tab-toolbar>
  <v:button id="btn-save" caption="@Common.Save" fa="save" enabled="<%=canEdit%>"/>
</v:tab-toolbar>

<v:tab-content>
  <v:last-error/>

  <div id="maskedit-container"></div>
</v:tab-content>

<script>

var metaFields = <%=pageBase.getBL(BLBO_MetaData.class).encodeItems(sale.MetaDataList)%>;
asyncLoad("#maskedit-container", "<%=pageBase.getContextURL()%>?page=maskedit_widget<%=params%>");

</script>

</v:page-form>

<script>
$(document).ready(function() {
  $("#sale-mask-form #btn-save").click(_save);
  
  function _save() {
    var entityType = <%=LkSNEntityType.Sale.getCode()%>;
    var entityId = <%=sale.SaleId.getJsString()%>;
    
    snpAPI.cmd("MetaData", "SaveMetaData", {
      "EntityType": entityType,
      "EntityId": entityId,
      "MetaDataList": prepareMetaDataArray("#sale-mask-form")      
    }).then(ansDO => entitySaveNotification(entityType, entityId, "tab=metadata"))
  }
});
</script>