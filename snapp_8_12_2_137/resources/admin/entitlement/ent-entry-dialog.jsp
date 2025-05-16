<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="ent-entry-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.Entry"/>">
  <v:widget caption="@Entitlement.PerfSelTitle">
    <v:widget-block>
      <v:lk-radio field="entry-type-radio" lookup="<%=LkSN.EntryType%>" inline="false" allowNull="false"/>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Common.Quantity">
        <v:input-text field="entry-qty-edit" placeholder="@Common.Unlimited"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>
