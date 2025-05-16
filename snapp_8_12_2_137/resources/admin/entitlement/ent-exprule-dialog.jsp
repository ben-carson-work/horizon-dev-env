<%@page import="com.vgs.cl.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.lookup.LkSNExpirationRule.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
List<LkSNExpirationRule.ExpRuleGroupBean> expGroupList = LkSNExpirationRule.findExpRuleGroupList();
%>

<style>

.exprule-group {
  display: inline-block;
  margin-right: 20px;
}

</style>

<div id="ent-exprule-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.ExpirationRule"/>">
  <v:widget>
  
    <v:widget-block>
      <div id="exprule-group-container">
        <% for (LkSNExpirationRule.ExpRuleGroupBean expGroup : expGroupList) {%>
          <div class="exprule-group" data-rootonly="<%=expGroup.isRootOnly()%>">
            <v:radio name="exprule-group-radio" value="<%=expGroup.getGroupId()%>" caption="<%=expGroup.getGroupRawTitle()%>"/>
          </div>
        <% }%>
      </div>
    </v:widget-block>
  </v:widget>
  
  <v:widget>
    <v:widget-block>
      <table class="form-table">
         <tr valign="top">
           <td width="50%">
             <% for (LkSNExpirationRule.ExpRuleGroupBean expGroup : expGroupList) {%>
                <div class="group-<%=expGroup.getGroupId()%>-items" data-groupid="<%=expGroup.getGroupId()%>">
 	                <% for (LookupItem item : expGroup.getItems()) {%>
 	                  <div class="exprule-item" data-groupid="<%=expGroup.getGroupId()%>">
 	                    <label>
 	                      <input 
 	                        type="radio" 
 	                        id="exprule-radio" 
 	                        name="exprule-radio" 
 	                        value="<%=item.getCode()%>"
 	                        data-groupid="<%=expGroup.getGroupId()%>" 
 	                        data-placeholder="<%=JvMultiLang.translate(pageBase.getLang(), ((LkSNExpirationRule.ExpRuleItem) item).getQtyPlaceHolder())%>"
 	                        data-defaultoption="<%=((LkSNExpirationRule.ExpRuleItem) item).isGroupDefaultItem()%>"
 	                      /> 
 	                    <%=item.getHtmlDescription(pageBase.getLang())%>    
 	                    </label><br/>
 	                  </div>
 	                <% }%>
 	              </div>
             <% }%>
           </td>
           <td width="50%">
             <v:alert-box type="info" id="exprule-hint"></v:alert-box>
           </td>
         </tr>
      </table>
    </v:widget-block>

    <v:widget-block id="exprule-firstusagefromnode-tr">
      <v:db-checkbox field="exprule-firstusagefromnode" value="true" caption="@Entitlement.ExpRuleFirstUsageFromNode" hint="@Entitlement.ExpRuleFirstUsageFromNodeHint"/>
    </v:widget-block>
    
  </v:widget>
  
  <v:widget id="exprule-qty-tr">
    <v:widget-block>
      <v:form-field caption="@Common.Quantity">
        <v:input-text field="exprule-qty-edit" placeholder="@Common.Unlimited"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

  <% for (LookupItem item : LkSN.ExpirationRule.getItems()) {%>
    <div id="exprule-<%=item.getCode()%>-hint" class="hidden"><v:itl key="<%=item.getRawHint()%>"/></div>
  <% }%>
</div>
