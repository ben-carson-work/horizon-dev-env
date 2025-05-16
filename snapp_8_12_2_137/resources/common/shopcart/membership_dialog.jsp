<%@page import="com.vgs.snapp.api.product.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String paymentMethodId = pageBase.getNullParameter("PaymentMethodId"); 
String sChargeAmount = pageBase.getNullParameter("ChargeAmount");

APIDef_Product_Search.DORequest reqDO = new APIDef_Product_Search.DORequest();
reqDO.ProductTypes.setLkArray(LkSNProductType.Membership);
reqDO.ProductStatus.setLkArray(LkSNProductStatus.OnSale, LkSNProductStatus.OnSale_Online);
reqDO.MembershipPaymentMethodId.setString(paymentMethodId);

APIDef_Product_Search.DOResponse ansDO = new APIDef_Product_Search.DOResponse();
pageBase.getBL(API_Product_Search.class).execute(reqDO, ansDO);
List<DOProductRef> listPlan = ansDO.ProductList.getItems();

%>

<v:dialog id="folio_dialog" title="@Account.SelectFolioActionTitle" width="900" height="700" resizable="false">

  <div class="body-block">
    <div class="form-toolbar">
      <v:button id="btn-search" fa="magnifying-glass" caption="@Common.Search"/>
    </div>
  
    <v:profile-recap>
      <v:widget>
        <v:widget-block>
          <v:input-text field="txtSearchText" placeholder="@Common.FullSearch"/>
        </v:widget-block>
      </v:widget>

      <v:widget caption="@Product.MembershipPlan">
        <v:widget-block>
          <% 
          boolean first = true; 
          for (DOProductRef plan : listPlan) { 
            %><div><v:radio name="radioHotel" value="<%=plan.ProductId.getHtmlString()%>" caption="<%=plan.ProductName.getHtmlString()%>" checked="<%=first%>"/></div><%
            first = false;
          } 
          %>
        </v:widget-block>
      </v:widget>
    </v:profile-recap>	  

    <v:profile-main>
      <v:async-grid id="folio-grid" jsp="../common/shopcart/membershipcard_grid.jsp" autoload="false"></v:async-grid>
    </v:profile-main>    


	</div>
  
  <div class="toolbar-block">
    <div id="btn-folio-back" class="v-button btn-float-right hl-green"><v:itl key="@Common.Back"/></div>
  </div>

  <script>
    $(document).ready(function() {
      var $dlg = $("#folio_dialog");
      var $btnSearch = $dlg.find("#btn-search");
      var $txtSearchText = $dlg.find("#txtSearchText");
      
      $txtSearchText.focus();
      $txtSearchText.keypress(_searchOnEnter);
      $btnSearch.click(_search);
      
      $dlg.find("#btn-folio-back").click(doCloseDialog);
      
      $(document).von($dlg, "folio-pickup", function() {
        $dlg.dialog("close");
      });
      
      function _searchOnEnter() {
        if (event.keyCode == KEY_ENTER) 
          _search();
      }
      
      function _search() {
        var $radioHotel = $dlg.find("[name='radioHotel']:checked");
        setGridUrlParam("#folio-grid", "ChargeAmount", <%=sChargeAmount%>);
        setGridUrlParam("#folio-grid", "MembershipPlanId", $radioHotel.val());
        setGridUrlParam("#folio-grid", "SearchText", $txtSearchText.val(), true);
      }
    });
  </script>

</v:dialog>