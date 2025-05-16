entDialog("ent-firstusagerule-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $radioGroup = $dlg.find("input[name='firstusagerule-group-radio']");
  var $radioRule = $dlg.find("input[name='firstusagerule-radio']");
  var $txtQuantity = $dlg.find("#firstusagerule-qty-edit");
  var $datepicker = $dlg.find(".firstusagerule-date");
  var $contQuantity = $dlg.find("#quantity-container");
  var $contDate = $dlg.find("#date-container");

  $radioRule.click(_refreshFirstUsageRuleHint);
  $radioGroup.click(_refreshFirstUsageRuleGroup);
  
  function _decodeDate(str) {
    return (getNull(str) == null) ? null : new Date(str.replace("-", "/"));
  }

  function _refreshFirstUsageRuleGroup() {
    var $containers = $dlg.find(".firstusagerule-group-container");
    var $selContainer = $containers.filter("[data-group='" + $radioGroup.filter(":checked").val() + "']");
     
    $containers.addClass("hidden");
    $selContainer.removeClass("hidden");
    $selContainer.find("input[name='firstusagerule-radio']").first().prop("checked", true);

    _refreshFirstUsageRuleHint();
  }
  
  function _refreshFirstUsageRuleHint() {
    var $selRule = $radioRule.filter(":checked");
    $dlg.find("#firstusagerule-hint .alert-content").text(itl($selRule.attr("data-hint")));
    $contQuantity.setClass("hidden", $selRule.attr("data-hasquantity") !== "true");
    $contDate.setClass("hidden", $selRule.attr("data-hasdate") !== "true");
  }
  
  function _getFirstUsageGroupCode(firstUsageRule) {
    return $radioRule.filter("[value='" + firstUsageRule + "']").closest(".firstusagerule-group-container").attr("data-group");
  }

  return {
    "width": 600,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      var root = (obj.EntType == null) || (obj.EntType == 1/*LkSNEntitlementType.Default*/);
      $dlg.find("[name='firstusagerule-group-radio'][value='4']").closest(".firstusagerule-group").setClass("hidden", !root);
      
      setRadioChecked($radioRule, (obj.FirstUsageRule == null) ? 1/*LkSNFirstUsageRule.NumOfDays*/ : obj.FirstUsageRule);
      setRadioChecked($radioGroup, (obj.FirstUsageRule == null) ? 1 : _getFirstUsageGroupCode(obj.FirstUsageRule));
      $datepicker.datepicker("setDate", _decodeDate(obj.FirstUsageRuleDate));
    
      _refreshFirstUsageRuleGroup();
      _refreshFirstUsageRuleHint();
    },
    
    "onSave": function() {
      obj.FirstUsageRule = parseInt($radioRule.filter(":checked").val());
      obj.FirstUsageRuleQty = $contQuantity.hasClass("hidden") ? null : getNull($txtQuantity.val());
      obj.FirstUsageRuleDate = $contDate.hasClass("hidden") ? null : getNull($datepicker.getXMLDate());
      
      callback();
    }
  };
});
