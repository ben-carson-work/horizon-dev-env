entDialog("ent-passthrough-dialog", function($dlg) {
  const SubEventPassthroughType_Day = 1;
  const SubEventPassthroughType_Minute = 2;
  var obj = null;
  var callback = null;
  var $radio = $dlg.find("[name='radio-passthrough']");
  var $txtStart = $dlg.find("#passthrough-tolstart-edit");
  var $txtEnd = $dlg.find("#passthrough-tolend-edit");
  var $blockTol = $dlg.find("#passthrough-tolerance");
  
  $radio.click(_refreshVisibility);
  
  function _refreshVisibility() {
    $blockTol.setClass("hidden", $radio.filter(":checked").val() != SubEventPassthroughType_Minute);
  }
  
  return {
    "width": 400,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      setRadioChecked($radio, (obj.PassthroughType) ? obj.PassthroughType : SubEventPassthroughType_Day);
      $txtStart.val(obj.PassthroughTolStart);
      $txtEnd.val(obj.PassthroughTolEnd);
    
      _refreshVisibility();
    },
    
    "onSave": function() {
      var tolStart = parseInt($txtStart.val());
      var tolEnd = parseInt($txtEnd.val());
      
      obj.PassthroughType = parseInt($radio.filter(":checked").val());
      obj.PassthroughTolStart = isNaN(tolStart) ? null : tolStart;
      obj.PassthroughTolEnd = isNaN(tolEnd) ? null : tolEnd;
    
      callback();
    }
  };
});
