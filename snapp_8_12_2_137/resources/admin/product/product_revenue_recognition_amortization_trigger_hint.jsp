<%@page import="com.vgs.snapp.lookup.LkSNAmortizationTriggerType"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<b><v:itl key="<%=LkSNAmortizationTriggerType.StartValidity.getHtmlDescription(pageBase.getLang())%>"/></b>: Amortization periods start from date of sale (following period type rules)<br/>
<b><v:itl key="<%=LkSNAmortizationTriggerType.FirstUsage.getHtmlDescription(pageBase.getLang())%>"/></b>: Amortization periods start from date of first usage (following period type rules)<br/>
<b><v:itl key="<%=LkSNAmortizationTriggerType.Payment.getHtmlDescription(pageBase.getLang())%>"/></b>: Amortization periods start from date of payment (following period type rules)<br/>
<br/>
<b>Behavior on renewals:</b><br/>
Trigger type is ignored during renewals.<br/>
if "valid from" of the pass is in the past then amortization periods start from renewal date.<br/>
if "valid from" of the pass is not in the past then amortization periods start from "valid from" date.<br/>