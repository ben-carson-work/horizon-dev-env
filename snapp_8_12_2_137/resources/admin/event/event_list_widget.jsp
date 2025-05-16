<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEventList" scope="request"/>

<v:page-form>
<input type="hidden" id="CategoryId" name="CategoryId" value="<%=pageBase.getEmptyParameter("CategoryId")%>"/>

<div class="tab-toolbar">
  <% String hrefNewEvent = ConfigTag.getValue("site_url") + "/admin?page=event&id=new&AccountId=" + pageBase.getParameter("AccountId"); %>
  <v:button caption="@Common.New" title="@Event.NewEventHint" fa="plus" href="<%=hrefNewEvent%>"/>
  <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="postaction:delete:confirm"/>
  <v:pagebox gridId="event-grid"/>
</div>
    
<div class="tab-content">
  <v:last-error/>
  
  <% String params = "AccountId=" + pageBase.getParameter("AccountId"); %>
  <v:async-grid id="event-grid" jsp="event/event_grid.jsp" params="<%=params%>"/>
</div>

</v:page-form>
