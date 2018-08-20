// show/hide terminal
$(document).keydown(function(e) {
   if (e.keyCode === 27/*192*/) {
      switchTerminal(e);
   }
});

function showTerminal()
{
   savedFocus = document.activeElement;
   $("#canvas").hide();
   terminal.resume();

   if (document.activeElement != undefined)
      document.activeElement.blur();
}

function hideTerminal()
{
   terminal.pause();

   // resize the canvas to terminal
   $("#canvas").css({
      'height': $("#terminal").outerHeight(),
      'width':  $("#terminal").outerWidth()
   });
   $("#canvas").show();

   if (savedFocus != undefined)
      savedFocus.focus();
}

function switchTerminal(e)
{
   if ($("#canvas").is(":visible")) {
      showTerminal();
   }
   else {
      hideTerminal();
   }

   if (e != undefined)
      e.preventDefault();
}

function doit(text)
{
   showTerminal();

   terminal.focus();
//   console.log("text:", text);
   if (text.indexOf("\n") == 0)
      text = text.substring(1);
   terminal.exec(text);
}

// TERMINAL:
var stdInput = ""; //unescape(encodeURIComponent(",load \"init.lisp\"")); // loading the script with initial code

var terminal;
$('#terminal').terminal(function(command, terminal) {
   stdInput += unescape(encodeURIComponent(command));

   // let's clear prompt up to got response
   terminal.set_prompt('');
}, {
   prompt: '> ',
   name: 'repl',
   greetings: '',
   enabled: false,
   height: 200,

   onInit: function(term) {
      terminal = term;
      terminal.ready = false;
   }
});

$('#terminal').mousewheel(function(event) {
   terminal.scroll(event.deltaY);
   // console.log(event.deltaX, event.deltaY, event.deltaFactor);
   if (event.preventDefault)  //disable default wheel action of scrolling page
      event.preventDefault();
   else
      return false;
});

var Module = {
   //arguments: ['/repl', 'test.lisp', '--interactive'],
   arguments: ['/repl', '-', '--interactive'],
   // dynamicLibraries: ['libNewton.js'],
   TOTAL_MEMORY: 67108864,

   preRun: function() {
      console.log("preRun");
      //LibraryManager.library = Module;

      function stdin() {
         if (stdInput.length == 0) {
            return undefined;
         }

         var chr = stdInput.charCodeAt(0);
         stdInput = stdInput.substring(1);
         return chr;
      }
      var stdout = null;
      var stderr = null;
      FS.init(stdin, stdout, stderr);

      Libraries.forEach( function(i) {
         console.log("i: ", i.path + "/" + i.name);
         if (i.path != "/")
            FS.createPath("/", i.path, true, true);
         FS.createDataFile(i.path + "/", i.name, i.data, true, false);
      });
      // cleanup?
      //Libraries = [];


      //loadDynamicLibrary("library_gl.js");
      //loadDynamicLibrary("library_xlib.js");
      //var GLctx; GL.init()
   },
   postRun: function() {
      terminal.focus();
      terminal.exec("\n"); // start loading process.
//    terminal.exec("(import (lib opengl))");
      terminal.resume();
   },

   print: function(text) {
      if (arguments.length > 1) text = Array.prototype.slice.call(arguments).join(' ');

      if (terminal.ready == false) {
         terminal.ready = true;
         terminal.clear();
      }

      //console.log("text: [", text, "]");

      // reaction on "(print)" - show canvas
      if (text=="> ") {
         terminal.ready = true;
         hideTerminal();
      }

      // let's process OL's prompt:
      terminal.set_prompt('> ');
      terminal.position(1);
      while (text.indexOf("> ") == 0)
         text = text.substring(2);
      terminal.resume();

      if (text == "'delivered") // just filter the output log
        return;
      terminal.echo(text);

      // well, we got greeting. let's import (lib opengl)
      if (text == "type ',help' to help, ',quit' to end session.")
         terminal.exec("(import (lib opengl))");
   },
   printErr: function(text) {
      console.log("error: ", text);
      terminal.error(text);

      showTerminal();
   },
   canvas: (function() {
      var canvas = document.getElementById('canvas');

      // please, add to glutCreateWindow() 'preserveDrawingBuffer: true' attribute!
      // it should looks like
      // function _glutCreateWindow(name){var contextAttributes={antialias:(GLUT.initDisplayMode&128)!=0,depth:(GLUT.initDisplayMode&16)!=0,stencil:(GLUT.initDisplayMode&32)!=0,alpha:(GLUT.initDisplayMode&8)!=0,preserveDrawingBuffer:true}

      // As a default initial behavior, pop up an alert when webgl context is lost. To make your
      // application robust, you may want to override this behavior before shipping!
      // See http://www.khronos.org/registry/webgl/specs/latest/1.0/#5.15.2
      canvas.addEventListener("webglcontextlost", function(e) { alert('WebGL context lost. You will need to reload the page.'); e.preventDefault(); }, false);

      // and resize to terminal sizes
      $("#canvas").css({
         'height': $("#terminal").outerHeight(),
         'width':  $("#terminal").outerWidth()
      });
      showTerminal(); // а надо?
      return canvas;
   })(),

   setStatus: function(text) {
      console.log("status: ", text);
   },

   totalDependencies: 0,
   noExitRuntime: 0,

   onAbort: function(text) {
      console.log("abort: ", text);
   },

   monitorRunDependencies: function(left) {
      console.log("monitorRunDependencies: ", left);
      // this.totalDependencies = Math.max(this.totalDependencies, left);
      // Module.setStatus(left ? 'Preparing... (' + (this.totalDependencies-left) + '/' + this.totalDependencies + ')' : 'All downloads complete.');
   }
};
Module.setStatus('Downloading...');
window.onerror = function(event) {
   // TODO: do not warn on ok events like simulating an infinite loop or exitStatus
   Module.setStatus('onerror: Exception thrown, see JavaScript console', event);
   //spinnerElement.style.display = 'none';
   Module.setStatus = function(text) {
      if (text) Module.printErr('[post-exception status] ' + text);
   };
};

