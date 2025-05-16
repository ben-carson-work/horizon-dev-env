<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageExtMediaBatch" scope="request"/>
<jsp:useBean id="extMediaBatch" class="com.vgs.snapp.dataobject.DOExtMediaBatch" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
JvDataSet ds = pageBase.getDB().executeQuery(
    "select" + JvString.CRLF +
    "  ExtProductCode," + JvString.CRLF +
    "  ExtProductName," + JvString.CRLF +
    "  ExtProductPrice," + JvString.CRLF +
    "  count(ExtMediaBatchDetailId) Total" + JvString.CRLF +
    "from" + JvString.CRLF +
    "  tbExtMediaBatchDetail" + JvString.CRLF +
    "where" + JvString.CRLF +
    "  ExtMediaBatchId=" + JvString.sqlStr(extMediaBatch.ExtMediaBatchId.getString()) + JvString.CRLF +
    "Group by" + JvString.CRLF +
    "  ExtProductCode, ExtProductName, ExtProductPrice"  + JvString.CRLF +
    "UNION" + JvString.CRLF +
    "select" + JvString.CRLF +
    "  EPT.ExtProductCode," + JvString.CRLF +
    "  EPT.ExtProductName," + JvString.CRLF +
    "  EPT.ExtProductPrice," + JvString.CRLF +
    "  count(EPT.ExtProductTypeId) Total" + JvString.CRLF +
    "from" + JvString.CRLF +
    "  tbExtMediaCode EMC join" + JvString.CRLF +
    "  tbExtProductType EPT on EPT.ExtProductTypeId=EMC.ExtProductTypeId" + JvString.CRLF +
    "where" + JvString.CRLF +
    "  EMC.ExtMediaBatchId=" + JvString.sqlStr(extMediaBatch.ExtMediaBatchId.getString()) + JvString.CRLF +
    "Group by" + JvString.CRLF +
    "  ExtProductCode, ExtProductName, ExtProductPrice");
request.setAttribute("ds", ds);
%>

<div class="tab-toolbar">
  <% String href="javascript:asyncDialogEasy('account/extmedia_batch_dialog','Id=" + extMediaBatch.ExtMediaBatchId.getString() +"&accountId=" + extMediaBatch.AccountId.getString() + "')"; %>
  <v:button id="btn_approve" caption="@Common.Approve"  href="<%=href%>"/>
  <v:button id="btn_reject" caption="@ExtMediaBatch.Reject"  onclick="setRejectStatus()"/>
  <v:button id="btn_suspend" caption="@ExtMediaBatch.Suspend"  onclick="setSuspendStatus()"/>
  <v:button id="btn_unsuspend" caption="@ExtMediaBatch.Unsuspend"  onclick="setUnSuspendStatus()"/>  
  <v:button id="btn_void" caption="@ExtMediaBatch.Void"  onclick="setVoidStatus()"/>
   <span class="divider"></span>
  <% String hRef = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + extMediaBatch.ExtMediaBatchId.getString() + "');"; %>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/> 
</div>

<div class="tab-content">
<v:last-error/>
  <div class="profile-pic-div">
    <v:widget caption="@Common.Profile">
      <v:widget-block>
        <div class="recap-value-item">
          <v:itl key="@ExtMediaBatch.ExtMediaBatchCodeExt1"/> 
          <span class="recap-value"><%=extMediaBatch.ExtMediaBatchCodeExt1.getHtmlString()%></span>
        </div>
        <div class="recap-value-item">  
          <v:itl key="@Common.FileName"/>
          <span class="recap-value"><%=extMediaBatch.ImportFileName.getHtmlString() %></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Common.Status"/>
            <span class="recap-value"><%=LkSN.ExtMediaBatchStatus.findItemDescriptionHtml(extMediaBatch.ExtMediaBatchStatus.getInt())%></span>
        </div>
          <v:itl key="@Common.Warning"/>
          <span class="recap-value"><%=LkSN.ExtMediaBatchAnomaly.findItemDescriptionHtml(extMediaBatch.ExtMediaBatchAnomaly.getInt())%></span>
        <div>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Common.ValidFrom"/>
           <span class="recap-value"><snp:datetime format="shortdate" timestamp="<%=extMediaBatch.EarlyValidDateFrom%>" timezone="local"/>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Common.ValidTo"/>
          <span class="recap-value"><snp:datetime format="shortdate" timestamp="<%=extMediaBatch.EarlyValidDateTo%>" timezone="local"/></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Common.Quantity"/>
          <span class="recap-value"><%=extMediaBatch.Quantity.getInt() %></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Common.Assigned"/>&ndash;<v:itl key="@Common.Balance"/>
          <span class="recap-value"><%=extMediaBatch.MediaCodesAssigned.getInt()%>&ndash;<%=extMediaBatch.MediaCodesAvailable.getInt()%></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@ExtMediaBatch.ExtMediaBatchCodeExt2"/>
          <span class="recap-value"><%=extMediaBatch.ExtMediaBatchCodeExt2.getHtmlString() %></span>
        </div>
      </v:widget-block>
    </v:widget>
  </div>
  
  <div class="profile-cont-div">
    <v:grid id="items-grid" dataset="<%=ds%>"  >
      <thead>
        <tr>
        <td></td>
          <td width="50%">
            <v:itl key="@Common.Code"/><br/>
            <v:itl key="@ExtMediaBatch.ExtProductName"/>
          </td>
          <td width="50%" align="right">
            <v:itl key="@ExtMediaBatch.ExtProductPrice"/><br/>
            <v:itl key="@Common.Quantity"/>
          </td>
        </tr>
      </thead>
      
      <tbody>
        <v:grid-row dataset="ds">
          <td><%-- <v:grid-checkbox header="true"/> --%></td>
          <td>
            <span class="list-title"><%=ds.getField("ExtProductCode").getHtmlString()%></span><br/>
            <span class="list-subtitle"><%=ds.getField("ExtProductName").getHtmlString()%></span>
          </td>
          <td align="right">
            <span class="list-title"><%=pageBase.formatCurrHtml(ds.getField("ExtProductPrice"))%></span><br/>
            <span class="list-subtitle"><%=ds.getField("Total").getHtmlString()%></span>
          </td>
        </v:grid-row>
      </tbody>
    </v:grid>
  </div>
</div>