<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.query.*"%>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
%>

<div id="ent-perfbaseddays-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.PerfValidity"/>">

  <v:widget>

    <v:widget-block>
      <v:db-checkbox field="perfmatch" value="true" caption="@Entitlement.PerfMatch" hint="@Entitlement.PerfMatchHint"/>
    </v:widget-block>
  
    <v:widget-block id="perfdays-widget">
      <v:form-field caption="@Entitlement.PerfStartDaysShort" hint="@Entitlement.PerfStartDaysHint">
        <v:input-text field="perfstartdays-qty-edit" placeholder="@Ticket.EncodeDateTime"/>
      </v:form-field>
    
      <v:form-field caption="@Entitlement.PerfExpDaysShort" hint="@Entitlement.PerfExpDaysHint">
        <input type="text" class="form-control" id="perfexpdays-qty-edit"/>
      </v:form-field>
    </v:widget-block>

  </v:widget>

</div>
