<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<% PageMobileSales pageBase = (PageMobileSales)request.getAttribute("pageBase"); %>

<script type="text/javascript" id="event-js.jsp" >

var SellableDateTimeFrom
function populateEvent(eventId) {
  
  reqDO = {
      Command: 'LoadEntEvent',
      LoadEntEvent : {
        EventId : eventId
      }
        };   
  //alert(JSON.stringify(reqDO));
  vgsService('Event',reqDO,true, function(ansDO) {
    if (ansDO.Answer!=null) {
      localStorage.setItem('Event_'+eventId,JSON.stringify(ansDO.Answer.LoadEntEvent.Event));
      event = JSON.parse(localStorage.getItem('Event_'+eventId));
      
      if(event.EventType=1) {
        $('#PerformancesContainer').html('');
        getPerformances(eventId);
        
      }
      var image;
      var imgbgstyle;
      if (event.ProfilePictureId) {
        image = '<v:config key="site_url"/>/repository?id='+event.ProfilePictureId+'&type=medium';
      } else {
        image = '<v:image-link name="<%=LkSNEntityType.Event.getIconName()%>" size="64"/>';
        imgbgstyle = 'background-size: 80%;';
      }
      
      $('#eventImage').html('<img src="'+image+'" class="img-responsive"/>');
      $('#eventTitle').html("<h2>"+event.EventName+"</h2>");
      //$('#eventDesc').html(event.RichDescList[0].Description);
      $('#eventId').val(eventId);
      $('#mainContent').bind('scroll', chk_scroll);

    } else {
            
    }
  }); 
  
  
  
}
function getPerformances(eventId,SellableDateTimeFrom,PagePos) {
  
  if(!SellableDateTimeFrom) {
    var currentdate = new Date(); 
    SellableDateTimeFrom = currentdate.getFullYear() + "-"
                    + ('0' + (currentdate.getMonth()+1)).slice(-2)  + "-" 
                    + ('0' + currentdate.getDate()).slice(-2) + "T"  
                    + currentdate.getHours() + ":"  
                    + currentdate.getMinutes() + ":" 
                    + currentdate.getSeconds();
    var ToDateTime = currentdate.getFullYear() + "-"
    + ('0' + (currentdate.getMonth()+1)).slice(-2)  + "-" 
    + ('0' + currentdate.getDate()).slice(-2) + "T23:59:00";
    
  } else {
    var ToDateTime = SellableDateTimeFrom.slice(0, 10)+ "T23:59:00";
    //var SellableDateTimeFrom = SellableDateTimeFrom+ "T00:00:00";
    
  }
  if(!PagePos) {
    PagePos = 0;
  } 
  
  $('#SellableDateTimeFrom').val(SellableDateTimeFrom);
  PagePos = parseInt(PagePos)+1;
  $('#PagePos').val(PagePos);
  reqDO = {
      Command : 'Search',
      Search : {
        EventId : eventId,
        SellableDateTimeFrom : SellableDateTimeFrom,
        ToDateTime:ToDateTime,
        SeatMinQuantity:1,
        PagePos:PagePos,
        ReturnProducts: true,
        SellableOnly: true,
        ReturnAvailability: true,
        ReturnSeatCategoryRateCode: true,
        EventCatalogId: currentFolder.CatalogId,
        RecordPerPage:20
     }
  };
  
  vgsService('Performance', reqDO, true,function(ansDO) {

    if (ansDO.Answer != null) {
      if(ansDO.Answer.Search.PerformanceList) {
        var performanceList = ansDO.Answer.Search.PerformanceList;
        populatePerformances(performanceList);
        $('#mainContent').bind('scroll', chk_scroll);
      }
    } else {

    }
    
  });
  
  $('#dateChoosen').html(formatDate(xmlToDate(SellableDateTimeFrom), <%=pageBase.getRights().ShortDateFormat.getInt()%>));
}

