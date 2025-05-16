<%@page import="com.vgs.snapp.dataobject.DOProduct.DOProductPrice"%>
<%@page import="com.vgs.web.library.product.BLBO_ProductSuspend"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
String[] parentIDs = EntityTree.getIDs(pageBase.getConnector(), LkSNEntityType.ProductType, pageBase.getId());
JvDataSet dsPerfTypeAll = pageBase.getBL(BLBO_PerformanceType.class).getDS(parentIDs);
JvDataSet dsSaleChannelAll = pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS((LookupItem)null);
JvDataSet dsRateCodeAll = pageBase.getBL(BLBO_RateCode.class).getDS();
JvDataSet dsMembershipPointAll = pageBase.getBL(BLBO_RewardPoint.class).getRewardPointDS();
JvDataSet dsTaxProfile = pageBase.getBL(BLBO_Tax.class).getTaxProfileDS();

request.setAttribute("dsPerfTypeAll", dsPerfTypeAll);
request.setAttribute("dsSaleChannelAll", dsSaleChannelAll);
request.setAttribute("dsRateCodeAll", dsRateCodeAll);
request.setAttribute("dsMembershipPointAll", dsMembershipPointAll);
request.setAttribute("dsTaxProfile", dsTaxProfile);


boolean canEdit = pageBase.getRightCRUD().canUpdate(); 
String sReadOnly = canEdit ? "" : "readonly=\"readonly\""; 
String sDisabled = canEdit ? "" : "disabled=\"disabled\"";

String packageIndividualComponentsPriceMismatchMessage = pageBase.getBL(BLBO_Product.class).packageIndividualComponentsPriceMismatchMessage(product);

LookupItem prodStatus = pageBase.getBL(BLBO_Product.class).findProductStatus(pageBase.getId());
boolean validPriceConfSIAE = pageBase.getBL(BLBO_Siae.class).checkPriceConfAgainstTipoTitolo(pageBase.getId(), prodStatus, false);
boolean fairPresale = pageBase.getBL(BLBO_Siae.class).isPresaleFair(pageBase.getId());
boolean isSiaeProduct = pageBase.getBL(BLBO_Siae.class).isSiaeProduct(pageBase.getId());
boolean isPriceTrifling = pageBase.getBL(BLBO_Siae.class).isPriceTrifling(pageBase.getId());
boolean showI1PriceWarning = pageBase.getBL(BLBO_Siae.class).showProductPriceEqualToI1Warning(pageBase.getId());
%>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" href="javascript:doSave()" enabled="<%=canEdit%>"/>
</div>

<%if (!validPriceConfSIAE) {%>
  <div id="main-system-error" class="errorbox">SIAE - Configurazione del prezzo e/o prevendita non compatibile con il tipo titolo assegnato. Il prodotto non è vendibile (bozza)</div>
<%}; %>

<%if (showI1PriceWarning) {%>
  <div id="main-system-error" class="errorbox">SIAE - Il prezzo è uguale a quello del prodotto I1 di riferimento</div>
<%}; %>


<%if (!fairPresale) {%>
  <div id="main-system-error" class="errorbox">SIAE - Il valore della prevendita è uguale o superiore al prezzo del prodotto</div>
<%}; %>  

<%if (isPriceTrifling) {%>
  <div id="main-system-error" class="errorbox">SIAE - Il prezzo configurato è irrisorio</div>
<%}; %>  

<v:tab-content style="min-height:300px; overflow:hidden">

