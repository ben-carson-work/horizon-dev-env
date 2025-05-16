<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileSales" scope="request"/>

<script>
function setmask() {
	var rootCategory = JSON.parse(localStorage.getItem('Category_'+Person_RootCategoryId));
	//alertjson(rootCategory);
	$('#categorySelect').html('');
	$('#categorySelect').append($("<option>", { value: rootCategory.CategoryId, html: rootCategory.CategoryName }));
	populateSelect(rootCategory,1);	
}

function populateSelect(rootCategory,level) {
	//alertjson(rootCategory);
	var prefix = new Array(level+1).join('- ');
	if (rootCategory.CategoryList.length>0) {
		$(rootCategory.CategoryList).each(function (index, value) {
      var selected = '';
			if (value.CategoryId==AccountPRS_DefaultCategoryId)	{
				selected = 'selected="selected"';
				populateForm(value.CategoryId);
			}

			if (value.CategoryList && (value.CategoryList.length>0)) {
				$('#categorySelect').append("<option value="+value.CategoryId+" "+selected+">"+prefix+value.CategoryName+"</option>");
				populateSelect(value,level+1);
			} else {
				$('#categorySelect').append("<option value="+value.CategoryId+" "+selected+">"+prefix+value.CategoryName+"</option>");
			}						
		})		
	}	
}

function populateForm(CategoryId) {
	$('#accountFormFields').html('');
	$('.accountscontainer').html('');
	takenImage = '';
	
	var MaskIds = JSON.parse(localStorage.getItem('Category_'+CategoryId)).MaskIDs;
	
	if (MaskIds) {
		MaskIds = MaskIds.split(",");
		$('#accountFormFields').append('<img src="<v:config key="resources_url"/>/mobileSales/assets/images/appSalesGuest/profile_placeholder.jpg" style="border-radius: 10px;" class="ProfilePictureId" /><br clear="all" />');
		$(MaskIds).each(function(index,value) {
			Mask = JSON.parse(localStorage.getItem('Mask_'+value));
			MaskFields = Mask.MaskItemList;
			if (MaskFields.length>0) {
			$('#accountFormFields').append('<h2>'+Mask.MaskName+'</h2>');
			$('#accountFormFields').append('<table class="tablefield'+value+'" style="width:100%">');
			//alertjson(MaskFields);
			$(MaskFields).each(function (index2,field) {
				if (field.Required) {
		    		var required = 'required="required"';
		    		var requiredlabel = "(*)";
		    	} else {
		    		var required = '';
		    		var requiredlabel = "";
		    	}
				//alertjson(field);
				switch(field.FieldDataType) {
				    case 1:
				        fieldtype= '<input class="metafield" '+required+' name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="text" />';
				        break;
				    case 2:
				        fieldtype= '<input class="metafield" '+required+' name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="number" />';
				        break;
				    case 7:
				    	fieldtype = '<select class="metafield" '+required+' name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'">';
				    	var MetaFieldItemList = field.MetaFieldItemList;
				    	$(MetaFieldItemList).each(function (index,value) {
				    		fieldtype += '<option value="'+value.MetaFieldItemId+'">'+value.MetaFieldItemName+'</option>';
				    	})
				    	
				    	fieldtype += '</select>';
				        break;
				    case 8:
				    	fieldtype = '';
				    	var MetaFieldItemList = field.MetaFieldItemList;
				    	$(MetaFieldItemList).each(function (index,value) {
			          if (index == 0)
			        	  var isChecked = "checked";
			          else
                  var isChecked = "";
                fieldtype += '<input class="metafield" type="radio" name="'+field.MetaFieldId+'" value="'+value.MetaFieldItemCode+'"' + isChecked + '>';
                fieldtype += '<label for="'+value.MetaFieldItemId+'">'+
											    		 value.MetaFieldItemName+
											    	 '</label><br />';
				    	})
				    	
				    	
				        break;
				    case 9:
				    	fieldtype = '';
				    	var MetaFieldItemList = field.MetaFieldItemList;
				    	$(MetaFieldItemList).each(function (index,value) {
				    		fieldtype += '<input class="metafield" '+required+' type="checkbox" name="'+field.MetaFieldId+'" value="'+value.MetaFieldItemCode+'" >'+
				    		'<label for="'+value.MetaFieldItemId+'">'+
			    				value.MetaFieldItemName+
			    			'</label><br />';
				    	})

				        break;
				    case 12:
				        fieldtype= '<input class="metafield" '+required+' name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="text" />';
				        break;
				}
				$('#saveAccount .tablefield'+value).append('<tr><td style="width:30%"><label class="fieldlabel">'+field.MetaFieldName+requiredlabel+'</label></td><td style="width:70%">'+fieldtype+"<br clear='all' /></tr>");
			});
			//$('#accountFormFields').append('</table>');
			}
			//alertjson(Mask);
		})
	} else {

	}	
}
var searchtext='';
var lastarray = {};

