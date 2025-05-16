/**
 * @license Copyright (c) 2003-2021, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see https://ckeditor.com/legal/ckeditor-oss-license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
  config.allowedContent = {
      $1: {
          // Use the ability to specify elements as an object.
          elements: CKEDITOR.dtd,
          attributes: true,
          styles: true,
          classes: true
      }
  };
  config.disallowedContent = 'script; *[on*]';
  config.autoParagraph = false;
  config.height = '65vh';
};
