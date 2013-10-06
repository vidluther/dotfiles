// Adapted from https://github.com/jigish/dotfiles/blob/master/slate.js

// Configs
S.cfga({
  "defaultToCurrentScreen" : true,
  "secondsBetweenRepeat" : 0.1,
  "checkDefaultsOnLoad" : true,
  "focusCheckWidthMax" : 3000,
  "orderScreensLeftToRight" : true, 
  "windowHintsShowIcons"  : true, 
  "windowHintsIgnoreHiddenWindows": false, 
  "windowHintsSpread" : true, 
  "windowHintsOrder"  : true, 
  "windowHintsSpreadSearchWidth"  : 50, 
  "windowHintsSpreadPadding"  : 20, 

});

// Monitors
var retina = "0";
var cinema = "1";


var fullCinema = S.op("move", {
  "screen" : cinema,
  "x" : "screenOriginX",
  "y" : "screenOriginY",
  "width" : "screenSizeX",
  "height" : "screenSizeY"
});

var leftCinema = fullCinema.dup({ "width" : "screenSizeX/3" });

var midCinema = leftCinema.dup({ "x" : "screenOriginX+screenSizeX/3" });
var rightCinema = leftCinema.dup({ "x" : "screenOriginX+(screenSizeX*2/3)" });

var lapFull = S.op("move", {
  "screen" : retina,
  "x" : "screenOriginX",
  "y" : "screenOriginY",
  "width" : "screenSizeX",
  "height" : "screenSizeY"
});


/** 
 Commonly used operations.. basically, things that I'll do in many situations
 for various reasons 
**/

var hideSpotify = S.op("hide", { "app" : "Spotify" });
var hideiTunes = S.op("hide", { "app" : "iTunes" });
var showiTerm = S.op("focus", { "app" : "iTerm" });
var hideFinder  = S.op("hide", { "app" : "Finder"}); 

var lapMainHash = {
  "operations" : [lapFull],
  "ignore-fail" : true,
  "repeat" : true
};

var iTermHash = {
  "operations" : [fullCinema],
  "sort-title" : true,
  "repeat" : true
};

var Sublime = {
  "operations" : [fullCinema],
  "ignore-fail": true, 
  "sort-title" : true,
  "repeat" : true
};


/**
 This makes it so that when I have Firebug, or the Developer Tools window open 
 those windows go to the laptop. 

 Sometimes this isn't automatic, so pressing ctrl 1 will force Slate to reload
 **/
var genBrowserHash = function(regex) {
  return {
    "operations" : [function(windowObject) {
      var title = windowObject.title();
      if (title !== undefined && title.match(regex)) {
        windowObject.doOperation(lapFull);
      } else {
        windowObject.doOperation(fullCinema);
      }
    }],
    "ignore-fail" : true,
    "repeat" : true
  };
}

// 2 monitor layout
var twoMonitorLayout = S.lay("twoMonitor", {
   "_before_" : { "operations" : [hideSpotify,hideiTunes,hideFinder] }, // before the layout is activated, hide Spotify
  //"_after_" : {"operations" : showiTerm }, // after the layout is activated, focus iTerm
  "iTerm" : iTermHash,
  "Sublime Text": Sublime,
  "Google Chrome" : genBrowserHash(/^Developer\sTools\s-\s.+$/),
  "Firefox" : genBrowserHash(/^Firebug\s-\s.+$/),
  "Safari"  : { "operations" : [fullCinema]}, 
  "RTM": lapMainHash
});

// 1 monitor layout
var oneMonitorLayout = S.lay("oneMonitor", {
   "_before_" : { "operations" : [hideSpotify,hideiTunes,hideFinder] },
  "iTerm" : lapMainHash,
  "Google Chrome" : lapMainHash,
  "Firefox" : lapMainHash,
  "Safari" : lapMainHash,
  "iTunes" : lapMainHash,
  "Sublime Text": lapMainHash,
  "RTM": lapMainHash
});


// Defaults
S.def(2, twoMonitorLayout);
S.def(1, oneMonitorLayout);

// Layout Operations
var twoMonitor = S.op("layout", { "name" : twoMonitorLayout });
var oneMonitor = S.op("layout", { "name" : oneMonitorLayout });



// Window pushing.. 

var pushRight =  S.op("push", { "direction" : "right", "style" : "bar-resize:screenSizeX/2" }); 
var pushLeft = S.op("push", { "direction" : "left", "style" : "bar-resize:screenSizeX/2" }); 
var topHalf = S.op("push", { "direction" : "up", "style" : "bar-resize:screenSizeY/2" }); 
var bottomHalf = S.op("push", { "direction" : "down", "style" : "bar-resize:screenSizeY/2" }); 



// Batch bind everything. Less typing.
S.bnda({
  
  
  "1:alt" : oneMonitor,
  "2:alt" : twoMonitor, 
  // Basic Location Bindings
  // Send whatever app window I'm focused on to the laptop and maximize
  "[:ctrl" : lapFull,
  // Move from the laptop to the Cinema
  "]:ctrl" : fullCinema,


  // Push Bindings
  "right:ctrl;shift" : pushRight,
  "left:ctrl;shift" : pushLeft, 
  "up:ctrl;shift" : topHalf, 
  "down:ctrl;shift" : bottomHalf, 

  // Nudge Bindings
  // NOTE: some of these may *not* work if you have not removed the expose/spaces/mission control bindings
  "right:ctrl;alt" : S.op("nudge", { "x" : "+10%", "y" : "+0" }),
  "left:ctrl;alt" : S.op("nudge", { "x" : "-10%", "y" : "+0" }),
  "up:ctrl;alt" : S.op("nudge", { "x" : "+0", "y" : "-10%" }),
  "down:ctrl;alt" : S.op("nudge", { "x" : "+0", "y" : "+10%" }),
  
  
  // Window Hints
  "e:cmd" : S.op("hint"),
  "i:ctrl"  : showiTerm, 

// Just hit ctrl + 1 to relaunch slate (in case changes had been made)
  "1:ctrl" : S.op("relaunch"),
 
});



// Log that we're done configuring
S.log("[SLATE] -------------- Finished Loading Config --------------");