function searchDuplicate(text,textfield) {
	var newarray = new Array();
	//if (text){
		
		$("#saveAccount .metafield").each(function (index,value) {
			var type = $(value).attr('type');
			if (type=='text' || type=='number') {
				var val = $(value).val();
				if (val) {
					
					newarray.push(val);
				}
			}
		});
    	
    	
    	searchtext = newarray.join();
    	var reqDO = {
    	    	Command: 'SearchDuplicates',
    	    	SearchDuplicates : {
    	    		EntityType:'15',
    	    		Values:searchtext
    			  }
    	    };
    	vgsService('Account',reqDO,false, function(ansDO) {
         	//alertjson(ansDO);
         	if (ansDO.Answer) {
         		$('.accountscontainer').html('');
         		
         		$(ansDO.Answer.SearchDuplicates.AccountList).each(function (index,value) {
         			
         			if (value.ProfilePictureId!=null) {
	    					var image = "<v:config key='site_url'/>/repository?id="
	                        + value.ProfilePictureId 
	                        + '&type=small';
	    				} else {
	    					var image = '<v:image-link name="'+value.IconName+'" size="50"/>';
	    				}
         			$('.accountscontainer').append('<span class="existingaccount" id="'+value.AccountId+'" style="float:left;"><div style="background:url('+image
         	                + ');width: 30px; height: 30px; float: left;background-position: 50% 50%; margin-right: 10px;background-size: 100%;" />'+value.DisplayName+'<br/><span class="category">'+value.CategoryRecursiveName+'</span></span>');
         		});
         		$('.accountscontainer').append('<br clear="all">');        		
         	}
         	
         	//$(".accountscontainer").width((($(".existingaccount").outerWidth()*$('.existingaccount').length)+10)+"px");
         	if ( (($(".existingaccount").outerWidth()*$('.existingaccount').length)+10) > $( window ).width() ) {
         		$("#existingAccounts").css("overflow","scroll");
         	} else {
         		$("#existingAccounts").css("overflow","hidden");
         	}
        });
	//}
    	
}

var takenImage = '';

function onRegistrationImageCapture(imageData) {
  takenImage = imageData;  
  $("#saveAccount .ProfilePictureId").attr("src","data:image/png;base64,"+takenImage);
}

function onUpdateRegistrationImageCapture(imageData) {
  takenImage = imageData;
  $("#existSaveAccount .ProfilePictureId").attr("src","data:image/png;base64,"+takenImage);
}

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
var fieldtype = '';