<v:profile-recap id="price-params">
  <v:widget caption="@Product.Taxes">
    <v:widget-block>
      <% for (LookupItem item : LkSN.TaxCalcType.getItems()) { %>
        <% String checked = product.TaxCalcType.isLookup(item) ? "checked='checked'" : ""; %>
        <label class="checkbox-label"><input type="radio" name="TaxCalcType" value="<%=item.getCode()%>" <%=checked%> <%=sDisabled%>/> <%=item.getHtmlDescription(pageBase.getLang())%></label><br/>
      <% } %>
    </v:widget-block>
    <v:widget-block clazz="tax-list">
      <v:itl key="@Product.TaxProfile"/><br/>
      <v:combobox field="product.TaxProfileId" lookupDataSetName="dsTaxProfile" idFieldName="TaxProfileId" captionFieldName="TaxProfileName" linkEntityType="<%=LkSNEntityType.TaxProfile.getCode()%>"/>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox caption="@Product.ApplyTaxOnFacePrice" hint="@Product.ApplyTaxOnFacePriceHint" value="true" field="product.ApplyTaxOnFacePrice"/><br/>
    </v:widget-block>
    <%if (!isSiaeProduct) {%>
        <v:widget-block>
          <v:multi-col style="margin: 0px" caption="@Product.TaxablePrice" hint="@Product.TaxablePriceHint">
            <input type="text" name="TaxablePrice" class="form-control" placeholder="100%" <%=sReadOnly%>/>
          </v:multi-col>
        </v:widget-block>
    <%}%>
  </v:widget>
  
  <v:widget id="price-options-widget" caption="@Common.Options">
    <v:widget-block>
      <v:db-checkbox caption="@Product.VariablePrice" value="true" field="product.VariablePrice"/><br/>
      <v:db-checkbox caption="@Product.ChargeToWallet" value="true" field="product.ChargeToWallet"/><br/>
      <v:itl key="@Product.PosPricingPlugin"/><br/>
      <v:combobox field="product.PosPricingPluginId" lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.ProdPricingPos)%>" captionFieldName="PluginDisplayName" idFieldName="PluginId" linkEntityType="<%=LkSNEntityType.Plugin%>" enabled="<%=canEdit%>"/>
    </v:widget-block>
    <v:widget-block>
      <v:itl key="@Product.PriceGroup"/> <v:hint-handle hint="@Product.PriceGroupHint"/><br/>
      <snp:dyncombo field="product.PriceGroupTagId" entityType="<%=LkSNEntityType.PriceGroup%>" enabled="<%=canEdit%>"/>
    </v:widget-block>
    <v:widget-block>
      <v:itl key="@Product.MinPrice"/><br/>
      <v:input-text field="product.VariablePriceMin" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
      <br/>
      <v:itl key="@Product.MaxPrice"/><br/>
      <v:input-text field="product.VariablePriceMax" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
    </v:widget-block>
    <v:widget-block>
      <v:itl key="@Product.ClearingLimitPerc"/><br/>
      <input type="text" name="ClearingLimitPerc" class="form-control" placeholder="100%" <%=sReadOnly%>/>
      <v:db-checkbox caption="@Product.IncludeBearedDiscounts" hint="@Product.IncludeBearedDiscountsHint" value="true" field="product.ClearingLimitIncludeBearedDisc"/><br/>
      <v:db-checkbox caption="@Product.IncludeBearedTaxes" hint="@Product.IncludeBearedTaxesHint" value="true" field="product.ClearingLimitIncludeBearedTaxes"/><br/>
    </v:widget-block>
    
    <%if (!product.ProductType.isLookup(LkSNProductType.Presale)) {%>
      <v:widget-block>
        <v:itl key="@Product.PresaleValue"/><br/>
        <v:input-text type="text" field="product.PresaleValue" enabled="<%=canEdit%>" required="true"/>
        <v:itl key="@Product.PresaleFee"/><br/>
        <v:combobox 
          field="product.PresaleProductId" 
          lookupDataSet="<%=pageBase.getBL(BLBO_Product.class).getPresaleProductsDS()%>" 
          idFieldName="ProductId" 
          captionFieldName="ProductName"
          linkEntityType="<%=LkSNEntityType.ProductType%>" 
          enabled="<%=canEdit%>"/>
      </v:widget-block>
    <%}%>
    
    <v:widget-block id="fee-perc-block">
      <v:db-checkbox caption="@Product.FeeTransactionPerc" hint="@Product.FeeTransactionPercHint" value="true" field="product.FeeTransactionPercentage" enabled="<%=canEdit%>"/><br/>           
      <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.ProductType.getCode() + ",'product.FeePercTagIDs')"; %>
      <a href="<%=hrefTag%>"><v:itl key="@Common.Tags"/></a><br/>
      <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
      <v:multibox field="product.FeePercTagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" enabled="<%=canEdit%>"/>    
    </v:widget-block>
  </v:widget>
</v:profile-recap>

<v:profile-main>
  <div id="matrix-container"> 
    <ul id="matrix-tabs" class="matrix-tab">
      <li class="matrix-tab-plus"><i class="fa fa-plus"></i></li>
    </ul>
  
    <div id="price-matrix-container">
	    <% if (packageIndividualComponentsPriceMismatchMessage != null) { %>
	      <v:alert-box type="warning"><%=packageIndividualComponentsPriceMismatchMessage%></v:alert-box>
	    <% } %>
      <div class="matrix-title price-title"></div>  
      <table id="price" class="matrix-grid"></table>
    </div>  
  
    <div id="advance-matrix-container">
      <div class="matrix-title price-title-advance"></div>  
      <table id="advance" class="matrix-grid"></table>
    </div>  
  
    <div id="membership-matrix-container">
      <div class="matrix-title price-title-membership"></div>  
      <table id="mempt" class="matrix-grid">
        <thead>
    	    <tr>
    	      <td class="fixed setup" title="Configure reward points matrix" onclick="showMemPTSetupDialog()"><i class="fa fa-cog"></i></td> <%//TODO: ITL%>
    	      <td class="fixed">Points</td> <%//TODO: ITL%>
    	    </tr>
    	  </thead>
    	  <tbody id="mempt-tbody">
    	  </tbody>
      </table>
    </div>  
    
    <div id="fee-perc-value-container">
      <v:widget>
        <v:widget-block>
          <v:form-field caption="@Product.FeeTransactionPerc" >
            <v:input-text field="priceDate.FeePercValue" enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>
      </v:widget>   
    </div>  
  </div>
  
  <div id="varprice-container">
    <v:widget caption="@Common.Options">
      <v:widget-block>
        <v:db-checkbox caption="@Product.VariablePriceFreeInput" hint="@Product.VariablePriceFreeInputHint" value="true" field="product.VariablePriceFreeInput" enabled="<%=canEdit%>"/><br/>
      </v:widget-block>
    </v:widget>

    <v:widget caption="@Common.Amounts">
      <v:widget-block id="varprice-preset-amounts"></v:widget-block>
      <v:widget-block>
        <v:button id="btn-varprice-preset-add" fa="plus" caption="@Common.Add" enabled="<%=canEdit%>"/>
      </v:widget-block>
    </v:widget>
  </div>  
