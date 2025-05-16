<%@page import="com.vgs.snapp.web.query.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.stream.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.transaction.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSale" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="sale" class="com.vgs.snapp.dataobject.transaction.DOSale" scope="request"/>
<jsp:useBean id="rightCRUD" class="com.vgs.snapp.library.FtCRUD" scope="request"/>
    
<v:grid>
  <thead>
    <v:grid-title caption="@Product.Discounts"/>
    
    <tr>
      <td>&nbsp;</td>
      
      <td width="30%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.Type"/><br/>           
        <v:itl key="@Product.PromoActionTarget"/>
      </td>
      <td width="20%">
        <v:itl key="@Product.PromoSelection"/><br/>
        <v:itl key="@Product.PromoCombinable"/>           
      </td>
      <td width="30%" align="right">
        <v:itl key="@Common.Amount"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <% for (DOSale.DOSaleDiscount discount : sale.DiscountList) { %>
    <tr class="grid-row">
      <td>
        <v:grid-icon name="promorule.png"/>
      </td>
      <td>
        <snp:entity-link entityId="<%=discount.PromoRuleId%>" entityType="<%=LkSNEntityType.PromoRule%>">
          <%=discount.PromoRuleName.getHtmlString()%><br/>
        </snp:entity-link>
        <span class="list-subtitle"><%=discount.PromoRuleCode.getHtmlString()%></span>&nbsp;
      </td>
      <td>
        <%=discount.PromoRuleType.getHtmlLookupDesc(pageBase.getLang())%><br/>
        <span class="list-subtitle"><%=discount.PromoActionTarget.getHtmlLookupDesc(pageBase.getLang())%>&nbsp;</span>
      </td>
      <td>
        <%=discount.PromoSelectionType.getHtmlLookupDesc(pageBase.getLang())%><br/>
        <span class="list-subtitle">
        <%if (discount.Combinable.getBoolean()) {%>
          <v:itl key="@Product.PromoCombinable"/>  
        <%} else {%>
          <v:itl key="@Product.PromoNotCombinable"/>  
        <%} %>         
        &nbsp;</span>
      </td>
      <td align="right">
        <%=pageBase.formatCurrHtml(discount.DiscountAmount)%>
      </td>
    </tr>
    <% } %>
  </tbody>
</v:grid>
