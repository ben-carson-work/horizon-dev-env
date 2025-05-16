<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePaymentSetup" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<div class="tab-toolbar">
  <% String clickNew = "asyncDialogEasy('payment/merchant_dialog', 'id=new')";%>
  <v:button caption="@Common.Search" fa="search" onclick="search()"/>
  <span class="divider"></span>
  <v:button caption="@Common.New" fa="plus" onclick="<%=clickNew%>"/>
	<span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.Merchants.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
  
  <v:pagebox gridId="merchant-grid"/>
</div>

<div class="tab-content">   
  <div class="profile-pic-div">
    <v:widget caption="@Common.Search">
      <v:widget-block>
        <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
      </v:widget-block>
    </v:widget>
    
    <v:widget caption="@Common.Status">
      <v:widget-block>
      <% for (LookupItem status : LkSN.MerchantStatus.getItems()) { %>
        <v:db-checkbox field="MerchantStatus" caption="<%=status.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(status.getCode())%>"/><br/>
      <% } %>
      </v:widget-block>
    </v:widget>
  </div>
  <div class="profile-cont-div">
    <v:async-grid id="merchant-grid" jsp="payment/merchant_grid.jsp" />
  </div>
</div>

<script>
$(document).ready(function() {
  $("#full-text-search").keypress(function(e) {
    if (e.keyCode == KEY_ENTER) {
      search();
      return false;
    }
  });
});

function search() {
  setGridUrlParam("#merchant-grid", "MerchantStatus", $("[name='MerchantStatus']").getCheckedValues());
  setGridUrlParam("#merchant-grid", "FullText", $("#full-text-search").val(), true);
}
</script>
