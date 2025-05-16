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

$(document).ready(function() {
  var $dlg = $("#mediainput_dialog");
  var $table = $dlg.find("#mediainput-table");

  $dlg.find("#btn-mediainput-next").click(_next);
  $dlg.find("#btn-mediainput-back").click(function() {_stepCallBack(StepDir_Back)});
  
  _initMediaInput();
  
  function _stepCallBack(dir) {
    $dlg.dialog("close");
    stepCallBack(Step_MediaInput, dir);
  }
  
  function _initMediaInput() {
    var $itemTemplate = $dlg.find("#mediainput-templates .mi-item");
    var $detailTemplate = $dlg.find("#mediainput-templates .mi-detail");
    
    for (const item of (shopCart.Items || [])) {
      if (stringToIntArray(item.ProductFlags).indexOf(<%=LkSNProductFlag.RequireMediaInputOnCLC.getCode()%>) >= 0) {
        var $item = $itemTemplate.clone().appendTo($table);
        $item.find(".mi-item-title").text(item.ProductName);
        
        for (const detail of (item.ItemDetailList || [])) {
          var $detail = $detailTemplate.clone().appendTo($item);
          $detail.attr("data-itemid", item.ShopCartItemId);
          $detail.attr("data-detailid", detail.ShopCartDetailId);
          $detail.attr("data-position", detail.Position);
          $detail.find(".mi-detail-position").text(detail.Position);
          
          var $account = $detail.find(".mi-detail-account"); 
          $account.text(detail.AccountName);
          if (isAnonymousAccount(detail.AccountName)) {
            $account.text(itl("@Account.AnonymousAccount"));
            $account.addClass("anonymous-account");
          }
          
          var $txt = $detail.find(".txt-mediacode");
          $txt.change(_validateMediaCode);
          $txt.keydown(_resetMediaCodeStatus);
          
          if ((detail.MediaReadList || []).length > 0) {
            var mediaRead = detail.MediaReadList[0];
            $txt.val(mediaRead.MediaCode);
          }
        }
      }
    }
  }
  
  function _next() {
    var $emptyTXTs = $table.find(".txt-mediacode").filter((index, elem) => $(elem).val().length <= 0);
    if ($emptyTXTs.length > 0) {
      $emptyTXTs.addClass("is-invalid").removeClass("is-valid");
      showIconMessage("warning", itl("@Common.CheckRequiredFields"));
    }
    else {
      var reqDO = {
        Command: "SetItemDetail",
        SetItemDetail: {
          ItemDetailList: []
        }
      };
      
      $table.find(".mi-detail").each((index, elem) => {
        var $detail = $(elem);

        var mediaCodeList = [];    
        for (const mc of $detail.find(".txt-mediacode").val().split(","))
          mediaCodeList.push({MediaCode:mc.trim()});
        
        reqDO.SetItemDetail.ItemDetailList.push({
          ShopCartItemId: $detail.attr("data-itemid"),
          DetailPosition: $detail.attr("data-position"),
          MediaCodeList: mediaCodeList
        });
      });
      
      doCmdShopCart(reqDO, function() {
        _stepCallBack(StepDir_Next);
      });
    }
  }
  
  function _validateMediaCode() {
    var $txt = $(this);
    
    if (isValidMediaCode($txt.val()))
      $txt.addClass("is-valid").removeClass("is-invalid")
    else {
      $txt.addClass("is-invalid").removeClass("is-valid")
      $txt.focus();
      showIconMessage("warning", itl("@Media.InvalidMediaCode", $txt.val()));
    }
  }
  
  function _resetMediaCodeStatus() {
    $(this).removeClass("is-valid is-invalid");
  }
});

</script>
