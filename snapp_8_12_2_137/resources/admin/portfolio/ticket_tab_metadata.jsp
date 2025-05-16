<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>
<jsp:useBean id="ticket" class="com.vgs.snapp.dataobject.DOTicket" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="ticketRights" class="com.vgs.snapp.dataobject.ticket.DOTicketRights" scope="request"/>

<% 
boolean canEdit = ticketRights.MetaDataEdit.getBoolean();
String sMaskIDs = JvArray.arrayToString(ticket.MaskList.mapStrings(it -> it.MaskId.getString()), ",");
String params = "&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Ticket.getCode() + "&MaskIDs=" + sMaskIDs + "&FlatMetaData=" + ticket.MaskList.isEmpty() + "&readOnly=" + !canEdit;
%>

<v:page-form id="ticket-mask-form" trackChanges="true">

  <v:tab-toolbar include="<%=canEdit%>">
    <v:button id="btn-ticket-save-metadata" caption="@Common.Save" fa="save" enabled="<%=canEdit%>"/>
  </v:tab-toolbar>
  
  <v:tab-content>
    <div id="maskedit-container"></div>
  </v:tab-content>

</v:page-form>

<script>
var metaFields = <%=pageBase.getBL(BLBO_MetaData.class).encodeItems(ticket.MetaDataList)%>;

$(document).ready(function() {
  $("#btn-ticket-save-metadata").click(_save);
  asyncLoad("#maskedit-container", addTrailingSlash(BASE_URL) + "admin?page=maskedit_widget<%=params%>");

  function _save() {
    var entityType = <%=LkSNEntityType.Ticket.getCode()%>;
    var entityId = <%=ticket.TicketId.getJsString()%>;
    
    snpAPI.cmd("MetaData", "SaveMetaData", {
      "EntityType": entityType,
      "EntityId": entityId,
      "MetaDataList": prepareMetaDataArray("#ticket-mask-form")      
    }).then(ansDO => entitySaveNotification(entityType, entityId, "tab=metadata"));
  }
});
</script>
