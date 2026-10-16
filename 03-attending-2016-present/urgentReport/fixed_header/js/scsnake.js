var dt = $('table');
var headers = []; // header_name: is_sorted (0 -> 1 -> -1)
var sortLock = false;
var grayRow = []; // indexes of rows with grayText class

// var testCols = ['CLASS NAME','TYPE','HOURS','TRAINER','SPOTS'];
// setColumnHeaders(testCols);

if(Array.prototype.equals)
    console.warn("Overriding existing Array.prototype.equals. Possible causes: New API defines the method, there's a framework conflict or you've got double inclusions in your code.");
// attach the .equals method to Array's prototype to call it on any array
Array.prototype.equals = function (array) {
    // if the other array is a falsy value, return
    if (!array)
        return false;

    // compare lengths - can save a lot of time 
    if (this.length != array.length)
        return false;

    for (var i = 0, l=this.length; i < l; i++) {
        // Check if we have nested arrays
        if (this[i] instanceof Array && array[i] instanceof Array) {
            // recurse into the nested arrays
            if (!this[i].equals(array[i]))
                return false;       
        }           
        else if (this[i] != array[i]) { 
            // Warning - two different object instances will never be equal: {x:20} != {x:20}
            return false;   
        }           
    }       
    return true;
};
// Hide method from for-in loops
Object.defineProperty(Array.prototype, "equals", {enumerable: false});
Array.prototype.spliceArray = function(index, n, array) {
    return Array.prototype.splice.apply(this, [index, n].concat(array));
};

function getElementsInArray(arr, indexes){
	var ret = [];
	$.each(indexes, function(i,v){
		ret.push(arr[v]);
	});
	return ret;
}

function setColumnHeaders(colNames, colWidths){
	dt.children('thead')
		.html('<tr><th>'+(colNames.join('</th><th>'))+'</th></tr>')
		.find('tr').addClass('row100 head')
		.find('th').click(sortRow).on('selectstart', function(){return false;})
		.each(function(i, v){
			$(v).addClass('cell100 column'+(i+1));
			if(colWidths) $(v).width(colWidth[i]);
			headers[colNames[i]] = 0;
		});
}

function addRow(rowData){
	dt.children('tbody').append('<tr><td>'+(rowData.join('</td><td>'))+'</td></tr>')
		.find('tr').addClass('row100 body')
		.find('td').each(function(i, v){
			$(v).addClass('row100 column'+(i+1)).width(colWidth[i]);
		});
}

function modifyRow(row, rowData){
	var r = $(row).children('td').each(function(i,v){
		$(v).text(rowData[i]);
	});
}

function table2data(addIndex){
	if(addIndex===undefined) addIndex=true;
	
	var data = [];
	grayRow = [];
	
	dt.find('tbody tr').each(function(i, v){
			data[i] = [];
			if($(this).hasClass('grayText')) grayRow.push(i);
			
			$(this).children('td').each(function(ii, vv){
					data[i][ii] = $(this).text();
			}); 
			
			if(addIndex) data[i].splice(0,0,i);
	});
	
	return data;
}

function getKeyInd(dic, key){
	var ind=-1;
	
	for (var k in dic) {
    if (dic.hasOwnProperty(key)) {           
      ind+=1;
			if(k===key){
				return ind;
			}  
    }
	}
	return -1;
}

function sortRow(e){
	if(sortLock) return;
	
	sortLock = true;
	var isMultiSort = !!e.shiftKey;
	var thisHeader = $(this).text().replace(/↓|↑/g, '');
	var thisHeaderInd = getKeyInd(headers, thisHeader)+1;
	var thisSort = headers[thisHeader];
	var newSortOrder = (thisSort==0)?1:(-1)*thisSort;

	var data = table2data(true);
	var newGrayRow = [];
	
	if(data.length<2) return;
	
	if(!isMultiSort){
		dt.find('th').each(function(){
			var t = $(this).text().replace(/↓|↑/g, '');
			$(this).text(t);
		});
		data.alphanumSort(true, thisHeaderInd, newSortOrder);
		
		dt.find('th').removeClass('sortedCol');
	}else{
		var sortedCols = [];
		var ii=0;
		for (var i in headers) {
			if (headers.hasOwnProperty(i)) {           
				ii+=1;
				if(headers[i]!=0) sortedCols.push(ii);	
			}
		}

		var prvRow = data[0];
		var startInd = 0;
		var seg;
		$.each(data, function(i,r){
			if(!getElementsInArray(r,sortedCols).equals(getElementsInArray(prvRow,sortedCols))){
				seg = data.slice(startInd, i);
				seg.alphanumSort(true, thisHeaderInd, newSortOrder);
				data.spliceArray(startInd, i - startInd, seg);
				startInd = i;
			}
			prvRow=r;
		});
		var l = data.length;
		if(l - startInd > 1){
			seg = data.slice(startInd, l);
			seg.alphanumSort(true, thisHeaderInd, newSortOrder);
			data.spliceArray(startInd, l - startInd, seg);
		}
		
	}
	
	$.each(zip(dt.find('tbody tr').toArray(), data), function(i,v){
		modifyRow(v[0], v[1].slice(1));
		
		var oldInd = v[1][0];
		if(grayRow.indexOf(oldInd)>-1){
			$(v[0]).addClass('grayText');
			newGrayRow.push(i);
		}else{
			$(v[0]).removeClass('grayText');
		}
		
	});
	
	grayRow = newGrayRow;
	
	headers[thisHeader] = newSortOrder;
	$(this).text(thisHeader + (newSortOrder==1?'↓':'↑')).addClass('sortedCol');
	// dt.find('tbody tr td:nth-child('+thisHeaderInd+')').addClass('sortedCol');
	
	
	sortLock = false;
}

function zip(a,b) {
  return a.map(function(e, i) {
		return [e, b[i]];
	});
}

