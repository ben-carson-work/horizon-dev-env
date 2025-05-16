<%@ taglib uri="vgs-tags" prefix="v" %>
    
<v:alert-box id="import-details" type="info" title="@Common.Info" style="max-height:350px;overflow:auto">
  <b>Import type</b>: <text name="ImportType"></text>
  <b>Items count</b>: <text name="ItemCount"></text>
  <b>Import from</b>:
  <ul>
    <li><b>License</b>: <text name="LicenseName"></text></li>
    <li><b>URL</b>: <text name="URL"></text></b></li>
    <li><b>BKO version</b>: <text name="SnAppBkoVersion"></text></li>
    <li><b>Workstation</b>: <text name="WorkstationName"></text></li>
    <li><b>User</b>: <text name="UserAccountName"></text></li>
    <li><b>Date/time</b>: <text name="ExportDateTime"></text></li>
  </ul>
</v:alert-box>