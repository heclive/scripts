/*!
 Linphone Web - Web plugin of Linphone an audio/video SIP phone
 Copyright (c) 2013 Belledonne Communications
 All rights reserved.
 

 Authors:
 - Yann Diorcet <diorcet.yann@gmail.com>
 
 */

/*globals jQuery,linphone*/

linphone.ui.view.help = {
	init: function(base) {
		linphone.ui.view.help.uiInit(base);
	},
	uiInit: function(base) {
		base.find('> .content .view > .help').data('linphoneweb-view', linphone.ui.view.help);
		
		base.find('> .content .view > .help .button').click(linphone.ui.exceptionHandler(base, function(){
			linphone.ui.view.hide(base, 'help');
		}));
	},
	translate: function(base) {
	},
	
	/**/
	show: function(base) {
		linphone.ui.menu.hide(base);
	},
	hide: function(base) {
		linphone.ui.view.hide(base, 'help'); // Do not stack
	}
};