<%@page import="java.util.List"%>
<%@page import="com.vgs.snapp.web.gencache.SrvBO_Cache_LocationTimezone"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SaleCapacity.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = rights.PromotionRules.canUpdate();

QueryDef qdef = new QueryDef(QryBO_SaleCapacity.class)
.addSelect(
    QryBO_SaleCapacity.Sel.CommonStatus,
    QryBO_SaleCapacity.Sel.SaleCapacityId,
    QryBO_SaleCapacity.Sel.ParentSaleCapacityId,
    QryBO_SaleCapacity.Sel.SaleCapacityStatus,
    QryBO_SaleCapacity.Sel.SerialName,
    QryBO_SaleCapacity.Sel.PriorityOrder,
    QryBO_SaleCapacity.Sel.ValidDateFrom,
    QryBO_SaleCapacity.Sel.ValidDateTo,
    QryBO_SaleCapacity.Sel.Quantity,
    QryBO_SaleCapacity.Sel.TimeSlotType,
    QryBO_SaleCapacity.Sel.TimeSlotStep,
    QryBO_SaleCapacity.Sel.SaleChannelId,
    QryBO_SaleCapacity.Sel.SaleChannelName,
    QryBO_SaleCapacity.Sel.IndentCount,
    QryBO_SaleCapacity.Sel.AshedSaleCapacitySerial,
    QryBO_SaleCapacity.Sel.SaleCapacityTreePath,
    QryBO_SaleCapacity.Sel.CurrentSlotId,
    QryBO_SaleCapacity.Sel.CurrentSlotStartDate,
    QryBO_SaleCapacity.Sel.CurrentSlotEndDate,
    QryBO_SaleCapacity.Sel.CurrentSlotQtyMax,
    QryBO_SaleCapacity.Sel.CurrentSlotQtyFree,
    QryBO_SaleCapacity.Sel.ProductFlags)
.addSort(QryBO_SaleCapacity.Sel.SaleCapacityTreePath)
.addSort(QryBO_SaleCapacity.Sel.PriorityOrder)
.addFilter(QryBO_SaleCapacity.Fil.SaleCapacityStatus, LookupManager.getIntArray(LkSNSaleCapacityStatus.Active, LkSNSaleCapacityStatus.Inactive))
.addFilter(QryBO_SaleCapacity.Fil.CurrentPeriodDate, pageBase.getBrowserFiscalDate());
//Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;

if (pageBase.getNullParameter("ProductId") != null)
  qdef.addFilter(Fil.ProductId, pageBase.getNullParameter("ProductId"));

JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<style>
.prgbar-lbl {
  width: 100px;
  text-align: center;
  font-weight: bold; 
}
.prgbar-ext {
  width: 100px;
  height: 6px;
}
.prgbar-ext-gray {
  background-color: var(--base-gray-color);
}
.prgbar-ext-red {
  background-color: var(--base-red-color);
}
.prgbar-int {
  float: left;
  height: 6px;
}
.prgbar-int-green {
  background-color: var(--base-green-color);
}
.current-slot {
  background-color:#f2f2f2;
}

