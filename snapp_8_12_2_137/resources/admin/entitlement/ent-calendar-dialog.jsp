<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<div id="ent-calendar-dialog" class="ent-dialog" title="<v:itl key="@Common.Calendar"/>">
  <v:form-field caption="@Common.Calendar">
    <snp:dyncombo field="cal-id-combo" entityType="<%=LkSNEntityType.Calendar%>"/>
  </v:form-field>
</div>
