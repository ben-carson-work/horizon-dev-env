<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>
<%
JvDocument cfg = (JvDocument)request.getAttribute("cfg");
request.setAttribute("cfgftp", cfg.getChildNode("FtpConfig"));
%>

<%
QueryDef qdef = new QueryDef(QryBO_Workstation.class);
// Select
qdef.addSelect(
    QryBO_Workstation.Sel.IconName,
    QryBO_Workstation.Sel.WorkstationId,
    QryBO_Workstation.Sel.WorkstationCode,
    QryBO_Workstation.Sel.WorkstationName);
// Filter
qdef.addFilter(QryBO_Workstation.Fil.WorkstationType, LkSNWorkstationType.WEB.getCode());
// Sort
qdef.addSort(QryBO_Workstation.Sel.WorkstationName);
// Paging

// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType);
request.setAttribute("dsTag", dsTag);
%>

<v:widget caption="Info">
  <v:widget-block>
    <p>
      The purpose of this task is to import account details <b>(account must already exists)</b> from <b>csv</b> files.</br>
      Task will process all the .csv files in the configured folder  
    </p>
    <p>
      First row of file must contain column names. <br/>
      Each file contains a list of <b>Accounts</b>, one per line.<br/>
      Files are encoded in UTF-8.<br/>
    </p>
    <p>
    	File <b>must have</b> column <b>User ID</b> with a valid Account Code, used to identify account to update</br>
    	Column <b>Badge ID</b> if valued will enable the possibility to login into the system using badge specified into the column</br>
    	Column <b>TKTUserName</b> is the login name, if valued will enable the possibility to login into the system using this as username</br>
    	Column <b>SKU</b> is the product code of the product that has to be added to account's portfolio, if it is blank all special product into the portfolio will be blocked</br>
    	Column <b>Email Address-Business</b> is the Account email address </br>
    	</br>Below table describes mapping between the file column names, that the task is expecting, and Snapp meta fields</br>
    </p>
    <table>
        <tr>
            <th>Column name</th>
            <th>Snapp Metafield name</th>
        </tr>
        <tr>
            <td>First Name-Personal Information</td>
            <td style="text-align:center;">FT1</td>
        </tr>
        <tr>
            <td>Last Name-Personal Information</td>
            <td style="text-align:center;">FT3</td>
        </tr>
        <tr>
            <td>Gender-Personal Information</td>
            <td style="text-align:center;">FT19</td>
        </tr>
        <tr>
            <td>Company Name-EN</td>
            <td style="text-align:center;">FT31</td>
        </tr>
        <tr>
            <td>National ID</td>
            <td style="text-align:center;">FT63</td>
        </tr>
        <tr>
            <td>Grade Range</td>
            <td style="text-align:center;">GRADE-RANGE</td>
        </tr>
        <tr>
            <td>Position</td>
            <td style="text-align:center;">POSITION-CODE</td>
        </tr>
        <tr>
            <td>Position Title-EN</td>
            <td style="text-align:center;">POSITION-TITLE</td>
        </tr>
        <tr>
            <td>Supervisor</td>
            <td style="text-align:center;">SUPERVISOR</td>
        </tr>
        <tr>
            <td>Company</td>
            <td style="text-align:center;">COMPANY-CODE</td>
        </tr>
        <tr>
            <td>Business Unit</td>
            <td style="text-align:center;">BIZ-CODE</td>
        </tr>
        <tr>
            <td>Business Unit Name-EN</td>
            <td style="text-align:center;">BIZUNIT-NAME</td>
        </tr>
        <tr>
            <td>Division</td>
            <td style="text-align:center;">DIV-CODE</td>
        </tr>
        <tr>
            <td>DivisionName-EN</td>
            <td style="text-align:center;">DIVISION-NAME</td>
        </tr>
        <tr>
            <td>SubDivision</td>
            <td style="text-align:center;">SUBDIV-CODE</td>
        </tr>
        <tr>
            <td>Subdivision Name-EN</td>
            <td style="text-align:center;">SUBDIV-NAME</td>
        </tr>
        <tr>
            <td>Department</td>
            <td style="text-align:center;">DEPTCODE</td>
        </tr>
        <tr>
            <td>Department Name-EN</td>
            <td style="text-align:center;">DEPT-NAME</td>
        </tr>
        <tr>
            <td>SubDepartment</td>
            <td style="text-align:center;">SUBDEPTCODE</td>
        </tr>
        <tr>
            <td>SubDepartment Name-EN</td>
            <td style="text-align:center;">SUBDEPT-NAME</td>
        </tr>
        <tr>
            <td>Group</td>
            <td style="text-align:center;">GROUPCODE</td>
        </tr>
        <tr>
            <td>GroupName-EN</td>
            <td style="text-align:center;">GROUP-NAME</td>
        </tr>
        <tr>
            <td>SubGroup</td>
            <td style="text-align:center;">SUBGROUPCODE</td>
        </tr>
        <tr>
            <td>GroupName-EN</td>
            <td style="text-align:center;">GROUP-NAME</td>
        </tr>
        <tr>
            <td>SubGroupName-EN</td>
            <td style="text-align:center;">SUBGROUP-NAME</td>
        </tr>
        <tr>
            <td>Employee Status</td>
            <td style="text-align:center;">EMP-STATUS</td>
        </tr>
        <tr>
            <td>Employee Class</td>
            <td style="text-align:center;">EMPCLASSCODE</td>
        </tr>
        <tr>
            <td>EmployeeClass-EN</td>
            <td style="text-align:center;">EMPCLASS-NAME</td>
        </tr>
        <tr>
            <td>Employment Type</td>
            <td style="text-align:center;">EMPTYPECODE</td>
        </tr>
        <tr>
            <td>EmploymentType-EN</td>
            <td style="text-align:center;">EMPTYPE-NAME</td>
        </tr>
        <tr>
            <td>Job Classification</td>
            <td style="text-align:center;">JOBCLASSCODE</td>
        </tr>
        <tr>
            <td>Job Classification-EN</td>
            <td style="text-align:center;">JOBCLASS-NAME</td>
        </tr>
        <tr>
            <td>Personale SubArea</td>
            <td style="text-align:center;">PERSUBAREACODE</td>
        </tr>
        <tr>
            <td>PersonaleSubArea-EN</td>
            <td style="text-align:center;">PERSUBAREA-NAME</td>
        </tr>
        <tr>
            <td>Official Name-Personal Information</td>
            <td style="text-align:center;">OFFICIALNAME</td>
        </tr>
        <tr>
            <td>English/Preferred Name-Personal Information</td>
            <td style="text-align:center;">PREF-NAME</td>
        </tr>
        <tr>
            <td>Full Name-Personal Information</td>
            <td style="text-align:center;">FULLNAME</td>
        </tr>
        <tr>
            <td>Display name-Personal Information</td>
            <td style="text-align:center;">DISP-NAME</td>
        </tr>
        <tr>
            <td>National Id Card Type</td>
            <td style="text-align:center;">DOCIDTYPE</td>
        </tr>
        <tr>
            <td>Valid Period-National ID</td>
            <td style="text-align:center;">VAL-PERIOD-ID</td>
        </tr>
        
	</table>
    
  </v:widget-block>
