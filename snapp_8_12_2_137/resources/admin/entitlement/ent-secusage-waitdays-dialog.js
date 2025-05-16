entDialog("ent-secusage-waitdays-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $txtDays = $dlg.find("#secusage-waitdays-edit");
  
  return {
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $txtDays.val(obj.SecUsageWaitDays);
      $txtDays.select();
    },
    
    "onSave": function() {
      var value = $txtDays.val();
      var qty = (value == "") ? null : parseInt(value);
    
      if ((qty != null) && isNaN(qty)) {
        showMessage(itl("@Common.InvalidValueError", $txtDays.val()), function() {
          txtQty.select();
        });
      } 
      else {
        obj.SecUsageWaitDays = qty;
        callback();
      }
    }
  };
});

/*
function showEntSecUsageWaitDaysDialog(obj, callback) {
  obj_EntSecUsage = obj;
  fnc_EntSecUsage = callback;

  $("#secusage-waitdays-edit").val(obj.SecUsageWaitDays);

  var $dlg = $("#ent-secusage-waitdays-dialog");
  $dlg.dialog({
    title: itl("@Entitlement.SecUsageWaitDays"),
    modal: true,
    width: 400,
    buttons: [
      {
        text: itl("@Common.Ok"),
        click: entSecUsage_OK
      },
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ] 
  });
  $("#secusage-waitdays-edit").focus();
  $("#entitlement-widget").on("remove", function() {
    $dlg.remove();
  });
}

function entSecUsage_DecodeDays(value) {
  return (value == "") ? null : parseInt(value);
}

function entSecUsage_OK() {
  var txtQty = $("#secusage-waitdays-edit");
  var value = txtQty.val();
  var qty = (value == "") ? null : parseInt(value);

  if ((qty != null) && isNaN(qty)) {
    showMessage(itl("@Common.InvalidValueError", value), function() {
      txtQty.focus();
    });
  } 
  else {
    closeDialog("#ent-secusage-waitdays-dialog");
    
    obj_EntSecUsage.SecUsageWaitDays = qty;
    fnc_EntSecUsage();
  }
}

$("#ent-secusage-waitdays-dialog").keypress(function(e) {
  if (e.keyCode == KEY_ENTER) 
    entSecUsage_OK();
});
*/