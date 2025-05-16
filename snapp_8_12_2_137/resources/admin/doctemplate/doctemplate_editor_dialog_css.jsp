<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />

<style>

* {
  user-select: none;
  -moz-user-select: none;
  -khtml-user-select: none;
  -webkit-user-select: none;
  -o-user-select: none;
}

select#comp-image {
  border: 0;
  outline: 0;
  cursor: pointer;
}

h1.snp-template {
  text-align: center;
}

#doctemplate_editor_dialog {
  overflow: hidden;
}

 #cm-text-editor-dialog {
  padding: 0;
 }

.snp-property-value.snp-prop-with-btn > input:not([type='checkbox']) {
  padding-right: 27px;
}

.snp-text {
  height: 100%;
  overflow: hidden;
  line-height: normal;
}

.snp-prop-with-btn > .snp-input-btn {
  margin-left: -27px;
  width: 25px;
  border: none;
  display: none;
}

.snp-input-btn > .ui-button-text {
  padding: 0;
}

.snp-prop-with-btn > .snp-input-btn:hover {
  background-color: var(--body-bg-color);
}

.snp-property:hover .snp-input-btn {
  display: inline-block;
}

.doctemplate_editor_dialog_class, #doctemplate_editor_dialog.ui-dialog-content {
  position: fixed !important;
  top: 0px !important;
  bottom:0px !important;
  left:0px !important;
  right:0px !important;
  width: initial !important;
  border-radius: 0 !important;
  padding: 0 !important;
}

.ui-selectable-helper {
  border-width: 2px;
  border-color: red;
  background-color: rgba(0,0,0,0.2);
  z-index: 32;
}


.snp-workspace {
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  justify-content: space-between;
  flex-direction: column;
}

.snp-toolbar {
  flex-grow: 0;
  flex-shrink: 0;
  background-color: var(--body-bg-color);
  border-bottom: 1px solid var(--border-color);
  line-height: 29px;
  z-index: 30;
  white-space: nowrap;
  padding: 10px;
}

.snp-editor-view {
  position: relative;
  flex-grow: 1;
  overflow: hidden;
}

.snp-editor-view:not(.view-active) {
  display: none !important;
}

#view-design {
  display: flex;
  justify-content: space-between;
}

.snp-properties {
  flex-shrink: 0;
  flex-grow: 0;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  border-right: 1px solid var(--border-color);
  width: 350px;
}

.snp-template-title {
  flex-shrink: 0;
  flex-grow: 0;
  padding: 10px;
  margin-bottom: 5px;
  font-size: 1.4em;
  font-weight: bold;
  text-align: center;
}

.snp-properties .v-tabs-container {
  flex-shrink: 1;
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  overflow: hidden;
}

.snp-properties .v-tabs-nav {
  flex-shrink: 0;
  flex-grow: 0;
}

.snp-properties .v-tabs-panel {
  flex-shrink: 1;
  flex-grow: 1;
  overflow: auto;
}

.snp-design-content {
  position: relative;
  flex-grow: 1;
  flex-shrink: 1;
}

.snp-workspace h1 {
  margin: 0;
  font-size: 1.1em;
  padding: 2px 4px;
  font-weight: bold;
  line-height: normal;
  border-bottom: 1px solid var(--border-color);
  margin-top: 4px;
}

.snp-property {
  display: flex;
  justify-content: space-between;
}

.snp-property label {
  flex-grow: 0;
  flex-shrink: 0;
  vertical-align: middle;
  padding: 2px 6px 2px 16px;
  width: 150px;
}

.snp-property-value {
  flex-grow: 1;
  flex-shrink: 1;
  background-color: white;
}

.snp-property-value input:not([type='checkbox']):focus,
.snp-property-value select:focus {
  outline: none;
  background-color: rgba(255, 255, 0, 0.2);
}

.snp-property-value input:not([type='checkbox']) {
  border: 0;
  margin: 0;
  padding: 0px 4px;
  line-height: 23px;
}

