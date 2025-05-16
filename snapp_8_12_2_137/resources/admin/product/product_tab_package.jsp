<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
boolean canEdit = pageBase.getRightCRUD().canUpdate();
String packageIndividualComponentsPriceMismatchMessage = pageBase.getBL(BLBO_Product.class).packageIndividualComponentsPriceMismatchMessage(product);
%>

<div class="tab-toolbar">
  <v:button id="btn-package-save" caption="@Common.Save" fa="save" enabled="<%=canEdit%>"/>
</div>

<div id="package-tab-content" class="tab-content">

  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Package.PackageType" hint="@Package.PackageType_Hint">
        <v:lk-combobox lookup="<%=LkSN.ProductPackageType%>" field="product.ProductPackageType" allowNull="false" enabled="<%=canEdit%>"/>
      </v:form-field>
      <div id="packagetype-itemized-flags">
	      <v:form-field caption="@Common.DynamicPricing" hint="@Package.PriceOnItemsHint">
	        <v:radio name="pricing-group-radio" value="1" caption="@Package.Package"/>&nbsp;
	        <v:radio name="pricing-group-radio" value="2" caption="@Package.IndividualComponents"/>
	      </v:form-field>
	      <v:form-field caption="@AccessPoint.Redemption">
	        <div><v:db-checkbox field="product.PackageRedeemPackage" caption="@Package.RedeemPackage" hint="@Package.RedeemPackageHint" value="true" enabled="<%=canEdit%>"/></div>
          <div data-visibilitycontroller="#product\.PackageRedeemPackage"><v:db-checkbox field="product.PackagePropagateUsagesOnItems" caption="@Package.PropagateUsagesOnItems" hint="@Package.PropagateUsagesOnItemsHint" value="true" enabled="<%=canEdit%>"/></div>
	      </v:form-field>
      </div>
    </v:widget-block>
  </v:widget>
  
  <v:widget clazz="package-producttype" caption="@Package.IndividualComponents">
    <% if (packageIndividualComponentsPriceMismatchMessage != null) { %>
      <div data-pricing><v:alert-box type="warning"><%=packageIndividualComponentsPriceMismatchMessage%></v:alert-box></div>
    <% } %>
    <v:widget-block>
      <v:grid id="package-producttype-grid">
        <thead>
          <tr class="header">
            <td><v:grid-checkbox header="true"/></td>
            <td width="30%">
              <v:itl key="@Common.Name"/><br/>
              <v:itl key="@Common.Code"/>
            </td>
            <td width="55%">
              <v:itl key="@Product.Attributes"/>         
            </td>
            <td width="10%" align="right">
              <div data-pricing><v:itl key="@Reservation.UnitAmount"/></div>         
            </td>
            <td width="5%" align="right">
              <v:itl key="@Common.Quantity"/>
            </td>
            <td>
            </td>
          </tr>
        </thead>
        <tbody id="individual-components-body">
        </tbody>
        <div data-pricing>
          <tbody data-pricing>
            <tr class='header'>
              <td/>
              <td></td>
              <td align="right">Total amount</td>
              <td align="right"><input type="text" class="form-control" style="text-align:right;" id="txt-pricevalue-total" disabled/></td>
              <td/>
              <td/>
            </tr>
          </tbody>
        </div>
      </v:grid>
    </v:widget-block>
    <% if (canEdit) { %>
      <v:widget-block>
        <v:button caption="@Common.Add" fa="plus" id="btn-add-product"/>
        <v:button caption="@Common.Remove" fa="minus" id="btn-remove-product"/>
      </v:widget-block>
    <% } %>
  </v:widget>

</div>

<div id="package-producttype-templates" class="hidden">
  <v:grid>
    <tr class="grid-row tr-producttype">
      <td><v:grid-checkbox header="false"></v:grid-checkbox></td>
      <td>
        <a class="product-name" target="_new"></a><br/>
        <span class="product-code"></span>
      </td>
      <td>
        <span class="optionset-desc"></span><br/>
        <a class="optionset-edit"></a>
      </td>
      <td>
        <div data-pricing>
          <input type="text" style="text-align:right;" class="txt-pricevalue form-control"/>
        </div>
      </td>
      <td align="right">
        <input type="text" style="text-align:right;" class="txt-quantity form-control"/>
      </td>
      <td>
        <span class="grid-move-handle row-hover-visible"></span>
      </td>
    </td>
    </tr>
  </v:grid>
</div>

<jsp:include page="product_tab_package_js.jsp"/>
