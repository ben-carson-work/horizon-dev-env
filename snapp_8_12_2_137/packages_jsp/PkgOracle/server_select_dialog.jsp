<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>


<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="server_selection_dialog" title="Server selection" width="500" autofocus="false">
  <v:widget>
		<v:widget-block>
			<v:form-field caption="@Common.Server" >
				<snp:dyncombo id="ServerId"  entityType="<%=LkSNEntityType.Server%>" allowNull="false"/>
			</v:form-field>
		</v:widget-block>
	</v:widget>

<script>

$(document).ready(function() {

  var $dlg = $("#server_selection_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      dialogButton("@Common.Confirm", doConfirm),
      dialogButton("@Common.Cancel", doConfirm)
    ];
  });
  
  function doConfirm() {
    addServerConfiguration($dlg.find("#ServerId").prop('dataset'));
		$dlg.remove();
	}
});

</script>
</v:dialog>
