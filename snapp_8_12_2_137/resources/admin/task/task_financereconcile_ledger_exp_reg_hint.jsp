<%@page import="com.vgs.snapp.lookup.LkSNLedgerRegDateTimeRule"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<b><v:itl key="<%=LkSNLedgerRegDateTimeRule.ScheduledDateTime.getHtmlDescription(pageBase.getLang())%>"/></b>: Ledger is registered on product's expiration date<br/>
<b><v:itl key="<%=LkSNLedgerRegDateTimeRule.PreviousFiscalDate.getHtmlDescription(pageBase.getLang())%>"/></b>: Ledger is registered on previous day fiscal date of task execution<br/>
<b><v:itl key="<%=LkSNLedgerRegDateTimeRule.ExecutionDateTime.getHtmlDescription(pageBase.getLang())%>"/></b>: Ledger is registered on task execution date<br/>
<br/>
<b>Example scenario:</b><br/>
<i>Product expired on July 7th</i><br/>
<i>Fiscal day switch hour 5:00am</i><br/>
<i>Task executed on July 25th 8:00am</i><br/>
<b>Result:</b><br/>
<i><v:itl key="<%=LkSNLedgerRegDateTimeRule.ScheduledDateTime.getHtmlDescription(pageBase.getLang())%>"/></i>: Ledger registered on July 8th at 4:59am<br/>
<i><v:itl key="<%=LkSNLedgerRegDateTimeRule.PreviousFiscalDate.getHtmlDescription(pageBase.getLang())%>"/></i>: Ledger registered on July 24th at 4:59am<br/>
<i><v:itl key="<%=LkSNLedgerRegDateTimeRule.ExecutionDateTime.getHtmlDescription(pageBase.getLang())%>"/></i>: Ledger registered on July 25th at 8:00am<br/>