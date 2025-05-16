<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="com.vgs.snapp.web.queue.outbound.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageOpentab" scope="request"/>
<jsp:useBean id="opentabRef" class="com.vgs.snapp.dataobject.DOOpentabRef" scope="request"/>

<%
QueryDef qDef = new QueryDef(QryBO_SaleItem.class);
//select
qDef.addSelect(
    QryBO_InvoiceItem.Sel.IconName,
    QryBO_InvoiceItem.Sel.SaleItemId,
    QryBO_InvoiceItem.Sel.SaleId,
    QryBO_InvoiceItem.Sel.SaleCode,
    QryBO_InvoiceItem.Sel.ProductId,
    QryBO_InvoiceItem.Sel.ProductCode,
    QryBO_InvoiceItem.Sel.ProductName,
    QryBO_InvoiceItem.Sel.ProductProfilePictureId,
    QryBO_InvoiceItem.Sel.ProductEntityType,
    QryBO_InvoiceItem.Sel.Quantity,
    QryBO_InvoiceItem.Sel.UnitAmount,
    QryBO_InvoiceItem.Sel.UnitTax,
    QryBO_InvoiceItem.Sel.TotalAmount,
    QryBO_InvoiceItem.Sel.TotalTax,
    QryBO_InvoiceItem.Sel.OptionsDesc,
    QryBO_InvoiceItem.Sel.TaxCount,
    QryBO_InvoiceItem.Sel.DiscountCount,
    QryBO_InvoiceItem.Sel.TotalDiscount);

//where
qDef.addFilter(QryBO_SaleItem.Fil.SaleTabId, pageBase.getId());
qDef.addFilter(QryBO_SaleItem.Fil.NonStatOnly, "true");
qDef.addFilter(QryBO_SaleItem.Fil.NonZeroOnly, "true");
qDef.addSort(QryBO_SaleItem.Sel.SaleCode);

JvDataSet dsItem = pageBase.execQuery(qDef);
request.setAttribute("dsItem", dsItem);
%>

