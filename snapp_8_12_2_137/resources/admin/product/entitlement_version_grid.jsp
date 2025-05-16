<%@page import="com.vgs.snapp.dataobject.DOEntitlementVersionRef"%>
<%@page import="com.vgs.snapp.api.entitlement.API_Entitlement_SearchVersion"%>
<%@page import="com.vgs.snapp.dataobject.DOEntitlementVersionSearchAnswer"%>
<%@page import="com.vgs.snapp.dataobject.DOEntitlementVersionSearchRequest"%>
<%@page import="com.vgs.snapp.dataobject.DOSaleRef"%>
<%@page import="com.vgs.snapp.dataobject.DOSaleSearchAnswer"%>
<%@page import="com.vgs.snapp.dataobject.DOSaleSearchRequest"%>
<%@page import="com.vgs.snapp.search.dataobject.DOSearchGroupContainer"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Sale.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="/resources/common/error/grid_error.jspf"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
String productId = pageBase.getNullParameter("ProductId");
DOEntitlementVersionSearchRequest reqDO = new DOEntitlementVersionSearchRequest();

//Paging
reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

//Sort
reqDO.SearchRecap.addSortField("OverrideVersion", true);

// Where
if (pageBase.getNullParameter("ProductId") != null) 
  reqDO.Filters.ProductId.setString(pageBase.getNullParameter("ProductId")); 

// Exec
DOEntitlementVersionSearchAnswer ansDO = new DOEntitlementVersionSearchAnswer();   
pageBase.getBL(BLBO_Entitlement.class).searchEntitlementVersion(reqDO, ansDO);
%>

<script>
function openEntitlementVersionWindow(params) {
	var productId = params.substr(0, params.indexOf('|'));
	var overrideVersion = params.substr(params.indexOf('|')+1, params.length);
  window.open("admin?page=entitlement_version_entitlement&ProductId=" + productId + "&OverrideVersion=" + overrideVersion);  
}
</script>

<v:grid search="<%=ansDO%>" entityType="<%=LkSNEntityType.EntitlementVersion%>">
  <tr class="header">
    <td width="40%">
      <v:itl key="@Entitlement.EntitlementVersion"/> &mdash; <v:itl key="@Reservation.Flag_Encoded"/><br>
      <v:itl key="@Entitlement.CreateDateTime"/>
    </td>
    <td width="40%">
      <v:itl key="@Entitlement.CreateWorkstation"/> <br>
      <v:itl key="@Entitlement.CreateUser"/>
    </td>
    <td width="20%" align="right">
      <v:itl key="@Common.Entitlements"/> 
    </td>
    
  </tr>
  <v:grid-row search="<%=ansDO%>" idFieldName="entitlementVersionId"> 
    <% DOEntitlementVersionRef rec = ansDO.getRecord(); %>
    <td>
      <div><b>#<%=rec.OverrideVersion.getInt()%></b> &mdash; <snp:datetime timestamp="<%=rec.EncodeDateFrom.getDateTime()%>" format="shortdate" timezone="local"/> &rarr; <snp:datetime timestamp="<%=rec.EncodeDateTo.getDateTime()%>" format="shortdate" timezone="local"/></div>
      <div class="list-subtitle"><snp:datetime timestamp="<%=rec.CreateDateTime.getDateTime()%>" format="shortdatetime" timezone="local"/></div>
    </td>
    <td>
      <snp:entity-link entityId="<%=rec.CreateWorkstationId.getString()%>" entityType="<%=LkSNEntityType.Workstation%>">
        <%=pageBase.getBL(BLBO_PagePath.class).findEntityDesc(LkSNEntityType.Workstation, rec.CreateWorkstationId.getString())%>
      </snp:entity-link><br/>
      <snp:entity-link entityId="<%=rec.CreateUserAccountId.getString()%>" entityType="<%=LkSNEntityType.Person%>">
        <%=(rec.CreateUserAccountId.isNull()) ? "&mdash;" : pageBase.getBL(BLBO_PagePath.class).findEntityDesc(LkSNEntityType.Person, rec.CreateUserAccountId.getString())%>
      </snp:entity-link>
    </td>
    <td align="right">
      <% String params = rec.ProductId.getString() + "|" + rec.OverrideVersion.getInt(); %> 
      <% String href = "openEntitlementVersionWindow('" + params + "')"; %>         
      <v:button fa="external-link" caption="@Common.Link" onclick="<%=href%>"/>
    </td>
  </v:grid-row>
</v:grid>
