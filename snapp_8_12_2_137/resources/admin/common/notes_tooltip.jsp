<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>


<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<%
LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType"));
String entityId = pageBase.getParameter("EntityId"); 

FtList<DONote> list = new FtList<>(null, DONote.class);
int recordCount = pageBase.getBL(BLBO_Note.class).fillNoteList(list, entityId, 1, 1);
DONote note = list.getItem(0); 
%>

<style>
.note-tooltip-body {
  padding: 10px;
  margin-top: 10px;
  margin-bottom: 10px;
  border: 0px solid var(--border-color);
  border-width: 1px 0 1px 0;
}

.note-tooltip-buttons {
  text-align: center;
}
</style>

<div>
  <div>
    <snp:entity-link entityType="<%=LkSNEntityType.Person%>" entityId="<%=note.UserAccountId%>" entityTooltip="false"><%=note.UserAccountName.getHtmlString()%></snp:entity-link>
    <v:itl key="@Common.On" transform="lowercase"/>
    <snp:entity-link entityType="<%=LkSNEntityType.Workstation%>" entityId="<%=note.WorkstationId%>" entityTooltip="false"><%=note.WorkstationName.getHtmlString()%></snp:entity-link>
  </div>
  
  <div>
    <snp:datetime timestamp="<%=note.NoteDateTime%>" format="shortdatetime" timezone="local"/>
    &mdash;
    <v:itl key="@Common.LastNote"/>
  </div>
</div>

<div class="note-tooltip-body">
  <% if (note.NoteType.isLookup(LkSNNoteType.Highlighted)) { %>
    <i class="fa fa-exclamation-triangle"></i>
  <% } %>
  <%=note.Note.getHtmlString()%>
</div>

<div class="note-tooltip-buttons">
  <% String sOnClick = "asyncDialogEasy('common/notes_dialog', 'DisableTriggerNotification=true&id=" + entityId + "&EntityType=" + entityType.getCode() + "')"; %>
  <v:button caption="@Common.ShowAll" onclick="<%=sOnClick%>"/>
</div>