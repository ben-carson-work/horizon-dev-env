<%@page import="com.vgs.web.library.BLBO_Auth.*"%>
<%@page import="com.vgs.snapp.web.plugin.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.snapp.web.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.print.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.wpg.page.PageWPG_PayByLinkCheckout" scope="request"/>
<jsp:useBean id="wpgtrn" class="com.vgs.snapp.dataobject.DOWpgTransaction" scope="request"/>

<!DOCTYPE html>
<html>

<jsp:include page="../common/header-head.jsp"></jsp:include>

<body>
  <script>
    function WebPayment_CallBack(trnRecap, data) {
    	window.location = BASE_URL + "/wpg?page=paybylink_checkout" + 
    			"&SaleTokenId=<%=pageBase.getNullParameter("SaleTokenId")%>" +
    			"&WorkstationId=<%=pageBase.getSession().getWorkstationId()%>" +
    			"&PaymentConfirmation=true" +
    			"&WebAuthId=" + data.WebAuthId; 
    }
  </script>
  
  <div style="position:fixed; top:0; left:0; right:0; bottom:0">
  <% SrvBO_Cache_SystemPlugin.instance().getPluginInstance(PlgWpgBase.class, wpgtrn.PluginId.getString()).includePaymentWidget(pageBase, pageContext, wpgtrn); %>
  </div>
</body>

</html>

