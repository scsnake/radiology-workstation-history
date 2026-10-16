var df;
function processFile(){
	$('#selectFileButton').hide();
	
	var f = event.target.files[0];
  var reader = new FileReader();
  reader.onload = function(e) {
    var data = new Uint8Array(e.target.result);
    var wb = XLSX.read(data, {type: 'array'});
		var sh = wb.Sheets[wb.SheetNames[0]];
		df = XLSX.utils.sheet_to_json(sh);
		// var enc = new TextEncoder(); // always utf-8
		// var buffer = enc.encode(csv);
		
		// var DataFrame = dfjs.DataFrame;
		// var df;
		// DataFrame.fromCSV(enc.encode(csv)).then(d => d.show()});
		
		
  };
  reader.readAsArrayBuffer(f);
}

