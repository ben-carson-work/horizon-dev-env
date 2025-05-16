<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="msg" class="com.vgs.snapp.dataobject.DOMessage" scope="request"/>
<% boolean canEdit = rights.SettingsMessages.getBoolean(); %>

<div class="tab-content">
	<v:widget caption="@Common.General">
	  <v:widget-block>
	    <v:form-field caption="@Common.Name" mandatory="true">
	      <v:input-text field="msg.MessageName" enabled="<%=canEdit%>"/>
	    </v:form-field>
       <v:form-field caption="@Category.Category" mandatory="true">
          <v:combobox field="msg.CategoryId" lookupDataSet="<%=pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.Message)%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName" enabled="<%=canEdit%>"/>
       </v:form-field>
    </v:widget-block>
    <% if (!msg.MessageId.isNull()) { %>
      <v:widget-block>
        <v:form-field caption="@Common.CreatedBy">
          <snp:entity-link entityId="<%=msg.CreateUserAccountId%>" entityType="<%=LkSNEntityType.Person%>">
            <%=msg.CreateUserAccountName.getHtmlString()%>
          </snp:entity-link>
        </v:form-field>
        <v:form-field caption="@Common.DateTime">
          <snp:datetime timestamp="<%=msg.CreateDateTime%>" timezone="local" format="shortdatetime"/>
        </v:form-field>
      </v:widget-block>
    <% } %>
    <v:widget-block>
	    <v:form-field caption="@Common.From" mandatory="true">
	      <v:input-text type="datetimepicker" field="msg.DateTimeFrom" enabled="<%=canEdit%>"/>
	    </v:form-field>
	    <v:form-field caption="@Common.To">
	      <v:input-text type="datetimepicker" field="msg.DateTimeTo" enabled="<%=canEdit%>"/>
	    </v:form-field>
    </v:widget-block>
	  <v:widget-block>
	    <v:db-checkbox caption="@Common.MessageForcePopupDialog" value="true" field="msg.ForcePopupDialog" enabled="<%=canEdit%>"/><br/>
	    <v:db-checkbox caption="@Common.Enabled" value="true" field="msg.Enabled" enabled="<%=canEdit%>"/>
	  </v:widget-block>
	</v:widget>
</div>
