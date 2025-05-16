<%@page import="com.vgs.snapp.api.membership.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Ticket.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"
  errorPage="/resources/common/error/grid_error.jspf"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<%@ taglib uri="snp-tags" prefix="snp"%>

<jsp:useBean id="pageBase"
  class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request" />


<%
APIDef_Membership_Search.DORequest reqDO = new APIDef_Membership_Search.DORequest();
reqDO.MembershipPlan.ProductId.setString(pageBase.getNullParameter("MembershipPlanId"));
reqDO.Details.SearchText.setString(pageBase.getNullParameter("SearchText"));
reqDO.Details.ChargeAmount.setString(pageBase.getNullParameter("ChargeAmount"));

APIDef_Membership_Search.DOResponse ansDO = new APIDef_Membership_Search.DOResponse();
pageBase.getBL(API_Membership_Search.class).execute(reqDO, ansDO);
%>

<v:grid>
  <thead>
    <tr>
      <td width="50%" nowrap>
        <div>
          <v:itl key="@Payment.GuestName" />
        </div>
        <div>
          <v:itl key="@Payment.RoomNumber" />
        </div>
      </td>
      <td width="50%"></td>
    </tr>
  </thead>
  <tbody id="tbody-folio">
  </tbody>
</v:grid>

<div id="folio-grid-templates" class="hidden">
  <table>
    <tr class="folio-row-template grid-row">
      <td class="folio-status">
        <div class="list-title folio-guest"></div>
        <div class="list-subtitle folio-room"></div>
      </td>
      <td>
        <div class="list-subtitle folio-warn"></div>
      </td>
    </tr>

    <tr class="folio-empty-template grid-row">
      <td colspan="100%">0 <v:itl key="@Common.ResultsFound"/></td>
    </tr>
  </table>
</div>

<script>
$(document).ready(function() {
  <% if (ansDO.MembershipCardList.isEmpty()) { %>
    $tr = $("#folio-grid-templates .folio-empty-template").clone().appendTo("#tbody-folio");
  <% } else { %>
    <%for (DOMembershipCard folioDO : ansDO.MembershipCardList) {%>
      _addFolio(<%=folioDO.getJSONString()%>);
    <%}%>
  <% } %>
  
  
  function _addFolio(folio) {
    var $tr = $("#folio-grid-templates .folio-row-template").clone().appendTo("#tbody-folio");
    $tr.data(folio);
    $tr.find(".folio-status").setCommonStatusStyle(folio.CommonStatusColor);
    $tr.find(".folio-room").text(folio.MembershipCardCodeDisplay);
    $tr.find(".folio-warn").text(folio.WarnMessage);
    
    var $guest = $tr.find(".folio-guest");
    if (folio.CommonStatus == 20/*active*/)
      $guest = $("<a></a>").appendTo($guest);
    $guest.text(folio.CardHolderName);
    
    
    $tr.find("a").click(function() {
      $(document).trigger("folio-pickup", $tr.data());
    });
  }
});
</script>
