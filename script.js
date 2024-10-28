/*
	Quelle: http://mathiasbynens.be/notes/html5-details-jquery
*/
var isDetailsSupported = (function(doc) {
  var el = doc.createElement('details'),
      fake,
      root,
      diff;
  if (!('open' in el)) {
    return false;
  }
  root = doc.body || (function() {
    var de = doc.documentElement;
    fake = true;
    return de.insertBefore(doc.createElement('body'), de.firstElementChild || de.firstChild);
  }());
  el.innerHTML = '<summary>a</summary>b';
  el.style.display = 'block';
  root.appendChild(el);
  diff = el.offsetHeight;
  el.open = true;
  diff = diff != el.offsetHeight;
  root.removeChild(el);
  if (fake) {
    root.parentNode.removeChild(root);
  }
  return diff;
}(document));



$(document).ready(function() {if(localStorage){

	// <details> wird vom Browser unterstützt
	if(isDetailsSupported){
		
		//initial details laden
		$("details").each(function(){
			this.open = (localStorage[this.id] === "true");
		});
		
		//auf-/zuklappen von details -> speichern
		$("details").bind("DOMSubtreeModified", function(){
			localStorage[this.id] = this.open;
		});
		
	}
	// <details> wird NICHT vom Browser unterstützt
	else {
		
		//initial details laden
		$("details").each(function(){
			var id = this.id;
			var open = (localStorage[id] === "true");
			
			//für alle <details> Kind-Elemente ohne <summary>
			$(this).children(":not(summary)").each(function(){
				if(open)
					//aufklappen
					$(this).css("display", "block");
				else
					//zuklappen
					$(this).css("display", "none");
			});
			
			//Gliederungselement hinzufügen
			$(this).children("summary").each(function(){
				if(open)
					$(this).html("<span>&#x25bc;</span> " + $(this).html());
				else
					$(this).html("<span>&#x25b6;</span> " + $(this).html());
			});
			
		});
		
		//klicken auf <summary> -> auf-/zuklappen und speichern
		$("summary").click(function(){
			
			var open = false;
			
			//für alle <details> Kind-Elemente ohne <summary>
			$(this).parent().children(":not(summary)").each(function(){
				//aktueller Status
				open = $(this).css("display") === "none";
				
				if($(this).css("display") === "none")
					//aufklappen
					$(this).css("display", "block");
				else
					//zuklappen
					$(this).css("display", "none");
			});
			
			//Gliederungselement switchen
			if(open){
				$(this).children("span:first").html("&#x25bc;");
				
			} else {
				$(this).children("span:first").html("&#x25b6;");
			}
			
			//speichern im lokalem Speicher
			localStorage[$(this).parent().attr("id")] = open;
		});
		
	}
	
	
	//initial checkboxen laden
	$(":checkbox").each(function(){
		this.checked = (localStorage[this.name] === "true");
	});
	
	//ändern der checkbox -> speichern
	$(":checkbox").change(function() {
		localStorage[this.name] = this.checked;
	});
	
	//check all
	$("#check").click(function(){
		$(":checkbox").each(function(){
			this.checked = true;
			localStorage[this.name] = true;
		});
	});
	
	//uncheck all
	$("#uncheck").click(function(){
		$(":checkbox").each(function(){
			this.checked = false;
			localStorage[this.name] = false;
		});
	});
	
	//reset speicher
	$("#reset").click(function(){
		localStorage.clear();
		window.location.reload();
	});
	
	//video wegklicken
	var closeVideo = function(){
		$("#background").css("display", "none");
		$("#videocont").html("");
	};
	
	$("#background").click(closeVideo);
	
	//auf video-content klicken soll es nicht schließen
	$("#videocont").click(function(event){
		event.stopPropagation();
	});
	
	
	$("input").click(function(event){
		event.stopPropagation();
	});
	
	$("a").click(function(event){
		event.stopPropagation();
	});
	
	var nextVideo = function(){
		closeVideo();
		currentVideo = currentVideo.next("div");
		loadVideo(currentVideo);
	}
	
	var prevVideo = function(){
		closeVideo();
		currentVideo = currentVideo.prev("div");
		loadVideo(currentVideo);
	}
	
	var loadVideo = function(div){
		//Close Button
		$("<div/>").attr("class","closeVideo").html("X"/*"&#x274c;"*/).click(closeVideo).appendTo("#videocont");
		
		//nicht das erste Video
		if(div.prev("div").prev("div").length == 1){
			$("<div/>").attr("class","prevVideo").html("&#x2190;").click(prevVideo).appendTo("#videocont");
		}
		
		//nicht das letzte Video
		if(div.next("div").length == 1){
			$("<div/>").attr("class","nextVideo").html("&#x2192;").click(nextVideo).appendTo("#videocont");
		}
		
		//Videotitel
		var title = div.children("a:first").text();
		$("<div/>").attr("class","vtitle").text(title).appendTo("#videocont");
		
		
		//video element erstellen
		var video = $("<video/>");
		video.attr("width","600").attr("height","450")
		video.attr("preload","none").attr("controls","controls");
		
		//links auf die Video-Dateien
		var files = div.children("a:not(:first)");
		
		//für jeden Dateityp, ein <source> zum Video
		files.each(function(){
			var url = $(this).attr("href");
			var type = $(this).text();
			type = "video/" + type.substring(1, type.length - 1);
			
			var source = $("<source/>");
			source.attr("src", url).attr("type", type);
			source.appendTo(video);
		});
		
		//<video> einfügen
		video.appendTo("#videocont");
		
		//einblenden
		$("#background").css("display", "block");
	};
	
	//video öffnen
	$(".videobtn").click(function(){
		//div, welches die Videodaten enthält
		currentVideo = $(this).parent();
		loadVideo(currentVideo);
	});
	
}});