$( document ).ready(function() {
	
	$(document).on('click','#existSaveAccount .ProfilePictureId',function() {
		NativeBridge.call("CaptureImage", ["onUpdateRegistrationImageCapture"], null);
	});
	
	$(document).on('click','#saveAccount .ProfilePictureId',function() {
    NativeBridge.call("CaptureImage", ["onRegistrationImageCapture"], null);
  });
	
	
	//function to focus on next field in form with enter 
	jQuery.extend(jQuery.expr[':'], {
	    focusable: function (el, index, selector) {
	        return $(el).is('a, button, :input, [tabindex]');
	    }
	});

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
	//! function to focus on next field in form with enter 
	
	
	$('#categorySelect').on('change',function() {
		populateForm($(this).val());
	});
	
	$(document).on('focusout',"#saveAccount .metafield[type=text]",function () {
		searchDuplicate($(this).val(),$(this).attr('id'));		
	})
	
	$(document).on('click','.existingaccount',function() {
		var reqDO = {
		    	Command: 'LoadEntAccount',
		    	LoadEntAccount : {
		    		AccountId:$(this).attr('id')
				  }
		    };
		vgsService('Account',reqDO,false, function(ansDO) {
	     	//alertjson(ansDO);
	     	$('#existAccountFormFields').html('');
	     	$('#existAccountForm').removeClass('hidden');
	     	$('#existSaveAccount').css({'margin-left':'200%'}).animate({
	     	    "margin-left": "5%"
	     	});
	     	if (ansDO.Answer.LoadEntAccount.Account.ProfilePictureId) {
	     	var image = "<v:config key='site_url'/>/repository?id="
                + ansDO.Answer.LoadEntAccount.Account.ProfilePictureId 
                + '&type=small';
	     	
     			$('#existAccountFormFields').append('<img src="'+image+'" style="border-radius: 10px;" class="ProfilePictureId" /><br clear="all" />');
     			//$('#existAccountFormFields').append('<input type="hidden" class="metafield" id="ProfilePictureId" name="ProfilePictureId" value="'+ansDO.Answer.LoadEntAccount.Account.ProfilePictureId+'" />');
	     	} else {
	     	 $('#existAccountFormFields').append('<img src="<v:config key="resources_url"/>/mobileSales/assets/images/appSalesGuest/profile_placeholder.jpg" style="border-radius: 10px;" class="ProfilePictureId" /><br clear="all" />');
	     	 
	     	}
	     	var MaskIds = ansDO.Answer.LoadEntAccount.Account.MaskIDs;
	     		MaskIds = MaskIds.split(",");
	     		
	     		$(MaskIds).each(function(index,value) {
	    			Mask = JSON.parse(localStorage.getItem('Mask_'+value));
	    			MaskFields = Mask.MaskItemList;
	    			if (MaskFields.length>0) {
	    			$('#existAccountFormFields').append('<h2>'+Mask.MaskName+'</h2>');
	    			$('#existAccountFormFields').append('<table class="tablefield'+value+'" style="width:100%">');
	    			$('#existAccountFormFields').append('<input type="hidden" id="AccountId" value="'+ansDO.Answer.LoadEntAccount.Account.AccountId+'" />');
	    			$('#existAccountFormFields').append('<input type="hidden" id="CategoryId" value="'+ansDO.Answer.LoadEntAccount.Account.CategoryId+'" />');
	    			$(MaskFields).each(function (index2,field) {
	    				$(ansDO.Answer.LoadEntAccount.Account.MetaDataList).each(function (index3,accvalue){
	    					if (field.MetaFieldId == accvalue.MetaFieldId) {
	    						value2 = accvalue.Value;
	    						return false;
	    					} else {
	    						value2 = '';
	    					}
	    				});
	    				
	    				
	    				if (field.Required) {
	    		    		var required = 'required="required"';
	    		    		var requiredlabel = "(*)";
	    		    	} else {
	    		    		var required = '';
	    		    		var requiredlabel = "";
	    		    	}
	    				switch(field.FieldDataType) {
	    				    case 1:
	    				    	
	    				        fieldtype= '<input class="metafield" '+required+' value="'+value2+'" name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="text" />';
	    				        break;
	    				    case 2:
	    				    	
	    				        fieldtype= '<input class="metafield" '+required+' name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="number" />';
	    				        break;
	    				    case 7:
	    				    	
	    				    	fieldtype = '<select class="metafield" '+required+' name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'">';
	    				    	var MetaFieldItemList = field.MetaFieldItemList;
	    				    	$(MetaFieldItemList).each(function (index,value) {
	    				    		if (value2==value.MetaFieldItemName) {
	    				    			checked = "selected='selected'";
	    				    		} else {
	    				    			checked = "";
	    				    		}
	    				    		fieldtype += '<option value="'+value.MetaFieldItemId+'" '+checked+'>'+value.MetaFieldItemName+'</option>';
	    				    	})
	    				    	
	    				    	fieldtype += '</select>';
	    				        break;
	    				    case 8:
	    				    	fieldtype = '';
	    				    	var MetaFieldItemList = field.MetaFieldItemList;
	    				    	$(MetaFieldItemList).each(function (index,value) {
	    				    		if (value2==value.MetaFieldItemCode) {
	    				    			checked = "checked";
	    				    		} else {
	    				    			checked = "";
	    				    		}
	    				    		fieldtype += '<input class="metafield" type="radio" name="'+field.MetaFieldId+'" value="'+value.MetaFieldItemCode+'" '+checked+'>'+
	    				    		'<label for="'+value.MetaFieldItemId+'">'+
	    				    			value.MetaFieldItemName+
	    				    		'</label><br />';
	    				    	})
	    				    	
	    				    	
	    				        break;
	    				    case 9:
	    				    	fieldtype = '';
	    				    	value2 = value2.split(",");
	    				    	
	    				    	var MetaFieldItemList = field.MetaFieldItemList;
	    				    	$(MetaFieldItemList).each(function (index,value) {
	    				    		$(value2).each(function (index,value3) {
	    				    		if (value3==value.MetaFieldItemCode) {
	    				    			checked = "checked";
	    				    			return false;
	    				    		} else {
	    				    			checked = "";
	    				    		}
	    				    		});
	    				    		fieldtype += '<input class="metafield"  type="checkbox" name="'+field.MetaFieldId+'" value="'+value.MetaFieldItemCode+'" '+checked+' >'+
	    				    		'<label for="'+value.MetaFieldItemId+'">'+
	    			    				value.MetaFieldItemName+
	    			    			'</label><br />';
	    				    	})

	    				        break;
	    				    case 12:
	    				    	fieldtype= '<input class="metafield" '+required+' value="'+value2+'" name="'+field.MetaFieldId+'" id="'+field.MetaFieldId+'" type="text" />';
	    				        break;
	    				}
	    				
	    				$('#existAccountFormFields .tablefield'+value).append('<tr><td style="width:30%"><label class="fieldlabel">'+field.MetaFieldName+requiredlabel+'</label></td><td style="width:70%">'+fieldtype+"<br clear='all' /></tr>");
	    			});
	    			}
	    			//alertjson(Mask);
	    		})
	     		
	     	//localStorage.setItem('Mask_'+MaskId,JSON.stringify(ansDO.Answer.LoadEntMask.Mask));     	
	    });
	});
	
	$('.back').on('click',function() {
		$('#existAccountForm').addClass('hidden');
		return false;
	});
	$('.update').on('click',function() {
	  validation = validateForm("existAccountForm");
    if(validation) {
     return false;
    }
		var Html = "";
		Html = '<div>'
			+ '<div class="button dialogClose">Close</div>'
			+ '<div class="button Save" id="update">Save</div>'
			+ 'Do you want to update this Account?'
      + '</div>';
      Html += '</div>';
    showDialog('Confirm', Html, false, '80%','300px');
		
		    return false;
	});
	
	$('.copy').on('click',function() {
	  validation = validateForm("existAccountForm");
    if(validation) {
     return false;
    }
		var Html = "";
		Html = '<div>'
			+ '<div class="button dialogClose">Close</div>'
			+ '<div class="button Save" id="copy">Save</div>'
			+ 'Do you want to create a new Account copyng those information?'
      + '</div>';
      Html += '</div>';
    showDialog('Confirm', Html, false, '80%','300px');
		
		    return false;
	});
	/*
	$('#existSaveAccount').submit(function() {
		var Html = "";
		Html = '<div>'
			+ '<div class="button dialogClose">Close</div>'
			+ '<div class="button Save" id="update">Save</div>'
			+ '</div>';
			Html += '</div>';
		showDialog('Confirm', Html, false, '50%','200px');
		return false;
	});*/
	function validateForm (formid) {
	  var Html = "";
    var validation = "";
    if ($("#"+formid+" .metafield[required='required']").length>0) {
      
      $("#"+formid+" .metafield[required='required']").each(function (index,value) {
        metadata = "";
        var type = $(value).attr('type');
       
        if (type=='text' || type=='number') {
          
          if ( $(value).val().length == '') {
            validation = 'error';
            Html = '<div>'
              + '<div class="button dialogClose">Close</div>'
              + 'Please fill in all required data'
              + '</div>';
              Html += '</div>';
            showDialog('Missing Data', Html, false, '80%','300px');
            $(value).focus();
            return false;
          }
        } 
      });
      if (validation) {
        return validation;
      }
      var checkboxes = {}
      $(":checkbox[required='required']").each(function(){
        checkboxes[this.name] = $(this);
      })
      for(group in checkboxes){
        metadata = "";
          if(($(":checkbox[name='"+group+"']:checked").length)==0) {
          validation = 'error';
          Html = '<div>'
            + '<div class="button dialogClose">Close</div>'
            + 'Please fill in all required checkboxes'
            + '</div>';
            Html += '</div>';
          showDialog('Missing Data', Html, false, '80%','300px');
         
          break;
          
        }
      }
    }
    return validation;
	}
	$("#saveAccount").submit(function() {
	  
	  validation = validateForm("saveAccount");
	  if(validation) {
	   return false;
	  }
	  
		
		Html = '<div>'
			+ '<div class="button dialogClose">Close</div>'
			+ '<div class="button Save" id="Save">Save</div>'
			+ "Do you want to save those Account's information?"
			+ '</div>';
			Html += '</div>';
		showDialog('Confirm', Html, false, '80%','300px');
	 return false;
	});
	$(document).on("click", '.dialogClose', function() {
        $('#dialogBG').hide();
        });
    $(document).on("click",'#Save', function() {
    //alert($(this).attr('rel'));
      saveAccountDetails();
      $('#dialogBG').hide();
    });
    $(document).on("click",'#copy', function() {
        //alert($(this).attr('rel'));
          copyAccountDetails();
          $('#dialogBG').hide();
        });
    $(document).on("click",'#update', function() {
        //alert($(this).attr('rel'));
          updateAccountDetails();
          $('#dialogBG').hide();
    });
});

