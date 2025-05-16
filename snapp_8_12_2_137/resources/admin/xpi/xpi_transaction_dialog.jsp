<%@page import="com.vgs.cl.json.JSONObject"%>
<%@page import="com.vgs.cl.JvDateTime"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
 
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
  String saleId = pageBase.getNullParameter("SaleId");
String transactionId = pageBase.getNullParameter("TransactionId");
String crossTransactionRef = pageBase.getNullParameter("CrossTransactionRef");
String crossPlatformId = pageBase.getEmptyParameter("CrossPlatformId");

QueryDef qdef = new QueryDef(QryBO_TransactionCrossPlatform.class);
//Select
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionCrossPlatformId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionDateTime);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionFiscalDate);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransacrionSerialDateTime);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionLocationAccountId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionTotQuantity);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionTotAmount);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.SaleId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.SaleCode);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.Status);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.ServerId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.ServerCode);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.ServerName);

//Where
qdef.addFilter(QryBO_TransactionCrossPlatform.Fil.CrossPlatformId, crossPlatformId);
if (transactionId != null)
  qdef.addFilter(QryBO_TransactionCrossPlatform.Fil.TransactionId, transactionId);
if (crossTransactionRef != null)
  qdef.addFilter(QryBO_TransactionCrossPlatform.Fil.CrossTransactionRef, crossTransactionRef);
if (saleId != null)
  qdef.addFilter(QryBO_TransactionCrossPlatform.Fil.SaleId, saleId);

//Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

String transactionCrossPlatformId = ds.getField(QryBO_TransactionCrossPlatform.Sel.TransactionCrossPlatformId).getString();

JvDataSet dsItems = pageBase.getDB().executeQuery(
    "select" + JvString.CRLF +
    "  PCS.CrossProductCode as ProductCode," + JvString.CRLF +
    "  PCS.CrossProductName as ProductName," + JvString.CRLF +
    "  TCPI.Quantity as Quantity," + JvString.CRLF +
    "  TCPI.UnitPrice * TCPI.Quantity as TotAmount" + JvString.CRLF +
    "from" + JvString.CRLF +
    "  tbTransactionCrossPlatformItem TCPI inner join" + JvString.CRLF +
    "  tbSaleItem SI on SI.SaleItemId=TCPI.SaleItemId inner join" + JvString.CRLF +
    "  tbProductCrossSell PCS on PCS.ProductId=SI.ProductId and PCS.CrossPlatformId=" + JvString.sqlStr(crossPlatformId) + JvString.CRLF +
    "where" + JvString.CRLF +
    "  TCPI.TransactionCrossPlatformId=" + JvString.sqlStr(transactionCrossPlatformId));

LookupItem status = LkSN.TransactionCrossPlatformStatus.getItemByCode(ds.getField(QryBO_TransactionCrossPlatform.Sel.Status).getInt());
%>