function populatePerformances(performanceList) {
  $('#PerformancesContainer').html('');
  $.each(performanceList, function (index, value) {
    //alert(JSON.stringify(value));
    var display;
    if(value.QuantityMax == 0) {
      value.QuantityFree = '';
      display = "display:none";
    }
    
    if(value.PerformanceDesc==null) {
      value.PerformanceDesc='';
    }

    /*var divExt = $("<div class='performance'/>").appendTo("#PerformancesContainer");
    var divDate = $("<div style='padding:30px' class='flex col-md-11 col-xs-11' />").appendTo(divExt);
    var divPerformanceDate = $("<div class='performanceDate col-md-2 col-xs-2' />").appendTo(divDate);
    div.text(asfgsagf)*/
    

    var availability = '';
    if (value.QuantityMax > 0)
    {
      availability = '<div class="Availability col-md-3 col-xs-3">'
                      + ((value.QuantityFree > 0)? value.QuantityFree : "Sold Out") +
                      '<div class="progress" style="'+display+'">'+
                      '<div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="'+value.QuantityFree+'" aria-valuemin="0" aria-valuemax="'+value.QuantityMax+'" style="width: '+(value.QuantityFree/value.QuantityMax)*100+'%">'+
                        '<span class="sr-only">'+(value.QuantityFree/value.QuantityMax)*100+'%</span>'+
                      '</div>'+
                      '</div>'+
                    '</div>';
    }

    var prfrmncItm = '<div class="performance" id ="'+value.PerformanceId +'">'+
                      '<div style="padding: 10px 20px 10px 0;align-items: center" class="flex col-md-11 col-xs-10">'+
                        '<div class="performanceDate col-md-4 col-xs-4 flex" style="align-items: center;">'+
                            '<div class="col-md-4 col-xs-6"><img src="<v:image-link name="b2b-perf.png" size="64"/>" class="img-responsive" /></div><div class="col-md-8 col-xs-6">'+
                            formatTime(xmlToDate(value.DateTimeFrom), <%=pageBase.getRights().ShortTimeFormat.getInt()%>)+
                            '<br/>'+
                            formatTime(xmlToDate(value.DateTimeTo), <%=pageBase.getRights().ShortTimeFormat.getInt()%>)+
                        '</div></div>'+
                        '<div class="performanceDesc col-md-6 col-xs-6">'+ value.PerformanceDesc + '</div>'+
                        availability +
                        '</div>'+
                      '<div class="col-md-1 col-xs-2 no-padding">'+
                        '<button class="btn btn-default PerformanceProduct"><img src="<v:image-link name="bkoact-forward-grey.png" size="64"/>" class="img-responsive" /></button>'+
                      '</div>'+
                      '<br clear="all" />'+
                    '</div>'
    
    $('#PerformancesContainer').append(prfrmncItm);
    $('#'+ value.PerformanceId).data('data-performance', value)                    
  });
  
}

$(document).on(clickAction,('.PerformanceProduct','.performance'),function(e) {
  e.stopPropagation();
  e.stopImmediatePropagation();
  var performance = $(this).data('data-performance');
  //alert(PerformanceId);
  $('#performanceCapacity').html('');
   $('#productList').html('');
  showProducts(performance);
  mainactivity(mainactivity_step.eventProducts);
  
});

function showProducts(performance) {
   populateProducts(performance.ProductList, performance.performanceId);
}

function populateProducts(ProductList, Performanceid) {

	var categorys = ProductList.map(function(item) { return { SeatCategoryId: item.SeatCategoryId,
															  SeatCategoryName: item.SeatCategoryName,
															  SeatQuantityFree: item.SeatQuantityFree,
															  SeatQuantityMax: item.SeatQuantityMax };});
	var uniqueCategoryIds = [];
	var uniqueCategories = [];
	for(i = 0; i< categorys.length; i++){
	    if(uniqueCategoryIds.indexOf(categorys[i].SeatCategoryId) === -1){
	    	uniqueCategoryIds.push(categorys[i].SeatCategoryId);
	    	uniqueCategories.push(categorys[i]);
	    }
	}

	$.each(uniqueCategories,function (index,value){
		$('#performanceCapacity').append('<div class="col-sm-3"><div class="capacitycategory"><div class="clearfix"><div class="capacitycategorytitle" title="'+value.SeatCategoryName+'">'+value.SeatCategoryName+'</div><div id="ctgrFree_'+value.SeatCategoryId+'" class="capacitycategorycount" title="'+ value.SeatQuantityFree  +'">'+ value.SeatQuantityFree  +'</div></div><div>'+'<div class="progress">'+
                '<div id="ctgrPrgrs_'+value.SeatCategoryId+'" class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="'+value.SeatQuantityFree+'" aria-valuemin="0" aria-valuemax="'+value.SeatQuantityMax+'" style="width: '+(value.SeatQuantityFree/value.SeatQuantityMax)*100+'%">'+
                '</div></div></div></div></div>');
	});
	
	
  $.each(ProductList, function (index, value) {
    $('#productList').append(
      '<div class="Product panel-body">'+
        '<div style="padding:0px">'+
          '<div class="flex">'+
             '<h3 class="col-md-10">'+value.ProductName+'</h3>'+ 
          '</div>'+
          '<div class="col-md-4 col-xs-4 col-sm-4">'+
            '<span class="price" style="font-size:24px;">'+
            currency.Symbol+' ' +value.Price.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator)+
            '</span>'+
          '</div>'+
          '<div class="col-md-4 col-xs-4 col-sm-4">'+
            '<span  id="dn-'+value.ProductId+'" class="quantity btn btn-primary" rel="-1" data-productId="'+value.ProductId+'">-</span>'+
            '<input type="text" class="quantitytoadd  form-control" value="0" name="q'+value.ProductId+'" id="q'+value.ProductId+'" data-productId="'+value.ProductId+'" data-Performance="'+ Performance+'" >'+
            '<span  id="up-'+value.ProductId+'" class="btn btn-primary quantity" rel="1" data-productId="'+value.ProductId+'" data-freeqnt="'+ value.SeatQuantityFree +'" data-maxqnt="' + value.SeatQuantityMax + '" >+</span>'+
          '</div>'+
          '<div class="col-md-4 col-xs-4 col-sm-4">'+
            '<btn btn-primary class="btn btn-primary addperformancetocart" data-productId="'+value.ProductId+'" data-performance="'+Performance+'" style="float:right;">'+
            'Add To Cart'+
            '</button>'+
          '</div>'+
        '</div>'+
      '</div>');
  });
  $('#ProductContainer').addClass('active');
}