function copyAccountDetails() {
	var reqDO = {
	    	Command: 'SaveAccount',
	    	SaveAccount : {
	    		EntityType:'15',
	    		CategoryId:$("#existSaveAccount #CategoryId").val()
			}
	    };
	reqDO['SaveAccount']['MetaDataList'] = new Array();
	
	$("#existSaveAccount .metafield").each(function (index,value) {
		metadata = "";
		var type = $(value).attr('type');
		
		if (type=='text' || type=='number') {
			 metadata = {
			   	MetaFieldId:$(value).attr('name'),
    			Value: $(value).val()
		    };
		} else if (type=='radio') {
			if($(this).is(':checked')) {
		        metadata = {
					   	MetaFieldId:$(value).attr('name'),
		    			Value: $(this).val()
				    };
			}
		} else if (type=='checkbox') {
			/*var name = $(this).attr('name');
			$("input[name='"+name+":checked").each(function(){
				checkboxes[name].push($(this).val());
			});*/
		}
		if (metadata) {
			reqDO['SaveAccount']['MetaDataList'].push(metadata);
		}
	});
	
	$("#existSaveAccount select.metafield").each(function(){
		metadata = "";
		metadata = {
			   	MetaFieldId:$(this).attr('id'),
    			Value:$(this).find(":selected").text()
		    };
		
		if (metadata) {
			reqDO['SaveAccount']['MetaDataList'].push(metadata);
		}
	})
	
	var radio_groups = {}
	$("#existSaveAccount :checkbox").each(function(){
	    radio_groups[this.name] = $(this);
	})
	for(group in radio_groups){
		metadata = "";
		value = '';
	    $("#existSaveAccount :checkbox[name='"+group+"']:checked").each(function (index,checkboxvalue) {
	    	value +=  $(checkboxvalue).val()+",";
	    });
	    metadata = {
			   	MetaFieldId:group,
    			Value: value
		    };
	    if (metadata) {
			reqDO['SaveAccount']['MetaDataList'].push(metadata);
		}
	}
	
  doSaveAccount(reqDO);
}

