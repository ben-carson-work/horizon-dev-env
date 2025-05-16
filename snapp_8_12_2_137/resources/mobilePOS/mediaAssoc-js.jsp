<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<% PageMobileSales pageBase = (PageMobileSales)request.getAttribute("pageBase"); %>

<script type="text/javascript" id="mediaAssoc-js.jsp" >

$(".mediaItem").blur(function(){
  $(this).find('.removeCode').hide();
});
function populateMediaAssoc() {
	   //mainactivity(mainactivity_step.checkout);
   sendCommand("StopRFID");
  var selected;
  $('#mediaAssocContent').html('');
  var cartItems = JSON.parse(localStorage.getItem('CartItems'));
  var hasProductsToEncode = false;
  $.each(cartItems, function (index, value) {
    console.log(value);
    
    if(((value.DocTemplateId != null)  && (value.DocEditorType == <%=LkSNDocEditorType.MediaInput.getCode()%>)) || (value.ForceMediaGeneration == true)) {
      var mediaRequired = true;
      var empty = 'empty';
      hasProductsToEncode = true;
    } else {
      var mediaRequired = false;
      var empty = 'nomedia empty';
    }
    if(value.RequireAccount) {
      var accountRequired = true;
      var requiredAccount = 'required';
      hasProductsToEncode = true;
    } else {
      var accountRequired = false;
      var requiredAccount = '';
    }
  
	  if (value.ShopCartItemType == <%=LkSNShopCartItemType.MatrixCell.getCode()%> && (mediaRequired) || accountRequired) {
      if (value.DocTemplateId == null && (mediaRequired)) {
     	  alert("<v:itl key="@Ticket.MisconfigMediaTemplateError"/>");
      } else {
        
				
				var itemDetailList = value.ItemDetailList;
				var cartItem = $("<div class='cartItem panel panel-default' data-ProductId="+value.ProductId+"/>").appendTo("#mediaAssocContent");
				var panelHeading = $('<div class="panel-heading" />').appendTo(cartItem);
				var productTitle = $('<h2 class="productTitle panel-title" />').appendTo(panelHeading);
				var mediaContainer = $("<div class='panel-body'/>").appendTo(cartItem);
				
				$(productTitle).append(value.ProductName);
				$.each(itemDetailList,function (a,itemDetail) {
				  if(index==0 && a==0) {
				    selected = 'selected';
				    if(empty=='nomedia empty') {
				      sendCommand("StopRFID");
				    } else {
				      sendCommand("StartRFID");
				    }
				  } else {
				    selected = '';
				  }
				  var mediaItem = $("<div class='mediaItem "+empty+" col-md-6 col-xs-6 text-center' data-itemDetailList="+itemDetail.Position+" data-requireAccount="+requiredAccount+" />").appendTo(mediaContainer);
				  var mediaStatus = $("<div class='"+selected+"'></div>").appendTo(mediaItem);
				  if(mediaRequired) {
				    var mediaRequest = $("<span class='barcodeContainer'>Media Required</span>").appendTo(mediaStatus);
				  }
				  var codeRemover = $("<span class='btn removeCode' style='display:none'>x</span>").appendTo(mediaItem);
				  if(accountRequired) {
				    $("<span class='accountName col-md-12 col-xs-12'>Account Required</span><br clear='all' />").appendTo(mediaStatus);
				  }
				});
				var mediaContainer = $("<br clear='all' />").appendTo(cartItem);
       }
	   }	   
  });

  if (hasProductsToEncode) {
	  //sendCommand("StartRFID");
  } else { 
	  mainactivity(mainactivity_step.checkout);
  }

}

