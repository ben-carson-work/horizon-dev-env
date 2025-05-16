<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.web.bko.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = pageBase.getRightCRUD().canUpdate(); %>

<v:tab-toolbar>
  <v:button id="btn-save-ppurule" fa="save" caption="@Common.Save" enabled="<%=canEdit%>"/>
  <v:button-group>
    <v:button id="btn-add-ppurule" fa="plus" caption="@Common.Add" enabled="<%=canEdit%>"/>
    <v:button id="btn-del-ppurule" fa="minus" caption="@Common.Remove" enabled="<%=canEdit%>"/>
  </v:button-group>
</v:tab-toolbar>

<v:tab-content>
  <v:grid id="ppurule-grid" style="table-layout:fixed">
    <thead>
      <tr>
        <td width="25px"><v:grid-checkbox header="true"/></td>
        <td width="50%"><v:itl key="@Event.Event"/></td>
        <td width="50%"><v:itl key="@Product.MembershipPoint"/></td>
        <td width="130px"><v:itl key="@Common.ValidFrom"/><v:hint-handle hint="@Common.PPURuleFromDateHint"/></td>
        <td width="130px"><v:itl key="@Common.ValidTo"/><v:hint-handle hint="@Common.PPURuleToDateHint"/></td>
        <td width="160px"><v:itl key="@Event.ActiveTimeFrom"/></td>
        <td width="160px"><v:itl key="@Event.ActiveTimeTo"/></td>
        <td width="100px"><v:itl key="@Common.Value"/></td>
      </tr>
    </thead>
    <tbody id="ppurule-tbody">
    </tbody>
  </v:grid>
</v:tab-content>

<div id="ppurule-templates" class="hidden">
  <table>
    <tr class="grid-row ppurule-row">
      <td><v:grid-checkbox/></td>
      <td><snp:dyncombo name="EventId" entityType="<%=LkSNEntityType.Event%>" clazz="ppurule-field" enabled="<%=canEdit%>"/></td>
      <td><snp:dyncombo name="MembershipPointId" entityType="<%=LkSNEntityType.WalletAndRewardPoint%>" clazz="ppurule-field" enabled="<%=canEdit%>"/></td>
      <td><v:date-picker name="ValidDateFrom" placeholder="@Common.Always" clazz="ppurule-field" template="true" enabled="<%=canEdit%>"/></td>
      <td><v:date-picker name="ValidDateTo" placeholder="@Common.Always" clazz="ppurule-field" template="true" enabled="<%=canEdit%>"/></td>
      <td><v:time-picker name="ValidTimeFrom" clazz="ppurule-field" enabled="<%=canEdit%>"/></td>
      <td><v:time-picker name="ValidTimeTo" clazz="ppurule-field" enabled="<%=canEdit%>"/></td>
      <td><v:input-text field="MembershipPointValue" clazz="ppurule-field" enabled="<%=canEdit%>"/></td>
    </tr>
  </table>
</div>


<script>

$(document).ready(function() {
  $("#btn-save-ppurule").click(_save);
  $("#btn-add-ppurule").click(_add);
  $("#btn-del-ppurule").click(_del);
  
  var $tbody = $("#ppurule-tbody");
  var $template = $("#ppurule-templates .ppurule-row");
  
  $tbody.docToGrid({
    "doc": <%=product.PPURuleList.getJSONString()%>,
    "template": $template
  });

  function _add(item) {
    $template.clone().appendTo($tbody);
  }
  
  function _del() {
    $tbody.find(".cblist:checked").closest("tr").remove();
  }
  
  function _save() {
    var reqDO = {
      Product: {
        ProductId: <%=JvString.jsString(pageBase.getId())%>,
        PPURuleList: $tbody.find("tr").gridToDoc({"fieldSelector":".ppurule-field"})
      }
    };
    
    snpAPI.cmd("Product", "SaveProduct", reqDO).then(ansDO => entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, ansDO.ProductId, "tab=ppurule"));
  }
});

</script>