<div class="tab-content">
<v:last-error/>
  <div class="profile-pic-div">
    <v:widget caption="@Common.Profile">
    	<v:widget-block>
    		<v:itl key="@Common.Prefix"/><span class="recap-value"><%=opentabRef.OpentabPrefix.getString()%></span><br/>
    		<v:itl key="@Common.Serial"/><span class="recap-value"><%=opentabRef.OpentabSerial.getInt()%></span><br/>
        <v:itl key="@Common.Status"/><span class="recap-value"><%=opentabRef.OpentabStatus.getHtmlLookupDesc(pageBase.getLang())%></span><br/>
        <% if (!opentabRef.Owner.isNull()) {%>
        	<v:itl key="@OpenTab.Owner"/><span class="recap-value"><%=opentabRef.Owner.getHtmlString()%></span><br/>
        <%} %>
        <% if (!opentabRef.WaiterName.isNull()) {%>
        	<v:itl key="@OpenTab.Waiter"/>
        	<span class="recap-value"><snp:entity-link entityId="<%=opentabRef.WaiterId.getString()%>" entityType="<%=LkSNEntityType.Waiter%>"><%=opentabRef.WaiterName.getHtmlString()%></snp:entity-link></span>
        	<br/>
        <%} %>
        <% if (!opentabRef.TableName.isNull()) {%>
        	<v:itl key="@OpenTab.Table"/>
        	<span class="recap-value"><snp:entity-link entityId="<%=opentabRef.TableId.getString()%>" entityType="<%=LkSNEntityType.OpentabTable%>"><%=opentabRef.TableName.getHtmlString()%></snp:entity-link></span>
        	<br/>
        	<v:itl key="@OpenTab.TableStatus"/>
        	<span class="recap-value"><%=opentabRef.TableStatus.getHtmlLookupDesc(pageBase.getLang())%></span><br/>
        <%} %>
      </v:widget-block>
      <v:widget-block>
        <div class="recap-value-item">
        	<v:itl key="@Common.FiscalDate"/><span class="recap-value"><%=pageBase.format(opentabRef.SaleTabFiscalDate.getDateTime(), pageBase.getShortDateFormat())%></span><br/>
        </div>
        <div class="recap-value-item">
        <v:itl key="@Common.CreationDate"/><span class="recap-value"><snp:datetime timestamp="<%=opentabRef.SaleTabDateTime.getDateTime()%>" format="shortdatetime" timezone="local"/></span><br/>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Account.OpArea"/>
          <span class="recap-value"><snp:entity-link entityId="<%=opentabRef.OpAreaAccountId.getString()%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=opentabRef.OpAreaAccountName.getHtmlString()%></snp:entity-link></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Common.Workstation"/>
          <span class="recap-value"><snp:entity-link entityId="<%=opentabRef.CreateWorkstationId.getString()%>" entityType="<%=LkSNEntityType.Workstation%>"><%=opentabRef.CreateWorkstationName.getHtmlString()%></snp:entity-link></span>
        </div>
      </v:widget-block>
			<v:widget-block>
        <div class="recap-value-item">
          <v:itl key="@Common.Items"/>
          <span class="recap-value"><%= opentabRef.ItemCount.getInt()%></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Reservation.TotalAmount"/>
          <span class="recap-value"><%=pageBase.formatCurrHtml(opentabRef.TotalAmount)%></span>
        </div>
      </v:widget-block>
		</v:widget>
	</div>
	<div class="profile-cont-div">
		<v:grid dataset="<%=dsItem%>" qdef="<%=qDef%>" entityType="<%=LkSNEntityType.Sale%>">
      <thead>
        <v:grid-title caption="@Common.Items"/>
        <tr calss="header">
    			<td>&nbsp;</td>
          <td width="40%">
            <v:itl key="@Product.ProductType"/> &mdash; <v:itl key="@Common.Options"/>
          </td>
          <td width="30%">
            <v:itl key="@Reservation.Discount"/>
          </td>
          <td width="10%" align="right">
            <v:itl key="@Invoice.UnitAmount"/><br/>
            <v:itl key="@Invoice.UnitTax"/>
          </td>
          <td width="10%" align="right">
            <v:itl key="@Common.Quantity"/>
          </td>
          <td width="10%" align="right">
            <v:itl key="@Invoice.TotalAmount"/><br/>
            <v:itl key="@Invoice.TotalTax"/>
          </td>
        </tr>
      </thead>
      <tbody>
       <% String lastSaleId = null; %>
        <v:ds-loop dataset="<%=dsItem%>">
        <% if (!dsItem.getField(QryBO_InvoiceItem.Sel.SaleId).isSameString(lastSaleId)) { %>
          <% lastSaleId = dsItem.getField(QryBO_InvoiceItem.Sel.SaleId).getString(); %>
          <tr class="group" data-entitytype="" data-entityid="">
            <td colspan="100%">
               <v:itl key="@Sale.PNR"/>&nbsp;
              <snp:entity-link entityId="<%=dsItem.getField(QryBO_InvoiceItem.Sel.SaleId)%>" entityType="<%=LkSNEntityType.Sale%>">
              <%=dsItem.getField(QryBO_InvoiceItem.Sel.SaleCode).getString()%>
            </snp:entity-link>
            </td>
          </tr>
        <% } %>      
       <tr class="grid-row">
          <td><v:grid-icon name="<%=dsItem.getField(QryBO_SaleItem.Sel.IconName).getString()%>" repositoryId="<%=dsItem.getField(QryBO_SaleItem.Sel.ProductProfilePictureId).getString()%>"/></td>
          <td>
         		<snp:entity-link entityId="<%=dsItem.getField(QryBO_SaleItem.Sel.ProductId)%>" entityType="<%=dsItem.getField(QryBO_SaleItem.Sel.ProductEntityType)%>">
              [<%=dsItem.getField(QryBO_SaleItem.Sel.ProductCode).getHtmlString()%>] <%=dsItem.getField(QryBO_SaleItem.Sel.ProductName).getHtmlString()%>
            </snp:entity-link>
            <% if (dsItem.getField(QryBO_SaleItem.Sel.OptionsDesc).getEmptyString().length() > 0) { %>
              &mdash; <%=dsItem.getField(QryBO_SaleItem.Sel.OptionsDesc).getHtmlString()%>
            <% } %>
          </td>
          <td>
            <% if (dsItem.getField(QryBO_SaleItem.Sel.DiscountCount).getInt() > 0) { %>
              <a href="javascript:showDiscounts('<%=dsItem.getField(QryBO_SaleItem.Sel.SaleItemId).getEmptyString()%>')"><%=pageBase.formatCurrHtml(dsItem.getField(QryBO_InvoiceItem.Sel.TotalDiscount))%></a>
            <% } %>
          </td>
          <td align="right">
            <%=pageBase.formatCurrHtml(dsItem.getField(QryBO_SaleItem.Sel.UnitAmount))%><br/>
            <%
            boolean hasTaxes = (dsItem.getField(QryBO_SaleItem.Sel.TaxCount).getInt() != 0); 
            String taxTooltipClass = hasTaxes ? " v-tooltip" : "";
            String dataJsp = hasTaxes ? " data-jsp=\"sale/saleitem_tax_tooltip&SaleItemId=" + dsItem.getField(QryBO_SaleItem.Sel.SaleItemId).getHtmlString() + "\"" : "";
            %>
            <span class="list-subtitle <%=taxTooltipClass%>" <%=dataJsp%>><%=pageBase.formatCurrHtml(dsItem.getField(QryBO_SaleItem.Sel.UnitTax))%></span>
          </td>
          <td align="right">
            <%=dsItem.getField(QryBO_SaleItem.Sel.Quantity).getEmptyString()%>
          </td>
          <td align="right">
          <%=pageBase.formatCurrHtml(dsItem.getField(QryBO_SaleItem.Sel.TotalAmount).getMoney())%><br/>
          <span class="list-subtitle"><%=pageBase.formatCurrHtml(dsItem.getField(QryBO_SaleItem.Sel.TotalTax))%></span>
          </td>
       </v:ds-loop>
      </tbody>
		</v:grid>
	</div>
</div>

<script>

	function showDiscounts(saleItemId) {
  	asyncDialogEasy("product/discount_list_dialog", "SaleItemId=" + saleItemId);
	}

</script>