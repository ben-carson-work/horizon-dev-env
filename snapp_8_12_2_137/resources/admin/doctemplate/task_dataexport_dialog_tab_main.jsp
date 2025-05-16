<%@page import="com.vgs.snapp.dataobject.task.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.snapp.web.common.page.PageCommonWidget"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>
<jsp:useBean id="docTemplate" class="com.vgs.snapp.dataobject.DODocTemplate" scope="request"/>
<jsp:useBean id="cfg" class="com.vgs.snapp.dataobject.task.DOTask_DataExport" scope="request"/>

<%
JvDataSet dsDataSource = pageBase.getBL(BLBO_DataSource.class).getDataSourceDS(LkSNDataSourceType.Reporting);
boolean allowDifferentialExport = docTemplate.ParamList.contains(param -> param.DocParamType.isLookup(LkSNMetaFieldDataType.EntityChangeId, LkSNMetaFieldDataType.LastUpdate));
int maxDateRange = pageBase.getBL(BLBO_DocTemplate.class).loadDocTemplate(cfg.DocTemplateId.getString()).MaxDateRangeDays.getInt();
%>

<div class="tab-content">
  <v:widget caption="<%=cfg.DataExportOption.getLkValue().getRawDescription()%>">
    <% if (cfg.DataExportOption.isLookup(LkSNDataExportOption.Folder)) { %>
      <v:widget-block>
        <v:form-field caption="@Common.Name" mandatory="true">
          <v:input-text field="task.TaskName"/>
        </v:form-field>
        <v:form-field caption="@Common.Folder" mandatory="true">
          <v:input-text field="cfg.ExportFolder"/>
        </v:form-field>
      </v:widget-block>
    <% } else if (cfg.DataExportOption.isLookup(LkSNDataExportOption.Email) && !docTemplate.DocTemplateType.isLookup(LkSNDocTemplateType.AdvancedNotification)) { %>      
      <v:widget-block>
        <v:form-field caption="@Task.EmailPurgeDays" hint="@Task.EmailPurgeDaysHint">
          <v:input-text field="cfgemail.PurgeDays" placeholder="@Common.Default"/>
        </v:form-field>
        <v:db-checkbox field="cbQuery" value="true" caption="@DocTemplate.DataSource" hint="@DocTemplate.TaskDataExportQueryHint" checked="<%=cfg.Query.getNullString(true) != null%>"/>
      </v:widget-block>
    <% } else if (cfg.DataExportOption.isLookup(LkSNDataExportOption.FTP)) { %>      
      <v:widget-block>
        <v:form-field caption="@Common.Name" mandatory="true">
          <v:input-text field="task.TaskName"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <jsp:include page="../common/ftp_config_widget.jsp"></jsp:include>
      </v:widget-block>
    <% } %>
    <v:widget-block>
      <v:db-checkbox field="cbEnabled" value="true" caption="@Common.Enabled" checked="<%=task.TaskStatus.isLookup(LkSNTaskStatus.Active)%>"/>
      <% if (allowDifferentialExport) { %>
      
        <v:form-field checkBoxField="cfg.DifferentialExport" caption="@Task.DifferentialExport" hint="@Task.DifferentialExportHint">
          <% if (!task.TaskId.isNull()) { %>
            &nbsp;
            Last entity change: <span id="LastEntityChangeId-Value"><%=task.LastEntityChangeId.getLong()%></span>
            &nbsp;
            (<a href="javascript:doRefreshLastEntityChangeId()"><v:itl key="@Common.Refresh"/></a> | <a href="javascript:doResetLastEntityChangeId()"><v:itl key="@Common.Reset"/></a>)
            <br/>
            &nbsp;
            Last update: <span id="LastUpdate-Value">
            <% if (task.LastUpdate.isNull()) { %>
              Never
            <% } else { %>    
              <%=task.LastUpdate.getDateTime()%>
            <% } %>
            </span>
            &nbsp;
            (<a href="javascript:doRefreshLastUpdate()"><v:itl key="@Common.Refresh"/></a> | <a href="javascript:doResetLastUpdate()"><v:itl key="@Common.Reset"/></a>)
          <% } %>
        </v:form-field>
      <% } %>
    </v:widget-block>
  </v:widget>
  
  <%!
  private String getParamValue(DOTask_DataExport cfg, String paramName) {
    for (DOTask_DataExport.DOParam param : cfg.ParamList)
      if (param.ParamName.isSameString(paramName))
        return param.ParamValue.getString();
    return null;
  }
  %>

  <v:widget caption="@Common.Parameters">
    <% if (!dsDataSource.isEmpty()) { %>
      <v:widget-block>
        <v:form-field caption="@Common.DataSource">
          <v:combobox field="cfg.DataSourceId" lookupDataSet="<%=dsDataSource%>" captionFieldName="DataSourceName" idFieldName="DataSourceId"/>
        </v:form-field>
      </v:widget-block>
    <% } %>
    <v:widget-block>
    <% for (DODocTemplate.DODocParam param : docTemplate.ParamList) { %>
      <% if (!param.DocParamType.isLookup(LkSNMetaFieldDataType.EntityChangeId, LkSNMetaFieldDataType.LastUpdate)) { %>
        <% String paramName = param.DocParamName.getString(); %>
        <% String paramValue = getParamValue(cfg, paramName); %>
        <% boolean mandatory = (param.DocParamType.isLookup(LkSNMetaFieldDataType.Date) && maxDateRange > 0) ? true : param.Mandatory.getBoolean(); %>
        <% String fieldHint = param.DocParamType.isLookup(LkSNMetaFieldDataType.Date) ? pageBase.getBL(BLBO_Task.class).getDateParamHint() : null; %>
        
        <v:form-field caption="<%=param.DocParamCaption.getString()%>" hint="<%=fieldHint%>" mandatory="<%=mandatory%>" >
        <% if (param.DocParamType.isLookup(LkSNMetaFieldDataType.Location)) { %>
            <snp:dyncombo 
                entityType="<%=LkSNEntityType.Location%>"
                entityId="<%=paramValue%>" 
                auditLocationFilter="true" 
                allowNull="<%=rights.AuditLocationFilter.isLookup(LkSNAuditLocationFilter.All) && !mandatory%>"
                name="<%=paramName%>" 
                clazz="param-item"
            />
        <% } else if (param.DocParamType.isLookup(LkSNMetaFieldDataType.User)) { %>
            <snp:dyncombo 
                entityType="<%=LkSNEntityType.User%>"
                entityId="<%=paramValue%>" 
                allowNull="<%=!mandatory%>"
                name="<%=paramName%>" 
                clazz="param-item"
            />
        <% } else if (param.DocParamType.isLookup(LkSNMetaFieldDataType.OpArea)) { %>
            <snp:dyncombo 
                entityType="<%=LkSNEntityType.OperatingArea%>"
                entityId="<%=paramValue%>" 
                auditLocationFilter="true" 
                allowNull="<%=!mandatory%>"
                name="<%=paramName%>" 
                parentComboId="p_LocationId"
                clazz="param-item"
            />
        <% } else if (param.DocParamType.isLookup(LkSNMetaFieldDataType.Workstation)) { %>
            <snp:dyncombo 
                entityType="<%=LkSNEntityType.Workstation%>"
                entityId="<%=paramValue%>" 
                auditLocationFilter="true" 
                allowNull="<%=!mandatory%>"
                name="<%=paramName%>" 
                parentComboId="p_OpAreaId"
                clazz="param-item"
            />
        <% } else if (param.DocParamType.isLookup(LkSNMetaFieldDataType.Catalog)) { %>
            <snp:dyncombo 
                entityType="<%=LkSNEntityType.Catalog%>" 
                entityId="<%=paramValue%>" 
                allowNull="<%=!mandatory%>"
                name="<%=paramName%>" 
                clazz="param-item" 
            />
        <% } else if (param.DocParamType.isLookup(LkSNMetaFieldDataType.Tag_ProductType)) { %>
            <snp:dyncombo
                entityType="<%=LkSNEntityType.Tag_ProductType%>"
                entityId="<%=paramValue%>"
                allowNull="<%=!mandatory%>"
                name="<%=paramName%>" 
                clazz="param-item" 
            />
        <% } else if (param.DocParamType.isLookup(LkSNMetaFieldDataType.Organization)) { %>
	          <snp:dyncombo 
	              entityType="<%=LkSNEntityType.Organization%>"
	              entityId="<%=paramValue%>"
                allowNull="<%=!mandatory%>" 
	              name="<%=paramName%>" 
	              clazz="param-item" 
	          />
        <% } else if (param.DocParamType.isLookup(LkSNMetaFieldDataType.PaymentMethod)) { %>
             <%System.out.println(paramValue);%>
            <snp:dyncombo 
                entityType="<%=LkSNEntityType.PaymentMethod%>" 
                entityId="<%=paramValue%>" 
                allowNull="<%=!mandatory%>"
                name="<%=paramName%>" 
                clazz="param-item" 
            />
         <% } else if (param.DocParamType.isLookup(LkSNMetaFieldDataType.SiaePerformance)) { %>
          <snp:dyncombo 
              entityType="<%=LkSNEntityType.SiaePerformance%>" 
              entityId="<%=paramValue%>" 
              allowNull="<%=!mandatory%>"
              name="<%=paramName%>" 
              clazz="param-item" 
          />
        <% } else { %>
          <%
          String listAttr = param.DocParamType.isLookup(LkSNMetaFieldDataType.Date) ? "list='DocDateEncode'" : "";
          String clazz = "param-item form-control ";
          String placeholder = "";
          if(param.DocParamType.isLookup(LkSNMetaFieldDataType.Date)){
          	clazz += paramName.indexOf("DateFrom") >= 0 ? "range-field-from" : paramName.indexOf("DateTo") >= 0 ? "range-field-to" : "";
            placeholder = "placeholder=\"" + JvString.escapeHtml(pageBase.getLang().Task.DateParamPlaceholder.getText()) + "\"";
          }
          %>
          <input type="text" name="<%=paramName%>" class="<%=clazz%>" value="<%=JvString.escapeHtml(paramValue)%>" <%=placeholder%> <%=listAttr%>/>
        <% } %>
        </v:form-field>
      <% } %>
    <% } %>
    </v:widget-block>
  </v:widget>