</v:profile-main>


<div id="price-templates" class="hidden">
  <div class="varprice-preset-amount" data-value="" data-type="">
    <div class="varprice-preset-amount-value"></div>
    <div class="varprice-preset-amount-del"><i class="fa fa-xmark"></i></div>
  </div>
</div>


<div id="price-setup-dialog" class="v-hidden" title="<v:itl key="@Product.PriceSetupHint"/>">
  <table style="width:100%">
    <tr valign="top">
      <td width="50%">
        <v:grid>
          <thead>
            <tr>
              <td><v:grid-checkbox header="true"/></td>
              <td width="100%"><v:itl key="@SaleChannel.SaleChannels"/></td>
            </tr>
          </thead>
          <tbody>
            <v:grid-row dataset="<%=dsSaleChannelAll%>">
              <td><v:grid-checkbox name="SaleChannelId" dataset="<%=dsSaleChannelAll%>" fieldname="SaleChannelId"/></td>
              <td><%=dsSaleChannelAll.getField(QryBO_SaleChannel.Sel.SaleChannelName).getHtmlString()%></td>
            </v:grid-row>
          </tbody>
        </v:grid>
      </td>
      <td>&nbsp;</td>
      <td width="50%">
        <v:grid>
          <thead>
            <tr>
              <td><v:grid-checkbox header="true"/></td>
              <td width="100%"><v:itl key="@Performance.PerformanceTypes"/></td>
            </tr>
          </thead>
          <tbody>
            <v:grid-row dataset="<%=dsPerfTypeAll%>">
              <td><v:grid-checkbox name="PerformanceTypeId" dataset="<%=dsPerfTypeAll%>" fieldname="PerformanceTypeId"/></td>
              <td><%=dsPerfTypeAll.getField(QryBO_PerformanceType.Sel.PerformanceTypeName).getHtmlString()%></td>
            </v:grid-row>
          </tbody>
        </v:grid>
      </td>
    </tr>
  </table>  
</div>

<div id="price-edit-dialog" class="v-hidden" title="Price Edit">
  <input type="hidden" id="pt-hidden"/>
  <input type="hidden" id="sc-hidden"/>
  <table class="form-table">
    <tr valign="top">
      <td width="50%" style="line-height:20px">
        <strong><v:itl key="@Product.PriceFormulaTitle"/></strong><br/>
        <% for (LookupItem item : LkSN.PriceActionType.getItems()) { %>
          <div><label id="ActionType-<%=item.getCode()%>-lbl"><input type="radio" name="ActionType" value="<%=item.getCode()%>"> <%=item.getDescription()%><br/></label></div>
        <% } %>
      </td>
      <td width="50%" style="line-height:20px">
        <div id="amount-container">
          <strong><v:itl key="@Product.PriceAmountTitle"/></strong><br/>
          <% for (LookupItem item : LkSN.PriceValueType.getItems()) { %>
            <div><label id="ValueType-<%=item.getCode()%>-lbl"><input type="radio" name="ValueType" value="<%=item.getCode()%>"> <%=item.getDescription()%><br/></label></div>
          <% } %>
          <input type="text" id="cell-value-edit" placeholder="<v:itl key="@Common.Value"/>" class="form-control" style="margin-top:10px"/><br/>
        </div>
      </td>
    </tr>
  </table>
</div>

