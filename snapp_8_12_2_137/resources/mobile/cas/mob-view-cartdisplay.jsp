<%@page import="com.vgs.snapp.web.mob.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-cartdisplay">
  <div class="cartdisplay-content noselect">
    <div class="cartdisplay-icon-spinner"><i class="fa fa-spin fa-circle-notch"></i></div>
    <div class="cartdisplay-icon-idle"><i class="fa fa-shopping-basket"></i></div>
    <div class="cartdisplay-item cartdisplay-qty mobile-ellipsis"><span class="autosize-text"></span></div>
    <div class="cartdisplay-item cartdisplay-total mobile-ellipsis"><span class="autosize-text"></span></div>
  </div>
</div>


<style>

#view-cartdisplay {
  width: 40rem;
  height: 20rem;
  float: left;
  padding: 1rem;
  cursor: pointer;
}

#view-cartdisplay .cartdisplay-content {
  padding: 2rem;
  background-color: rgba(0,0,0,0.9);
  color: white;
  font-weight: bold;
  border-radius: 2rem;
  line-height: 7rem;
  text-align: right;
  overflow: hidden;
}

#view-cartdisplay .cartdisplay-qty {
  margin-left: 7rem;
}

#view-cartdisplay .cartdisplay-icon-spinner {
  float: left;
  display: none;
}

#view-cartdisplay.working .cartdisplay-icon-spinner {
  display: block;
}

#view-cartdisplay .cartdisplay-icon-idle {
  float: left;
}

#view-cartdisplay.working .cartdisplay-icon-idle {
  display: none;
}

</style>


<script>

UIMob.init("cartdisplay", function($view, params) {

  $view.on(MOUSE_DOWN_EVENT, onDisplayClick);
  $(document).von($view, "ShopCartChange", onShopCartChange);
  $(document).von($view, "ShopCartWorkingChange", onWorkingChange);
  onShopCartChange();
  
  function onShopCartChange() {
    $view.find(".cartdisplay-qty .autosize-text").text("#" + recursiveCountItems(shopCart.Items));
    $view.find(".cartdisplay-total .autosize-text").text(formatCurr(shopCart.TotalAmount));
    
    $view.find(".autosize-text").each(function(index, elem) {
      var $text = $(elem);
      var $cont = $(elem).parent();
      
      $text.css("font-size", "");
      for (var i=0; i<1000; i++) { // "for" instead of a "while" to avoid potential infinitive loops
        if ($text.outerWidth() <= $cont.innerWidth())
          break;
        var fs = parseFloat($text.css("font-size"));
        $text.css("font-size", (fs - 1) + "px");
      }
    });
  }
  
  function onWorkingChange() {
    $view.find("#view-cartdisplay").setClass("working", BLCart.isWorking());
  }
  
  function onDisplayClick() {
    UIMob.setActiveTabMain(PKG_CAS + ".shopcart");
  }
  
  function recursiveCountItems(list) {
    list = (list || []);
    var result = 0;
    for (var i=0; i<list.length; i++) 
      result += strToIntDef(list[i].Quantity, 0) + recursiveCountItems(list[i].Items);
    return result;
  }
});

</script>