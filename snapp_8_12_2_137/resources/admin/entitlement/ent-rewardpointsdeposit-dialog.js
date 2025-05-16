entDialog("ent-rewardpointsdeposit-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var pt = {};
  var $comboType = $dlg.find("#rewardpoints-initial-deposit-id");
  var $txtAmount = $dlg.find("#rewardpoints-initial-deposit-amount");
  var $txtFace = $dlg.find("#rewardpoints-initial-deposit-face-value");
  var $cbInherit = $dlg.find("#rewardpoints-inherit-from-price");
  var $blockAmount = $dlg.find("#block-rewardpoints-deposit-amount");
  
  $cbInherit.click(_refreshVisibility);
  
  function _refreshVisibility() {
    $blockAmount.setClass("hidden", $cbInherit.isChecked());
  }
  
  function _getAmount($txt) {
    var txt = $txt.val();
    if (getNull(txt) == null)
      return null; 
    else {
      var result = parseFloat(txt.replace(",", "."));
      return isNaN(result) ? 0 : result;
    }
  }
  
  return {
    "width": 600,
    
    "onShow": function(aObj, aCallback) {
      obj = objEntRoot;
      callback = aCallback;
      
      var sel = getObjEnt(getSelectedNode());
      pt = ((sel) && (sel.PointsId)) ? sel : {};
      
      $comboType.val(pt.PointsId);
      $cbInherit.setChecked(pt.PointsInheritFromSalePrice);
      $txtAmount.val(pt.PointsAmount);
      $txtFace.val(pt.FaceValue);

      _refreshVisibility();
    },
    
    "onSave": function() {
      var pt = null;
      obj.PointsDepList = obj.PointsDepList || [];
      
      for (const item of obj.PointsDepList) {
        if (item.PointsId == $comboType.val()) {
          pt = item;
          break;
        }
      }
      
      if (pt == null) {
        pt = {};
        obj.PointsDepList.push(pt);
      }
        
      pt.PointsId = $comboType.val();
      pt.PointsInheritFromSalePrice = $cbInherit.isChecked();
      pt.PointsAmount = $cbInherit.isChecked() ? null :_getAmount($txtAmount);
      pt.FaceValue = $cbInherit.isChecked() ? null : _getAmount($txtFace);
       
      callback();
    }
  };
});
