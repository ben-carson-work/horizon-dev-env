<%@page import="com.vgs.snapp.lookup.LkSNLedgerType"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

Allows to specify a set of weights for revenue distribution based on the location of the usage.<br/>
The configuration affects only ledger rule types:<br/>
<b><v:itl key="<%=LkSNLedgerType.Clearing.getHtmlDescription(pageBase.getLang())%>"/></b><br/>
<b><v:itl key="<%=LkSNLedgerType.Expiration.getHtmlDescription(pageBase.getLang())%>"/></b><br/>
<b><v:itl key="<%=LkSNLedgerType.Amortization.getHtmlDescription(pageBase.getLang())%>"/></b><br/><br/>
The match between the product and the ledger rule specific detail is performed through the location<br/>
specified in the product location weight table and in the ledger rule detail list.<br/><br/>
When a match is found the system will overwrite ledger rule weight value with the one configured at the product level. 
  