<v:dialog id="xpi-transaction-dialog" width="800" height="650" title="@XPI.CrossTransaction" autofocus="false">

  <div id="tabs">
    <ul>
      <li><a href="#tabs-main"><span class="ab-icon" style="background-image: url('<v:image-link name="profile.png" size="16"/>')"></span>&nbsp;<v:itl key="@Common.Recap"/></a></li>
      <li><a href="#tabs-message"><span class="ab-icon" style="background-image: url('<v:image-link name="xml.png" size="16"/>')"></span>&nbsp;<v:itl key="@Upload.RequestMessage"/></a></li>
    </ul>
    <div id="tabs-main">
		  <%
		    if (pageBase.getRights().SuperUser.getBoolean() && status.isLookup(LkSNTransactionCrossPlatformStatus.Failed)) {
		  %>
  	  	<div class="tab-toolbar">
  	  	  <v:button caption="@Common.Retry" fa="repeat" href="javascript:doRetry()"/>
  	  	</div>
  	  	
  	  	<script>
			    function doRetry() {
			    	showWaitGlass();
			      var reqDO = {
			        Command: "RetryDispatchXPITransaction",
			        RetryDispatchXPITransaction: {
			          TransactionCrossPlatformId: <%=JvString.jsString(transactionCrossPlatformId)%>
			        }
			      };
			      
			      vgsService("Transaction", reqDO, false, function() {
			    	  hideWaitGlass();
			    	  showMessage(<v:itl key="@Common.SaveSuccessMsg" encode="JS"/>, function() {
			    		  dlg.dialog("close");
			    		  window.location.reload();
			    	  });
			      });
			    }  
			  </script>
  	  	
	  	<%
  	  		  	  }
  	  		  	%>
      <div class="tab-content">
			  <table class="recap-table" style="width:100%">
			    <tr>      
			      <td width="50%" valign="top">
							<v:widget caption="@Common.Info">
							  <v:widget-block>
							  	<v:itl key="@Sale.PNR"/><span class="recap-value">
							  	  <%
							  	    String hRef="javascript:showSale(" + JvString.sqlStr(ds.getField(QryBO_TransactionCrossPlatform.Sel.SaleId).getString()) + ")";
							  	  %>
							  	  <a href="<%=hRef%>"><%=ds.getField(QryBO_TransactionCrossPlatform.Sel.SaleCode).getHtmlString()%></a></span><br/>
							  	<v:itl key="@Common.DateTime"/> <span class="recap-value"><snp:datetime timestamp="<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.TransactionDateTime)%>" format="shortdatetime" timezone="local"/></span><br/>
							  	<span class="recap-value"><snp:datetime timestamp="<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.TransactionDateTime)%>" format="shortdatetime" timezone="location" location="<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.TransactionLocationAccountId)%>"/></span><br/>
			            <%
			              JvDateTime fiscalDateTime = ds.getField(QryBO_TransactionCrossPlatform.Sel.TransactionDateTime).getDateTime();
			            %>
			            <%
			              JvDateTime serialDateTime = ds.getField(QryBO_TransactionCrossPlatform.Sel.TransacrionSerialDateTime).getDateTime();
			            %>
			            <%
			              if (!JvDateTime.isSameDate(fiscalDateTime, serialDateTime)) {
			            %>
			              <v:itl key="@Sale.TransactionRealDateTime"/> <span class="recap-value" style="color:var(--base-red-color)"><snp:datetime timestamp="<%=serialDateTime%>" format="shortdatetime" timezone="location" location="<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.TransactionLocationAccountId)%>"/></span><br/>
			            <% } %>
			            <v:itl key="@Common.FiscalDate"/> <span class="recap-value"><%=pageBase.format(ds.getField(QryBO_TransactionCrossPlatform.Sel.TransactionFiscalDate), pageBase.getShortDateFormat())%></span><br/>
							  </v:widget-block>
							  <v:widget-block>
							    <v:itl key="@Common.Status"/><span class="recap-value"><%=LkSN.TransactionCrossPlatformStatus.getItemByCode(ds.getField(QryBO_TransactionCrossPlatform.Sel.Status).getInt()).getHtmlDescription()%></span><br/>
							    <v:itl key="@Common.Server"/>
							      <span class="recap-value">
							      <% if (ds.getField(QryBO_TransactionCrossPlatform.Sel.ServerId).isNull()) { %>
			                &mdash;
				            <% } else { %>
				              <%=ds.getField(QryBO_TransactionCrossPlatform.Sel.ServerName).getHtmlString()%>
				            <% } %>
				            </span>
			  	      </v:widget-block>
			  	    </v:widget>
			  	  </td>
			  	  <td width="50%" valign="top">
							<v:widget caption="@Common.Amount">
							  <v:widget-block>
			            <v:itl key="@Common.Quantity"/><span class="recap-value"><%=ds.getField(QryBO_TransactionCrossPlatform.Sel.TransactionTotQuantity).getHtmlString() %></span><br/>
			            <v:itl key="@Reservation.TotalAmount"/><span class="recap-value"><%=pageBase.formatCurrHtml(ds.getField(QryBO_TransactionCrossPlatform.Sel.TransactionTotAmount))%></span><br/>
			          </v:widget-block>
			  	    </v:widget>
			  	  </td>
			    </tr>
				</table>  	
			
				<v:grid>
			    <thead>
			      <v:grid-title caption="@Common.Items"/>
			      <tr>
			        <td width="50%">
			          <v:itl key="@Common.Name"/><br/>
			          <v:itl key="@Common.Code"/>
			        </td>
			        <td width="25%" align="right">
			          <v:itl key="@Common.Quantity"/>
			        </td>
			        <td width="25%" align="right">
			          <v:itl key="@Reservation.TotalAmount"/>
			        </td>
			      </tr>
			    </thead>
			    <tbody>
			      <v:grid-row dataset="<%=dsItems%>">
			        <td>
			          <%=dsItems.getField("ProductName").getHtmlString()%><br/>
			          <span class="list-subtitle"><%=dsItems.getField("ProductCode").getHtmlString()%><br/></span>
			    		</td>
			        <td align="right">
			          <%=dsItems.getField("Quantity").getHtmlString()%><br/>
			        </td>
			        <td align="right">
			          <%=pageBase.formatCurrHtml(dsItems.getField("TotAmount"))%><br/>
			        </td>
			      </v:grid-row>
			    </tbody>
			  </v:grid>
			</div>
		</div>
		<div id="tabs-message">
			<div class="tab-content">
				<%
			  Throwable error = null;
			  String msgRequest = JvString.getEmpty(pageBase.getDB().getString("select Message from tbTransactionCrossPlatform where TransactionCrossPlatformId=" + JvString.sqlStr(transactionCrossPlatformId)));
			  try {
			    if (msgRequest.startsWith("{"))
			      msgRequest = new JSONObject(msgRequest).toString(2);
			    else
			      msgRequest = JvDocUtils.docToHtml(msgRequest);
			  }
			  catch (Throwable t) {
			    error = t;
			  }
			  %>
			  
			  <% if (error != null) { %>
			    <div class="errorbox"><%=JvString.escapeHtml(JvUtils.getErrorMessage(error))%></div>
			  <% } %>
	  		<pre><%=msgRequest%></pre> 
			</div>
		</div>
  </div>
  
  
<script>
  var dlg = $("#xpi-transaction-dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Close" encode="JS"/>: doCloseDialog
    };
  });
  
  function showSale(saleId) {
	  var dlg = $("#xpi-transaction-dialog");
	  dlg.dialog("close");
	  window.location = "<v:config key="site_url"/>/admin?page=sale&id=" + saleId;
	}
  
</script>

</v:dialog>