function updateAccountDetails() {
	//alert($("#existSaveAccount #ProfilePictureId").val());
	var reqDO = {
	    	Command: 'SaveAccount',
	    	SaveAccount : {
	    		AccountId: $("#existSaveAccount #AccountId").val(),
	    		EntityType:'15',
	    		CategoryId:$("#existSaveAccount #CategoryId").val(),
	    		ProfilePictureId:$("#existSaveAccount #ProfilePictureId").val()
			}
	    };
	
	
	reqDO['SaveAccount']['MetaDataList'] = new Array();
	
	$("#existSaveAccount .metafield").each(function (index,value) {
		metadata = "";
		var type = $(value).attr('type');
		
		if (type=='text' || type=='number') {
			 metadata = {
			   	MetaFieldId:$(value).attr('name'),
    			Value: $(value).val()
		    };
		} else if (type=='radio') {
			metadata = "";
			if($(this).is(':checked')) {
		        metadata = {
					   	MetaFieldId:$(value).attr('name'),
		    			Value: $(this).val()
				    };
			}
		} else if (type=='checkbox') {
			/*var name = $(this).attr('name');
			$("input[name='"+name+":checked").each(function(){
				checkboxes[name].push($(this).val());
			});*/
		}
		if (metadata) {
			reqDO['SaveAccount']['MetaDataList'].push(metadata);
		}
	});
	
	$("#existSaveAccount select.metafield").each(function(){
		metadata = "";
		metadata = {
			   	MetaFieldId:$(this).attr('id'),
    			Value:$(this).find(":selected").text()
		    };
		if (metadata) {
			reqDO['SaveAccount']['MetaDataList'].push(metadata);
		}
	})
	
	var radio_groups = {}
	$("#existSaveAccount :checkbox").each(function(){
	    radio_groups[this.name] = $(this);
	})
	for(group in radio_groups){
		metadata = "";
		value = '';
	    $("#existSaveAccount :checkbox[name='"+group+"']:checked").each(function (index,checkboxvalue) {
	    	value +=  $(checkboxvalue).val()+",";
	    });
	   
	    metadata = {
			   	MetaFieldId:group,
    			Value: value
		    };
	    if (metadata) {
			reqDO['SaveAccount']['MetaDataList'].push(metadata);
		}
	}
		
	doSaveAccount(reqDO);	
}

