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

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div class="main-container">
  <v:tab-group name="tab" main="true">
    <v:tab-item caption="@Common.Recap" icon="profile.png" tab="main" jsp="extmediabatch_tab_main.jsp" default="true" />
    
    <%if ((extMediaBatch.MediaCodesAssigned.getInt() > 0) || (extMediaBatch.MediaCodesAvailable.getInt() > 0)) {%>
     <v:tab-item caption="@Common.Media" icon="media.png" tab="media" jsp="extmediabatch_tab_media.jsp" />
    <%} %>
  </v:tab-group>
</div>
<script>

$(document).ready(function() {

  _enableDisable();
  
  function _enableDisable() {
    var toBeProcessed = <%=extMediaBatch.ExtMediaBatchStatus.isLookup(LkSNExtMediaBatchStatus.Draft, LkSNExtMediaBatchStatus.Warn, LkSNExtMediaBatchStatus.Processing)%>;
    var canApproveReject = <%=LkSNRightExtMediaBatchLevel.ApproveReject.check(pageBase.getRights().ExtMediaBatchLevel.getLkValue())%>;
    var canSuspendUnsuspend = <%=LkSNRightExtMediaBatchLevel.SuspendUnsuspend.check(pageBase.getRights().ExtMediaBatchLevel.getLkValue())%>;
    var canVoid = <%=LkSNRightExtMediaBatchLevel.Void.check(pageBase.getRights().ExtMediaBatchLevel.getLkValue())%>;
    $("#btn_approve").setClass("hidden", !toBeProcessed || !canApproveReject);
    $("#btn_reject").setClass("hidden", !toBeProcessed || !canApproveReject);
    $("#btn_suspend").setClass("hidden", !<%=extMediaBatch.ExtMediaBatchStatus.isLookup(LkSNExtMediaBatchStatus.Approved)%> || !canSuspendUnsuspend);
    $("#btn_unsuspend").setClass("hidden", !<%=extMediaBatch.ExtMediaBatchStatus.isLookup(LkSNExtMediaBatchStatus.Suspended)%> || !canSuspendUnsuspend);
    $("#btn_void").setClass("hidden", !<%=extMediaBatch.ExtMediaBatchStatus.isLookup(LkSNExtMediaBatchStatus.Suspended)%> || !canVoid);
  }
});

function setRejectStatus(){ 
  confirmDialog(null, function() {
    changeStatus("<%=LkSNExtMediaBatchStatus.Rejected.getCode()%>");
  });
}

function setSuspendStatus(){
  changeStatus("<%=LkSNExtMediaBatchStatus.Suspended.getCode()%>");
}

function setVoidStatus(){
  changeStatus("<%=LkSNExtMediaBatchStatus.Voided.getCode()%>");
}

function setUnSuspendStatus(){
  changeStatus("<%=LkSNExtMediaBatchStatus.Approved.getCode()%>");
}

function changeStatus(status){
  var reqDO = {
      Command: "UpdateBatchStatus",
      UpdateBatchStatus: {
        ExtMediaBatchId: "<%=extMediaBatch.ExtMediaBatchId.getString()%>",
        Status: status
      }
    };
      
    vgsService("ExternalMedia", reqDO, false, function(ansDO) {
      window.location.reload();
    });

}
</script>
<jsp:include page="/resources/common/footer.jsp"/>