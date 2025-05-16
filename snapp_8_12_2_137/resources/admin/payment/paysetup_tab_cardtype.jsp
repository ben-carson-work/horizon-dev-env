<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePaymentSetup" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<div class="tab-toolbar">
  <% String hrefNew = "javascript:asyncDialogEasy('payment/cardtype_dialog', 'id=new')";%>
  <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>"/>
  <v:button caption="@Common.Delete" fa="trash" href="javascript:deleteCardTypes()"/>
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.CardType.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
  <v:pagebox gridId="cardtype-grid"/>
</div>
    
<v:last-error/>

<div class="tab-content">
  <v:async-grid id="cardtype-grid" jsp="payment/cardtype_grid.jsp" />
</div>

<script>
  function deleteCardTypes() {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteCardType",
        DeleteCardType: {
          CardTypeIDs: $("[name='CardTypeId']").getCheckedValues()
        }
      };
      
      vgsService("CardType", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.CardType.getCode()%>);      
      });
    });
  }
</script>