<div id="advance-setup-dialog" class="v-hidden" title="SnApp">
  <table style="width:100%">
    <tr class="spaceUnder">
      <td colspan="100%" >
        <v:grid>
          <thead>
            <tr>
              <td width="100%"><v:itl key="@Product.AdvanceDays"/></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <i><v:itl key="@Product.AdvanceDaysHint"/></i>
                <input type="text" name="AdvanceDays" class="form-control"/>
              </td>
            </tr>
          </tbody>
        </v:grid>
      </td>
    </tr>
    <tr class="spaceUnder" valign="top">
      <td colspan="50%" >
        <v:grid>
          <thead>
            <tr>
              <td width="100%"><v:itl key="@Common.Type"/></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <v:lk-combobox lookup="<%=LkSN.ProductPriceAdvanceType%>" field="product.ProductPriceAdvanceType" allowNull="false"/>
              </td>
            </tr>
          </tbody>
        </v:grid>
      </td>
      <td>&nbsp;</td>
      <td width="50%" id="ProductPriceAdvanceSaleChannel">
        <v:grid>
          <thead>
            <tr>
              <td><v:grid-checkbox header="true"/></td>
              <td width="100%"><v:itl key="@SaleChannel.SaleChannels"/></td>
            </tr>
          </thead>
          <tbody>
          <%JvDataSet dsAllSaleChannel = pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS((LookupItem)null); %>
            <v:grid-row dataset="<%=dsAllSaleChannel%>">
              <td><v:grid-checkbox name="SaleChannelId" dataset="<%=dsAllSaleChannel%>" fieldname="SaleChannelId"/></td>
              <td><%=dsAllSaleChannel.getField(QryBO_SaleChannel.Sel.SaleChannelName).getHtmlString()%></td>
            </v:grid-row>
          </tbody>
        </v:grid>
      </td>
      <td width="50%" id="ProductPriceAdvancePerformanceType" class="v-hidden">
        <v:grid>
          <thead>
            <tr>
              <td><v:grid-checkbox header="true"/></td>
              <td width="100%"><v:itl key="@Performance.PerformanceTypes"/></td>
            </tr>
          </thead>
          <tbody>
            <%JvDataSet dsAllPerfType = pageBase.getBL(BLBO_PerformanceType.class).getDS(parentIDs);%>
            <v:grid-row dataset="<%=dsAllPerfType%>">
              <td><v:grid-checkbox name="PerformanceTypeId" dataset="<%=dsAllPerfType%>" fieldname="PerformanceTypeId"/></td>
              <td><%=dsAllPerfType.getField(QryBO_PerformanceType.Sel.PerformanceTypeName).getHtmlString()%></td>
            </v:grid-row>
          </tbody>
        </v:grid>
      </td>
      <td width="50%" id="ProductPriceAdvanceRateCode" class="v-hidden">
        <v:grid>
          <thead>
            <tr>
              <td><v:grid-checkbox header="true"/></td>
              <td width="100%"><v:itl key="@Common.RateCodes"/></td>
            </tr>
          </thead>
          <tbody>
            <v:grid-row dataset="<%=dsRateCodeAll%>">
              <td><v:grid-checkbox name="RateCodeId" dataset="<%=dsRateCodeAll%>" fieldname="RateCodeId"/></td>
              <td><%=dsRateCodeAll.getField(QryBO_RateCode.Sel.RateCodeName).getHtmlString()%></td>
            </v:grid-row>
          </tbody>
        </v:grid>
      </td>
    </tr>
  </table>  
</div>

<div id="mempt-setup-dialog" class="v-hidden" title="<v:itl key="@Product.MembershipPoints"/>">
  <v:grid>
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="100%"><v:itl key="@Product.MembershipPoints"/></td>
      </tr>
    </thead>
    <tbody>
      <v:grid-row dataset="<%=dsMembershipPointAll%>">
        <td><v:grid-checkbox name="MembershipPointId" dataset="<%=dsMembershipPointAll%>" fieldname="MembershipPointId"/></td>
        <td><%=dsMembershipPointAll.getField(QryBO_RewardPoint.Sel.MembershipPointName).getHtmlString()%></td>
      </v:grid-row>
    </tbody>
  </v:grid>
</div>

<div id="price-date-dialog" class="v-hidden" title="Price Date">
  <span class="ui-helper-hidden-accessible"><input type="text"/></span>
  <v:form-field caption="@Common.FromDate">
    <v:input-text type="datepicker" field="ValidDateFrom"/>
  </v:form-field>
  <v:form-field caption="@Common.ToDate">
    <v:input-text type="datepicker" field="ValidDateTo"/>
  </v:form-field>
</div>

<div id="price-templates" class="hidden">
  <ul>
    <li class="matrix-tab">
      <div class="matrix-tab-text">
        <div class="matrix-tab-serial"></div>
        <div class="matrix-tab-caption"></div>
      </div>
      <div class="matrix-tab-remove matrix-tab-btn"><i class="fa fa-times"></i></div>
      <div class="matrix-tab-edit matrix-tab-btn"><i class="fa fa-pencil"></i></div>
    </li>
  </ul>
</div>

</v:tab-content>


<jsp:include page="product_tab_price_css.jsp"/>
<jsp:include page="product_tab_price_js.jsp"/>
