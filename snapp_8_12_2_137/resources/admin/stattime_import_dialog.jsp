<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="stattime-import-dialog" title="@Common.Import" width="800" height="600" autofocus="false">
  <div id="step-input">
    <v:widget caption="@Common.Parameters">
      <v:widget-block>
        <jsp:include page="repository/file_upload_widget.jsp"/>
      </v:widget-block>
    </v:widget>
    <v:alert-box type="info" title="@Common.Info">
      <v:itl key="This wizard will import statistical time from a CSV file into the system."/><br/>
      <v:itl key="@Account.ImportWizard_Line2"/>
      <ul>
        <li><strong>ReferenceTime</strong>: The Time represented in military format such as "05:35" for 5:35 AM  or "18:45"  for 6:45 PM</li>
        <li><strong>ClockTime</strong>: The Time represented as it would appear on a clock such as "5:35" for 5:35 AM  or "6:45"  for 6:45 PM</li>
        <li><strong>ClockTimeSuffixName</strong>: A suffix indicating the time relationship to the overall day as A.M., P.M., Noon or Midnight</li>
        <li><strong>ClockTimeSuffixAbbreviationName</strong>: An abbreviation indicating the time relationship to the overall day.  The following are the four possible abbreviations and what they mean: AM (before noon; ante meridian), PM (after noon; post meridian), Nn (noon), Mn (midnight.)</li>
        <li><strong>CalendarDayMinuteCount</strong>: The number of minutes since midnight; a number from 0 to 1399</li>
        <li><strong>FiscalClockOffsetNumber</strong>: Indicates if time is within the fiscal day or belongs to the previous fiscal day.  A -1 indicates that the time belongs to the preceding fiscal day.  For example, if 1:01 AM belongs to the previous day, the fiscal clock offset would be -1 for that time.</li>
        <li><strong>Reference5MinuteSegmentStartTime</strong>: The closest preceding or co-existing five minute segment to the indicated time</li>
        <li><strong>Reference5MinuteSegmentEndTime</strong>: The closest following or co-existing five minute segment to the indicated time</li>
        <li><strong>Reference15MinuteSegmentStartTime</strong>: The closest preceding or co-existing fifteen minute segment to the indicated time</li>
        <li><strong>Reference15MinuteSegmentEndTime</strong>: The closest following or co-existing fifteen minute segment to the indicated time</li>
        <li><strong>Reference20MinuteSegmentStartTime</strong>: The closest preceding or co-existing twenty minute segment to the indicated time</li>
        <li><strong>Reference20inuteSegmentEndTime</strong>: The closest following or co-existing twenty minute segment to the indicated time</li>
        <li><strong>Reference30MinuteSegmentStartTime</strong>: The closest preceding or co-existing thirty minute segment to the indicated time</li>
        <li><strong>Reference30MinuteSegmentEndTime</strong>: The closest following or co-existing thirty minute segment to the indicated time</li>
        <li><strong>Reference60MinuteSegmentStartTime</strong>: The closest preceding or co-existing sixty minute segment to the indicated time</li>
        <li><strong>Reference60MinuteSegmentEndTime</strong>: The closest following or co-existing sixty minute segment to the indicated time</li>
      </ul>
    </v:alert-box>
  </div>

  <div id="step-preview" class="step-item v-hidden">
    <jsp:include page="csv_import_widget.jsp">
      <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_START_TIME%>"/>
    </jsp:include>
  </div>

<script>

function doUploadFinish(obj) {
  $("#step-input").addClass("v-hidden");
  $("#step-preview").removeClass("v-hidden");
  doCsvImport(obj.RepositoryId);
}

</script>

</v:dialog>
