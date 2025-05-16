<%@page import="com.vgs.web.library.product.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="org.apache.poi.util.*"%>
<%@page import="com.vgs.snapp.dataobject.DOProduct.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightCRUD" class="com.vgs.snapp.library.FtCRUD" scope="request"/>

<% 
boolean canEdit = rightCRUD.canUpdate();
String sDisabled = canEdit ? "" : "disabled=\"disabled\"";
boolean systemCode = product.ProductType.isLookup(LkSNProductType.System);
boolean requireAccountOnEncoding = product.RequireAccountOnEncodingOnly.getBoolean();
boolean requireAccountOnRedemption = product.RequireAccountOnRedemptionOnly.getBoolean();
String checkedOnEncoding = requireAccountOnEncoding ? "checked='checked'" : "";
String checkedOnRedemption = requireAccountOnRedemption ? "checked='checked'" : "";
String checkedOnSale = !requireAccountOnEncoding && !requireAccountOnRedemption ? "checked='checked'" : "";
%>

<v:widget caption="@Account" include="<%=!product.ProductType.isLookup(LkSNProductType.System, LkSNProductType.Material, LkSNProductType.Presale)%>">
  <v:widget-block>
    <v:form-field checkBoxField="product.RequireAccount" caption="@Product.RequireAccount" hint="@Product.RequireAccountHint">
      <v:combobox field="product.AccountCategoryId" lookupDataSetName="dsAccountCategoryTree" idFieldName="CategoryId" captionFieldName="AshedCategoryName"/>
      <label class="checkbox-label">
        <input 
          type="radio" 
          name="RequireAccountOption" 
          value=<%=BLBO_Product.RequestAccountOption.ON_SALE.name()%> 
          <%=checkedOnSale%>
          <%=sDisabled%>>
          <v:itl key="@Product.RequireAccountOnSaleOnly"/>
      </label>
      &nbsp; 
      <label class="checkbox-label">
        <input 
          type="radio" 
          name="RequireAccountOption" 
          value=<%=BLBO_Product.RequestAccountOption.ON_ENCODING.name()%> 
          <%=checkedOnEncoding%>
          <%=sDisabled%>>
          <v:itl key="@Product.RequireAccountOnEncodingOnly"/>
      </label>
      &nbsp; 
      <label class="checkbox-label">
        <input 
          type="radio" 
          name="RequireAccountOption" 
          value=<%=BLBO_Product.RequestAccountOption.ON_REDEMPTION.name()%> 
          <%=checkedOnRedemption%>
          <%=sDisabled%>> 
          <v:itl key="@Product.RequireAccountOnRedemptionOnly"/>
      </label>

    </v:form-field>
  </v:widget-block>

  <v:widget-block include="<%=!product.ProductType.isLookup(LkSNProductType.StaffCard)%>">
    <v:form-field caption="@Product.MinAge">
      <v:input-text field="product.MinAge" placeholder="Unlimited" enabled="<%=canEdit && !systemCode%>" />
    </v:form-field>
    <v:form-field caption="@Product.MaxAge">
      <v:input-text field="product.MaxAge" placeholder="Unlimited" enabled="<%=canEdit && !systemCode%>" />
    </v:form-field>
  </v:widget-block>
</v:widget>


