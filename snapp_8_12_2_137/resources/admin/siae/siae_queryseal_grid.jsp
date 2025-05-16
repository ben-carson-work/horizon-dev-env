<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Payment.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<% 
String sDate = pageBase.getNullParameter("SearchDate");
JvDateTime date = sDate == null ? null : JvDateTime.createByXMLDate(sDate);

List<DOSiaeFullDetail> list = pageBase.getBL(BLBO_Siae.class).querySeals(date, pageBase.getNullParameter("SiaeBoxId")); 

%>

<v:grid id="siae-queryseal-grid" include="true">
  <thead>
    <tr>
      <td width="20%">
        <v:itl key="Seal request ID"/><br/>
      </td>
      <td width="10%">
        <v:itl key="Codice carta"/><br/>
        <v:itl key="Progressivo carta"/>
      </td>
      <td width="5%">
        <v:itl key="Sigillo"/><br/>
        <v:itl key="Data Ora emissione"/>
      </td>
      <td width="5%">
        <v:itl key="Prezzo titolo"/><br/>
        <v:itl key="Operazione"/>
      </td>
      <td width="20%">
        <v:itl key="ProductId"/><br/>
        <v:itl key="MediaId"/><br/>
      </td>
      <td width="20%">
        <v:itl key="PerformanceId"/><br/>
      </td>
      <td width="20%">
        <v:itl key="WorkstationId"/><br/>
    </tr>
  </thead>
  
  <tbody>
    <% for (DOSiaeFullDetail det : list) { %>
      <tr class="grid-row">
        <td>
          <%=det.SealRequestId.getHtmlString()%>
        </td>
        <td>
          <%=det.CodiceCarta.getHtmlString()%><br/>
          <%=det.ProgressivoCarta.getHtmlString()%>
        </td>
        <td>
          <%=det.Sigillo.getHtmlString()%>
          <span class="list-subtitle"><%=pageBase.format(det.DataOraEmissione, pageBase.getShortDateTimeFormat(), true)%></span> 
        </td>
        <td>
          <%=pageBase.formatCurrHtml(det.PrezzoTitolo)%><br/>
          <span class="list-subtitle"><%=LkSN.SiaeOperationType.getItemByCode(det.Operazione)%></span>
        </td>
        <td>
          <%=det.ProductId.getHtmlString()%><br/>
          <%=det.MediaId.getHtmlString()%></span>
        </td>
        <td>
          <%=det.PerformanceId.getHtmlString()%>
        </td>
        <td>
          <%=det.WorkstationId.getHtmlString()%>
        </td>
      </tr>
    <% } %>
  </tbody>
</v:grid>
