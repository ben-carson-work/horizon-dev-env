<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileSales" scope="request"/>

<script type="text/javascript" id="mainfooter.jsp" >
$(document).on("<%=pageBase.getEventMouseDown()%>",'#configPanelToggle',function(e) {
	e.stopPropagation();
	$('#configPanelContent').slideToggle( "slow");
});

</script>

<div class="tab-button-list">
  <div class="tab-button active-tab goToCatalog" data-tabcode="catalog">
    <div class="tab-button-icon" style="background-image:url(<v:image-link name="mob-menu.png|TransformNegative" size="128"/>)"></div>
    <div class="tab-button-caption"><v:itl key="@Product.Catalog"/></div>
  </div>
  <div class="tab-button goToShopcart" data-tabcode="shopcart">
    <div class="tab-button-icon" style="background-image:url(<v:image-link name="bkoact-basket.png|TransformNegative" size="128"/>)"></div>
    <div class="tab-button-caption"><v:itl key="@Common.ShopCart"/></div>
  </div>
  <div class="tab-button goToAccount" data-tabcode="account">
    <div class="tab-button-icon" style="background-image:url(<v:image-link name="mob-pos-account.png|TransformNegative" size="128"/>)"></div>
    <div class="tab-button-caption"><v:itl key="@Account.Account"/></div>
  </div>
  <div class="tab-button goToLookup" data-tabcode="info">
    <div class="tab-button-icon" style="background-image:url(<v:image-link name="mobpos-search-black.png|TransformNegative" size="128"/>)"></div>
    <div class="tab-button-caption"><v:itl key="@Common.Lookup"/></div>
  </div>
  <div class="tab-button goToInfo" data-tabcode="info">
    <div class="tab-button-icon" style="background-image:url(<v:image-link name="bkoact-info.png|TransformNegative" size="128"/>)"></div>
    <div class="tab-button-caption"><v:itl key="@Common.Info"/></div>
  </div>
</div>