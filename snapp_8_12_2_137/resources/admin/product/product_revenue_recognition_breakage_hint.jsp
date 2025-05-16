<%@page import="com.vgs.snapp.lookup.LkSNBreakageDaysType"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<b><v:itl key="<%=LkSNBreakageDaysType.Never.getHtmlDescription(pageBase.getLang())%>"/></b>: Revenue recognition does not happen<br/>
<b><v:itl key="<%=LkSNBreakageDaysType.Sale.getHtmlDescription(pageBase.getLang())%>"/></b>: Revenue recognition happens "breakage days" after product's sale date<br/>
<b><v:itl key="<%=LkSNBreakageDaysType.Validation.getHtmlDescription(pageBase.getLang())%>"/></b>: Revenue recognition happens "breakage days" after product's validation date<br/>
<b><v:itl key="<%=LkSNBreakageDaysType.Expiration.getHtmlDescription(pageBase.getLang())%>"/></b>: Revenue recognition happens "breakage days" after product's expiration date<br/>
If product does not have an expiration date revenue recognition is not going to happen.<br/>
Product expiration can change during lifecycle of a product, breakage date will follow the changes.<br/>
<br/>
<b>Example scenario:</b><br/>
<i>Breakage days set to 10</i><br/>
<i>Product sold on Dec 10th</i><br/>
<i>Product validated on Dec 15th</i><br/>
<i>Product expiration date is Dec 20th</i><br/>
<i>Product never used</i><br/>
<br/>
<b>Result:</b><br/>
<b><i><v:itl key="<%=LkSNBreakageDaysType.Never.getHtmlDescription(pageBase.getLang())%>"/></i></b>: Revenue recognition does not happen<br/>
<b><i><v:itl key="<%=LkSNBreakageDaysType.Sale.getHtmlDescription(pageBase.getLang())%>"/></i></b>: Revenue recognition happens on Dec 20th<br/>
<b><i><v:itl key="<%=LkSNBreakageDaysType.Validation.getHtmlDescription(pageBase.getLang())%>"/></i></b>: Revenue recognition happens on Dec 25th<br/>
<b><i><v:itl key="<%=LkSNBreakageDaysType.Expiration.getHtmlDescription(pageBase.getLang())%>"/></i></b>: Revenue recognition happens on Dec 30th<br/>