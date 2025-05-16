<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<script type="text/javascript" id="functions.jsp" >
  var workstationId = null;
  var userAccountId = null;
  
  function formatDate2(date1, format, divider) {
    var date1 = new Date(date1);
    var formattedDate = '';
    format = format.split(",");
    var field = {
      "d" : date1.getDate(),
      "m" : date1.getMonth() + 1 < 10 ? '0' + date1.getMonth() + 1 : date1
          .getMonth() + 1,
      "Y" : date1.getFullYear(),
      "h" : date1.getHours() < 10 ? '0' + date1.getHours() : date1.getHours(),
      "i" : date1.getMinutes() < 10 ? '0' + date1.getMinutes() : date1
          .getMinutes(),
      "s" : date1.getSeconds()
    };
    var formatLength = format.length;
    for (var i = 0; i < formatLength; i++) {
      formattedDate = formattedDate + field[format[i]];
      if ((i + 1) < formatLength) {
        formattedDate = formattedDate + divider;
      }

    }
    return formattedDate;
  }

  function getForm(maskCategoryId, savedData) {
    $(".accountForm").removeClass("active");
    var storedDatas = [];
    if (savedData!=null) {
      savedData = savedData.split('&');
      $.each(savedData, function(a, b) {
        var field = b.split('=');
        storedDatas.push(field);
      });
    }
    var form;
    var savedValue = '';
    var MaskIds = JSON.parse(localStorage.getItem('Category_' + maskCategoryId)).MaskIDs;
    if (MaskIds) {
      MaskIds = MaskIds.split(",");
      $(MaskIds).each(
      function(index, value) {
        var Mask = JSON.parse(localStorage.getItem('Mask_' + value));
        //alertjson(Mask);
        if(Mask) {
          var MaskFields = Mask.MaskItemList;
          if (MaskFields.length > 0) {
            form = '<h2 class="hidden">' + Mask.MaskName + '</h2>';
            form += '<form class="accountForm active">';
            //alertjson(MaskFields);
            $(MaskFields).each(
            function(index2, field) {
              if(storedDatas.length>1) {
              $(storedDatas).each(
                function(indexstored, storedvalue) {
                  if (storedvalue[0] == field.MetaFieldId) {
                    savedValue = decodeURIComponent(storedvalue[1]);
                    return false;
                  } else {
                    savedValue = '';
                  }
                });
              } else {
                savedValue = '';
              }
              if (field.Required) {
                var required = 'required="required"';
                var requiredlabel = "(*)";
              } else {
                var required = '';
                var requiredlabel = "";
              }
              //alertjson(field);
              var fieldtype;
              switch (field.FieldDataType) {
              case 1:
                fieldtype = '<input class="metafield" '+required+' data-fieldType="'+field.FieldType+'" name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="text" value="'+savedValue+'" />';
                break;
              case 2:
                fieldtype = '<input class="metafield" '+required+' data-fieldType="'+field.FieldType+'" name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="number"  value="'+savedValue+'" />';
                break;
              case 4:
                fieldtype = '<input class="metafield" '+required+' data-fieldType="'+field.FieldType+'" name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="text" value="'+savedValue+'" readonly />';
                fieldtype+= "<script>$(function () {$('#"+field.MetaFieldId+"').datepicker({changeYear:true,yearRange: '-100:+0',dateFormat: 'yy-mm-dd'});});</scr" + "ipt>";
                
                break;
              case 5:
                  fieldtype = '<input class="metafield" '+required+' data-fieldType="'+field.FieldType+'" name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="text"  value="'+savedValue+'"/>';
                  break;
              case 6:
                  fieldtype = '<input class="metafield datepicker" '+required+' data-fieldType="'+field.FieldType+'" name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="text" value="'+savedValue+'"/>';
                  //fieldtype+= "<script>$(function () {$('#"+field.MetaFieldId+"').datepicker({changeYear:true,yearRange: '-100:+0',dateFormat: 'yy-mm-dd'});});</scr" + "ipt>";
                  break;
              case 7:
                fieldtype = '<select class="metafield" '+required+' data-fieldType="'+field.FieldType+'" name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'">';
                var MetaFieldItemList = field.MetaFieldItemList;
                $(MetaFieldItemList)
                    .each(
                        function(index, value) {
                          fieldtype += '<option value="'+value.MetaFieldItemId+'">'
                              + value.MetaFieldItemName
                              + '</option>';
                        })

                fieldtype += '</select>';
                break;
              case 8:
                fieldtype = '';
                var MetaFieldItemList = field.MetaFieldItemList;
                $(MetaFieldItemList)
                    .each(
                        function(index, value) {
                          if (index == 0)
                            var isChecked = "checked";
                          else
                            var isChecked = "";
                          fieldtype += '<input class="metafield" type="radio" name="'+field.MetaFieldId+'" value="'+value.MetaFieldItemCode+'"' + isChecked + '>';
                          fieldtype += '<label for="'+value.MetaFieldItemId+'">'
                              + value.MetaFieldItemName
                              + '</label><br />';
                        })

                break;
              case 9:
                fieldtype = '';
                var MetaFieldItemList = field.MetaFieldItemList;
                $(MetaFieldItemList)
                    .each(
                        function(index, value) {
                          fieldtype += '<input class="metafield" '+required+' type="checkbox" name="'+field.MetaFieldId+'" value="'+value.MetaFieldItemCode+'"  value="'+savedValue+'">'
                              + '<label for="'+value.MetaFieldItemId+'">'
                              + value.MetaFieldItemName
                              + '</label><br />';
                        })

                break;
              case 10:
                  fieldtype = '<input class="metafield" '+required+' data-fieldType="'+field.FieldType+'" name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="text"  value="'+savedValue+'"/>';
                  break;
              case 11:
                  fieldtype = '<input class="metafield" '+required+' data-fieldType="'+field.FieldType+'" name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="text"  value="'+savedValue+'"/>';
                  break;
              case 12:
                fieldtype = '<input class="metafield" '+required+' data-fieldType="'+field.FieldType+'" name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="text"  value="'+savedValue+'"/>';
                break;
              case 15:
                fieldtype = '<input class="metafield" '+required+' data-fieldType="'+field.FieldType+'" name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="text" value="'+savedValue+'" />';
                break;
              default: fieldtype=field.FieldDataType;
                break;
              }
              form += '<div class="formItem flex" style="align-items:center"><div class="col-md-3 col-xs-3"><label class="fieldlabel">'
                  + field.MetaFieldName
                  + requiredlabel
                  + '</label></div><div class="col-md-9 col-xs-9">'
                  + fieldtype + "</div><br clear='all' /></div>";
              
            });
            
            //$('#accountFormFields').append('</table>');
          }
         
        }
        //alertjson(Mask);
      });
      form += '</form>';
    } else {

    }

    

    return form;
  }

  function validateForm() {
    var fieldtofocus = false;
    var requiredFields = $('.accountForm').find('[required="required"]');
    $.each(requiredFields, function(index, value) {
      if ($(this).val() == '') {
        $(this).addClass('error');
        if (fieldtofocus == false) {
          fieldtofocus = $(this);
        }
      }
    });

    if (fieldtofocus) {
      fieldtofocus.focus();
      return false;
    } else {
      return true;
    }
  }
  
  var focused;
  $(document).on('focus', '.accountForm.active input', function() {
    focused = document.activeElement;
    $('.formNavigation').show();
    // alert(focused);
  });

  $(document).on("click", ".formPrev", function() {
    event.preventDefault();
    event.stopPropagation();
    event.stopImmediatePropagation();
    var inputs = $(focused).closest("form").find(":input");
    inputs.eq(inputs.index(focused) - 1).focus();
  });
  
  $(document).on("click", ".formNext", function() {
    event.preventDefault();
    event.stopPropagation();
    //event.stopImmediatePropagation();
    //alert($(document.activeElement).val());
    var inputs = $(focused).closest("form").find(":input");
    inputs.eq(inputs.index(focused) + 1).focus();

  });
  
  $(document).on("click", ".accountForm.active .ProfilePictureId", function() {
    NativeBridge.call("CaptureImage", ["onRegistrationImageCapture"], null);
  });

  $(document).on("click", ".copyLast", function() {
    var lastDatas = [];
    event.preventDefault();
    event.stopPropagation();
    var lastSavedAccount = localStorage.getItem("lastSavedAccount");
    if (lastSavedAccount) {
      lastSavedAccount = lastSavedAccount.split("&");
      $.each(lastSavedAccount, function(a, b) {
        var field = b.split("=");
        lastDatas.push(field);
      });
    }
    $(lastDatas).each(function(indexstored, storedvalue) {
      $("#" + storedvalue[0]).val(decodeURIComponent(storedvalue[1]));
    });
  });
  
