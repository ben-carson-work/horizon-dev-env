<%@page import="com.vgs.snapp.lookup.*"%>
<script>
function encodeExpirationUsageTypes() {
	  var fullAdmPrdUsage = JSON.stringify([<%=LkSNExpirationUsageType.OnFullAdmUsage.getCode()%>, <%=LkSNExpirationUsageType.OnFullPrdUsage.getCode()%>]);
	  var fullAdmWalletUsage = JSON.stringify([<%=LkSNExpirationUsageType.OnFullAdmUsage.getCode()%>, <%=LkSNExpirationUsageType.OnFullWalletUsage.getCode()%>]);
	  var fullPrdWalletUsage = JSON.stringify([<%=LkSNExpirationUsageType.OnFullPrdUsage.getCode()%>, <%=LkSNExpirationUsageType.OnFullWalletUsage.getCode()%>]);
	  var fullUsage = JSON.stringify([<%=LkSNExpirationUsageType.OnFullAdmUsage.getCode()%>, <%=LkSNExpirationUsageType.OnFullPrdUsage.getCode()%>, <%=LkSNExpirationUsageType.OnFullWalletUsage.getCode()%>]);
	 
	  var expUsageMap = new Map();
	  expUsageMap.set(fullAdmPrdUsage, <%=LkSNExpirationUsageType.OnFullAdmPrdUsage.getCode()%>);
	  expUsageMap.set(fullAdmWalletUsage, <%=LkSNExpirationUsageType.OnFullAdmWalletUsage.getCode()%>);
	  expUsageMap.set(fullPrdWalletUsage, <%=LkSNExpirationUsageType.OnFullPrdWalletUsage.getCode()%>);
	  expUsageMap.set(fullUsage, <%=LkSNExpirationUsageType.OnFullUsage.getCode()%>);
	  
	  var checkedExpUsageTypes = [];
	  $('input[id="product.ExpirationUsageType"]:checked').each(function() {
	    checkedExpUsageTypes.push(Number($(this).val()));
	  });
	  
	  if (checkedExpUsageTypes.length === 0) 
	    checkedExpUsageTypes = [<%=LkSNExpirationUsageType.AsScheduled.getCode()%>];
	  
	  return expUsageMapGetOrDefault(expUsageMap, JSON.stringify(checkedExpUsageTypes), checkedExpUsageTypes[0]);
	}

	function expUsageMapGetOrDefault(map, key, defaultValue) {
	  return map.has(key) ? map.get(key) : defaultValue;  
	}

	function decodeExpirationUsageType(expUsageType) {
	  var defaultExpUsageType = [expUsageType];
	  var expUsageMap = new Map();
	  expUsageMap.set(<%=LkSNExpirationUsageType.AsScheduled.getCode()%>, []);
	  expUsageMap.set(<%=LkSNExpirationUsageType.OnFullUsage.getCode()%>, [<%=LkSNExpirationUsageType.OnFullAdmUsage.getCode()%>, <%=LkSNExpirationUsageType.OnFullPrdUsage.getCode()%>, <%=LkSNExpirationUsageType.OnFullWalletUsage.getCode()%>]);
	  expUsageMap.set(<%=LkSNExpirationUsageType.OnFullAdmPrdUsage.getCode()%>, [<%=LkSNExpirationUsageType.OnFullAdmUsage.getCode()%>, <%=LkSNExpirationUsageType.OnFullPrdUsage.getCode()%>]);   
	  expUsageMap.set(<%=LkSNExpirationUsageType.OnFullAdmWalletUsage.getCode()%>, [<%=LkSNExpirationUsageType.OnFullAdmUsage.getCode()%>, <%=LkSNExpirationUsageType.OnFullWalletUsage.getCode()%>]);
	  expUsageMap.set(<%=LkSNExpirationUsageType.OnFullPrdWalletUsage.getCode()%>, [<%=LkSNExpirationUsageType.OnFullPrdUsage.getCode()%>, <%=LkSNExpirationUsageType.OnFullWalletUsage.getCode()%>]);
	  
	  return expUsageMapGetOrDefault(expUsageMap, expUsageType, defaultExpUsageType);
	}
</script>
