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
  var x = document.getElementById("pallets");
  var y = document.getElementById("toggle_button");
  button_text = y.innerHTML;
  if (button_text == "All Pallets") {
    y.innerHTML = "No Pallets";
    var i;
    for (i = 0; i < x.length; i++) {
      x.options[i].selected = true;
    }
  }
  else {
    y.innerHTML = "All Pallets"
    var i;
    for (i = 0; i < x.length; i++) {
      x.options[i].selected = false;
    }
  }
}

function updatePallet() {
  var cost_center = document.getElementById("cost_centers").value;
  var i = 0;
  var j = 0;
  var x = document.getElementById("pallets");
  while (x.options.length) {
    x.remove(0);
  }
  var ccs = document.getElementById("jsccs").innerHTML;
  var ccs_array = getData(ccs);
  var pallets = document.getElementById("jspallets").innerHTML;
  var pallets_array = getData(pallets);
  var destination_ccs = document.getElementById("jsdestinationccs").innerHTML;
  var destination_ccs_array = getData(destination_ccs);
  var current_locations = document.getElementById("jscurrentlocations").innerHTML;
  var current_locations_array = getData(current_locations);
  var vendor_codes = document.getElementById("jsvendorcodes").innerHTML;
  var vendor_codes_array = getData(vendor_codes);
  var arraylength = pallets_array.length;
  for (i = 0; i < arraylength; i++) {
    if (cost_center == ccs_array[i]) {
     var pallet_txt = pallets_array[i]+'-'+destination_ccs_array[i]+'-'+current_locations_array[i]+'-'+vendor_codes_array[i]
     var pallet = new Option(pallet_txt, pallet_txt);
     x.options.add(pallet);
     j++;
    }
  }
  var y = document.getElementById("trucks");
  j = 0;
  while (y.options.length) {
    y.remove(0);
  }
  ccs = document.getElementById("jstrucksccs").innerHTML;
  ccs_array = getData(ccs);
  var trucks = document.getElementById("jstrucks").innerHTML;
  var trucks_array = getData(trucks);
  var arraylength = trucks_array.length;
  for (i = 0; i < arraylength; i++) {
    if (cost_center == ccs_array[i]) {
     var truck = new Option(trucks_array[i], trucks_array[i]);
     y.options.add(truck);
     j++;
    }
  }
}

function updateNewLocation() {
  var cost_center = document.getElementById("pallet_origin_cc").value;
  var i = 0;
  var x = document.getElementById("pallet_current_location");
  while (x.options.length) {
    x.remove(0);
  }
  var ccs = document.getElementById("jsccs").innerHTML;
  var ccs_array = getData(ccs);
  var loctypes = document.getElementById("jsloctypes").innerHTML;
  var loctypes_array = getData(loctypes);
  var locations = document.getElementById("jslocations").innerHTML;
  var locations_array = getData(locations);
  var arraylength = locations_array.length;
  for (i = 0; i < arraylength; i++) {
    if (cost_center == ccs_array[i] && loctypes_array[i] != "S") {
    // exclude staging locations on new pallet screen
     var location = new Option(locations_array[i], locations_array[i]);
     x.options.add(location);
    }
  }
}

function updateVendor() {
  var x = document.getElementById("pallet_vendor_code");
  var vendor_len = x.options.length
  x.options.length = 0;
  var o = document.createElement("option");
  o.selected = true;
  if (vendor_len > 1) {
    // set the vendor to dartagnan and the vendor field to read only
    o.text = 'DARTAGNAN';
    x.options.add(o, x.options.length);
  } else {
    // create a select field containing a list of vendors
    var vendors = document.getElementById("vendors").innerHTML;
    var vendors_array = getData(vendors);
    vendors_array.sort();
    vendors_array.unshift("BACKHAUL");
    var arraylength = vendors_array.length;
    for (i = 0; i < arraylength; i++) {
      //* the part description includes the filter entered by the user
      o.text = vendors_array[i].replace(/~/g, ' ');
      x.options.add(o, x.options.length);
      o.selected = false;
      o = document.createElement("option");
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
