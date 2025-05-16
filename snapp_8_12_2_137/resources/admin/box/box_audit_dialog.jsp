<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Plugin.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="box" class="com.vgs.snapp.dataobject.DOBox" scope="request"/>

<%
  String boxId = pageBase.getNullParameter("boxId");
  String foreingCurrencyPluginId = "";

  char strChar = '\'';
  
  JvDataSet ds = pageBase.getDB().executeQuery(
  "select" + JvString.CRLF +
  "  PL.PluginId," + JvString.CRLF +
  "  PPM.IconName as PaymentIconName," + JvString.CRLF +
//   "  CAST(PL.PluginSettings AS NVARCHAR(255)) as PluginSettings," + JvString.CRLF +
  "  PL.PluginEnabled as PluginEnabled," + JvString.CRLF +
  "  PL.PriorityOrder as PriorityOrder," + JvString.CRLF +
  "  Coalesce(PL.PluginName, D.DriverName) as PluginName," + JvString.CRLF +
  "  D.DriverType as DriverType," + JvString.CRLF +
  "  BDD.CurrencyISO as ISOCode," + JvString.CRLF +
  "  C.Symbol as Symbol," + JvString.CRLF +
  "  C.CurrencyFormat as CurrencyFormat," + JvString.CRLF +
  "  C.CurrencyType as CurrencyType," + JvString.CRLF +
  "  Sum(Coalesce(BDD.TotalAmount, 0)) as Amount" + JvString.CRLF +
  "from" + JvString.CRLF +
  "  tbPlugin PL inner join" + JvString.CRLF +
  "  tbPluginPaymentMethod PPM on PPM.PluginId=PL.PluginId left join" + JvString.CRLF +
  "  tbDriver D on D.DriverId=PL.DriverId left join" + JvString.CRLF + 
  "  tbBoxDeposit BD on BD.BoxId = '" + boxId + "' and BD.BoxDepositType=" + LkSNBoxDepositType.FinalClose.getCode() + " left join" + JvString.CRLF + 
  "  tbBoxDepositDetail BDD on BDD.PluginId=PL.PluginId and BDD.BoxDepositId=BD.BoxDepositId left join" + JvString.CRLF +
  "  tbCurrency C on C.ISOCode=BDD.CurrencyISO" + JvString.CRLF +
  "where" + JvString.CRLF +
  "  (D.DriverType in (" + JvArray.arrayToString(LkSNDriverType.getGroup(LkSNDriverType.GROUP_Payment), ",", strChar) + ")) AND" + JvString.CRLF + 
  "  (PL.PluginEnabled = 1)" + JvString.CRLF + 
  "group by" + JvString.CRLF + 
  "  PL.PluginId," + JvString.CRLF + 
  "  PL.PluginEnabled," + JvString.CRLF +
//   "  CAST(PL.PluginSettings AS NVARCHAR(255))," + JvString.CRLF +
  "  PPM.IconName," + JvString.CRLF +
  "  PL.PriorityOrder," + JvString.CRLF + 
  "  PL.PluginName," + JvString.CRLF +
  "  D.DriverType," + JvString.CRLF + 
  "  D.DriverName," + JvString.CRLF + 
  "  BDD.CurrencyISO," + JvString.CRLF + 
  "  C.Symbol," + JvString.CRLF + 
  "  C.CurrencyFormat," + JvString.CRLF +
  "  C.CurrencyType" + JvString.CRLF + 
  "order by" + JvString.CRLF +  
  "  PL.PriorityOrder");
  
  QueryDef qdef = new QueryDef(QryBO_Currency.class);
  //Select
  qdef.addSelect(QryBO_Currency.Sel.IconName);
  qdef.addSelect(QryBO_Currency.Sel.CurrencyType);
  qdef.addSelect(QryBO_Currency.Sel.ISOCode);
  qdef.addSelect(QryBO_Currency.Sel.Symbol);
  qdef.addSelect(QryBO_Currency.Sel.RoundDecimals);
  qdef.addSelect(QryBO_Currency.Sel.CurrencyName);
  qdef.addSelect(QryBO_Currency.Sel.CurrencyFormat);
  //Filter
  qdef.addFilter(QryBO_Currency.Fil.CurrencyType, LkCurrencyType.Foreign.getCode());
  //Sort
  qdef.addSort(QryBO_Currency.Sel.CurrencyType);
  qdef.addSort(QryBO_Currency.Sel.ISOCode);
  //Exec    
  JvDataSet dsFC = pageBase.execQuery(qdef);  

  Map<String, Long> mapFC = new HashMap<>(); // <ISOCode, Amount>
%>

