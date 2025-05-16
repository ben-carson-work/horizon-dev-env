<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<div id="ent-period-constraint-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.PeriodConstraint"/>">
  <v:widget>
    <v:widget-block>
      <table class="form-table">
        <tr valign="top">
          <td width="34%">
            <v:lk-radio lookup="<%=LkSN.PeriodType%>" field="period-constraint-radio" allowNull="false" inline="false"/>
          </td>
          <td width="64%">
            <v:alert-box type="info"><v:itl key="@Entitlement.PeriodConstraintHint"/></v:alert-box>
          </td>
        </tr>
      </table>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field caption="@Common.Quantity">
        <v:input-text field="period-constraint-qty-edit" placeholder="@Common.Unlimited" />
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>
