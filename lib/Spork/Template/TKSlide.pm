package Spork::Template::TKSlide;
use strict;
use warnings;
use Spork::Template::TT2 '-base';

our $VERSION = '0.01';

=head1 NAME

Spork::Template::TKSlide - Default TKSlide Template.

=head1 DESCRIPTION

These are the default template file for Spork:TKSlide,
You don't want to edit html templates, but you can
try to design your own style by applying different CSS.

See L<Spork::Config::TKSlide> for changing default style.

=head1 SEE ALSO

L<Spork>, L<Spork::Config::TKSlide>

=head1 COPYRIGHT

Copyright 2004 by Kang-min Liu <gugod@gugod.org>.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See <http://www.perl.com/perl/misc/Artistic.html>

B<TKSlide> is done by Tkirby Wu <b88039@csie.ntu.edu.tw>,
the official site is at <http://www.csie.ntu.edu.tw/~b88039/slide/>.

=cut


1;
__DATA__
__start.html__
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>[% slide_heading %]</title>
<meta name="generator" content="[% spork_version %]">
<link rel="stylesheet" type="text/css" href="[% style_file %]">
</head>
<body>

[% allpage_content %]

<script type="text/javascript" src="controls.js"></script>

</body>
</html>

__slide.html__
<!-- BEGIN slide.html -->
<div class="page" id="[% slide_name %]">
<div class="headline">[% slide_heading %]</div>
<div class="content">
[% image_html %]
[% slide_content %]
</div>
</div>
<!-- END slide.html -->
__slide-zen.css__
body
{ overflow:hidden;
  margin:0px;
  padding:0px;
  font-size:16px;
  font-family:Tahoma, Arial;
  background:#fff url(http://meerkat.elixus.org//images/zen/blossoms.jpg) no-repeat bottom right;
}

a {text-decoration:none;}