</style>
<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SaleCapacity%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td width="20%">
      <v:itl key="@Common.Serial"/>
    </td>
    <td width="20%">
      <v:itl key="@SaleCapacity.TimeSlotType"/><br/>
      <v:itl key="@SaleCapacity.TimeSlotStep"/>
    </td>
    <td width="20%">
      <v:itl key="@Common.Validity"/><br/>
       <v:itl key="@SaleChannel.SaleChannel"/>
    </td>
    <td width="20%" align="right">
      <v:itl key="@Common.Quantity"/>
    </td>
    <td></td>
    <td align="center" width="20%" class="current-slot">
      <v:itl key="@Performance.Availability"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="SaleCapacityId" dataset="ds" fieldname="SaleCapacityId"/></td>
    <td>
       <% for (int i=0; i<ds.getField("IndentCount").getInt(); i++) { %> 
         &nbsp;&nbsp;&nbsp;&nbsp;
       <% } %>
      <snp:entity-link entityId="<%=ds.getField(Sel.SaleCapacityId)%>" entityType="<%=LkSNEntityType.SaleCapacity%>" clazz="list-title">
        <%=ds.getField(Sel.SerialName).getHtmlString()%>
      </snp:entity-link>
      <br/>
    </td>
    <td>
      <%=LkSN.SaleCapacityTimeSlotType.getItemByCode(ds.getField(Sel.TimeSlotType)).getDescription(pageBase.getLang())%>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.TimeSlotStep).getHtmlString()%></span>
    </td>    
    <td>
      <%
        String validityStr = "";
        if (ds.getField(Sel.ValidDateFrom).isNull() && ds.getField(Sel.ValidDateTo).isNull())
          validityStr = pageBase.getLang().Common.Unlimited.getText();
        else {
          ds.getField(Sel.ValidDateFrom).setDisplayFormat(pageBase.getShortDateFormat());
          ds.getField(Sel.ValidDateTo).setDisplayFormat(pageBase.getShortDateFormat());
          if (!ds.getField(Sel.ValidDateFrom).isNull())
            validityStr += pageBase.getLang().Common.From.getText() + " " + ds.getField(Sel.ValidDateFrom).getHtmlString() + "&nbsp;&nbsp;&nbsp;";
          if (!ds.getField(Sel.ValidDateTo).isNull())
            validityStr += pageBase.getLang().Common.To.getText() + " " + ds.getField(Sel.ValidDateTo).getHtmlString();
        }
      %>
      <%=validityStr%>
      <br/>
      <snp:entity-link entityId="<%=ds.getField(Sel.SaleChannelId)%>" entityType="<%=LkSNEntityType.SaleChannel%>" clazz="list-title">
        <%=ds.getField(Sel.SaleChannelName).getHtmlString()%>
      </snp:entity-link>
    </td>
    <td align="right">
      <%=ds.getField(Sel.Quantity).getHtmlString()%>
      <br/>
      <%  
        List<LookupItem> productFlags = LookupManager.getArray(LkSN.ProductFlag, JvArray.stringToIntArray(ds.getString(Sel.ProductFlags), ","));
        LookupItem saleCapacityCountType = BLBO_SaleCapacity.encodeSaleCapacityCountType(productFlags);
      %>
      <span class="list-subtitle"><%=saleCapacityCountType.getHtmlDescription(pageBase.getLang())%></span>
    </td>
    <td align="right">
      <% String hrefAdd = "javascript:asyncDialogEasy('product/salecapacity/sale_capacity_dialog', 'ProductId=" + pageBase.getNullParameter("ProductId") + "&Operation=add&ParentSaleCapacityId=" + ds.getField(QryBO_SaleCapacity.Sel.SaleCapacityId).getEmptyString() + "')"; %>
      <v:button clazz="row-hover-visible" fa="plus" href="<%=hrefAdd%>"/>
    </td>
    <td align="center" class="current-slot">
      <%
        String periodStr = "";
        if (ds.getField(Sel.CurrentSlotId).isNull())
          periodStr = pageBase.getLang().Common.NotUsed.getText();
        else if (ds.getField(Sel.CurrentSlotStartDate).isNull() && ds.getField(Sel.CurrentSlotEndDate).isNull())
          periodStr = pageBase.getLang().Common.Unlimited.getText();
        else {
          ds.getField(Sel.CurrentSlotStartDate).setDisplayFormat(pageBase.getShortDateFormat());
          ds.getField(Sel.CurrentSlotEndDate).setDisplayFormat(pageBase.getShortDateFormat());
          if (!ds.getField(Sel.CurrentSlotStartDate).isNull())
            periodStr += ds.getField(Sel.CurrentSlotStartDate).getHtmlString() + "&nbsp;&mdash;&nbsp;";
          if (!ds.getField(Sel.CurrentSlotEndDate).isNull())
            periodStr += ds.getField(Sel.CurrentSlotEndDate).getHtmlString();
        }
      %>
      <%=periodStr%>
      <br/>
      <% 
      float percFree = (ds.getField(Sel.CurrentSlotQtyFree).getFloat() * 100.0f) / ds.getField(Sel.CurrentSlotQtyMax).getFloat();
      String clsext = (ds.getField(Sel.CurrentSlotQtyFree).getInt() > 0) ? "prgbar-ext-gray" : "prgbar-ext-red";
      %>
      <div class="prgbar-lbl">
        <% 
          String capacityTxt;
          if (!ds.getField(Sel.CurrentSlotId).isNull() && (ds.getField(Sel.CurrentSlotQtyFree).getInt() == 0))
            capacityTxt = pageBase.getLang().Seat.SoldOut.getText().toUpperCase();
          else
            capacityTxt = ds.getField(Sel.CurrentSlotQtyFree).getInt() + "&nbsp;(" + Math.round(percFree) + "%)";
        %> 
        <% if (!ds.getField(QryBO_SaleCapacity.Sel.CurrentSlotId).isNull()) {%>
          <% String hrefEdit = "javascript:asyncDialogEasy('product/salecapacity/sale_capacity_slot_edit_dialog', 'SaleCapacitySlotId=" +  ds.getField(QryBO_SaleCapacity.Sel.CurrentSlotId).getEmptyString() + "')";%> 
          <a href="<%=hrefEdit%>"><%=capacityTxt%></a>
        <% } else {%>
          <%=capacityTxt%>
        <% } %>
      </div>
      <div class="prgbar-ext <%=clsext%>"><div class="prgbar-int prgbar-int-green" style="width:<%=percFree%>%"/></div></div>
    </td>
  </v:grid-row>
</v:grid>

<script>
