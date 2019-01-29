var EITC_Calculator = function() {
    "use strict";
    var c = this;
    c.parms = {
        "0": {
            "earned_income_base_amount": 6670,
            "begin_phaseout": 8340,
            "marriage_penalty_relief": 5590,
            "phase_in_rate": 0.0765,
            "phase_out_rate": 0.0765
        },
        "1": {
            "earned_income_base_amount": 10000,
            "begin_phaseout": 18340,
            "marriage_penalty_relief": 5590,
            "phase_in_rate": 0.34,
            "phase_out_rate": 0.1598
        },
        "2": {
            "earned_income_base_amount": 14040,
            "begin_phaseout": 18340,
            "marriage_penalty_relief": 5590,
            "phase_in_rate" : 0.4,
            "phase_out_rate": 0.2106
        },
        "3": {
            "earned_income_base_amount": 14040,
            "begin_phaseout": 18340,
            "marriage_penalty_relief": 5590,
            "phase_in_rate": 0.45,
            "phase_out_rate": 0.2106
        }
    };


    /*
        inputs is an object with keys
    */
    c.calculate = function(inputs, ignoreIRSTableBins) {
        if (typeof(ignoreIRSTableBins) === "undefined") {
            ignoreIRSTableBins = false;
        }
        if (isNaN(inputs.dependents*1)) {
            inputs.dependents = 0;
        }
        inputs.dependents = Math.round(Math.max(0, Math.min(3, inputs.dependents), inputs.dependents));
        /*actual calculation here. pretty self-explanatory*/
        var parms = c.parms[inputs.dependents],
            rounded_wages = inputs.wages;
        if (ignoreIRSTableBins === false) {
            rounded_wages = (inputs.wages === 0 ? 0 : Math.floor(inputs.wages/50)*50 + 25);
        }
        var marriage_penalty_relief = (inputs.filingStatus === "married") ? parms.marriage_penalty_relief : 0,
            /*total potential EITC*/
            gross_eitc = Math.min(rounded_wages, parms.earned_income_base_amount)*parms.phase_in_rate,
            /*minus phaseout*/
            less_amount = Math.max(0,(rounded_wages - (parms.begin_phaseout + marriage_penalty_relief))*parms.phase_out_rate);
        return Math.max(0, gross_eitc - less_amount);
    };
};



function checkNumber(obj)
{
    var str = obj.value;

    if (str.length == 0 || str == "" || str == null) {
        return false;
    }

    for (var i = 0; i < str.length; i++) {
        var ch = str.substring(i, i + 1)
        if ((ch < "0" || "9" < ch) && ch != '.' && ch != '$' && ch != ',') {
            return false;
        }
    }

    return true;
}

function tonum(str)
{
    var     nstr = "";

    for (var i = 0; i < str.length; i++) {
        var ch = str.substring(i, i + 1);
        if ((ch >= "0" && ch <= "9") || ch == '.') {
            nstr += ch;
        }
    }

    return parseFloat(nstr);
}

function valueOrDefault(obj, defval)
{
    if (!checkNumber(obj)) {
        return defval;
    }

    var val = tonum(obj.value);

    if (val == 0) {
        return defval;
    }
    return val;
}


function format(val, len, decimal)
{
    var     scale = 1;

    if (decimal == null)
        decimal = 1;

    for (i = 0; i <= decimal; i++)
        scale *= 10;

    var     str = "" + Math.round(parseFloat(val) * scale);

    if (str.length == 0 || str == "0") {
        str = "000";
    }

    str = "$" + str;
    i = len - str.length;
    if (scale != 1)
        i--;
    while (0 < i--)
        str = " " + str;
    if (scale != 1) {
        var p = len - decimal - 2;
        var a = str.substring(0, p);
        var b = str.substring(p, len);
        return a + "." + b;
    }
    return str;
}

function compute(input)
{
    var form = input.form;

    EARNINGS = valueOrDefault(form.FORMEARNINGS, 0);
    STATUS = form.FORMSTATUS.value;
    KIDS = valueOrDefault(form.FORMKIDS, 0);

    var calculator = new EITC_Calculator();

    /*Formula for  with  Kids*/

    var result = calculator.calculate({
        wages: EARNINGS,
        dependents: KIDS,
        filingStatus: STATUS,
    });
    form.total.value = Math.round(result);
}



var statusInput = document.getElementById('FORMSTATUS');

function useStatusValue() {
    compute(this);
    var StatusValue = statusInput.value;
    // use it
}
statusInput.onload = useStatusValue;
statusInput.onchange = useStatusValue;
statusInput.onblur = useStatusValue;

var kidsInput = document.getElementById('FORMKIDS');
function useKidsValue() {
    compute(this);
    var KidsValue = kidsInput.value;
    // use it
}
kidsInput.onload = useKidsValue;
kidsInput.onchange = useKidsValue;
kidsInput.onblur = useKidsValue;

var earningsInput = document.getElementById('FORMEARNINGS');
function useEarningsValue() {
    compute(this);
    var EarningsValue = earningsInput.value;
    // use it
}

earningsInput.onload = useEarningsValue;
earningsInput.onkeyup = useEarningsValue; earningsInput.onkeyup = submitForm;
earningsInput.onblur = useEarningsValue;

var totalInput = document.getElementById('total');
function useTotalValue() {
    compute(this);
    var TotalValue = totalInput.value;
    // use it

}
totalInput.onload = useTotalValue;
totalInput.onchange = useTotalValue;earningsInput.onkeyup = useTotalValue;
statusInput.onchange= useTotalValue;
kidsInput.onchange= useTotalValue;
totalInput.onblur = useTotalValue;


function checkNumber(obj)
{
    var str = obj.value;

    if (str.length == 0 || str == "" || str == null) {
        return false;
    }

    for (var i = 0; i < str.length; i++) {
        var ch = str.substring(i, i + 1)
        if ((ch < "0" || "9" < ch) && ch != '.' && ch != '$' && ch != ',') {
            return false;
        }
    }

    return true;
}

function tonum(str)
{
    var   nstr = "";

    for (var i = 0; i < str.length; i++) {
        var ch = str.substring(i, i + 1);
        if ((ch >= "0" && ch <= "9") || ch == '.') {
            nstr += ch;
        }
    }

    return parseFloat(nstr);
}

function valueOrDefault(obj, defval)
{
    if (!checkNumber(obj)) {
        return defval;
    }

    var val = tonum(obj.value);

    if (val == 0) {
        return defval;
    }
    return val;
}


function format(val, len, decimal)
{
    var   scale = 1;

    if (decimal == null)
        decimal = 1;

    for (i = 0; i <= decimal; i++)
        scale *= 10;

    var   str = "" + Math.round(parseFloat(val) * scale);

    if (str.length == 0 || str == "0") {
        str = "000";
    }

    str = "$" + str;
    i = len - str.length;
    if (scale != 1)
        i--;
    while (0 < i--)
        str = " " + str;
    if (scale != 1) {
        var p = len - decimal - 2;
        var a = str.substring(0, p);
        var b = str.substring(p, len);
        return a + "." + b;
    }
    return str;
}

function compute(input)
{
    var form = input.form;

    EARNINGS = valueOrDefault(form.FORMEARNINGS, 0);
    STATUS = form.FORMSTATUS.value;
    KIDS = valueOrDefault(form.FORMKIDS, 0);

    var calculator = new EITC_Calculator();

    /*Formula for with Kids*/

    var result = calculator.calculate({
        wages: EARNINGS,
        dependents: KIDS,
        filingStatus: STATUS,
    })

    form.total.value = Math.round(result);
}

;