<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:include page="/resources/admin/product/product_suspend_dialog_js.jsp"/>

<%
DOProduct product = SrvBO_OC.getProduct(pageBase.getConnector(), pageBase.getId(), true).Product;
boolean canEdit = !pageBase.isParameter("ReadOnly", "true");
boolean canAdd = (product.ProductSuspendList.getSize() == 0) || !product.ProductSuspendList.getItem(0).SuspendDateTo.isNull();
%>

<div id="suspend_edit_dialog" class="v-hidden tab-content">
  <v:widget>
    <v:widget-block>
      <v:form-field caption="@Common.FromDate">
        <v:input-text type="datepicker" field="SuspendFrom" placeholder="@Common.Unlimited"/>
      </v:form-field>
      <v:form-field caption="@Common.ToDate">
        <v:input-text type="datepicker" field="SuspendTo" placeholder="@Common.Unlimited"/>
      </v:form-field>
    </v:widget-block>  
  </v:widget>
</div>

<v:dialog id="suspend-dialog" width="1000" height="600" title="@Product.Suspensions">
  <v:alert-box type="info" title="@Common.Info"><v:itl key="@Product.SuspensionHint"/></v:alert-box>
  
  <v:grid id="suspend-grid">
    <tr class="header">
      <td width="40%">
        <v:itl key="@From"/>
      </td>
      <td width="40%">
        <v:itl key="@To"/> 
      </td> 
      <td alisgh="right" width="20%"></td>
    </tr>
    <tbody id="suspend-body">
    </tbody>
  </v:grid>

<script>

<%for (DOProductSuspend item : product.ProductSuspendList) {%>
  <% boolean editable = canEdit && (item.SuspendDateFrom.getDateTime().isAfter(JvDateTime.now().getDatePart()) || item.SuspendDateTo.isNull() || item.SuspendDateTo.getDateTime().isAfterOrEquals(JvDateTime.now().getDatePart()));%>
  <% String dateFrom = pageBase.format(item.SuspendDateFrom, pageBase.getShortDateFormat()); %>
  <% String dateTo = item.SuspendDateTo.isNull() ? pageBase.getLang().Common.Unlimited.getHtmlText() : pageBase.format(item.SuspendDateTo, pageBase.getShortDateFormat()); %>
  addSuspendItem(<%=item.ProductSuspendId.getJsString()%>, <%=JvString.jsString(dateFrom)%>, <%=JvString.jsString(dateTo)%>, <%=item.getJSONString()%>, <%=editable%>);
<% } %>

var dlg = $("#suspend-dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    Save : {
      text: itl("@Common.Add"),
      disabled: <%=!canEdit%> || <%=!canAdd%>,
      click: suspendDlg
    },
    Cancel : {
      text: itl("@Common.Close"),
      click: doCloseDialog
    }
  };
});

</script>  

</v:dialog>