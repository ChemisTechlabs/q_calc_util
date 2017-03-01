/*
	Copyright 2013-2014 ChemisProject

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.*/
document.onkeydown = dixonEvents;

function dixonEvents(e) {
    if (!e) var e = window.event;
    (e.keyCode) ? key = e.keyCode : key.which;
    switch (key) {
    case 37:
        console.log("Esquerda");
        break;
    case 38:
        fieldMoveUp();
        break;
    case 39:
        console.log("Direita");
        break;
    case 40:
        fieldMoveDown();
        break;
    case 8: removeEmptyField();
        break;
	case 27: openMenu();
		break;
    }
}

var menuOpened=false;

function openMenu(){
    var menu=$("#chemis-menu");
    var mask=$("#chemis-menu-mask");
    if(menuOpened){
        console.log("Fechou");
        $(menu).removeClass("open");
        $(mask).removeClass("open");
        menuOpened=false;
    }else{
        console.log("Abriu");
		$(menu).addClass("open");
        $(mask).addClass("open");
        menuOpened=true;
    }
}

function getCurrentDate(){
    return formatDate(new Date());
}

function getCurrentTime(){
    return formatTime(new Date());
}

function formatTime(date){
    var hour=date.getHours();
    var min=date.getMinutes();
    var sec=date.getSeconds();
    if(hour<10){
        hour="0"+hour;
    }
    if(min<10){
        min="0"+min;
    }
    if(sec<10){
        sec="0"+sec;
    }
    return ""+hour+":"+min+":"+sec;
}

function formatDate(date){
    var dia=date.getDate();
    var mes=date.getMonth()+1;
    if(dia<10){
        dia="0"+dia;
    }
    if(mes<10){
        mes="0"+mes;
    }
    return ""+dia+"/"+mes+"/"+date.getFullYear();
}

function daysInMonth(month,year) {
    return new Date(year, month, 0).getDate();
}

//chemis alert message
var alertQueue=[];

function showAlert(text){
	alertQueue.push(text);
	if(($("#chemis-alert.open")).length===0){
		$("#chemis-alert").addClass("open");
		shiftQueue();
	}
}

function setAlertMessage(text){
	setTimeout(function(){
		$("#chemis-alert-text").text(text);
		$("#chemis-alert-text").removeClass("fade-out");
	},300);
}

function shiftQueue(){
	if(alertQueue.length>0){
		setAlertMessage(alertQueue.shift());
		setTimeout(function(){
			$("#chemis-alert-text").addClass("fade-out");
			shiftQueue();
		},4000);
	}else{
		closeAlert();
	}
}

function closeAlert(){
	$("#chemis-alert").removeClass("open");
}