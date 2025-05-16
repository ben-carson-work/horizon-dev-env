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

<v:widget caption="Info">
  <v:widget-block>
    <p>
      The purpose of this task is to export the access white list for the potential visitors of the <i>current date</i>.<br/>
      The task will create 2 files (1 for MG events, 1 for EG events) for the <i>current date</i>.<br/>
      <b>Current date</b> is relative to the licensee time zone settings (server timezone is not considered)<br/>
    </p>
    <p>
      The files are named <b>Int0071_IDFR_MG-YYYYMMDD00000.adm</b> and <b>Int0071_IDFR_EP-YYYYMMDD00000.adm</b> where <b>YYYYMMDD</b> is the admission date. If the file is already exiting on the FTP destination, it will be replaced.
    </p>
    <p>
      Each file contains a list of <b>AccountId</b>, one per line.<br/>
      Lines are separated with <i>line-feed</i> (ASCII code 10)<br/>
      Files are encoded in UTF-8.<br/>
    </p>
  </v:widget-block>
</v:widget> 

<v:widget caption="Tags">
  <v:widget-block>
    <v:form-field caption="MG Tag">
      <v:combobox field="cfg.MG_TagId" lookupDataSet="<%=pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Event)%>" captionFieldName="TagName" idFieldName="TagId"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="EP Tag">
      <v:combobox field="cfg.EP_TagId" lookupDataSet="<%=pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Event)%>" captionFieldName="TagName" idFieldName="TagId"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="FTP Settings">
  <v:widget-block>
    <jsp:include page="/resources/admin/common/ftp_config_widget.jsp"></jsp:include>
  </v:widget-block>
</v:widget>	
  
<script>
function saveTaskConfig(reqDO) {
  var config = {
    MG_TagId: $("#cfg\\.MG_TagId").val(),
    EP_TagId: $("#cfg\\.EP_TagId").val(),
    FtpConfig: getFtpConfig()
  }
  
  reqDO.TaskConfig = JSON.stringify(config); 
}
</script>

