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
<v:widget>
  <v:widget-block>
    <div class="info-hint-box" style="margin-top:10px">
      This task will import into database all csv files found in the specified folder of the configured SFTP server.<br/>
      The file have to be formatted with one <b>Header row</b> followed by multiples <b>Detail rows</b>, last line must be <b>Footer row</b>.
      Each line has to be formatted as follow:
      <ul>
        <li><b>Header row</b></li>
        <ul>
          <li><b>Row type</b> <i>(mandatory)</i>: must be HEADER</li>
          <li><b>Row data</b> <i>(optional)</i>: not used</li>
        </ul>
      </ul> 
      <ul>
        <li><b>Detail rows</b></li>
        <ul>
          <li><b>OrderId</b> <i>(mandatory)</i>: Order reference number</li>
          <li><b>Open date</b> <i>(mandatory)</i>: Date the order is opened in the format YYYYMMDD</li>
          <li><b>VisualId (MediaCode)</b> <i>(mandatory)</i>: Ticket Visual Id (MediaCode)</li>
          <li><b>PLU</b> <i>(mandatory)</i>: Item code of the product</li>
          <li><b>Descr</b> <i>(mandatory)</i>: Item description</li>
          <li><b>Price</b> <i>(mandatory)</i>: Item price</li>
          <li><b>StartDate</b> <i>(mandatory)</i>: ticket start validity in the format YYYYMMDD</li>
          <li><b>EndDate</b> <i>(mandatory)</i>: ticket end validity in the format YYYYMMDD (not used)</li>
          <li><b>Monday</b> <i>(mandatory)</i>: (not used)Ticket validity on the day (0=invalid, 1=valid)</li>
          <li><b>Tuesday</b> <i>(mandatory)</i>: (not used)Ticket validity on the day (0=invalid, 1=valid)</li>
          <li><b>Wednesday</b> <i>(mandatory)</i>: (not used)Ticket validity on the day (0=invalid, 1=valid)</li>
          <li><b>Thursday</b> <i>(mandatory)</i>: (not used)Ticket validity on the day (0=invalid, 1=valid)</li>
          <li><b>Friday</b> <i>(mandatory)</i>: (not used)Ticket validity on the day (0=invalid, 1=valid)</li>
          <li><b>Saturday</b> <i>(mandatory)</i>: (not used)Ticket validity on the day (0=invalid, 1=valid)</li>
          <li><b>Sunday</b> <i>(mandatory)</i>: (not used)Ticket validity on the day (0=invalid, 1=valid)</li>
          <li><b>TicketStatus</b> <i>(mandatory)</i>: Ticket status (Valid, Invalid, Returned)</li>
        </ul>
      </ul>
     <ul>
        <li><b>Footer row</b></li>
        <ul>
          <li><b>Row type</b> <i>(mandatory)</i>: must be FOOTER</li>
          <li><b>Rows number</b> <i>(mandatory)</i>: number of file's detail rows</li>
        </ul>
      </ul>
    </div>
  </v:widget-block>
</v:widget>

<v:widget caption="@Account.Organization">
  <v:widget-block>
      <snp:dyncombo field="cfg.AccountId" entityType="<%=LkSNEntityType.Organization%>" allowNull="false"/>
  </v:widget-block>
</v:widget>
<v:widget caption="SFTP Server Configuration">
<v:widget-block>
    <jsp:include page="/resources/admin/common/ftp_config_widget.jsp"></jsp:include>
  </v:widget-block>
</v:widget>
<script>

function saveTaskConfig(reqDO) {
  if(!($("#cfg\\.AccountId").val()))
    throw new Error("Organization field is mandatory!");
  
  var config = {
    AccountId: $("#cfg\\.AccountId").val(),
    FtpConfig: getFtpConfig()
  }
  
  reqDO.TaskConfig = JSON.stringify(config); 
}
</script>