</v:widget>
<v:widget caption="Configuration">
  <v:widget-block>
  	<v:form-field caption="Account Category" mandatory="true">
      <snp:dyncombo field="cfg.CategoryId" entityType="<%=LkSNEntityType.Category_Person%>" allowNull="false"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Workstation" mandatory="true" hint="Define workstation to be used for import process">
      <v:combobox field="cfg.WorkstationId" lookupDataSetName="ds" idFieldName="WorkstationId" captionFieldName="WorkstationName" linkEntityType="<%=LkSNEntityType.Workstation%>" allowNull="false"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Prodcut Tag"  hint="Tag associated to all the stuf products">
      <v:combobox field="cfg.TagId" lookupDataSetName="dsTag" idFieldName="TagId" captionFieldName="TagName" linkEntityType="<%=LkSNEntityType.Tag%>" allowNull="false"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Fields separator"  hint="Define file fields separator, if not valued default value is '|'">
	  <v:input-text field="cfg.CsvSeparator" maxLength="1"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
<v:widget caption="File Transfer Settings">
  <v:widget-block>
    <jsp:include page="/resources/admin/common/ftp_config_widget.jsp"></jsp:include>
    <v:form-field caption="Backup folder" hint="Directory where processed files will be moved to, a relative path to the folder where original file is or an absolute path ca be used">
  		<v:input-text field="cfg.BackupFolder"/>
  	</v:form-field>
  </v:widget-block>
</v:widget> 
  
<script>
function saveTaskConfig(reqDO) {
  var config = {
    FtpConfig: getFtpConfig(),
    CategoryId: $("#cfg\\.CategoryId").val(),
    TagId: $("#cfg\\.TagId").val(),
    CsvSeparator: $("#cfg\\.CsvSeparator").val(),
    WorkstationId: $("#cfg\\.WorkstationId").val(),
    BackupFolder: $("#cfg\\.BackupFolder").val()
  }
  
  reqDO.TaskConfig = JSON.stringify(config); 
}
</script>

