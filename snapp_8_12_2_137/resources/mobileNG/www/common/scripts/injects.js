// need to minify and compact all these files into one:
var sources = {
	libs: [
		COMMON_JS.base_url +'common/lib/ionic/js/ionic.bundle.min.js',
		COMMON_JS.base_url +'common/lib/ng-lodash/build/ng-lodash.min.js',
		COMMON_JS.base_url +'common/lib/jquery/dist/jquery.min.js'
	],
	js: [
		COMMON_JS.base_url +'common/scripts/functions.js',
		COMMON_JS.base_url +'common/js/app.js',
		COMMON_JS.base_url +'common/js/controllers.js',
		COMMON_JS.base_url +'common/js/services.js',
		COMMON_JS.base_url +'common/js/directives.js',
		COMMON_JS.base_url +'common/js/constants.js',
		// adm
		COMMON_JS.base_url +'mob_adm/js/adm_app.js',
		COMMON_JS.base_url +'mob_adm/js/adm_controllers.js',
		COMMON_JS.base_url +'mob_adm/js/adm_directives.js',
		// pay
		COMMON_JS.base_url +'mob_pay/js/pay_app.js',
		COMMON_JS.base_url +'mob_pay/js/pay_controllers.js',
		// sales operator
		COMMON_JS.base_url +'mob_sales_operator/js/sop_app.js',
		COMMON_JS.base_url +'mob_sales_operator/js/sop_controllers.js'
	],
	js_prod: [
		COMMON_JS.base_url +'common/scripts/all.min.js'
	],
	css: [
		COMMON_JS.site_url +'fonts/fonts.css',
		COMMON_JS.base_url +'common/css/ionic.app.min.css'
	]
};

document.write('<title>'+ COMMON_JS.title +'</title>');

for (var i=0, len = sources.libs.length; i<len; ++i) {
	document.write('<scr'+'ipt type="text/javascript" src="'+ sources.libs[i] +'"></scr'+'ipt>');
}

if (COMMON_JS.debug === true) {
	for (var i=0, len = sources.js.length; i<len; ++i) {
		document.write('<scr'+'ipt type="text/javascript" src="'+ sources.js[i] +'"></scr'+'ipt>');
	}
} else {
	for (var i=0, len = sources.js_prod.length; i<len; ++i) {
		document.write('<scr'+'ipt type="text/javascript" src="'+ sources.js_prod[i] +'"></scr'+'ipt>');
	}
}

for (var i=0, len = sources.css.length; i<len; ++i) {
	document.write('<link rel="stylesheet" href="'+ sources.css[i] +'">');
}

var customStyle = `<style>
	.button, .button.activated, .button.button-positive, .button.button-positive.activated, .buttonSnapp {
		background-color: `+ COMMON_JS.buttonColor +`;
	}

	.error {
		color: `+ COMMON_JS.redColor +`;
	}

	.percentage > .percentage-bar {
		background-color: `+ COMMON_JS.greenColor +`;
	}

	input.ng-invalid:not(.ng-invalid-required), .button.red {
    	background-color: `+ COMMON_JS.redColor +`;
		color: #fff;
    }

	.validate[data-status='good'] {
		border-color: `+ COMMON_JS.greenColor +`;
	}
	.validate[data-status='good'] > h2 {
		background-color: `+ COMMON_JS.greenColor +`;
	}

	.validate[data-status='bad'] {
		border-color: `+ COMMON_JS.redColor +`;
	}
	.validate[data-status='bad'] > h2 {
		background-color: `+ COMMON_JS.redColor +`;
	}

	.good-status {
		color: `+ COMMON_JS.greenColor +`!important;
	}
	.warn-status {
		color: `+ COMMON_JS.orangeColor +`!important;
	}
	.bad-status {
		color: `+ COMMON_JS.redColor +`!important;
	}

	ion-tabs .tab-item.tab-item-active {
		border-top-color: `+ COMMON_JS.buttonColor +`;
	}
	ion-tabs .tab-item .iconRedemption {    
		background-image: url(`+ COMMON_JS.icons.barcode +`);
	}
	ion-tabs .tab-item .iconAttendance {    
		background-image: url(`+ COMMON_JS.icons.attendance +`);
	}
	ion-tabs .tab-item .iconInfo {    
		background-image: url(`+ COMMON_JS.icons.infoNegative +`);
	}
	ion-tabs .tab-item .iconCatalog {    
		background-image: url(`+ COMMON_JS.icons.catalog +`);
	}
	ion-tabs .tab-item .iconShopcart {    
		background-image: url(`+ COMMON_JS.icons.shopcart +`);
	}

	ion-nav-bar.manual-barcode .bar.bar-stable.bar-header .buttons-right {
		background-color: `+ COMMON_JS.buttonColor +`;
	}

	.item[media-lookup-status="`+ COMMON_JS.mediaLookupCommonStatus.draft +`"]:before {
		background-color: `+ COMMON_JS.grayColor +`;
	}
	.item[media-lookup-status="`+ COMMON_JS.mediaLookupCommonStatus.active +`"]:before {
		background-color: `+ COMMON_JS.greenColor +`;
	}
	.item[media-lookup-status="`+ COMMON_JS.mediaLookupCommonStatus.warn +`"]:before {
		background-color: `+ COMMON_JS.orangeColor +`;
	}
	.item[media-lookup-status="`+ COMMON_JS.mediaLookupCommonStatus.deleted +`"]:before {
		background-color: `+ COMMON_JS.redColor +`;
	}
	.item[media-lookup-status="`+ COMMON_JS.mediaLookupCommonStatus.completed +`"]:before {
		background-color: `+ COMMON_JS.blueColor +`;
	}
	.item[media-lookup-status="`+ COMMON_JS.mediaLookupCommonStatus.fatalError +`"]:before {
		background-color: `+ COMMON_JS.purpleColor +`;
	}

	/* mob_pay */
	ion-view[data-page="pay_steps"] #pay-confirm .title.approved {
		background-color: `+ COMMON_JS.greenColor +`;
	}
	ion-view[data-page="pay_steps"] #pay-confirm .title.denied {
		background-color: `+ COMMON_JS.redColor +`;
	}
	/* */

	/* mob_adm */
	ion-view[data-page="adm_attendance"] .list .item-thumbnail-left:before {
		background-color: `+ COMMON_JS.grayColor +`;
	}
	ion-view[data-page="adm_attendance"] .list .item-thumbnail-left[data-status="status-busy"]:before {
		background-color: `+ COMMON_JS.orangeColor +`;
	}
	ion-view[data-page="adm_attendance"] .list .item-thumbnail-left[data-status="status-open"]:before {
		background-color: `+ COMMON_JS.greenColor +`;
	}
	/* */
</style>`;

document.write(customStyle);
