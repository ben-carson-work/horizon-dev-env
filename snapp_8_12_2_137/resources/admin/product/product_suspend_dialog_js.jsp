<%@page import="com.vgs.cl.JvDateTime"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
DOProduct product = SrvBO_OC.getProduct(pageBase.getConnector(), pageBase.getId(), true).Product;
%>

<script>

function addSuspendItem(id, from, to, item, editable) {
	var today = new Date();
	today.setHours(0, 0, 0, 0);
	
  var tr = $("<tr class='grid-row'/>").appendTo("#suspend-body");
  var tdDateFrom = $("<td/>").appendTo(tr);
  var tdDateTo = $("<td/>").appendTo(tr);
  var tdEdit = $("<td align='right'>").appendTo(tr);
  
  tdDateFrom.append(from);
  if (to)
    tdDateTo.append(to);
  else
	  tdDateTo.append("Unlimited");
  
  if (editable) 
	  tdEdit.append("<button type='button' data-suspendfrom='" + item.SuspendDateFrom + "' data-suspendto='" + item.SuspendDateTo + "' id='" + id + "' class='btn btn-default' onclick='javascript:suspendDlg(this)'><i class='fas fa-edit'></i></button></td>");
}

function suspendDlg(obj) {
  var $btn = $(obj);
  var suspendFrom = $btn.attr("data-suspendfrom");
  var suspendTo = $btn.attr("data-suspendto");
  
  if (suspendFrom == undefined)
	  $("#SuspendFrom-picker").datepicker("setDate", new Date());
  else  
    $("#SuspendFrom-picker").datepicker("setDate", new Date(suspendFrom));
  
  if (suspendTo == undefined)
	  $("#SuspendTo-picker").datepicker("setDate", null);
  else
    $("#SuspendTo-picker").datepicker("setDate", new Date(suspendTo));
  
  var dlgCreate = $("#suspend_edit_dialog");
  dlgCreate.dialog({
    title: itl("@Common.Suspend"),
    width: 400, 
    height: 250,
    modal: true,
    buttons: [
      {
        text: itl("@Common.Confirm"),
        click: _doSuspend
      },
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ] 
  });
   
  function _doSuspend() {
		  var productSuspendId = $btn.attr("id");
	    var reqDO = {
	        Command: "SaveSuspend",
	        SaveSuspend: {
	        	Product: {
	        		ProductId: <%=JvString.jsString(pageBase.getId())%>
	        	},
	        	ProductSuspendId: productSuspendId == undefined ? null : productSuspendId,
	          SuspendDateFrom: $("#SuspendFrom-picker").getXMLDate(),
	          SuspendDateTo: $("#SuspendTo-picker").getXMLDate()
	        }
	    }	  
	    
	    dlgCreate.dialog("close");
	    
	    showWaitGlass();
	    vgsService("Product", reqDO, false, function(ansDO) {
	      hideWaitGlass();
		    entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, <%=JvString.jsString(pageBase.getId())%>);
	    });
// 	  });
  }
 
}

</script>