//! function to focus on next field in form with enter 
  $(document).on('keypress', 'input,select', function (e) {
    if (e.which == 13) {
      e.preventDefault();
      // Get all focusable elements on the page
      var $canfocus = $(':focusable');
      var index = $canfocus.index(this) + 1;
      if (index >= $canfocus.length) index = 0;
      $canfocus.eq(index).focus();
    }
  });

  function saveAccountDetails(accountDetails, accountId,categoryId) {
    //alert('ciao');
    var storedDatas = [];
    
    if (accountDetails) {
      accountDetails = accountDetails.split('&');
      $.each(accountDetails, function(a, b) {
        var field = b.split('=');
        storedDatas.push(field);
      });
    }
    
    if(!categoryId) {
      categoryId = Person_RootCategoryId;
    }
    
    var reqDO = {
      Command : 'SaveAccount',
      SaveAccount : {
        EntityType : '15',
        CategoryId : categoryId
      }
    };
    if (accountId) {
      reqDO['SaveAccount']['AccountId'] = accountId;
    }
    reqDO['SaveAccount']['MetaDataList'] = new Array();

    $(storedDatas).each(function(indexstored, storedvalue) {
      if (storedvalue[1].length > 0) {
        var metadata = {
          MetaFieldId : storedvalue[0],
          Value : decodeURIComponent(storedvalue[1])
        };
      } else {

      }
      if (metadata) {
        reqDO['SaveAccount']['MetaDataList'].push(metadata);
      }
    });

    return reqDO;
  }
    
  function CreditCardPayment(Amount, SaleId) {
    //----------- TO DO ---------------
    //Need to dinamically get informations from devices of the workstation
    //----------- TO DO ---------------
    NativeBridge.call("Pay", [ "pay_mPOS", Amount, SaleId ], function(paymentResult) {
      if (paymentResult.PaymentStatus == 2) {
        payTransaction(paymentResult.SaleID,paymentResult.CardNumber,paymentResult.AuthorizationCode,paymentResult.PaymentAmount,paymentResult.PaymentStatus);
      } else {

      }
    });
  }

  function activatePlugins(pluginList) {
    NativeBridge.call("SetPlugins", [ pluginList ], null);
  }

  function payTransaction(SaleId,CardNumber,AuthorizationCode,PaymentAmount,PaymentStatus) {
    var ShopCart = JSON.parse(localStorage.getItem('ShopCart'));
    
    ShopCart['Reservation']['SaleId']= SaleId;
    var reqDO = {
        Command : 'ValidateShopCart'
        };
      if (ShopCart) {
        reqDO.ShopCart = ShopCart;
      }
      //alert(JSON.stringify(reqDO));
      vgsService('ShopCart', reqDO, false,function(ansDO) {
        if (ansDO.Answer != null) {
          reqDO = {
            Command : 'InitTransaction',
            InitTransaction: {
              ShopCart: ansDO.Answer.ShopCart
            }
          };
          //alert(JSON.stringify(reqDO));
          vgsService('Transaction', reqDO, false,function(ansDO) {
            if (ansDO.Answer != null) {
              var msgRequest = JSON.stringify(ansDO.Answer.InitTransaction.Message);
              msgRequest = JSON.parse(msgRequest);
              
              var payment = {
                  PaymentType: '2',
                  PaymentStatus: PaymentStatus,
                  PaymentAmount:PaymentAmount,
                  CurrencyAmount:PaymentAmount,
                  CurrencyISO:'EUR',
                  ExchangeRate:1,
                  Change:1,
                  CreditCard: {
                    AuthorizationCode:AuthorizationCode,
                    CardNumber: CardNumber
                  }
                }
                
                msgRequest['Request']['PaymentList'] = new Array();
                msgRequest['Request']['PaymentList'].push(payment);
              }
              
              //if ((ShopCart.IncludeOrderConfirmationTickets || ShopCart.PreparePahDownload) && !isAsyncPayment) {
                msgRequest['Request']['Approved'] = true;
                msgRequest['Request']['Encoded'] = true;
                msgRequest['Request']['Printed'] = true;
                msgRequest['Request']['Validated'] = true;
              //} 
              
              reqDO = {
                Command: 'Add',
                Add: {
                  UploadId: getUniquid().toString().toUpperCase(),
                  UploadType: 1,
                  MsgRequest: JSON.stringify(msgRequest)
                }
              };   

              vgsService('Upload', reqDO, false,function(ansDO) {
                if (ansDO.Answer != null) 
                  checkUploadStatus(ansDO.Answer.Add.UploadId,'1');
                else {
                }
              });  
           
          });  
        } else {
        }
      }); 
      
      
  }

  
</script>

