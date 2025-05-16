<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_RedemptionCommissionRule.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_RedemptionCommissionRule.class);
// Select
qdef.addSelect(
    Sel.CommonStatus,
    Sel.IconName,
    Sel.RedemptionCommissionRuleId,
    Sel.LocationId,
    Sel.LocationName,
    Sel.OpAreaId,
    Sel.OpAreaName,
    Sel.AccessPointId,
    Sel.AccessPointName,
    Sel.EventNames,
    Sel.ProductTagNames,
    Sel.SaleChannelNames,
    Sel.MembershipPointId,
    Sel.MembershipPointCode,
    Sel.MembershipPointName,
    Sel.ValidDateFrom,
    Sel.ValidDateTo,
    Sel.CommissionRuleValueType,
    Sel.CommissionRuleValue,
    Sel.CommissionRuleFormula,
    Sel.CommissionRuleStatus,
    Sel.PriorityOrder
    );
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
//Filter
if (pageBase.getNullParameter("MembershipPointId") != null)
  qdef.addFilter(Fil.MembershipPointId, pageBase.getNullParameter("MembershipPointId"));

if (pageBase.getNullParameter("CommissionRuleStatus") != null)
  qdef.addFilter(Fil.CommissionRuleStatus, JvArray.stringToArray(pageBase.getNullParameter("CommissionRuleStatus"), ","));

if (pageBase.getNullParameter("CommissionRuleFormula") != null)
  qdef.addFilter(Fil.CommissionRuleFormula, JvArray.stringToArray(pageBase.getNullParameter("CommissionRuleFormula"), ","));

if (pageBase.getNullParameter("CalculationAmountType") != null)
  qdef.addFilter(Fil.CalculationAmountType, JvArray.stringToArray(pageBase.getNullParameter("CalculationAmountType"), ","));

if (pageBase.getNullParameter("LocationId") != null)
  qdef.addFilter(Fil.LocationId, pageBase.getNullParameter("LocationId"));

if (pageBase.getNullParameter("OpAreaId") != null)
  qdef.addFilter(Fil.OpAreaId, pageBase.getNullParameter("OpAreaId"));

if (pageBase.getNullParameter("AccessPointId") != null)
  qdef.addFilter(Fil.AccessPointId, pageBase.getNullParameter("AccessPointId"));

if (pageBase.getNullParameter("EventIDs") != null)
  qdef.addFilter(Fil.EventIDs, JvArray.stringToArray(pageBase.getNullParameter("EventIDs"), ","));

if (pageBase.getNullParameter("SaleChannelIDs") != null)
  qdef.addFilter(Fil.SaleChannelIDs, JvArray.stringToArray(pageBase.getNullParameter("SaleChannelIDs"), ","));

if (pageBase.getNullParameter("ProductTagIDs") != null)
  qdef.addFilter(Fil.ProductTagIDs, JvArray.stringToArray(pageBase.getNullParameter("ProductTagIDs"), ","));

