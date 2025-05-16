<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
boolean canEdit = false;
String[] maskIDs = pageBase.getBL(BLBO_Payment.class).getPaymentMaskIDs(pageBase.getId());
String maskEditURL = pageBase.getContextURL() + "?page=maskedit_widget&id=" + pageBase.getId()  + "&EntityType=" + LkSNEntityType.Payment.getCode() + "&MaskIDs=" + JvArray.arrayToString(maskIDs, ",") + "&LoadData=true&readonly=" + !canEdit;
%>

<v:dialog id="payment_dialog" icon="role.png" title="@Common.Forms" width="800" height="700" autofocus="false">


<div id="maskedit-container"></div>


<script>
$(document).ready(function() {
  asyncLoad("#maskedit-container", <%=JvString.jsString(maskEditURL)%>);
});
</script>

</v:dialog>

