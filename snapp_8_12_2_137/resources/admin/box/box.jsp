<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageBox" scope="request"/>
<jsp:useBean id="box" class="com.vgs.snapp.dataobject.DOBox" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" id="main-tab-group" main="true">
    <v:tab-item caption="@Box.Deposits" icon="deposit.png" jsp="box_tab_main.jsp" tab="main" default="true"/>
    <v:tab-item caption="@Common.Transactions" icon="transaction.png" jsp="box_tab_transaction.jsp" tab="transaction"/>
    <v:tab-item caption="@Box.TotalCollected" icon="pay_cash.png" jsp="box_tab_collected.jsp" tab="collected"/>
    <v:tab-item caption="@Box.EstimatedContent" icon="pay_cash.png" jsp="box_tab_content.jsp" tab="content"/>
    <v:tab-item caption="@Box.CashierResponsibility" icon="pay_cash.png" jsp="box_tab_responsibility.jsp" tab="responsibility"/>
    
    <%-- LOG --%>
    <% if (box.LogCount.getInt() > 0) { %>
      <v:tab-item caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" jsp="../common/page_tab_logs.jsp" tab="log"/>
    <% } %>

    <%-- ADD --%>
    <% if (!pageBase.isNewItem()) { %>
      <v:tab-plus>
			  <%-- RECALC --%>
			  <v:popup-item caption="@Box.RecalcContent" fa="sync-alt" href="javascript:doRecalcBoxContent()"/>
			  <%-- NOTES --%>
			  <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Box.getCode() + "');"; %>
			  <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
      </v:tab-plus>
    <% } %>
  </v:tab-group>
</div>


<script>
  function doRecalcBoxContent() {
    confirmDialog(null, function() {
      showWaitGlass();
      var reqDO = {
        Command: "RecalcBoxContent",
        RecalcBoxContent: {
          BoxId: <%=JvString.jsString(pageBase.getId())%>
        }
      };
      
      vgsService("BOX", reqDO, false, function(ansDO) {
        window.location.reload();
      });
    });
  }
</script>


<jsp:include page="/resources/common/footer.jsp"/>