$(document).on('click','.closeProductcontainer',function(e) {
  e.stopPropagation();
  e.stopImmediatePropagation();
  $('#ProductContainer').removeClass('active');
});

$(document).on('click','.quantity',function(e) {
  var productId = $(this).attr('data-productId');
  var performance = $(this).attr('data-performance');
  var quantity = $('#q'+productId+'.quantitytoadd').val();
  var maxqnt = $(this).attr('data-maxqnt');
  if($(this).attr('rel')==1) 
  {
    var newval = parseInt(quantity) + 1;
    var maxqnt = $(this).attr('data-maxqnt');
    if(maxqnt > 0) 
    {
      var freeqnt = $(this).attr('data-freeqnt');
      var newfree = parseInt(freeqnt) - 1;
      if(newval > freeqnt)
      {
          var title = 'Quantity Exceeded';
          var msg = 'you can not exceed the max quantity available ( ' + freeqnt + ' )';
          var buttons = [<v:itl key="@Common.Cancel" encode="JS"/>];
          showMobileQueryDialog2(title, msg, buttons, function(index) { return true; });
          return false;
      }
      else 
      {
        $('#q'+productId+'.quantitytoadd').val(newval);
      }
    }
    else 
    {
      $('#q'+productId+'.quantitytoadd').val(newval);
    }
  } else 
  {
    if($('#q'+productId+'.quantitytoadd').val()>0) 
    {
      $('#q'+productId+'.quantitytoadd').val(parseInt(quantity)-1);
    }
  }
  //addProductToCart(productId,performanceId);
});

$(document).on('click','.addperformancetocart',function(e) {
  e.stopPropagation();
  e.stopImmediatePropagation();
  $('#floatingBarsGbg').show();
  var productId = $(this).attr('data-productId');
  var performance = $(this).attr('data-performance');
  var quantity = $('#q'+productId+'.quantitytoadd').val();
  addProductToCart(productId, performance.performanceId, quantity);
  $('#q'+productId+'.quantitytoadd').val(0);
  var maxqnt = $('#up-'+productId+'.quantity').attr('data-maxqnt');
  if(maxqnt > 0) 
  {
    var qntfree = $('#up-'+productId+'.quantity').attr('data-freeqnt');
    var newfree = parseInt(qntfree) - parseInt(quantity);
    $('#up-'+productId+'.quantity').attr('data-freeqnt', newfree);
  }
  $('#floatingBarsGbg').hide();
});



function chk_scroll(e) {
  var eventId = $('#eventId').val();
  var PagePos = $('#PagePos').val();
  var SellableDateTimeFrom = $('#SellableDateTimeFrom').val();
  var elem = $(e.currentTarget);
  if (elem[0].scrollHeight - elem.scrollTop() == elem.outerHeight()) {
    getPerformances(eventId,SellableDateTimeFrom,PagePos);
    $('#mainContent').unbind('scroll');
  }
}

$( function() {
  $( "#datepicker" ).datepicker({
    beforeShow: function(input, inst)
    {
        inst.dpDiv.css({right: '110px'});
    },
    dateFormat: "yy-mm-dd",
    minDate : 0,
    showOn: "button",
    buttonImage: "<v:image-link name='bkoact-calendar.png' size='64'/>",
    buttonImageOnly: true,
    buttonText: "Select date",
    prevText:"<",
    nextText:">"
  }).on("input change", function (e) {
     $('#mainContent').unbind('scroll');
    var eventId = $('#eventId').val();
    var PagePos = 0;
    SellableDateTimeFrom = e.target.value+"T00:00:00";
    $('#PerformancesContainer').html('');
    getPerformances(eventId,SellableDateTimeFrom,PagePos);
    
  });
});
</script>


