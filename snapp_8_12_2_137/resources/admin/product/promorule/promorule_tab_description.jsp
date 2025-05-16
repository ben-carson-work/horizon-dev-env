<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePromoRule" scope="request"/>
<jsp:useBean id="promo" class="com.vgs.snapp.dataobject.DOPromoRule" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% boolean canEdit = rights.PromotionRules.canUpdate() && !promo.ProductType.isLookup(LkSNProductType.SystemPromo); %>

<div class="tab-toolbar">
  <v:button fa="save" caption="@Common.Save" onclick="saveDescriptions()" enabled="<%=canEdit%>"/>
</div>

<jsp:include page="/resources/admin/common/richdesc_widget_container.jsp"></jsp:include>

<script>

function saveDescriptions() {
  var reqDO = {
    Command: "SavePromoRule",
    SavePromoRule: {
    	PromoRule: {
    		ProductId: <%=JvString.jsString(pageBase.getId())%>,
        RichDescList: convertRichDescWidgetList($(".rich-desc-widget").richdesc_getTransList())
      }
    }
  };   
  
  showWaitGlass();
  vgsService("Product", reqDO, false, function(ansDO) {
    hideWaitGlass();
    entitySaveNotification(<%=LkSNEntityType.PromoRule.getCode()%>, ansDO.Answer.SavePromoRule.ProductId, "tab=description");
  });
}
</script>