$(document).on(clickAction,'.mediaItem',function() {
  
  //doMediaRead('81409CB21F1B04');
    var codeContainer = $(this).find('div');
  if(codeContainer.hasClass('selected')) {
    //alert('selected');
      if($(this).attr('data-requireAccount')=='required') {
        //alert('required');
        sendCommand('StopRFID');
        productId = $(this).parents('.cartItem').attr('data-ProductId');
        position = $(this).attr('data-itemDetailList');
        //check for saved data on this media
        var savedData = localStorage.getItem('ticketAccount_'+productId+"."+position);
        
        var product = JSON.parse(localStorage.getItem('Product_'+productId));
        
        var form = getForm(product.AccountCategoryId,savedData);
        //alert(form);
        $('.formNavigation').show();
        
        $('#myModal').find('.modal-body').html(form);
        if(accountId = $(this).attr('data-accountId')) {
          var reqDO = {
              Command: 'LoadEntAccount',
              LoadEntAccount : {
                AccountId:accountId
              }
            };
          vgsService('Account',reqDO,false, function(ansDO) {
            
          });
          $('#myModal').find('.modal-body').append('<input type="hidden" class="accountId" value="'+accountId+'" />');
        }
        
        $('#myModal').find('.modal-body').append('<input type="hidden" class="ticketReferrer" value="'+productId+"."+position+'" />');
        $('#myModal').find('.modal-footer').hide();
        $('#myModal').modal({
          backdrop: 'static',
          keyboard: false
        });
        
        $('.accountForm.active input:text').first().focus();
      }
    
  } else {
    
    $('#mediaAssocContent').find('.selected').parent('.mediaItem').find('.removeCode').hide();
    $('#mediaAssocContent').find('.selected').removeClass('selected');
    $(codeContainer).addClass('selected');
    if (($(this).hasClass('full'))&&(!$(this).hasClass('nomedia'))) {
      $(this).find('.removeCode').show();
    } else {
    
    }
  }
  if($(this).hasClass('nomedia')) {
    sendCommand("StopRFID");
  } else {

    sendCommand("StartRFID");
  }
});

$(document).on(clickAction,'.removeCode',function(e) {
  e.stopPropagation();
  e.stopImmediatePropagation();
  $(this).parent('.mediaItem').find('.barcodeContainer').html('Media Required');
  $(this).parent('.mediaItem').removeClass('full').addClass('empty');
  $(this).hide();
  checkCompletedMediaAssoc();
});

$(document).on(clickAction,'.saveTicketAccount',function() {
  
  var validation = validateForm();
  var accountId = $('.accountId').val();
  if(validation==false) {
    return false;
  }
  
  var formfield = $('.accountForm.active').serialize();
  var ticketReferrer = $('.ticketReferrer').val();
  if(ticketReferrer) {
    ProductIdPosition = ticketReferrer.split('.');
  }
  var categoryId;
  switch (mainactivityStep) {
  case mainactivity_step.account:
    categoryId = $('#categorySelect').val();
    break;
  }
  reqDO = saveAccountDetails(formfield,accountId,categoryId);
  
  vgsService('Account',reqDO,false, function(ansDO) {
    //alertjson(ansDO);
    if (ansDO.Header.StatusCode==200) {
      accountId = ansDO.Answer.SaveAccount.AccountId;
      
      switch (mainactivityStep) {
      case mainactivity_step.account:
        if (takenImage) {
          saveProfilePicture(accountId);
          takenImage ='';
          $(".accountForm.active .ProfilePictureId").attr("src","<v:config key="resources_url"/>/mobileSales/assets/images/appSalesGuest/profile_placeholder.jpg");
        }
        alert('Account Saved!');
        break;
      case mainactivity_step.mediaAssoc:
        ShopCart = JSON.parse(localStorage.getItem('ShopCart'));
        ShopCartItems = ShopCart.Items;
        $.each(ShopCartItems, function (index, value) {
          if(value.ProductId==ProductIdPosition[0]) {
            var itemDetailList = value.ItemDetailList;
            $.each(itemDetailList, function (a, itemDetail) {
              if(itemDetail.Position == ProductIdPosition[1]) {
                itemDetail.AccountId =accountId;
                return false;              
              }
            });
            return false;
          }
        });
        ShopCart.Items = ShopCartItems;
        localStorage.setItem('ShopCart',JSON.stringify(ShopCart));
        localStorage.getItem('ShopCart');
        
        

        var name = $('.accountForm.active').find('[data-fieldType="1"]').val();
        var lastname = $('.accountForm.active').find('[data-fieldType="3"]').val();
        console.log(formfield);
        
        var mediaAssoc = ticketReferrer.split('.');
        $('#mediaAssocContent').find('.selected').parents('.mediaItem').find('.accountName').html(name+" "+lastname);
        $('#mediaAssocContent').find('.selected').parents('.mediaItem').find('.accountName').show();
        $('#mediaAssocContent').find('.selected').parents('.mediaItem').removeClass('missingAccountData');
        $('#mediaAssocContent').find('.selected').parents('.mediaItem').addClass('hasAccountData');
        $('#mediaAssocContent').find('.selected').parents('.mediaItem').attr('data-accountId',accountId);
        if($('#mediaAssocContent').find('.selected').parents('.mediaItem').hasClass('nomedia')){
          $('#mediaAssocContent').find('.selected').parents('.mediaItem').removeClass('empty').addClass('full');
        }
        localStorage.setItem('ticketAccount_'+ticketReferrer,formfield);
        
        sendCommand('StartRFID');
        $('#myModal').modal('hide');
        $('.formNavigation').hide();
      //hide modal and formnavigation//
      
        checkCompletedMediaAssoc();
        
        var _this = $('#mediaAssocContent').find('.selected');
        $(_this).removeClass('selected');
        $( ".empty div" ).first().addClass('selected');   
        break;
      }
      
      localStorage.setItem('lastSavedAccount',formfield);
      $('.accountForm.active').trigger("reset");
      //hide modal and formnavigation//
      
    } else {
      return false;
    }
  }); 

});

