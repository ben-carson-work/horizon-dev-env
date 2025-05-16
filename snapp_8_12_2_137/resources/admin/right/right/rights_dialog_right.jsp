<%@page import="com.vgs.snapp.exception.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="rgt-tags" prefix="rgt" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rightsEnt" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsDef" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsUI" class="com.vgs.snapp.dataobject.DORightDialogUI" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<rgt:menu>
  <li class="rights-menu-search"><input type="text" class="txt-search form-control" placeholder="<v:itl key="@Common.Search"/>" onkeyup="rightsSearch()"/></li>
  
  <rgt:menu-item contentId="rights-menu-login"     fa="lock"          color="green"  caption="@Common.Login"/>
  <rgt:menu-item contentId="rights-menu-order"     fa="shopping-cart" color="blue"   caption="@Common.Sales"/>
  <rgt:menu-item contentId="rights-menu-tools"     fa="tools"         color="gray"   caption="@System.Functions"/>
  
  <rgt:menu-divider/>
  
  <rgt:menu-item contentId="rights-menu-finance"   fa="dollar-sign"   color="blue"   caption="@Right.Finance"/>
  <rgt:menu-item contentId="rights-menu-crm"       fa="user"          color="blue"   caption="@Account.Accounts"/>
  <rgt:menu-item contentId="rights-menu-product"   fa="tag"           color="orange" caption="@Product.ProductTypes"/>
  <rgt:menu-item contentId="rights-menu-category"  fa="sitemap"       color="gray"   caption="@Product.Categories"/>
  <rgt:menu-item contentId="rights-menu-doc"       fa="print"         color="gray"   caption="@DocTemplate.DocTemplates"/>
  
  <rgt:menu-divider/>
  
  <rgt:menu-item contentId="rights-menu-admission" fa="barcode-scan"  color="green"  caption="@Common.Admission"/>
  <rgt:menu-item contentId="rights-menu-advanced"  fa="cog"           color="gray"   caption="@Common.Advanced"/>
</rgt:menu>



<rgt:menu-body>
  <jsp:include page="rights_dialog_right_login.jsp"></jsp:include>
  <jsp:include page="rights_dialog_right_order.jsp"></jsp:include>
  <jsp:include page="rights_dialog_right_tools.jsp"></jsp:include>
  <jsp:include page="rights_dialog_right_finance.jsp"></jsp:include>
  <jsp:include page="rights_dialog_right_crm.jsp"></jsp:include>
  <jsp:include page="rights_dialog_right_product.jsp"></jsp:include>
  <jsp:include page="rights_dialog_right_category.jsp"></jsp:include>
  <jsp:include page="rights_dialog_right_doc.jsp"></jsp:include>
  <jsp:include page="rights_dialog_right_admission.jsp"></jsp:include>
  <jsp:include page="rights_dialog_right_advanced.jsp"></jsp:include>
</rgt:menu-body>