<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="ent-walletinitialdeposit-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.WalletInitialDeposit"/>">
  <v:widget>
    <v:widget-block id="block-inherit-from-price">
      <v:db-checkbox field="wallet-inherit-from-price" caption="@Entitlement.InheritFromSalePrice" hint="@Entitlement.InheritFromSalePriceHint" value="true"/>
    </v:widget-block>
    <v:widget-block id="block-wallet-deposit-amount">
      <v:form-field caption="@Common.Amount">
        <v:input-text field="wallet-initial-deposit-edit"/>
      </v:form-field>
    </v:widget-block>
	</v:widget>
</div>
