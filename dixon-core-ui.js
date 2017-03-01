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
function DixonState() {
	this.sValues = null;
	this.sResults = null;
}

DixonState.prototype.values = function (values) {
	if (values !== undefined) {
		this.sValues = values;
	}
	return this.sValues;
};

DixonState.prototype.results = function (results) {
	if (results !== undefined) {
		this.sResults = results;
	}
	return this.sResults;
};

function addValueField(value) {
	$("#chemis-dixon-values-list").append(
		$('<li />').addClass("pure-control-group").append(
			$("<div/>").append(
				$('<input />').addClass("chemis-dixon-value").attr("type", "tel").attr("placeholder", "0,000").attr("value", value)
			)
		).append(
			$("<div/>").append(
				$("<button />").addClass("pure-button").text("X").attr("onclick", "removeValueField(this)")
			)
		)
	);
	var valuesCount = $(".chemis-dixon-value").length;
	$("#chemis-dixon-values-count").text("Valores: " + valuesCount);
}

function removeValueField(self) {
	var valuesCount = $(".chemis-dixon-value").length;
	if (valuesCount > 3) {
		$(self).addClass("chemis-dixon-value-rem");
		$(self).removeClass("chemis-dixon-value");
		$(self).parent().parent().fadeOut(300, function () {
			$(this).remove();
		});
		$("#chemis-dixon-values-count").text("Values: " + (valuesCount - 1));
	}
}

function getAllFields() {
	return $("#chemis-dixon-values-list .chemis-dixon-value");
}

function clearAllFields() {
	$("#chemis-dixon-values-list").html("");
	for (i = 0; i < 3; i++) {
		addValueField();
	}
}

function displayResults(dixon, results) {
	var per = results.percent;
	if (dixon !== null) {
		$("#result-" + per).html("Aprovado");
		var le = new countUp("le-" + per, 0, results.lowerEnd, 4, 0.5, options);
		var ue = new countUp("ue-" + per, 0, results.upperEnd, 4, 0.5, options);
		var n = new countUp("n-" + per, 0, dixon.getN(), 0, 0.5, options);
		var q = new countUp("q-" + per, 0, dixonConstants[per + "_" + dixon.getN()], 3, 0.5, options);
		le.start();
		ue.start();
		n.start();
		q.start();
		if (dixon.removed.length === 0) {
			$("#rm-" + per).html($("<li />").text("---"));
		} else {
			$("#rm-" + per).html("");
		}
		$.each(dixon.removed, function () {
			$("#rm-" + per).append($("<li />").text(this));
		});
	} else {
		$("#result-" + per).html("Reprovado");
		$("#le-" + per).html("---");
		$("#ue-" + per).html("---");
		$("#n-" + per).html("---");
		$("#q-" + per).html("---");
		$("#rm-" + per).html($("<li />").text("---"));
	}
}

function valuesToDixon() {
	var values = getAllFields();
	var dixon = new Dixon();
	$.each(values, function (index) {
		var value = $(this).val();
		value = value.replace(",", ".");
		value = value.trim();
		value = parseFloat(value);
		if (validateField(this, value, index, dixon)) {
			console.log("Value added:" + value);
			$(this).removeClass("chemis-dixon-value-invalid");
			$(this).val(value);
			dixon.addValue(value);
		}
	});

	return dixon;
}

function dixonToValues(dixon) {
	$("#chemis-dixon-values-list").html("");
	if (dixon !== undefined) {
		$.each(dixon.values, function () {
			addValueField(this);
		});
	}
	while (getAllFields().length < 3) {
		addValueField();
	}
}

function validateField(field, value, index, dixon) {
	if ($(field).val() === "") {
		removeValueField(field);
		console.log("Index #" + (index + 1) + " removed - empty value");
		return false;
	} else if (isNaN(value)) {
		$(field).addClass("chemis-dixon-value-invalid");
		console.log("Index #" + (index + 1) + " alert - Not a Number");
	} else if (dixon.values.indexOf(parseFloat(value)) != -1) {
		removeValueField(field);
		console.log("Index #" + (index + 1) + " removed - duplicated value");
		return false;
	} else {
		return true;
	}
}

