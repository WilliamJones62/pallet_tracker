function getData(data) {
  var p1 = data.replace('[', "");
  var p2 = p1.replace(']', "");
  p1 = p2.replace(/"/g, "");
  p2 = p1.replace(/,/g, "");
  var data_array = p2.split(" ");
  data_array.shift();
  data_array.pop();
  return data_array;
}

function setToggle() {
  var x = document.getElementById("fs_focus_item_name");
  var y = document.getElementById("toggle_button");
  button_text = y.innerHTML;
  if (button_text == "Select All") {
    y.innerHTML = "Select None";
    var i;
    for (i = 0; i < x.length; i++) {
      x.options[i].selected = true;
    }
  }
  else {
    y.innerHTML = "Select All"
    var i;
    for (i = 0; i < x.length; i++) {
      x.options[i].selected = false;
    }
  }
}

function partDescriptions() {
  //* find matches for part descriptions containing the value in part filter field
  var x = document.getElementById("filter");
  var y = document.getElementById("fs_focus_item_description");
  var filter_text = x.value.toUpperCase();
  var i = 0;
  //* Use filter to get list of descriptions
  var z = document.getElementById("descs").innerHTML;
  var descs_array = getData(z);
  y.options.length = 0;
  var o = document.createElement("option");
  o.selected = true;
  var arraylength = descs_array.length;
  for (i = 0; i < arraylength; i++) {
    if (descs_array[i].includes(filter_text)) {
    //* the part description includes the filter entered by the user
      o.text = descs_array[i].replace(/~/g, ' ');
      y.options.add(o, y.options.length);
      o.selected = false;
      o = document.createElement("option");
    }
  }
}