<v:dialog id="box_audit_dialog" icon="box.png" title="@Box.Audit" width="800" height="700" autofocus="false">
<div class="tab-content">

  <v:grid id="paymentmethods-grid">
    <thead>
      <v:grid-title caption="@Payment.PaymentMethods"/>
    <tbody> 
      <v:ds-loop dataset="<%=ds%>">
      <%
        LookupItem driverTypeLookup = LkSN.DriverType.findItemByCode(ds.getField(Sel.DriverType));
        if (LkSNDriverType.ForeignCurrency.isLookup(driverTypeLookup)) {
          foreingCurrencyPluginId = ds.getField("PluginId").getString();
          System.out.println(ds.getField("ISOCode").getString() + " - " + ds.getField("Amount").getMoney());
          mapFC.put(ds.getField("ISOCode").getString(), ds.getField("Amount").getMoney());
        }
        else {
          String iconName;
          if (JvImageCache.iconExists(ds.getField("PaymentIconName").getString()))
            iconName = ds.getField("PaymentIconName").getString();
          else
            iconName = LkSNDriverType.getPaymentIconName(driverTypeLookup, ds.getField(Sel.PluginEnabled).getBoolean());
      %> 
          <tr class='grid-row' data-PaymentMethodId='<%=ds.getField(Sel.PluginId).getString()%>' data-CurrencyISOId='<%=pageBase.getSession().getMainCurrencyISO()%>' data-FinalCloseAmount='<%=ds.getField("Amount").getString()%>'>
            <td><v:grid-icon name="<%=iconName%>"/></td>
            <td width="70%">
              <%=JvMultiLang.translate(pageBase.getSession().getLang(), ds.getField(Sel.PluginName).getString())%><br/>
              <span class="list-subtitle"><%=driverTypeLookup.getDescription(pageBase.getLang())%></span>
            </td>
            <td width="30%">
              <%JvCurrency currFormatter = new JvCurrency(pageBase.getSession().getMainCurrencyFormat(), pageBase.getSession().getMainCurrencySymbol(), pageBase.getSession().getMainCurrencyISO(), pageBase.getSession().getMainCurrencyDecimals(), pageBase.getRights().DecimalSeparator.getString(), pageBase.getRights().ThousandSeparator.getString());%>
              <input type="text" class="txt-paymentamount form-control" placeholder="<%=currFormatter.formatHtml(ds.getField("Amount"))%>">
            </td>
          </tr>
      <% } %>
      </v:ds-loop>
    </tbody>
  </v:grid>
  
  <v:grid id="foreincurrencies-grid">
    <thead>
      <v:grid-title caption="@Payment.ForeignCurrencies"/>
    </thead>
    <tbody> 
      <v:ds-loop dataset="<%=dsFC%>">
        <tr class='grid-row' data-PaymentMethodId='<%=foreingCurrencyPluginId%>' data-CurrencyISOId='<%=dsFC.getField("ISOCode").getString()%>' data-FinalCloseAmount='<%=ds.getField("Amount").getString()%>'>
        <td><v:grid-icon name="<%=dsFC.getField(QryBO_Currency.Sel.IconName).getString()%>"/></td>
        <td width="70%">
          <%=dsFC.getField("CurrencyName").getHtmlString()%><br/>
          <span class="list-subtitle"><%=dsFC.getField("Symbol").getHtmlString()%></span>
        </td>
        <td width="30%">
          <%
          JvCurrency currFormatter = new JvCurrency(dsFC.getField("CurrencyFormat").getInt(), dsFC.getField("Symbol").getString(), dsFC.getField("ISOCode").getString(), dsFC.getField("RoundDecimals").getInt(), pageBase.getRights().DecimalSeparator.getString(), pageBase.getRights().ThousandSeparator.getString());
          Long finalCloseAmount = mapFC.get(dsFC.getField("ISOCode").getString());
          if (finalCloseAmount == null)
            finalCloseAmount = 0l;
          %>
          <input type="text" class="txt-paymentamount form-control" placeholder="<%=currFormatter.formatHtml(finalCloseAmount)%>">
        </td>
      </tr>
      </v:ds-loop>
    <tbody> 
  </v:grid>
</div>
<script>


$(document).ready(function() {
  var dlg = $("#box_audit_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: <v:itl key="@Common.Save" encode="JS"/>,
        click: doSaveAudit
      }, 
      {
        text: <v:itl key="@Common.Cancel" encode="JS"/>,
        click: doCloseDialog
      }                     
    ];
  });
  
});

function doSaveAudit() {

  var reqDO = {
    Command: "SaveAudit",
    SaveAudit: {
      BoxId: "<%=boxId%>",
      PaymentAuditList: []
    }
  };

  var trs = $("#paymentmethods-grid tbody tr");
  for (var i=0; i<trs.length; i++) {
    var tr = $(trs[i]);
    var paymentAmount = convertPriceValue(tr.find(".txt-paymentamount").val());
    if (paymentAmount != null)
      reqDO.SaveAudit.PaymentAuditList.push({
        PaymentMethodId: tr.attr("data-PaymentMethodId"),
        CurrencyISOId: tr.attr("data-CurrencyISOId"),
        FinalCloseAmount: tr.attr("data-FinalCloseAmount"),
        AuditAmount: paymentAmount
      });
  }
    
  trs = $("#foreincurrencies-grid tbody tr");
  for (var i=0; i<trs.length; i++) {
    var tr = $(trs[i]);
    var paymentAmount = convertPriceValue(tr.find(".txt-paymentamount").val());
    if (paymentAmount != null)   
      reqDO.SaveAudit.PaymentAuditList.push({
        PaymentMethodId: tr.attr("data-PaymentMethodId"),
        CurrencyISOId: tr.attr("data-CurrencyISOId"),
        FinalCloseAmount: tr.attr("data-FinalCloseAmount"),
        AuditAmount: paymentAmount
      });    
  }
  
  vgsService("Box", reqDO, false, function(ansDO) {
    $("#box_audit_dialog").dialog("close");
    showMessage(<v:itl key="@Common.SaveSuccessMsg" encode="JS"/>);
    triggerEntityChange(<%=LkSNEntityType.Box.getCode()%>, <%=JvString.jsString(boxId)%>);
  });
}
  
</script>
  
</v:dialog>
