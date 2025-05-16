<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<style>

.firstusagerule-group {
  display: inline-block;
  margin-right: 20px;
}

</style>

<div id="ent-firstusagerule-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.FirstUsageRule"/>">
  <v:widget>
    <v:widget-block>
      <% for (LkSNFirstUsageRule.NRuleGroup group : LkSNFirstUsageRule.NRuleGroup.values()) { %>
        <div class="firstusagerule-group">
          <v:radio name="firstusagerule-group-radio" value="<%=group.getCode()%>" caption="<%=group.getRawTitle()%>"/>
        </div>
      <% } %>
    </v:widget-block>
  </v:widget>
  
  <v:widget>
    <v:widget-block>
      <table class="form-table">
        <tr valign="top">
          <td width="50%">
            <% for (LkSNFirstUsageRule.NRuleGroup group : LkSNFirstUsageRule.NRuleGroup.values()) { %>
              <div class="firstusagerule-group-container" data-group="<%=group.getCode()%>">
                <% for (LkSNFirstUsageRule.FirstUsageRuleItem item : group.getRules()) { %>
                  <div>
                    <label>
                      <input 
                        type="radio" 
                        name="firstusagerule-radio" 
                        data-hint="<%=JvString.escapeHtml(item.getRawHint())%>"
                        data-hasquantity="<%=item.hasOption(LkSNFirstUsageRule.NRuleOption.QUANTITY)%>"
                        data-hasdate="<%=item.hasOption(LkSNFirstUsageRule.NRuleOption.DATE)%>"
                        value="<%=item.getCode()%>"/>
                      
                      <%=item.getHtmlDescription(pageBase.getLang())%>
                    </label>
                  </div>           
                <% } %>
              </div>
            <% } %>
          </td>
          <td width="50%">
            <v:alert-box type="info" id="firstusagerule-hint"></v:alert-box>
          </td>
        </tr>
      </table>
    </v:widget-block>
  </v:widget>
  

  <v:widget id="quantity-container">
    <v:widget-block>
      <v:form-field caption="@Common.Quantity">
        <v:input-text field="firstusagerule-qty-edit" placeholder="@Common.Unlimited"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

  <v:widget id="date-container">
    <v:widget-block>
      <v:form-field caption="@Common.Date">
        <v:input-text type="datepicker" field="<%=JvUtils.newSqlStrUUID()%>" clazz="firstusagerule-date" placeholder="@Common.Unlimited" />
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>