function calcDixon() {
	var dixon95 = valuesToDixon();
	var dixon99 = valuesToDixon();
	var register = new DixonRegister("Resultado " + getCurrentDate() + " " + getCurrentTime(), new Date());
	register.values(valuesToDixon());
	try {
		var result95 = DixonControl.calc(dixon95, 95);
		register.result95(result95); /*salva registro95*/
		displayResults(dixon95, result95);
	} catch (err) {
		console.log(err.message);
		if(err.name=="Chemis Dixon Exception"){
			showAlert("Teste reprovado - 'N' é menor que 3");
		}
		displayResults(null, JSON.parse('{"percent":95}'));
	}

	try {
		var result99 = DixonControl.calc(dixon99, 99);
		register.result99(result99); /*salva registro99*/
		displayResults(dixon99, result99);
	} catch (err) {
		console.log(err.message);
		if(err.name=="Chemis Dixon Exception"){
			showAlert("Teste reprovado - 'N' é menor que 3");
		}
		displayResults(null, JSON.parse('{"percent":99}'));
	}
	register.dixon95(dixon95);
	register.dixon99(dixon99);
	dixonHistory.addRegister(register);
	addHistoryRegister(register);
}

function fieldMoveUp() {
	if (document.activeElement !== null) {
		var allFields = getAllFields();
		var index = allFields.index(document.activeElement);
		if (index != -1 && index !== 0) {
			allFields[index - 1].focus();
		} else if (index === 0) {
			getAllFields()[0].focus();
		}
	}
}

function fieldMoveDown() {
	if (document.activeElement !== null) {
		var allFields = getAllFields();
		var index = allFields.index(document.activeElement);
		if (index != -1 && index != allFields.length - 1) {
			allFields[index + 1].focus();
		} else if (index == allFields.length - 1) {
			addValueField();
			getAllFields()[index + 1].focus();
		}
	}
}

function getState() {
	var state = new DixonState();
	state.values(valuesToDixon());
	state.results($("#chemis-dixon-results").html());
	return state;
}

function restoreState() {
	dixonToValues(tempState.values());
	$("#chemis-dixon-results").html(tempState.results());
	console.log("State restored");
}

function saveState() {
	if (tempState !== undefined) {
		tempState = getState();
		console.log("State saved");
	} else {
		console.log("There's another saved state");
	}
}

function removeEmptyField() {
	var active = document.activeElement;
	if ($(active).val() === "" && getAllFields().length > 3) {
		if (getAllFields().index(active) === 0) {
			fieldMoveDown();
			removeValueField(active);
		} else {
			fieldMoveUp();
			removeValueField(active);
		}
	} else if ($(active).val() === "") {
		fieldMoveUp();
	}
}

function addHistoryRegister(register) {
	var list = $("#dixon-history-list");
	if(dixonHistory.registers.length==1){
		$(list).html("");
	}
	var id = "reg-" + register.date().getTime();
	var item = $("<li />").html($("<a />").attr("id", id).attr("href", "#").attr("title", "Registro").attr("onclick", "displayRegister('" + id + "')").text(register.name()));
	$(list).append($(item));
	console.log("Registro adicionado");
}

//Show selected dixon history register on result panel
function displayRegister(id) {
	saveState();
	showDialog();
	var register = dixonHistory.getRegisterById(id);
	dixonToValues(register.values());
	
	try{
		displayResults(register.rDixon95, register.rResult95);
	}catch(err){
		console.log(err.message);
		displayResults(null, JSON.parse('{"percent":95}'));
	}

	try{
		displayResults(register.rDixon99, register.rResult99);
	}catch(err){
		console.log(err.message);
		displayResults(null, JSON.parse('{"percent":99}'));
	}
	$("#chemis-page").addClass("history-mode");
}

function dialogCancel(){
	restoreState();
	closeDialog();
}

function dialogUse(){
	closeDialog();
}

function showDialog(){
	$("#dixon-history-dialog").addClass("open");
}

function closeDialog(){
	$("#dixon-history-dialog").removeClass("open");
}

var options = {  
	useEasing: true,
	useGrouping: true,
	separator: ',',
	decimal: '.'
};

var dixonHistory = new DixonHistory();
var tempRegister = null;
var tempState = null;

clearAllFields();