.snp-property-value select {
  border: none;
  border-radius: unset;
}

.snp-property-checkbox .snp-property-value {
  text-align: center;
}

#variable-tree {
  padding: 10px;
}

.button.snp-active:not([disabled]) {
  border: 1px solid #696969;
  background: linear-gradient(#dcdcdc, #d3d3d3) !important;
}

#btn-align-left.snp-active:hover, #btn-align-center.snp-active:hover, #btn-align-right.snp-active:hover {
  cursor: default;
}

.snp-spinner {
  font-size: 2em;
  padding: 10px;
  text-align: center;
}

.snp-icon {
  display: inline-block;
  width: 16px;
  height: 16px;
  margin-right: 5px;
  float: left;
  background-size: 16px 16px;
}

.snp-btn.snp-empty > .snp-icon {
  margin-right: -2px;
}

.snp-divider {
  border-left: 1px #bfbfbf solid;
  border-right: 1px #ffffff solid;
  padding-top: 10px;
  padding-bottom: 10px;
  margin: 0 6px;
}

.snp-buttonset {
  display: inline;
  margin-right: 7px;
}

.snp-buttonset > .snp-btn {
  margin-right: -0.4em;
}

.snp-title {
  position: relative;
  background-color: #eeeeee;
  line-height: 18px;
  padding: 4px;
  font-weight: bold;
  right: 0;
  border-bottom: 1px solid #0002;
}

.snp-selected > .snp-title {
  background: #bbbbbb;
  cursor: default;
}

*:not(.snp-selected) > .snp-title:hover {
  background-color: #cccccc;
}

.snp-band-container {
  border-bottom: 2px dashed #dddddd;
}

.snp-selected {
  border: 2px solid black;
}

.snp-body {
  position: relative;
  right: 0;
  overflow: hidden;
}

.snp-canvas {
  position: absolute;
  top: 25px;
  right: 0;
  bottom: 0;
  left: 25px;
  background-color: var(--pagetitle-bg-color);
  overflow: auto;
}

.snp-page-container {
  display: inline-block;
  background-color: white;
  border: 1px solid #0005;
  box-shadow: 0 0 10px #000A;
  transform-origin: top left;
}

#page {
  border: 1px dotted var(--base-blue-color);
}

#page>.snp-title {
  text-align: center;
}

#page>.snp-body {
  height: calc(100% - 28px);
}

#page>.snp-body:hover {
  overflow-y: auto;
}

#page>.snp-body::-webkit-scrollbar {
  width: 6px;
}

#page>.snp-body::-webkit-scrollbar-track {
  visibility: hidden;
}
   
#page>.snp-body::-webkit-scrollbar-thumb {
  background: rgba(0,0,0,0.3); 
  border-radius: 10px;
}
  
#page>.snp-body::-webkit-scrollbar-thumb:hover {
  background: black; 
}

.snp-component {
  position: absolute !important;
  border: 1px solid transparent;
  cursor: default;
}

.snp-component:not(.ui-selected):hover {
  border: 1px dashed rgba(0,0,0,0.2);
  background-color: rgba(255,255,0,0.2) !important;
}

.snp-component.ui-selected {
  border: 1px dashed red !important;
}

.snp-component[data-type='image'] {
  background-repeat: no-repeat;
  background-size: contain;
  background-position: center;
}

.snp-canvas.snp-preview .ui-resizable-handle.ui-icon {
  background-image: none !important;
}

#zoom {
  display: inline-block;
}

#zoom > span {
  vertical-align: middle;
}

#zoom > div {
  width: 200px;
  display: inline-block;
  margin-left: 20px;
}

.snp-ruler {
  position: absolute;
  left: 0;
  top: 0;
  z-index: 1;
  background: var(--body-bg-color);
  overflow: hidden;
}

.snp-ruler-h {
  height: 25px;
  right: 0;
  border-left: 25px solid #0000;
  border-bottom: 1px solid var(--border-color);
  z-index: 2;
}

