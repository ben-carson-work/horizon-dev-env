entDialog("ent-ppuentrycharge-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $radio = $dlg.find("input[name='ppu-entry-charge-radio']");
  var $comboType = $dlg.find("#ppu-entry-rewardpoints-id");
  var $txtAmount = $dlg.find("#ppu-entry-charge-edit");
  var $blockAmount = $dlg.find("#ppu-entry-charge-amount");
  
  $radio.click(_refreshVisibility);
  
  function _refreshVisibility() {
    $blockAmount.setClass("hidden", $radio.filter(":checked").val() != 2);
  }
  
  return {
    "width": 400,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      var applyRules = (obj.PPUEntryCharge && (obj.PPUEntryCharge == 0) && (obj.PPUEntryChargeApplyRules == true));
  
      if (applyRules) {
        $txtAmount.val("");
        setRadioChecked($radio, 1);
      }
      else if (obj.PPUEntryChargeList && (obj.PPUEntryChargeList.length > 0)) {
        var item = obj.PPUEntryChargeList[0];
        $comboType.val(item.PointId);
        $txtAmount.val(item.Amount);
        setRadioChecked($radio, 2);
      }
      else
        setRadioChecked($radio, 1);
      
      _refreshVisibility();
    },
    
    "onSave": function() {
      var radio = $radio.filter(":checked").val();
      var ppurule = $comboType.val();
      var amount = parseFloat($txtAmount.val());
      
      if ((radio == 2) && (isNaN(amount) || (amount == 0))) {
        showMessage(itl("@Entitlement.PPUChargeError"), function() {
          $txtAmount.select();
        });
      } 
      else {
        if (radio == 2) {
          obj.PPUEntryChargeApplyRules = false;
          obj.PPUEntryChargeList = [{
            "PointId": ppurule,
            "Amount": amount
          }];
        }
        else {
          obj.PPUEntryChargeApplyRules = true;
          obj.PPUEntryChargeList = null;
        }
          
        callback();
      }
    }
  };
});