// FILE SYSTEM
var Libraries = [
      { path: "/otus", name: "ffi.scm",    file: "https://rawgit.com/yuriy-chumak/ol/master/libraries/otus/ffi.scm" },
//      { path: "/otus", name: "ffi.scm",    file: "lib/ffi.scm" },
      { path: "/lib",  name: "opengl.scm", file: "lib/opengl.scm" },

      { path: "/EGL",       name: "version-1-1.scm", file: "https://rawgit.com/yuriy-chumak/ol/master/libraries/EGL/version-1-1.scm" },
      { path: "/OpenGL/ES", name: "version-2-0.scm", file: "https://rawgit.com/yuriy-chumak/ol/master/libraries/OpenGL/ES/version-2-0.scm" },
//    { path: "/OpenGL/ES", name: "version-2-0.scm", file: "lib/version-2-0.scm" },

//    { path: "/", name: "init.lisp", file: "init.lisp" },
      { path: "/", name: "repl", file: "https://rawgit.com/yuriy-chumak/ol/master/repl" }
   ];
var Downloaded = 0;

Libraries.forEach( function(item) {
   $.ajax({
      url: item.file,
      type: 'GET',
      beforeSend: function (xhr) {
         xhr.overrideMimeType("text/plain; charset=x-user-defined");
         console.log("let's download ", item.file);
      },
      error: function(a, b, c) {
         console.log(a);
         console.log(b);
         console.log(c);
      },
      success: function( data ) {
         console.log("ok: ", item.name)
         item.data = data;

         if (++Downloaded == Libraries.length) {
            // load olvm
            var script = document.createElement('script');
            script.src = "olvm.js";
         
            script.addEventListener('load', function(me) {
               terminal.echo("Loading...")
            }, false);
            script.addEventListener('error', function(event) {
               terminal.echo("Can't find olvm. Build it first and try again.")
            }, false);
         
            document.body.appendChild(script);
         }
      }
   });
});
