<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>

<script>
  function search() {
      setGridUrlParam("#ticket-grid", "TicketStatus", $("[name='Status']").getCheckedValues());
      changeGridPage("#ticket-grid", "first");
    }
</script>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" href="javascript:search()" />
  <v:pagebox gridId="ticket-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  <div class="profile-pic-div">
     <v:widget caption="@Common.Status">
        <v:widget-block>
          <v:db-checkbox field="Status" caption="@Lookup.TicketStatusGroup.Active" value="<%=LkSNTicketStatusGroup.Active.getCode()%>" checked="true"  /><br/>
          <v:db-checkbox field="Status" caption="@Lookup.TicketStatusGroup.Blocked" value="<%=LkSNTicketStatusGroup.Blocked.getCode()%>" checked="false"  /><br/>
          <v:db-checkbox field="Status" caption="@Lookup.TicketStatusGroup.Invalid" value="<%=LkSNTicketStatusGroup.Invalid.getCode()%>" checked="false"  />
        </v:widget-block>
     </v:widget>
  </div>
  <div class="profile-cont-div">
    <% String params = "AccountId=" + pageBase.getId() + "&TicketStatus=" + LkSNTicketStatusGroup.Active.getCode();%>
    <v:async-grid id="ticket-grid" jsp="portfolio/ticket_grid.jsp" params="<%=params%>"/>
  </div>
</div>

