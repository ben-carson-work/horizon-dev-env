entDialog("ent-exprule-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $txtQuantity = $dlg.find("#exprule-qty-edit");
  var $trQuantity = $dlg.find("#exprule-qty-tr");
  var $cbFirstUsageFromNode = $dlg.find("#exprule-firstusagefromnode");
  var $radioRule = $dlg.find("input[name='exprule-radio']");
  var $radioGroup = $dlg.find("input[name='exprule-group-radio']");
  var $hintExpRule = $dlg.find("#exprule-hint");

  function _checkExpRuleQtyAgainstPlaceHolder(expRule) {
    var expRuleQty = _getExpirationRuleQuantity(obj.ExpRule);
    var placeHolder = _findExpRulePlaceHolder(obj.ExpRule); 
  
    if ((!isNaN(expRuleQty) && expRuleQty !== "") && (!isNaN(placeHolder)))
      expRuleQty = expRuleQty < placeHolder ? placeHolder : expRuleQty; 
    
    return expRuleQty;
  }
  
  function _getExpirationRuleQuantity(expRule) {
    var placeHolder = _findExpRulePlaceHolder(expRule);
    var val = $txtQuantity.val();
    
    if (!isNaN(val) && val !== "")
      return val;

    if (!isNaN(placeHolder))
      return placeHolder;

    return "";
  }
  
  function _refreshExpRuleGroup() {
    var group = $radioGroup.filter(":checked").val();
    var ruleGroup = $radioRule.filter(":checked").data("groupid");
  
    $dlg.find("div[data-groupid]").each(function() {
      $(this).data("groupid") == group ? $(this).show() : $(this).hide();
    });
  
    if (ruleGroup != group) {
      var defaultExpRuleCode = $radioRule.filter("[data-defaultoption='true'][data-groupid='" + group + "']").val(); 
      setRadioChecked($radioRule, defaultExpRuleCode);
      _refreshExpRuleHint();
    }
  }
  
  function _findExpRulePlaceHolder(expRule) {
    return $radioRule.filter("[value='" + expRule + "']").data("placeholder");
  }
  
  function _refreshExpRuleHint() {
    var exprule = $radioRule.filter(":checked").val();
    var selector = "#exprule-" + exprule + "-hint"
    
    setVisible($hintExpRule, selector != "#-hint");
    $hintExpRule.find(".alert-content").html($dlg.find(selector).html());
    
    var placeHolder = _findExpRulePlaceHolder(exprule);
    setVisible($trQuantity, placeHolder !== "");
    $txtQuantity.attr("placeholder", placeHolder);
  }

  return {
    "width": 600,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      var root = (obj.EntType == null) || (obj.EntType == 1/*LkSNEntitlementType.Default*/);
      $dlg.find(".exprule-group").filter("[data-rootonly='true']").setClass("hidden", !root);
      setRadioChecked($radioRule, (obj.ExpRule == null) ? 2/*LkSNExpirationRule.DaysFromEncoding*/ : obj.ExpRule);
      
      var groupCode = $radioRule.filter("[value='" + obj.ExpRule + "']").data("groupid"); 
      setRadioChecked($radioGroup, (obj.ExpRule == null) ? 1 : groupCode);
      
      $txtQuantity.val(obj.ExpRuleQty);
      $cbFirstUsageFromNode.setChecked(obj.ExpRuleFirstUsageFromNode === true);
      $radioRule.click(_refreshExpRuleHint);
      $radioGroup.click(_refreshExpRuleGroup);

      _refreshExpRuleGroup();
      _refreshExpRuleHint();
    },
    
    "onSave": function() {
      obj.ExpRule = parseInt($radioRule.filter(":checked").val());
      obj.ExpRuleQty = _checkExpRuleQtyAgainstPlaceHolder(obj.ExpRule);
      obj.ExpRuleFirstUsageFromNode = $cbFirstUsageFromNode.isChecked();
      
      callback();
    }
  };
});