function saveProfilePicture(AccountId) {
  var reqDO = {
    Command: 'Save',
    Save: {
      EntityType: <%=LkSNEntityType.Person.getCode()%>,
      EntityId: AccountId,
      Description: 'Profile picture',
      FileName: 'Image.jpg',
      DocData: unescape(takenImage).replace(/[\n\r]+/g, '').replace(/\s{2,10}/g, ' '),
      ProfilePicture: true
    }
  };
  vgsService("Repository", reqDO, false, function(ansDO) { 
    //Update the picture with the ansDO.Answer.Save.RepositoryId
  });
}

$(document).on(clickAction,'.formCancel',function() {
  if($('#mediaAssocContent').find('.selected').parents('.mediaItem').hasClass('hasAccountData')) {
    
  } else {
    $('#mediaAssocContent').find('.selected').parents('.mediaItem').addClass('missingAccountData')
  }
  var _this = $('#mediaAssocContent').find('.selected');
  $(_this).removeClass('selected');
  $( ".empty div" ).first().addClass('selected');
  
  sendCommand('StartRFID');
//hide modal and formnavigation//
  $('#myModal').modal('hide');
  $('.formNavigation').hide();
//hide modal and formnavigation//
});


//enable to test on pc the media association 
//  $(document).on('click','#mediaAssocContent',function() {
//    doMediaRead('81409CB21E2F04');
//  });
    
    
    function checkCompletedMediaAssoc() {
  var completed = true;
  $.each($('#mediaAssocContent').find('.mediaItem'), function(a,b) {
    if($(this).attr('data-requireAccount')=='required') {
      if(!($(this).hasClass('full')) || !($(this).hasClass('hasAccountData'))) {
        completed = false;
      }
    } else {
      if(!$(this).hasClass('full')) {
        completed = false;
      }
    }
  });
  
  if(completed) {
    $('#mainHeaderContinue').removeClass('disabled');
  } else {
    $('#mainHeaderContinue').addClass('disabled');
  }
}

var codereaded;
function doMediaRead(barcode) {
  reqDO = {
	    Command : 'Search',
	    Search: {
	      MediaCode: barcode
	    }
    };
          
  vgsService('Media',reqDO,true, function(ansDO) {
     if (ansDO.Header.StatusCode==200) {
       var mediaRef = null;    
       
    	 if (ansDO.Answer.Search.MediaList && ansDO.Answer.Search.MediaList.length > 0)
         mediaRef = ansDO.Answer.Search.MediaList[0];
    	 associateMedia(barcode, mediaRef);
     }
  });            
}

function generatePortfolioGroup(shopCart) {
	var groups = [];
  if (shopCart && shopCart.PortfolioList) {
		$.each(shopCart.PortfolioList, function(index, value) {
			groups.push(value.PortfolioGroup);
		});
  }

  for (i=1; i<10000; i++) {
    var group = "PF"+i;

    if (groups.indexOf(group) < 0) 
      return group;
  }
  
  return null;
}

