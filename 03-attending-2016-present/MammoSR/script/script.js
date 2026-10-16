$(document).ready(function(){
	$('input[type=checkbox], span[contenteditable=true]').click(function(){
		$('#saveHint').show();
	});
	
	$('input[name=resultcb1]:first').parent().find('input[type=checkbox]').click(function(){
		if((this.name.indexOf('2')>-1 || this.name.indexOf('3')>-1) && this.checked) {
			$('#positiveFindingPage').hide();
		}else{
			$('#positiveFindingPage').show();
		}
	});
	
	var rand=Math.floor((Math.random() * 3) + 1); 
	var randTop=Math.random()*10-20;
	var randLeft=Math.random()*10-20;
	var randRot=Math.floor((Math.random() * 5) -9);
	
	var signImg=$("<img/>")
		.on('load', function() { $('span[name=radiologist]:first').hide(); $(this).show(); })
		.on('error', function() { $('span[name=radiologist]:first').show(); $(this).hide();})
		// .attr("src", "../sign/"+ $('span[name=radiologist]:first').text() +"/" + rand + ".png")
		.attr("src", "../sign/" + rand + ".png")
		.width(160)
		.css({'position': 'absolute', 
		'top': (-30+randTop),
		'left': randLeft,
		'-webkit-transform': 'rotate(' + randRot + 'deg)',
		'-	transform': 'rotate(' + randRot + 'deg)'});
		
	// var outerSignHereDiv = $('<div style="position:absolute; top: ' + (-30+randTop) + '; left: '+ (randLeft) +';"></div>');
	// $('#signHereDiv')[0].appendChild(outerSignHereDiv[0].appendChild(signImg[0]));
	// $('#signHereDiv')[0].appendChild(signImg[0]);
});

var lesionInd=0;
function createNewPositiveFinding(){
	while(true){
		lesionInd++;
		if(!$('#positiveFindingPage_'+lesionInd).length){break;}
	}
	var suffix="_"+lesionInd;
	
	var newLesion=$('#positiveFindingPage').clone().attr('id', 'positiveFindingPage'+suffix).show();
	newLesion.find('*').each(function(i){
		var name=$(this).attr('name');
		if(name!==undefined){
			$(this).attr('name', name+suffix);
		}
	});
	$('#saveHint').before(newLesion);
	$('#lesionCount').val(lesionInd);
	
}

function deleteLastFinding(){
	var lesionsI=0;
	while(true){
		lesionsI++;
		if(!$('#positiveFindingPage_'+lesionsI).length){break;}
	}
	lesionsI--;
	if(lesionsI>0){
		
		if(confirm('Delete last positive finding?')){
			$('#positiveFindingPage_'+lesionsI).remove();
			lesionInd=lesionsI-1;
			$('#lesionCount').val(lesionInd);
		}
	}
}

function deleteThisFinding(e){
	if(confirm('Delete this finding?')){
		var pf = $(e).closest('.positiveFinding');
		var id = pf.attr('id').match(/\d+/)[0];
		pf.remove();
		
		var lesionsI=0;
		while(true){
			lesionsI++;
			if(lesionsI==id){continue;}
			if(!$('#positiveFindingPage_'+lesionsI).length){break;}
			if(lesionsI>id){
				$('#positiveFindingPage_'+lesionsI).attr('id', 'positiveFindingPage_'+(lesionsI-1)).find('*').each(function(i){
					var name=$(this).attr('name');
					
					if(name!==undefined){
						var match=name.match(/_\d+$/);
						if(match){
							$(this).attr('name', name.replace(match[0], '_'+(lesionsI-1)));
						}
					}
				});
			}
		}
		lesionsI=lesionsI-2;
		lesionInd=lesionsI;
		$('#lesionCount').val(lesionInd);
	}
	return false;
}

function save(){
	location.href=location.hostname + location.pathname + '?lesionCount=' + $('#lesionCount').val() + '&' +  $('#reportForm').serialize().replace(/\=on/g,'=1');
}

