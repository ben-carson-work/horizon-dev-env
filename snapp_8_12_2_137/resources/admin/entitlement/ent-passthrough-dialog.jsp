<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>


<div id="ent-passthrough-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.Passthrough"/>">
  <v:widget>
    <v:widget-block>
      <v:form-field caption="@Common.Type">
        <% for (LookupItem item : LkSN.SubEventPassthroughType.getItems()) { %>
          <label class="checkbox-label"><input type="radio" name="radio-passthrough" value="<%=item.getCode()%>"/> <%=item.getDescription(pageBase.getLang())%></label>
          &nbsp;&nbsp;&nbsp;
        <% } %>
      </v:form-field>
    </v:widget-block>
  
    <v:widget-block id="passthrough-tolerance" clazz="hidden">
      <v:form-field caption="@Entitlement.PassthroughToleranceStart">
        <input type="text" id="passthrough-tolstart-edit" class="form-control" placeholder="0"/>
      </v:form-field>
      
      <v:form-field caption="@Entitlement.PassthroughToleranceEnd">
        <input type="text" id="passthrough-tolend-edit" class="form-control" placeholder="0"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>
