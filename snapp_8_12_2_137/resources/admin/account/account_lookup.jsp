<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="ds" scope="request" class="com.vgs.cl.JvDataSet"/>
<jsp:useBean id="pageBase" scope="request" class="com.vgs.web.page.PageAccountLookup"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<v:grid>
  <v:grid-row dataset="<%=ds%>">
    <input type="hidden" id="AccountId" value="<%=ds.getField(QryBO_Account.Sel.AccountId).getString()%>"/>
    <td><img src="<v:image-link name="<%=ds.getField(QryBO_Account.Sel.IconName).getString()%>" size="32"/>"/></td>
    <td width="100%">
      <%=pageBase.boldHighLight(ds.getField(QryBO_Account.Sel.DisplayName))%><br/>
      <span class="list-subtitle"><%=ds.getField(QryBO_Account.Sel.AccountCode).getHtmlString()%></span>
    </td>
  </v:grid-row>
</v:grid>

</html>