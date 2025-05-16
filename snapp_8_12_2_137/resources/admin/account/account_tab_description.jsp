<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="java.util.Locale"%>
<%@page import="com.vgs.snapp.library.SnappUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.web.bko.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.web.page.PageAccount"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>

<% boolean canEdit = pageBase.getRightCRUD().canUpdate();%>

<div class="tab-toolbar">
  <v:button fa="save" caption="@Common.Save" onclick="saveDescriptions()" enabled="<%=canEdit%>"/>
</div>

<jsp:include page="/resources/admin/common/richdesc_widget_container.jsp"></jsp:include>

<script>
function saveDescriptions() {
	var reqDO = {
    Command: "SaveAccount",
    SaveAccount: {
      AccountId : <%=account.AccountId.getJsString()%>,
      EntityType : <%=account.EntityType.getJsString()%>,
      RichDescList: convertRichDescWidgetList($(".rich-desc-widget").richdesc_getTransList())
    }
	};
	
  showWaitGlass();
  vgsService("Account", reqDO, false, function(ansDO) {
    hideWaitGlass();
    entitySaveNotification(<%=account.EntityType.getInt()%>, ansDO.Answer.SaveAccount.AccountId, "tab=description");
  });
}
</script>


