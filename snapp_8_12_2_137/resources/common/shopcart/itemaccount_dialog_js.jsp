<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<script>
var dlg = $("#itemaccount_dialog");

function initItemAccountTabs() {
  if (shopCart.Items) {
    var firstItem = true;
    var templateHtml = $("#itemaccount-li-template").html();
    for (var i=0; i<shopCart.Items.length; i++) {
      var item = shopCart.Items[i];
      if (item.RequireAccount) {
        for (var k=0; k<item.ItemDetailList.length; k++) {
          var detail = item.ItemDetailList[k];
          var li = $(templateHtml).appendTo(dlg.find(".tab-button-list"));
          li.attr("data-ShopCartItemId", item.ShopCartItemId);
          li.attr("data-DetailNo", detail.Position);
          li.attr("data-CategoryId", (item.ProductAccountCategoryId) ? item.ProductAccountCategoryId : <%=rights.AccountPRS_DefaultCategoryId.getJsString()%>);
          li.find(".tab-button-product").text(item.ProductName);
          
          if (detail.AccountId) {
            li.attr("data-AccountId", detail.AccountId);
            li.find(".tab-button-account").text(detail.AccountName);
            if (detail.AccountId != null)
              li.addClass("account-ok");
          }
          
          li.click(itemAccount_ItemClick);
          
          if (firstItem) {
            li.click();
            firstItem = false;
          }
        }
      }
    }
  } 
}

initItemAccountTabs();

function itemAccount_LoadAccount(li, previousSelAccount) {
	  var urlo = "<%=pageBase.getContextURL()%>?page=maskedit_widget&LoadData=true&EntityType=<%=LkSNEntityType.Person.getCode()%>&CategoryId=" + li.attr("data-CategoryId");
	  
	  var accountId = li.attr("data-AccountId");
	  if (accountId) {
	    urlo += "&id=" + accountId;
	  }
	  
	  asyncLoad(dlg.find(".tab-content"), urlo, function() {
	    dlg.find(".tab-content input").first().focus();
	    
	    if (previousSelAccount) {
	      for (let metaData of previousSelAccount) {
	        if (metaData.AutoPopulate) {
	          let selector = ".widget-content .form-field .form-field-value [data-metafieldid='" + metaData.MetaFieldId + "']";
	          let $metaField = dlg.find(selector);
	          
	          if ($metaField.length > 0) {
	            // Check the type of input element and read the value accordingly
	            let fieldType = $metaField.attr('type');
	            switch (fieldType) {
	              case 'checkbox':
	                $metaField.prop('checked', metaData.Value === 'true');
	                break;
	              case 'radio':
	                let $radioMetaField = $metaField.filter(function() {
						return $(this).val() === metaData.Value;
	                }); 
	            	if ($radioMetaField) {
	            		$radioMetaField.prop('checked', true);
	                }
	                break;
	              default:
	                $metaField.val(metaData.Value);
	                break;
	            }
	            $metaField.addClass("metadata-modified");
	            
	          }
	        }
	      }
	    }
	  });

	  $("#btn-itemaccount-copy").toggleClass("v-hidden", (li.index() == 0) || accountId);
	}


function selectItemAccount(tabButton, previousSelAccount) {
  tabButton = $(tabButton);
  dlg.find(".tab-button").removeClass("selected");
  //recupera l'item selezionato per passare l'account da cui copiare i dati a itemAccount_LoadAccount
  tabButton.addClass("selected");
  itemAccount_LoadAccount(tabButton, previousSelAccount);
}

function isSelectedItemAccountModified() {
  var liSel = dlg.find(".tab-button.selected");
  if (liSel.length > 0) 
    return (dlg.find(".meta-field-value.metadata-modified").length > 0);
  return false;
}

function itemAccount_ItemClick() {
  var tabButton = $(this);
  if (!tabButton.is(".selected")) {
    if (isSelectedItemAccountModified()) {
      saveSelectedItemAccount(function(li, metaDataList) {
        selectItemAccount(tabButton, metaDataList);
      });  
    }
    else 
      selectItemAccount(tabButton);
  } 
}

function saveSelectedItemAccount(callback) {
  var li = dlg.find(".tab-button.selected");
  li.removeClass("account-ok");
  
  var list = prepareMetaDataArray(dlg.find(".tab-content"));
  
  if (!(list)) 
    showMessage(itl("@Common.CheckRequiredFields"));
  else {
    showWaitGlass();
    var reqDO = {
      Command: "SaveAccount",
      SaveAccount: {
        AccountId: li.attr("data-AccountId"),
        EntityType: <%=LkSNEntityType.Person.getCode()%>,
        CategoryId: li.attr("data-CategoryId"),
        MetaDataList: list
      }
    };
    
    vgsService("Account", reqDO, false, function(ansDO) {
      hideWaitGlass();
      
      var accountId = ansDO.Answer.SaveAccount.AccountId;
      var accountName = ansDO.Answer.SaveAccount.DisplayName;
      var metaDataList = ansDO.Answer.SaveAccount.MetaDataList;
      
      li.attr("data-AccountId", accountId);
      li.find(".tab-button-account").text(accountName);
      li.addClass("account-ok");
		
      
      doSetPortfolioAccount(li.attr("data-ShopCartItemId"), parseInt(li.attr("data-DetailNo")), accountId, function() {
        if (callback)
          callback(li, metaDataList);
      });
    });
  }
}

function doItemAccountNext() {
  function doAfterSave(li, metaDataList) {
    var tabs = dlg.find(".tab-button-list .tab-button:not(.account-ok)");
    if (tabs.length > 0)
      selectItemAccount(tabs[0], metaDataList);
    else {
      dlg.dialog("close");
      stepCallBack(Step_ItemAccount, StepDir_Next);
    }
  }
  
  if (isSelectedItemAccountModified()) 
    saveSelectedItemAccount(doAfterSave);
  else 
    doAfterSave();
}

function doCopyAccount() {
  var selTabButton = dlg.find(".tab-button.selected");
  var srcAccountId = selTabButton.prev().attr("data-AccountId");
  
  if (srcAccountId) {
    var reqDO = {
      Command: "DuplicateMetaData",
      DuplicateMetaData: {
        SrcAccountId: srcAccountId,
        DstCategoryId: selTabButton.attr("data-CategoryId")
      }
    };
    
    vgsService("Account", reqDO, false, function(ansDO) {
      var dstAccountId = ansDO.Answer.DuplicateMetaData.DstAccountId;
      selTabButton.attr("data-AccountId", dstAccountId);
      itemAccount_LoadAccount(selTabButton);
    });
  }
}

$("#btn-itemaccount-copy").click(doCopyAccount);
$("#btn-itemaccount-next").click(doItemAccountNext);

$("#btn-itemaccount-back").click(function() {
  dlg.dialog("close");
  stepCallBack(Step_ItemAccount, StepDir_Back);
});

</script>