</div>

<script>
  function doRefreshLastEntityChangeId() {
    var reqDO = {
      Command: "GetLastEntityChangeId",
      GetLastEntityChangeId: {
        TaskId: <%=task.TaskId.getSqlString()%>
      }
    };
    
    vgsService("Task", reqDO, false, function(ansDO) {
      $("#LastEntityChangeId-Value").text(ansDO.Answer.GetLastEntityChangeId.LastEntityChangeId);
    });
  }
  
  function doResetLastEntityChangeId() {
    var reqDO = {
      Command: "ResetLastEntityChangeId",
      ResetLastEntityChangeId: {
        TaskId: <%=task.TaskId.getSqlString()%>
      }
    };
    
    vgsService("Task", reqDO, false, function(ansDO) {
      $("#LastEntityChangeId-Value").text("0");
    });
  }
  
  function doRefreshLastUpdate() {
	  var reqDO = {
	    Command: "GetLastUpdate",
	    GetLastUpdate: {
	      TaskId: <%=task.TaskId.getSqlString()%>
	    }
	  };
	    
	  vgsService("Task", reqDO, false, function(ansDO) {
		  if (ansDO.Answer.GetLastUpdate.LastUpdate)
	      $("#LastUpdate-Value").text(ansDO.Answer.GetLastUpdate.LastUpdate);
		  else
			  $("#LastUpdate-Value").text("Never");
	  });
	}
  
  function doResetLastUpdate() {
    var reqDO = {
      Command: "ResetLastUpdate",
      ResetLastUpdate: {
        TaskId: <%=task.TaskId.getSqlString()%>
      }
    };
    
    vgsService("Task", reqDO, false, function(ansDO) {
      $("#LastUpdate-Value").text("Never");
    });
  }
</script>

