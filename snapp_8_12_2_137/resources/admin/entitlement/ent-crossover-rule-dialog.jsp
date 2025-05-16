<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<div id="ent-crossover-rule-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.CrossoverRule"/>">
  <v:widget>
    <v:widget-block>
      <table class="form-table">
        <tr valign="top">
          <td width="34%">
          <% for (LookupItem item : LkSN.CrossoverRule.getItems()) { %>
            <label>
              <input 
                  type="radio" 
                  id="crossover-rule-radio" 
                  name="crossover-rule-radio" 
                  value="<%=item.getCode()%>"
                  data-rawhint="<%=item.getRawHint()%>"/>
                  
              <%=item.getDescription(pageBase.getLang())%>
            </label><br/>           
          <% } %>
          </td>
          <td width="64%">
            <v:alert-box id="crossover-rule-hint" type="info"></v:alert-box>
          </td>
        </tr>
      </table>
    </v:widget-block>
  </v:widget>
</div>
