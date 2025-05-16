<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<% boolean canEdit = pageBase.getRightCRUD().canUpdate(); %>

<div class="tab-toolbar">
  <v:button fa="save" caption="@Common.Save" onclick="saveDescriptions()" enabled="<%=canEdit%>"/>
</div>

<jsp:include page="/resources/admin/common/richdesc_widget_container.jsp"></jsp:include>

<script>

function saveDescriptions() {
  var reqDO = {
    Command: "SaveProduct",
    SaveProduct: {
      Product: {
        ProductId: <%=JvString.jsString(pageBase.getId())%>,
        RichDescList: convertRichDescWidgetList($(".rich-desc-widget").richdesc_getTransList())
  
      }
    }
  };   
  
  showWaitGlass();
  vgsService("Product", reqDO, false, function(ansDO) {
    hideWaitGlass();
    entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, ansDO.Answer.SaveProduct.ProductId, "tab=description");
  });
}
</script>