function associateMedia(mediaCode, mediaRef) { 
  codereaded = true;
  var _this = $('#mediaAssocContent').find('.selected');
  $(_this).find(".barcodeContainer").html(mediaCode);
  $(_this).parent('.mediaItem').removeClass('empty').removeClass('error').addClass('full');
  
  productId = $(_this).parents('.cartItem').attr('data-ProductId');
  position = $(_this).parent('.mediaItem').attr('data-itemDetailList');
  
  ShopCart = JSON.parse(localStorage.getItem('ShopCart'));
  ShopCartItems = ShopCart.Items;
  $.each(ShopCartItems, function (index, value) {
    if(value.ProductId==productId) {
      var itemDetailList = value.ItemDetailList;
      $.each(itemDetailList, function (a, itemDetail) {
    	  
        if(itemDetail.Position == position) {
        	if(value.MediaExclusiveUse) {
	 	        if (mediaRef) {
	 	        	$(_this).find(".barcodeContainer").html('Media Required');
	 	        	$(_this).parent('.mediaItem').removeClass('full').addClass('empty').addClass('error');
	           		alert('Media already used');
		           	return false;
	          	} else {
	            //TODO: add the media code to the comma separated list MediaCodeNew
	//	          if (!itemDetail.MediaCodeNew || !itemDetail.MediaCodeNew.contains(mediaCode))
	        	  itemDetail.MediaCodeNew = mediaCode;  
	          }
        	} else {
        		if (mediaRef) {
		            itemDetail.PortfolioGroup = generatePortfolioGroup();
		            itemDetail.PortfolioId = mediaRef.PortfolioId;
		            itemDetail.MainPortfolioId = mediaRef.MainPortfolioId;
		            itemDetail.AccountId = mediaRef.AccountId;
		            itemDetail.AccountCode = mediaRef.AccountCode;
		            itemDetail.AccountName = mediaRef.AccountName;
		            itemDetail.WalletBalance = mediaRef.WalletBalance;
		            itemDetail.MediaCodeNew = null;
		            itemDetail.LinkToPortfolio = true;
		                       
		            accountId = mediaRef.AccountId;
		            if(accountId) {
		              $(_this).parent('.mediaItem').attr('data-accountId', mediaRef.AccountId),
		              $(_this).parent('.mediaItem').find('.accountName').html(mediaRef.AccountName);
		              $(_this).parent('.mediaItem').find('.accountName').show();
		              $(_this).parent('.mediaItem').removeClass('missingAccountData');
		              $(_this).parent('.mediaItem').addClass('hasAccountData');
		              $(_this).parent('.mediaItem').attr('data-accountId',mediaRef.AccountId);
		   	        } else {
		   	          
		   	        }
	          	} else {
	            //TODO: add the media code to the comma separated list MediaCodeNew
	//	          if (!itemDetail.MediaCodeNew || !itemDetail.MediaCodeNew.contains(mediaCode))
	        	  itemDetail.MediaCodeNew = mediaCode;  
	          }
        	}
            //TODO: add the media code to the comma separated list MediaCodeRef
//          if ((!itemDetail.MediaCodeRef || !itemDetail.MediaCodeRef.contains(mediaCode)) && (mediaCode != null))
          if (mediaCode != null)
        	  itemDetail.MediaCodeRef = mediaCode;

          return false;              
        }
      });
      return false;
    }
  });
  ShopCart.Items = ShopCartItems;
  localStorage.setItem('ShopCart',JSON.stringify(ShopCart));
//  localStorage.getItem('ShopCart');
  
  
  
  if(!$(_this).parent('.mediaItem').hasClass('hasAccountData')) {
    if($(_this).parent('.mediaItem').attr('data-requireAccount')=='required') {
      $(_this).find('.removeCode').show();
      sendCommand('StopRFID');
      
      var product = JSON.parse(localStorage.getItem('Product_'+productId));
      //alert(localStorage.getItem('Product_'+productId));
      var form = getForm(product.AccountCategoryId);
      
      $('#myModal').find('.modal-body').html(form);
      $('#myModal').find('.modal-body').append('<input type="hidden" class="ticketReferrer" value="'+productId+"."+position+'" />');
      if(accountId = $(this).attr('data-accountId')) {
        var reqDO = {
            Command: 'LoadEntAccount',
            LoadEntAccount : {
              AccountId:accountId
            }
          };
        vgsService('Account',reqDO,false, function(ansDO) {

        });
        $('#myModal').find('.modal-body').append('<input type="hidden" class="accountId" value="'+accountId+'" />');
      }
      //$('#myModal').find('.modal-footer').html('<button class="btn btn-primary saveTicketAccount" data-dismiss="modal">Save</button>');
      $('#myModal').modal({
        backdrop: 'static',
        keyboard: false
      });
      $('.accountForm.active').find('*').filter(':input:first').focus();
    } else {
      $(_this).removeClass('selected');
      $( ".empty div" ).first().addClass('selected');
    }
  } else {
    $(_this).removeClass('selected');
    $( ".empty div" ).first().addClass('selected');
  }
  checkCompletedMediaAssoc();
}

</script>