.snp-ruler-v {
  top: 25px;
  width: 25px;
  bottom: 0;
  border-bottom: 1px solid var(--border-color);
}

.snp-relative {
  position: relative;
}

.snp-tick {
  position: absolute;
  display: inline-block;
  z-index: 1;
}

.snp-tick-h.snp-small {
  border-left: 1px solid #c9c9c9;
  height: 6px;
}

.snp-tick-v.snp-small {
  border-top: 1px solid #c9c9c9;
  width: 6px;
}

.snp-tick-h.snp-long {
  border-left: 1px solid black;
  height: 9px;
}

.snp-tick-v.snp-long {
  border-top: 1px solid black;
  width: 9px;
}

.snp-ruler-label {
  position: absolute;
  color: #4b4b4b;
  font-size: 0.8em;
  z-index: 1;
}

.snp-ruler-label-h {
  margin-left: 3px;
  margin-top: 6px;
}

.snp-ruler-label-v {
  margin-left: 11px;
  margin-top: -12px;
  transform: rotate(270deg);
}

.ui-dialog {
  z-index: 32 !important;
}

#comp-textarea, #cm-comp-textarea {
  width: 100%;
  height: calc(100% - 30px);
}

#btn-close-dialog {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 30px;
  height: 30px;
  cursor: pointer;
  font-size: 2em;
  opacity: 0.4;
}

#btn-close-dialog:hover {
  opacity: 1;
}

.snp-unset-color {
  position: relative;
  top: -2px;
  padding: 0 5px;
}

.snp-unset-color:hover {
  cursor: pointer;
  font-size: larger;
  font-weight: bold;
  top: 0;
}

input[type="color"] {
  cursor: pointer;
  width: 96px;
}

#dte-tabs-2 {
  height: calc(100% - 55px);
  overflow: auto;
}

#dte-tabs-2 > ul.vgs-tree {
  padding: 5px 5px;
}

.vgs-tree li.leaf {
  cursor: pointer;
}

#index-vars-dialog > * {
  box-sizing: border-box;
}

#index-vars-dialog > div {
  display: flex;
  height: 100%;
}

#index-vars {
  flex: 1;
  overflow: auto; 
  padding: 10px;
  border: 1px solid #dfdfdf;
  border-right: 1px solid #dfdfdf;
  border-bottom: 1px solid #dfdfdf;
  -webkit-border-radius: 5px;
  -moz-border-radius: 5px;
  border-radius: 5px;
}

.ivd-buttons {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 20px;
}

.ivd-buttons > button {
  margin: 5px;
}

.ivd-result {
  flex: 1;
  position: relative;
}

.ivd-result > select {
  position: absolute;
  top: 0;
  bottom: 0;
}

.ui-dialog.on-top {
  z-index: 33;
}

#index-vars-dialog {
  display: none;
}

.snp-overlay {
  position: absolute;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  background: #000;
  opacity: 0.1;
  z-index: 32;
}

.spinner-box.snp-spinner {
  top: calc(50% - 25px);
  left: calc(50% - 40px);
}

.CodeMirror-hints {
  z-index: 32 !important;
}

.cm-param-tag {
  color: #a22;
}

.cm-param-sep {
  color: #a70;
}

.cm-param-value {
  color: #00f;
}

.cm-variable,
.cm-param-name {
  color: #708;
}

.snp-pdf-preview {
  position: absolute; 
  z-index: 32; 
  top: 0; 
  left: 0;
  width: 100%;
  height: 100%;
  overflow: auto;
}

.snp-high-zindex {
  position: relative;
  z-index: 32;
}

.hidden-textarea {
  position: absolute;
  left: -1000px;
  width: 100px;
  height: 100px;
}

#view-source > .CodeMirror {
  height: 100%;
}

ul.popup-menu li.disabled a,
ul.popup-menu li.disabled a:hover {
  cursor: default;
  background-color: white;
  color: #21759b;
  opacity: 0.5;
}

.design-mode-only {
  display: inline-block;
}
</style>