function doSaveAccount(reqDO) {
    //alertjson(reqDO);
  vgsService('Account',reqDO,false, function(ansDO) {
	    //alertjson(ansDO);
	    if (ansDO.Header.StatusCode==200) {
	      showDialog('Account Saved','<p>Account Saved</p>',1,"80%","150px");
        $("#saveAccount .metafield:not([type='radio']):not([type='checkbox'])").val('');
        $(":checkbox").attr('checked', false); // Unchecks it;
	      $('#existAccountForm').addClass('hidden');
	      //alert(ansDO.Answer.SaveAccount.AccountId);
	      
	      if (takenImage) {
	        saveProfilePicture(ansDO.Answer.SaveAccount.AccountId);
	        takenImage ='';
	        }
	    } 
	    //localStorage.setItem('Mask_'+MaskId,JSON.stringify(ansDO.Answer.LoadEntMask.Mask));
	    $('.accountscontainer').html('');
	    $('#existAccountForm').addClass('hidden');
	    $("#saveAccount .ProfilePictureId").attr("src","<v:config key="resources_url"/>/mobileSales/assets/images/appSalesGuest/profile_placeholder.jpg");
	  });  
}

function saveAccountDetails() {
	
	var reqDO = {
	    	Command: 'SaveAccount',
	    	SaveAccount : {
	    		EntityType:'15',
	    		CategoryId:$('#categorySelect').val()
			  }
	    };
	reqDO['SaveAccount']['MetaDataList'] = new Array();
	if ($("#saveAccount .metafield").length>0) {
		$("#saveAccount .metafield").each(function (index,value) {
			metadata = "";
			var type = $(value).attr('type');
			
			if (type=='text' || type=='number') {
				//if ( $(value).val().length>0) {
				 metadata = {
				   	MetaFieldId:$(value).attr('name'),
	    			Value: $(value).val()
			    };
				//}
			} else if (type=='radio') {
				if($(this).is(':checked')) {
			        metadata = {
						   	MetaFieldId:$(value).attr('name'),
			    			Value: $(this).val()
					    };
				}
			} 
			if (metadata) {
				reqDO['SaveAccount']['MetaDataList'].push(metadata);
			}
		});
		
		$("select.metafield").each(function(){
			metadata = "";
			metadata = {
				   	MetaFieldId:$(this).attr('id'),
	    			Value:$(this).find(":selected").text()
			    };
			
			if (metadata) {
				reqDO['SaveAccount']['MetaDataList'].push(metadata);
			}
		})
		
		var checkboxes = {}
		$(":checkbox").each(function(){
			checkboxes[this.name] = $(this);
		})
		for(group in checkboxes){
			metadata = "";
			value = '';
		    $(":checkbox[name='"+group+"']:checked").each(function (index,checkboxvalue) {
		    	value +=  $(checkboxvalue).val()+",";
		    });
		    metadata = {
				   	MetaFieldId:group,
	    			Value: value
			    };
		    if (metadata) {
				reqDO['SaveAccount']['MetaDataList'].push(metadata);
			}
		}
	  		
	
		  doSaveAccount(reqDO); 
	}  	
	    return false;

}

</script>