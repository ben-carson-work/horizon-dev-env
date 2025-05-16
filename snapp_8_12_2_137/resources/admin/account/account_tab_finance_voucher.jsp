<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>
<% boolean voucherIssue = rights.VoucherIssue.getBoolean(); %>

<% int[] defaultStatusFilter = LookupManager.getIntArray(LkSNVoucherStatus.Issued, LkSNVoucherStatus.Committed, LkSNVoucherStatus.Redeemed, LkSNVoucherStatus.PartiallyRedeemed);%>
<script>
    function search() {
      setGridUrlParam("#voucher-grid-container", "VoucherStatus", $("[name='Status']").getCheckedValues());
      setGridUrlParam("#voucher-grid-container", "Active", $("[name='Active']").getCheckedValues());
      setGridUrlParam("#voucher-grid-container", "FromDate", $("#FromDate-picker").getXMLDate());
      setGridUrlParam("#voucher-grid-container", "ToDate", $("#ToDate-picker").getXMLDate());
      setGridUrlParam("#voucher-grid-container", "FullText", $("#full-text-search").val(), true);
    }
    
    $(document).on("OnEntityChange", search);
</script>

<div id="expdate-dialog" class="v-hidden" title="<v:itl key="@Voucher.VoucherChangeExpDate"/>">
  <v:input-text type="datepicker" field="NewExpDatePicker" style="width:105px"/>
</div>

<div id="reissue-dialog" class="v-hidden" title="<v:itl key="@Lookup.TransactionType.VoucherReissue"/>">
  <label class="checkbox-label"><input type="radio" name="voucher.GeneratePDF" value="true" checked="checked"/> <v:itl key="@Account.Credit.VoucherGeneratePDF"/></label>
  &nbsp;
  <label class="checkbox-label"><input type="radio" name="voucher.GeneratePDF" value="false"/> <v:itl key="@Account.Credit.VoucherPrintAtPOS"/></label>
</div>


<div class="tab-toolbar">
  <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" style="width:200px" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
  <script>
    $("#full-text-search").keypress(function(e) {
      if (e.keyCode == KEY_ENTER) {
        search();
        return false;
      }
    });
  </script>
  <span class="divider"></span>
  <v:button caption="@Common.Search" fa="search" onclick="search()"/>
  <v:button caption="@Common.Issue" fa="plus" onclick="showVoucherIssueDialog()" enabled="<%=voucherIssue%>"/>

  <div class="btn-group">  
	  <v:button id="action-btn" caption="@Voucher.VoucherActions" fa="flag" dropdown="true"/>
		<v:popup-menu bootstrap="true">
		  <% if (rights.VoucherBlock.getBoolean()) { %>
		    <v:popup-item caption="@Common.Block" href="javascript:setActive(false)"/>
		    <v:popup-item caption="@Common.Unblock" href="javascript:setActive(true)"/>
		  <% } %>
		  <% if (rights.VoucherReissue.getBoolean()) { %>
		    <v:popup-item caption="@Common.Reissue" id="reissue-btn"/>
		  <% } %>
		  <% if (rights.VoucherVoid.getBoolean()) { %>
		    <v:popup-item caption="@Common.Void" href="javascript:voidVoucher()"/>
		  <% } %>
		  <% if (rights.VoucherExpDate.getBoolean()) { %>
		    <v:popup-item caption="@Account.Credit.ExptDate" id="expdate-btn"/>
		  <% } %>
		</v:popup-menu>
	</div>
  
  <v:pagebox gridId="voucher-grid-container"/>
</div>

<div class="tab-content">
  <v:last-error/>
  <div id="main-container">
    <div class="profile-pic-div">
      <v:widget caption="@Common.DateRange"><v:widget-block>
        <table style="width:100%">
          <tr>
            <td>
              &nbsp;<v:itl key="@Common.From"/><br/>
              <v:input-text type="datepicker" field="FromDate" style="width:105px"/>
            </td>
            <td>&nbsp;</td>
            <td>
              &nbsp;<v:itl key="@Common.To"/><br/>
              <v:input-text type="datepicker" field="ToDate" style="width:105px"/>
            </td>
          </tr>
        </table>
      </v:widget-block></v:widget>
      
      <v:widget caption="@Common.Status">
        <v:widget-block>
          <% for (LookupItem status : LkSN.VoucherStatus.getItems()) { %>
          <v:db-checkbox field="Status" caption="<%=status.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
          <% } %>
        </v:widget-block>
        <v:widget-block>
          <v:db-checkbox field="Active" caption="<%=pageBase.getLang().Common.Active.getText()%>" value="1" checked="true"/><br/>
          <v:db-checkbox field="Active" caption="<%=pageBase.getLang().Common.Blocked.getText()%>" value="0" checked="true"/>
        </v:widget-block>
      </v:widget>
    </div>
  
    <div class="profile-cont-div">
      <% String params = "AccountId=" + pageBase.getId() + "&VoucherStatus=" + JvArray.arrayToString(defaultStatusFilter, ","); %>
      <v:async-grid id="voucher-grid-container" jsp="account/voucher_grid.jsp" params="<%=params%>"/>
    </div>
  </div>
</div>