a:visited {color:#669;}

img {border:none;}

.headline
{
  color: #7D775C;
  text-decoration:underline;
}

h1 {color: #707349;}
h2 {color: #707349;}
h3 {color: #707349;}
h4 {color: #707349;}
h5 {color: #707349;}
h6 {color: #707349;}

.page
{ position:absolute;z-index:0;overflow:hidden;
  top:0%;left:0%;bottom:7%;right:150px;
  border:none;
  padding-left: 115px;
  margin:0px;
  height:93%;
  display:none;
  background:#fff url(http://meerkat.elixus.org/images/zen/zen-bg.jpg) no-repeat top left;
  } 

.pagedisplay
 {border:1px inset #999;padding:1px;padding-left:10px;padding-right:10px;
  color:#000;background:#bfbfbf;
 }

.hider
 {border:1px outset #999;display:none;
 }

.headline
 {font-family:Arial;font-size:32px;text-align:center;padding:3px;padding-top:20px;}

.subtitle
 {font-family:Arial;font-size:12px;text-align:center;padding:3px;}

.author
 {position:absolute;right:10px;;bottom:10px;}

.section
 {}

.content
 {margin:10px;}

.comment
 {position:absolute;left:0px;width:80%;bottom:12px;font-size:12px;border-top:1px solid #000;
  padding:7px;}

.list 
 {}

.list .caption
 {font-size:18px;font-weight:600;}

.list .content
 {margin:0px;padding:0px;}

.list div ul
 {margin-left:15px;margin-top:5px;list-item:list-style:disc inside;}

.cpanel 
 {
   position:absolute;z-index:1;color:#9c9c9c;
   background:#eee;
   padding: 2px 5px;
   border:1px outset #bbb;
   right: 0%;
   top: 0%;
   font-size: 8px;
   font-family: courier;
 }
__slide.css__
 body
  {overflow:hidden;margin:0px;padding:0px;font-size:16px;font-family:Lucida console;
   background:#000;}

 a
  {text-decoration:none;}

 a:visited 
  {color:#669;}
.page
 {position:absolute;z-index:0;overflow:hidden;
 /* style settings */
  top:2%;left:2%;bottom:2%;right:2%;border:2px outset #aaa;
  background:#eee url(hill.jpg) no-repeat left bottom;padding:0px;margin:0px;
  height:96%;width:96%;display:none;
 } 

.pagedisplay
 {border:1px inset #999;padding:1px;padding-left:10px;padding-right:10px;
  color:#000;background:#bfbfbf;
 }

.hider
 {border:1px outset #999;display:none;
 }

.headline
 {font-family:Arial;font-size:32px;text-align:center;padding:3px;padding-top:20px;}

.subtitle
 {font-family:Arial;font-size:12px;text-align:center;padding:3px;}

.author
 {position:absolute;right:10px;;bottom:10px;}

.section
 {}

.content
 {margin:10px;}

.comment
 {position:absolute;left:0px;width:80%;bottom:12px;font-size:12px;border-top:1px solid #000;
  padding:7px;}

.list 
 {}

.list .caption
 {font-size:18px;font-weight:600;}

.list .content
 {margin:0px;padding:0px;}

.list div ul
 {margin-left:15px;margin-top:5px;list-item:list-style:disc inside;}

.cpanel 
 {
  position:absolute;z-index:1;color:#9c9c9c;
  background:#bbb;padding-top:2px;padding-bottom:2px;padding-left:5px;padding-right:5px;
  border:2px outset #bbb;
 }
__controls.js__
 var	pcount		= 0;		/* page count */
 var	pages		= null;		/* page list */
 var	cpage		= 0;		/* current page */
 var	opage		= 0;		/* previous page */
 var	pagedisplay	= null;		/* the panel show current page */
 var	gopage		= "";
 var	spagetimer	= null;
 var	hidetimer	= null;
 var	showtimer	= null;

 var	hcomp		= null;
 var	hcompp		= 0;

 function fall_down(v, a)
 {
  v				= v+a;
  a				= a+0.8;
  if(v<0) {
   hcompp.style.top		= v+"px";
   setTimeout("fall_down("+v+", "+a+");", 10);
  } else { 
   hcompp.style.top		= "";
   hcompp			= hcompp.nextHide;
  }
 }

 function show_hider()
 {
  hcompp.style.visibility	= "visible";
  hcompp.style.position		= "relative";
  hcompp.style.top		= "-300px";
 // hcompp			= hcompp.nextHide;
  setTimeout("fall_down(-300, 1);", 10);
 }

 function initHider()
 {
  var	i;
  for(i=0;i<pcount;i++) hcomp[i] = null;
  for(i=0;i<pcount;i++) get_allhide(pages[i], i);
 }

 function get_allhide(node, tpage)
 {
  var	i;
  if(node.title=="hide") {
   node.nextHide	= hcomp[tpage]; 
   hcomp[tpage]		= node;
   return;
  } else for(i=node.childNodes.length-1;i>=0;i--) { 
   get_allhide(node.childNodes[i], tpage);
  }
 }

 function gh() {change_page(0);} function ge() {change_page(pcount-1);}
 function gp() {change_page(cpage-1);} function gn() {change_page(cpage+1);}

 function fade_in(position)
 {
  pages[cpage].style.filter	= "alpha(opacity="+position+")";
  position+=10;
  if(position<100) spagetimer	= setTimeout("fade_in("+position+");", 10);
  else pages[cpage].style.filter= "";
 }

 function slip_in(position)
 {
  pages[cpage].style.left	= position+"%";
  position+=10;
  if(position<10) spagetimer	= setTimeout("slip_in("+position+");", 10);
  else pages[cpage].style.left	= "";
 }

 function hideHider(tpage)
 {
  var node			= hcomp[tpage];
  while(node!=null) {
   node.style.visibility	= "hidden";
   node				= node.nextHide;
  } hcompp			= hcomp[tpage];
 }

 function show_page(tpage, visible)
 {
  if(cpage==tpage && visible==0) return;
  if(visible) {
   //pages[cpage].style.filter	= "filter(opacity=0)";
   //if(spagetimer) clearTimeout(spagetimer);
   //spagetimer		= setTimeout("slip_in(-100)", 10);
   //spagetimer		= setTimeout("fade_in(0)", 10);
   //pages[cpage].style.left	= "-100%";
  }
  pages[tpage].style.display	= (visible?"block":"none");
  pages[tpage].style.zIndex	= (visible?visible:0);
  if(visible) {
   pagedisplay.childNodes[0].nodeValue	= "p. "+(tpage+1)+(tpage==pcount-1?"e":"");
   hideHider(tpage);
  } else hidetimer	= null; 
 }

 function write_cpanel()
 {
  var cpanel		= document.getElementById("ctrl_panel");

  if(!cpanel) {
   var archor;
   cpanel		= document.createElement("div");
   cpanel.id		= "ctrl_panel";
   cpanel.className	= "cpanel";
   cpanel.style.zIndex	= 2;
   archor		= document.createElement("a");
   archor.href		= "#";
   archor.onclick	= gh;
   archor.appendChild(document.createTextNode("<<"));
   cpanel.appendChild(archor);
   cpanel.appendChild(document.createTextNode(" / "));
   archor		= document.createElement("a");
   archor.href		= "#";
   archor.onclick	= gp;
   archor.appendChild(document.createTextNode("<"));
   cpanel.appendChild(archor);
   cpanel.appendChild(document.createTextNode(" / "));
   archor		= document.createElement("a");
   archor.href		= "#";
   archor.onclick	= gn;
   archor.appendChild(document.createTextNode(">"));
   cpanel.appendChild(archor);
   cpanel.appendChild(document.createTextNode(" / "));
   archor		= document.createElement("a");
   archor.href		= "#";
   archor.onclick	= ge;
   archor.appendChild(document.createTextNode(">>"));
   cpanel.appendChild(archor);
   cpanel.appendChild(document.createTextNode(" | "));
   archor		= document.createElement("span");
   archor.className	= "pagedisplay";
   archor.id		= "pagedisplay";
   archor.appendChild(document.createTextNode("p. "+(cpage+1)+(cpage==pcount-1?"e":"")));
   cpanel.appendChild(archor);
   archor		= document.createElement("span");
   archor.className	= "hider";
   archor.id		= "hider";
   archor.appendChild(document.createTextNode("<"));
   cpanel.appendChild(archor);

   document.body.appendChild(cpanel);
  }
 }

 function keyparser(e)
 {
  var eve		= (e?e:event);
  var code		= (eve.charCode?eve.charCode:eve.keyCode);
  //alert(code);
  if(code>47 && code<58) { // number
   gopage		= gopage+(code-48);
   pagedisplay.childNodes[0].nodeValue	= "p. "+gopage+"_";
  }
  if(code==13 || (code==32 && !hcompp)) {
   if(gopage!="") {
    var	gpage		= parseInt(gopage);
    gopage		= "";
    if(!isNaN(gpage) && gpage>=0 && gpage<=pcount) { 
     change_page(gpage-1);
    } else {
     pagedisplay.childNodes[0].nodeValue  = "p. "+(cpage+1)+(cpage==pcount-1?"e":"");
    }
   } else change_page(cpage+1);
  } else if(code==32 && hcompp) { show_hider(); }
  if(code==40 || code==39) change_page(cpage+1);
  if(code==37 || code==38) change_page(cpage-1);
  if(code==192) change_page(opage);
  if(code==34) change_page(cpage+5);
  if(code==33) change_page(cpage-5);
  if(code==36) change_page(0);
  if(code==35) change_page(pcount-1);
 }

 function change_page(page_number)
 {
  var i;
  if(page_number<0 || page_number>=pcount || cpage==page_number) return;
  show_page(page_number, 1);
  opage				= cpage;
  cpage				= page_number;
  hidetimer = setTimeout("show_page("+opage+", 0);", 10);  // prevet page blink //
  document.cookie		= "cpage="+cpage;
  gopage			= "";
 }

 function initial()
 {
  var	i		= 0;
  var	j		= 0;
  var	body		= document.body;
  document.onkeydown	= keyparser;
  pcount		= body.childNodes.length;
  pages			= new Array(pcount);
  hcomp			= new Array(pcount);
  for(i=0, j=0;i<pcount;i++) {
   if((body.childNodes[i].nodeName=="DIV" ||
       body.childNodes[i].nodeName=="div") && 
      body.childNodes[i].className=="page") {
    pages[j++]		= body.childNodes[i];
   }
  } 
  pcount		= j;
  cpage			= 0;
  if(document.cookie) {
   var cookie		= document.cookie;
   var limitloop	= 0;
   cpage		= parseInt(document.cookie.substring(6));
   while(cookie.indexOf("cpage=")>0) {
    if(limitloop++>=10) break;
    if(cookie.indexOf(";")<0) break;
    cookie		= cookie.substring(cookie.indexOf(";")+1);
    if(cookie.indexOf("c")<0) break;
    cookie		= cookie.substring(cookie.indexOf("c"));
   } if(cookie.indexOf("cpage=")==0)
   cpage 		= parseInt(cookie.substring(cookie.indexOf("=")+1));
  } if(isNaN(cpage)) cpage= 1;
  document.cookie	= "cpage="+(cpage)+";";
  write_cpanel();
  pagedisplay		= document.getElementById("pagedisplay");
  initHider();
  show_page(cpage, 1)
 }

 initial();
