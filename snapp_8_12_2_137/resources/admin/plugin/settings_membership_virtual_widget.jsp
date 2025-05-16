<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:grid id="grid-virual-membership">
  <thead>
    <v:grid-title caption="Virtual cards"/>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td width="35%">Member No</td>
      <td width="35%">Guest name</td>
      <td width="30%">Balance</td>
      <td>Active</td>
    </tr>
  </thead>
  <tbody id="tbody-cards">
  </tbody>
  <tbody>
    <tr>
      <td colspan="100%">
        <v:button id="btn-card-add" fa="plus" caption="@Common.Add"/>
        <v:button id="btn-card-del" fa="minus" caption="@Common.Remove"/>
      </td>
    </tr>
  </tbody>
</v:grid>

<div id="virtual-membership-templates" class="hidden">
  <v:grid>
    <tr class="virtual-card">
      <td><v:grid-checkbox header="false"/></td>
      <td><v:input-text clazz="card-memberno"/></td>
      <td><v:input-text clazz="card-guestname"/></td>
      <td><v:input-text clazz="card-balance"/></td>
      <td align="center"><v:db-checkbox clazz="card-active" field="" value="true" caption=""/></td>
    </tr>
  </v:grid>
</div>

<script>

$(document).ready(function() {
  var $templates = $("#virtual-membership-templates");
  var $rowTemplate = $templates.find(".virtual-card");
  var $grid = $("#grid-virual-membership");
  var $tbody = $grid.find("#tbody-cards");
  
  $grid.find("#btn-card-add").click(_doAdd);
  $grid.find("#btn-card-del").click(_doDel); 

  function _doAdd(card) {
    card = card || {};
    var $card = $rowTemplate.clone().appendTo($tbody);
    $card.find(".card-memberno").val(card.MemberNo);
    $card.find(".card-guestname").val(card.GuestName);
    $card.find(".card-active").setChecked(card.Active);
    $card.find(".card-balance").val(card.Balance);
  }
  
  function _doDel() {
    $grid.find(".cblist:checked").closest(".virtual-card").remove();
  }
  
  $(document).von($grid, "plugin-settings-load", function(event, params) {
    var settings = params.settings || {};
    for (const card of (settings.CardList || []))
      _doAdd(card);
  });
  
  $(document).von($grid, "plugin-settings-save", function(event, params) {
    var cards = [];
    $("#grid-virual-membership .virtual-card").each(function(index, elem) {
      var $card = $(elem);
      
      var balance = parseFloat($card.find(".card-balance").val().replace(",", "."));
      if (isNaN(balance))
        throw "Invalid amount: " + $card.find(".card-balance").val();
      
      cards.push({
        "MemberNo": $card.find(".card-memberno").val(),
        "GuestName": $card.find(".card-guestname").val(),
        "Balance": balance,
        "Active": $card.find(".card-active").isChecked()
      });
    });
    
    params.settings = {
      "CardList": cards
    };
  });
});

</script>