// Sort
qdef.addSort(Sel.PriorityOrder);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="redemptioncommissionrule-grid" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.RedemptionCommissionRule%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true" multipage="true"/></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.OpArea"/> 
        <br/>
        <v:itl key="@AccessPoint.AccessPoint"/>
      </td>
      <td width="16%">
        <v:itl key="@Event.Events"/>
        <br/>
        <v:itl key="@Product.ProductTypes"/>
      </td>
      <td width="16%">
        <v:itl key="@Product.MembershipPoint"/>
      </td>
      <td width="16%">
        <v:itl key="@SaleChannel.SaleChannels"/>
      </td>
      <td width="16%">
        <v:itl key="@Common.DateRange"/>
      </td>
       <td width="16%" align="right">
      	<v:itl key="@Product.PriceFormulaTitle"/>
      	 <br/>
      	<v:itl key="@Common.Value"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>">
        <v:grid-checkbox name="RedemptionCommissionRuleId" dataset="ds" fieldname="RedemptionCommissionRuleId"/>
      </td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td nowrap>
        <snp:entity-link entityId="<%=ds.getField(Sel.RedemptionCommissionRuleId).getString()%>" entityType="<%=LkSNEntityType.RedemptionCommissionRule%>" entityTooltip="false" clazz="list-title">
          # <%=ds.getField(Sel.PriorityOrder).getHtmlString()%>
        </snp:entity-link>
      </td>
      <td>
        <% if (ds.getField(Sel.LocationId).isNull()) { %>
          <span class="list-subtitle"><v:itl key="@Common.All"/></span>
        <% } else { %>
          <snp:entity-link entityId="<%=ds.getField(Sel.LocationId).getString()%>" entityType="<%=LkSNEntityType.Location%>">
            <%=ds.getField(Sel.LocationName).getHtmlString()%>
          </snp:entity-link>
          
          <% if (!ds.getField(Sel.OpAreaId).isNull()) { %>
            &raquo;
            <snp:entity-link entityId="<%=ds.getField(Sel.OpAreaId).getString()%>" entityType="<%=LkSNEntityType.OperatingArea%>">
              <%=ds.getField(Sel.OpAreaName).getHtmlString()%>
            </snp:entity-link>
          <% } %>
        <% } %>
        <br/>
        <% if (ds.getField(Sel.AccessPointId).isNull()) { %>
          <span class="list-subtitle"><v:itl key="@Common.All"/></span>
        <% } else { %>
          <snp:entity-link entityId="<%=ds.getField(Sel.AccessPointId).getString()%>" entityType="<%=LkSNEntityType.AccessPoint%>">
            <%=ds.getField(Sel.AccessPointName).getHtmlString()%>
          </snp:entity-link>
        <% } %>
      </td>
      <td>
        <span class="list-subtitle">
          <% if (ds.getField(Sel.EventNames).isNull()) { %>
            <v:itl key="@Common.All"/>
          <% } else { %>
            <%=ds.getField(Sel.EventNames).getHtmlString()%>
          <% } %>
          <br/>
          <% if (ds.getField(Sel.ProductTagNames).isNull()) { %>
            <v:itl key="@Common.All"/>
          <% } else { %>
            <%=ds.getField(Sel.ProductTagNames).getHtmlString()%>
          <% } %>
        </span>
      </td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.MembershipPointId).getString()%>" entityType="<%=LkSNEntityType.RewardPoint%>"><%=ds.getField(Sel.MembershipPointName).getHtmlString()%></snp:entity-link><br/>
      </td>
      <td>
        <span class="list-subtitle">
          <% if (ds.getField(Sel.SaleChannelNames).isNull()) { %>
            <v:itl key="@Common.All"/>
          <% } else { %>
            <%=ds.getField(Sel.SaleChannelNames).getHtmlString()%>
          <% } %>
        </span>
      </td>
      <td>
        <span class="list-subtitle">
          <% if (ds.getField(Sel.ValidDateFrom).isNull() && ds.getField(Sel.ValidDateTo).isNull()) { %>
            <v:itl key="@Common.AnyDate"/>
          <% } else { %>
            <% if (!ds.getField(Sel.ValidDateFrom).isNull()) { %>
              <v:itl key="@Common.From"/> <%=pageBase.format(ds.getField(Sel.ValidDateFrom), pageBase.getShortDateFormat()) %>
            <% } %>
            <% if (!ds.getField(Sel.ValidDateTo).isNull()) { %>
              <v:itl key="@Common.To"/> <%=pageBase.format(ds.getField(Sel.ValidDateTo), pageBase.getShortDateFormat()) %>
            <% } %>
          <% } %>
        </span>
      </td>
      <td align="right">
        <%LookupItem commissionRuleFormula = LkSN.CommissionRuleFormulaType.getItemByCode(ds.getField(Sel.CommissionRuleFormula));%>
        <%=commissionRuleFormula.getHtmlDescription(pageBase.getLang())%>
        <br/>
        <%int valueType = ds.getField(Sel.CommissionRuleValueType).getInt();%>
        <%=ds.getField(Sel.CommissionRuleValue).getHtmlString()%><%=BLBO_PriceRule.getValueSymbol(valueType)%>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
