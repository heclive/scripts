/*!
 Linphone Web - Web plugin of Linphone an audio/video SIP phone
 Copyright (c) 2013 Belledonne Communications
 All rights reserved.
 

 Authors:
 - Yann Diorcet <diorcet.yann@gmail.com>
 
 */

/*globals jQuery,linphone*/

linphone.ui.view.chat = {
	init: function(base) {
		linphone.ui.view.chat.uiInit(base);
	},
	uiInit: function(base) {
		base.find('> .content .view > .chat').data('linphoneweb-view', linphone.ui.view.chat);
	},
	translate: function(base) {
		
	},
	
	/**/
	show: function(base, room) {
		var chat = base.find('> .content .view > .chat');
		
		chat.find('.status').hide();
	
		//Add callbacks on chatroom
		base.on('messageReceived', linphone.ui.view.chat.onMessageReceived);
		base.on('isComposingReceived', linphone.ui.view.chat.isComposingReceived);
		
		linphone.ui.view.chat.update(base,room);	
	},
	
	update: function(base, room) {
		var core = linphone.ui.getCore(base);	
		var chat = base.find('> .content .view > .chat');		
		var actions = chat.find(' .actions');
		var list = base.find('> .content .view > .chat .list');
		
		actions.empty();
		list.empty();	

		//Display chat history		
		if(typeof room === 'undefined'){
			room = chat.data('room');	
		} else {
			chat.data('room',room);	
		}
		
		linphone.ui.view.chat.displayHistory(base, room);
		room.markAsRead();
			
		chat.data('contact',room.peerAddress);
		
		base.find('> .content .menu').data('contact',room.peerAddress.asStringUriOnly());	
		linphone.ui.menu.show(base);
		
		var sendMessage = function(base, room) {
			return function(){		
				linphone.ui.view.chat.sendChatMessage(base,room);
			};
		};
		
		var uploadFile = function(base, room) {
			return function(){		
				linphone.ui.view.chat.displayUploadFile(base,room);
			};
		};

		actions.append(linphone.ui.template(base, 'view.chat.actions', room.peerAddress));
		actions.find('.fileUpload').hide();
		actions.find('.messageToSend').show();
		
		if(linphone.ui.configuration(base).disableChatFileTransfert) {
			chat.find('.actions .sendImage').hide();
		}
		
		//Init text area
		var textArea = actions.find('.messageToSend .textArea');
		textArea.val('');
		textArea.focus();
		textArea.keypress(function() {
			room.compose();	
		});
		
		textArea.keydown(linphone.ui.exceptionHandler(base, function(event) {
			if(event.which === jQuery.ui.keyCode.ENTER && ! event.shiftKey){		
				linphone.ui.view.chat.sendChatMessage(base,room);
				event.preventDefault();
			}
		}));
		
		chat.find('> .content .view > .chat .scroll-pane').each(function(){
				linphone.ui.slider(jQuery(this));
		});
		
		chat.find('.actions .sendChat').click(linphone.ui.exceptionHandler(base,sendMessage(base,room)));		
		chat.find('.actions .sendImage').change(linphone.ui.exceptionHandler(base,uploadFile(base,room)));
	},
	
	hide: function(base) {
		base.off('messageReceived', linphone.ui.view.chat.onMessageReceived);
		base.off('isComposingReceived', linphone.ui.view.chat.isComposingReceived);
	},
	
	sendChatMessage: function(base,room){
		var chat = base.find('> .content .view > .chat');
		var core = linphone.ui.getCore(base);
		var textArea = chat.find('.messageToSend .textArea');
		var chatMsg = textArea.val();
		
		if(chatMsg !== ''){
			var message = room.newMessage(chatMsg);
			room.sendChatMessage(message);
			linphone.ui.core.addEvent(message,'msgStateChanged', linphone.ui.view.chat.onMsgStateChanged);
			linphone.ui.view.chat.displaySendMessage(base,room,message);
			
			//Reinit textArea
			textArea.val('');
			textArea.focus();
		}
		room.markAsRead();
		linphone.ui.menu.update(base);
	},
	
	displayUploadFile: function(base,room){
		var chat = base.find('> .content .view > .chat');
		var core = linphone.ui.getCore(base);
		var input = chat.find('.inputFile .fileName');
		var file = input.prop('files')[0];
		var actions = base.find('.actions');
		
		actions.find('.fileUpload').show();
		actions.find('.messageToSend').hide();

		var reader = new FileReader();
		reader.onloadend = function(e) {
			var binary = "";
			var bytes = new Uint8Array(reader.result);
			var length = bytes.byteLength;
			for (var i = 0; i < length; i++) {
				binary += String.fromCharCode(bytes[i]);
			}
	
			var content = core.createContent();
			var splitted_type = file.type.split("/");
			content.name = file.name;
			content.type = splitted_type[0];
			content.subtype = splitted_type[1];
			content.buffer = window.btoa(binary);
			var message = room.newFileTransferMessage(content);
			if(content.type === 'image'){
				message.appdata = window.btoa(binary);
			}
			
			var result;
			
			if(message.fileTransferInformation.type === 'image'){
				var contentFile = 'data:image/'+ splitted_type[1] + ';base64,' + window.btoa(binary) ;
				result = '<div><img src="'+ contentFile +'" class = "sentImage"></div>';
			}
	
			var element = linphone.ui.template(base, 'view.chat.actions.fileUpload', {
				name: file.name,
				size: linphone.ui.utils.formatFileSize(file.size)
			});
			element.find('.fileUploadPreviewMiddle').append(result);
			
			var sendFileMessage = function(base,room, message) {
				return function(){
					linphone.ui.view.chat.sendFileMessage(base,room,message);
					input.replaceWith(input.val('').clone(true));
				};
			};
			
			var cancelMessage = function(base, room, message) {
				return function(){
					linphone.ui.view.chat.clearFileUpload(base);
					input.replaceWith(input.val('').clone(true));
					
				};
			};
			
			actions.find('.fileUpload').empty();
			actions.find('.fileUpload').append(element);
			actions.find('.fileUpload .fileUploadSize .progress-bar').css('width',0);
			actions.find('.fileUpload .fileUploadActions .sendUploadFile').click(linphone.ui.exceptionHandler(base,sendFileMessage(base,room,message)));
			actions.find('.fileUpload .fileUploadActions .cancelUploadFile').click(linphone.ui.exceptionHandler(base,cancelMessage(base,message)));
			
	
		};

		if(typeof file !== 'undefined' && input.prop('files').length === 1){
			reader.readAsArrayBuffer(file);
		}	
	},
	
	clearFileUpload: function(base) {
		var chat = base.find('> .content .view > .chat');
		var actions = base.find('.actions');
		
		actions.find('.fileUpload').empty();
		actions.find('.fileUpload').hide();
		actions.find('.messageToSend').show();
	},
	
	sendFileMessage: function(base,room,message){
		var chat = base.find('> .content .view > .chat');
		var actions = base.find('.actions');
		
		actions.find('.fileUpload .fileUploadActions .cancelUploadFile').hide();
		
		room.sendChatMessage(message);
			
		linphone.ui.core.addEvent(message,'msgStateChanged', linphone.ui.view.chat.onMsgStateChanged);
		linphone.ui.core.addEvent(message,'fileTransferProgressIndication', linphone.ui.view.chat.onSendFileTransferProgressIndication);
		
		room.markAsRead();
	},
	
	resendChatMessage: function(base,message,element){
		var chat = base.find('> .content .view > .chat');
		var core = linphone.ui.getCore(base);
		var room = message.chatRoom;
		
		var list = chat.find('.list');
		element.remove();	
		var resentMessage = room.newMessage(message.text);
		room.deleteMessage(message);
		room.sendChatMessage(resentMessage);	
		linphone.ui.view.chat.displaySendMessage(base,room,resentMessage);
		linphone.ui.core.addEvent(resentMessage,'msgStateChanged', linphone.ui.view.chat.onMsgStateChanged);		
		room.markAsRead();
		
		linphone.ui.menu.update(base);
	},
	
	displayHistory: function(base, room){
		var chats = room.getHistoryRange(0,-1);
		
		for(var i = 0; i < chats.length; ++i) {
			var chat = chats[i];
			if(chat.outgoing){
				linphone.ui.view.chat.displaySendMessage(base, room, chat);
			} else {
				linphone.ui.view.chat.displayReceivedMessage(base, room, chat);
			}
		}	
		linphone.ui.view.chat.scrollDown(base);
	},
	
	displaySendMessage: function(base,room, message, state){
		var chat = base.find('> .content .view > .chat');
		var core = linphone.ui.getCore(base);
		var list = base.find('> .content .view > .chat .list');
		var proxy = linphone.ui.utils.getMainProxyConfig(base);
		var element;
		
		//Display message with file
		if(message.fileTransferInformation !== null){
			var result;
			if(message.fileTransferInformation.type === 'image'){
				var content = 'data:image/'+ message.fileTransferInformation.subtype + ';base64,' + message.appdata ;
				result = '<div><img src="'+ content +'" class = "sentImage"></div>';
			}

			element = linphone.ui.template(base, 'view.chat.list.entry.sent', {
				img: 'style/img/avatar.jpg',
				date: linphone.ui.utils.getTimeFormat(message.time),
				message: linphone.ui.utils.getChatSentFile(message.fileTransferInformation) ,
				state: linphone.ui.utils.getChatStateImg(message.state),
				name: linphone.ui.utils.getUsername(base, proxy.identity) + ":"
			});
			
			element.find('.message').append(result);
		} else {
			element = linphone.ui.template(base, 'view.chat.list.entry.sent', {
				img: 'style/img/avatar.jpg',
				date: linphone.ui.utils.getTimeFormat(message.time),
				message: message.text,
				state: linphone.ui.utils.getChatStateImg(message.state),
				name: linphone.ui.utils.getUsername(base, proxy.identity) + ":"
			});
		}

		var resendMessage = function(base, message, element) {
			return function(){
				linphone.ui.view.chat.resendChatMessage(base,message,element);
			};
		};
		
		list.append(element);
		
		if(message.state === linphone.ChatMessageState.NotDelivered && message.fileTransferInformation === null){
			element.find('.infos .stateMessage .image').addClass('resendMessage');
			element.find('.stateMessage .imageErrorMessage').click(linphone.ui.exceptionHandler(base,resendMessage(base,message,element)));
		}
		
		linphone.ui.view.chat.scrollDown(base);
	},
	
	displayReceivedMessage: function(base,room, message){
		var chat = base.find('> .content .view > .chat');
		var core = linphone.ui.getCore(base);
		var list = base.find('> .content .view > .chat .list');
		
		var element;
		if (message.fileTransferInformation !== null) {
			element = linphone.ui.template(base, 'view.chat.list.entry.received', {
				img: 'style/img/avatar.jpg',
				date: linphone.ui.utils.getTimeFormat(message.time),
				message: linphone.ui.utils.getChatReceivedFile(message.fileTransferInformation),
				name: message.peerAddress.username + ":"
			});
			
			element.find('.download').show();
			element.find('.download').attr({
				'download': message.fileTransferInformation.name,
				'href': message.externalBodyUrl,
				'target': '_blank'
			});
		} else if (typeof message.externalBodyUrl !== 'undefined' && message.externalBodyUrl !== null) {
			element = linphone.ui.template(base, 'view.chat.list.entry.received', {
				img: 'style/img/avatar.jpg',
				date: linphone.ui.utils.getTimeFormat(message.time),
				message: "",
				name: message.peerAddress.username + ":"
			});
			
			element.find('.download').show();
			element.find('.download').attr({
				'download': "",
				'href': message.externalBodyUrl,
				'target': '_blank'
			});
		} else {
			element = linphone.ui.template(base, 'view.chat.list.entry.received', {
				img: 'style/img/avatar.jpg',
				date: linphone.ui.utils.getTimeFormat(message.time),
				message: message.text,
				name: message.peerAddress.username + ":"
			});
			element.find('.download').hide();
		}
		
		list.append(element);
		linphone.ui.view.chat.scrollDown(base);
	},
	
	scrollDown: function(base){
		var list = base.find('> .content .view > .chat .scroll-pane');
		
		var child = list.children();
		var heightTot = 0;
		for(var i =0; i < child.length; i++){
			heightTot += child[i].scrollHeight;
		}

		list.scrollTop(heightTot);
	},
	
	onMessageReceived: function(event, room, message){		
		var base = jQuery(this);
		var chat = base.find('> .content .view > .chat');	
		
		var contact = chat.data('contact');	
		if(contact.asString() === message.fromAddress.asString()){
			linphone.ui.view.chat.displayReceivedMessage(base,room,message);
			room.markAsRead();
			linphone.ui.menu.update(base);
		}
	},
	
	onMsgStateChanged: function(message, state) {
		//Message state
		var core = message.chatRoom.core;
		var base = linphone.ui.core.instances[core.magic];
		
		var list = base.find('> .content .view > .chat .scroll-pane .entrySend');
		
		
		if(message.fileTransferInformation !== null){
			if(state === linphone.ChatMessageState.FileTransferDone || state === linphone.ChatMessageState.Delivered || state === linphone.ChatMessageState.NotDelivered){
				linphone.ui.view.chat.clearFileUpload(base);
			}
		}
		
		if(state === linphone.ChatMessageState.FileTransferDone){
			linphone.ui.view.chat.displaySendMessage(base,message.room,message);
		}
		
		var resendMessage = function(base, message, element) {
			return function(){	
				linphone.ui.view.chat.resendChatMessage(base,message,element);
			};
		};
		
		for(var i =0; i < list.length; i++){
			var child = jQuery(list[i]);
			var mess = child.find('.infos .message').text();
			var date =  child.find('.infos .date').text();
			
			if(date === linphone.ui.utils.getTimeFormat(message.time) && (mess === message.text || (message.fileTransferInformation !== null && mess.indexOf(message.fileTransferInformation.name) > 0))){
				child.find('.infos .stateMessage .image').removeClass('imageInProgress');
				child.find('.infos .stateMessage .image').addClass(linphone.ui.utils.getChatStateImg(state));

				if(state === linphone.ChatMessageState.NotDelivered && message.fileTransferInformation === null){
					child.find('.infos .stateMessage .image').addClass('resendMessage');
					child.find('.infos .stateMessage .imageErrorMessage').click(linphone.ui.exceptionHandler(base,resendMessage(base,message,child)));				
				}			
			}
		}
	},
	
	onSendFileTransferProgressIndication: function(message, content, offset, total) {
		var core = message.chatRoom.core;
		var base = linphone.ui.core.instances[core.magic];
		var chat = base.find('> .content .view > .chat');
		
		var progress = Math.round((offset * 100.0) / total) + "%";
        chat.find('.fileUpload .fileUploadSize .progress-bar').css('width',progress);
	},
	
	onRecvFileTransferProgressIndication: function(chatMsg, content, offset, total) {
		var core = chatMsg.chatRoom.core;
		var base = linphone.ui.core.instances[core.magic];
	},
	
	isComposingReceived: function(event, room){	
		var base = jQuery(this);
		var core = linphone.ui.getCore(base);
		var chat = base.find('> .content .view > .chat');
		var status = chat.find('.status');
		var contact = chat.data('contact');	
		
		if(room.remoteComposing && contact.asString() === room.peerAddress.asString()) {
			status.show();
		} else {
			status.hide();
		}	
	}
};