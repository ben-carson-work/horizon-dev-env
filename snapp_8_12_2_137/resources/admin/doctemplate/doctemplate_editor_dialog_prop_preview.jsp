<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% JvDataSet dsParam = pageBase.getDB().executeQuery("select * from tbDocParam where DocTemplateId=" + JvString.sqlStr(pageBase.getId()) + " order by DocParamName"); %>

<form id="docproc_form" action="<v:config key="site_url"/>/admin?page=docTemplate&id=<%=pageBase.getId()%>&action=preview" method="post" target="preview_iframe">
  <textarea id="preview-json" class="hidden-textarea" name="document"></textarea>
  <input id="media-code-input" name="mediaCode" type="hidden">
  
  <% if (dsParam.isEmpty()) { %>
    <span class="list-subtitle">No parameters</span>
  <% } else { %>
    <v:ds-loop dataset="<%=dsParam%>">
      <%
      LookupItem paramType = LkSN.MetaFieldDataType.getItemByCode(dsParam.getField("DocParamType"));
      String paramCaption = dsParam.getField("DocParamCaption").isNull(dsParam.getField("DocParamName").getString()); 
      String defaultValue = pageBase.getBL(BLBO_DocTemplate.class).decodeParamDefaultValue(dsParam.getField("DocParamDefault").getString());
      boolean readOnly = false;
      boolean visible = true;
      String paramName = "p_" + dsParam.getField("DocParamName").getHtmlString();
      if (pageBase.hasParameter(paramName)) {
        readOnly = pageBase.isParameter("lock_in_params", "true");
        defaultValue = pageBase.getParameter(paramName);
        visible = !paramType.isLookup(LkSNMetaFieldDataType.Text) || !JvUtils.isValidUUID(defaultValue);
      }
      else {
        for (Cookie c : request.getCookies()) {
          if (paramName.equalsIgnoreCase(c.getName())) {
            defaultValue = c.getValue();
            break;
          }
        }
      }
      request.setAttribute(paramName, defaultValue);
      
      String sReadOnly = readOnly ? " readonly=\"readonly\"" : "";
      String sDisabled = readOnly ? " disabled=\"disabled\"" : "";
      %>
      <div class="<%=visible?"":"v-hidden"%>">
        <v:form-field caption="<%=paramCaption%>">
          <% if (paramType.isLookup(LkSNMetaFieldDataType.Text, LkSNMetaFieldDataType.Numeric)) { %>
            <input type="text" class="param-item" name="<%=paramName%>" value="<%=defaultValue%>" <%=sReadOnly%>>
          <% } else if (paramType.isLookup(LkSNMetaFieldDataType.Date)) { %>
            <v:input-text type="datepicker" clazz="param-item snp-high-zindex" field="<%=paramName%>" enabled="<%=!readOnly%>" />
          <% } else if (paramType.isLookup(LkSNMetaFieldDataType.DateTime)) { %>
            <v:input-text type="datetimepicker" clazz="param-item snp-high-zindex" field="<%=paramName%>" enabled="<%=!readOnly%>"/>
          <% } else if (paramType.isLookup(LkSNMetaFieldDataType.Boolean)) { %>
            <label><input type="radio" class="param-item" name="<%=paramName%>" value="true" <%=sReadOnly%>/> <v:itl key="@Common.Yes"/></label>
            &nbsp;
            <label><input type="radio" class="param-item" name="<%=paramName%>" value="false" <%=sReadOnly%>/> <v:itl key="@Common.No"/></label>
          <% } else if (paramType.isLookup(LkSNMetaFieldDataType.Location)) { %>
            <snp:dyncombo field="<%=paramName%>" entityType="<%=LkSNEntityType.Location%>" entityId="<%=defaultValue%>" clazz="param-item"/>
          <% } else if (paramType.isLookup(LkSNMetaFieldDataType.User)) { %>
            <snp:dyncombo field="<%=paramName%>" entityType="<%=LkSNEntityType.User%>" entityId="<%=defaultValue%>" clazz="param-item"/>
          <% } else if (paramType.isLookup(LkSNMetaFieldDataType.OpArea)) { %>
            <snp:dyncombo field="<%=paramName%>" entityType="<%=LkSNEntityType.OperatingArea%>" entityId="<%=defaultValue%>" clazz="param-item" parentComboId="p_LocationId"/>
          <% } else if (paramType.isLookup(LkSNMetaFieldDataType.Workstation)) { %>
            <snp:dyncombo field="<%=paramName%>" entityType="<%=LkSNEntityType.Workstation%>" entityId="<%=defaultValue%>" clazz="param-item" parentComboId="p_OpAreaId"/>
          <% } else if (paramType.isLookup(LkSNMetaFieldDataType.SiaePerformance)) { %>
            <snp:dyncombo field="<%=paramName%>" entityType="<%=LkSNEntityType.SiaePerformance%>" entityId="<%=defaultValue%>" clazz="param-item"/>
          <% } else { %>
            <I>   [<%=paramType.getCode()%>] <%=paramType.getHtmlDescription(pageBase.getLang())%></I>
          <% } %>
        </v:form-field>
      </div>
    </v:ds-loop>
  <% } %>
</form>