<script>
function setActive(active) {
  var ids = $("[name='cbVoucherId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "SetActive",
        SetActive: {
          Active: active,
          VoucherIDs: ids
        }
      };
      if ($("#voucher-grid").hasClass("multipage-selected")) {
        reqDO.SetActive.VoucherIDs = null;            
        reqDO.SetActive.QueryBase64 = $("#voucher-grid").attr("data-QueryBase64");
      }
      vgsService("Voucher", reqDO, false, function(ansDO) {
        showMessage("Processed: " + ansDO.Answer.SetActive.AffectedRows + " Skipped: " + ansDO.Answer.SetActive.Skipped, function() {
          triggerEntityChange(<%=LkSNEntityType.Voucher.getCode()%>);
        });
      });
    });  
  }
} 

function setExpirationDate(expDate, voucherIDs) {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "SetExpDate",
      SetExpDate: {
        ExpDate: expDate,
        VoucherIDs: voucherIDs
      }
    };
    if ($("#voucher-grid").hasClass("multipage-selected")) {
      reqDO.SetExpDate.VoucherIDs = null;            
      reqDO.SetExpDate.QueryBase64 = $("#voucher-grid").attr("data-QueryBase64");
    }
    vgsService("Voucher", reqDO, false, function(ansDO) {
      showMessage("Processed: " + ansDO.Answer.SetExpDate.AffectedRows + " Skipped: " + ansDO.Answer.SetExpDate.Skipped, function() {
        triggerEntityChange(<%=LkSNEntityType.Voucher.getCode()%>);
      });
    });
  });
}

function voidVoucher() {
  var ids = $("[name='cbVoucherId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "VoucherVoid",
        VoucherVoid: {
          AccountId: <%=JvString.jsString(pageBase.getId())%>,
          VoucherIDs: ids
        }
      };
      if ($("#voucher-grid").hasClass("multipage-selected")) {
        reqDO.VoucherVoid.VoucherIDs = null;            
        reqDO.VoucherVoid.QueryBase64 = $("#voucher-grid").attr("data-QueryBase64");
      }
      vgsService("Voucher", reqDO, false, function(ansDO) {
        showMessage("Processed: " + ansDO.Answer.VoucherVoid.AffectedRows + " Skipped: " + ansDO.Answer.VoucherVoid.Skipped, function() {
          triggerEntityChange(<%=LkSNEntityType.Voucher.getCode()%>);
        });
      });
    });
  }
}

function reissueVoucher(printPDF, ids) {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "VoucherReissue",
      VoucherReissue: {
        PrintPDF: printPDF,
        VoucherIDs: ids
      }
    };
    if ($("#voucher-grid").hasClass("multipage-selected")) {
      reqDO.VoucherReissue.VoucherIDs = null;            
      reqDO.VoucherReissue.QueryBase64 = $("#voucher-grid").attr("data-QueryBase64");
    }
    vgsService("Voucher", reqDO, false, function(ansDO) {
      if (ansDO.Answer.VoucherReissue.AffectedRows == 0) {
        showMessage("Processed: " + ansDO.Answer.VoucherReissue.AffectedRows + " Skipped: " + ansDO.Answer.VoucherReissue.Skipped, function() {
          triggerEntityChange(<%=LkSNEntityType.Voucher.getCode()%>);});
      }
      else {
        if (printPDF) {
          var transactionId = ansDO.Answer.VoucherReissue.TransactionId;
          var docTemplateId = ansDO.Answer.VoucherReissue.DocTemplateId;
          var urlo = BASE_URL + "/voucherpdf?TransactionId=" + transactionId + "&DocTemplateId=" + docTemplateId;
          window.open(urlo, '_blank');
          triggerEntityChange(<%=LkSNEntityType.Voucher.getCode()%>);
        }
        else {
          var saleId = ansDO.Answer.VoucherReissue.SaleId;
          var saleCode = ansDO.Answer.VoucherReissue.SaleCode;
          var msg = <v:itl key="@Common.SaveSuccessMsg" encode="JS"/>;
          showMessage(msg, function() {
            window.open("<%=pageBase.getContextURL()%>?page=sale&id=" + saleId, "_blank");
            triggerEntityChange(<%=LkSNEntityType.Voucher.getCode()%>);
          });
        }
      }
    });
  });
}

function showVoucherIssueDialog() {
  asyncDialogEasy("account/voucher_issue_dialog", "AccountId=" + <%=JvString.jsString(pageBase.getId())%>);
}

$("#expdate-btn").click(function(event) {
  var ids = $("[name='cbVoucherId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    $("#expdate-dialog").dialog({
      modal: true,
      width: 300,
      height: 350,
      buttons: {
        <v:itl key="@Common.Close" encode="JS"/>: function() {
          $(this).dialog("close");
        },
        <v:itl key="@Common.Ok" encode="JS"/>: function() {
          $(this).dialog("close");
          setExpirationDate($("#NewExpDatePicker").val(), ids);
        }
      }
    });
  }
});

$("#reissue-btn").click(function(event) {
  var ids = $("[name='cbVoucherId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    $("#reissue-dialog").dialog({
      modal: true,
      width: 300,
      height: 150,
      buttons: {
        <v:itl key="@Common.Reissue" encode="JS"/>: function() {
          var printPFD = $(this).find("[name='voucher\\.GeneratePDF']:checked").val() == "true";
          $(this).dialog("close");
          reissueVoucher(printPFD, ids);
        },
        <v:itl key="@Common.Close" encode="JS"/>: function() {
          $(this).dialog("close");
        }
      }
    });
  }
});

</script>