// Adapted from https://github.com/jigish/dotfiles/blob/master/slate.js

// To read more: https://github.com/jigish/slate/wiki/JavaScript-Configs

// Configs
S.cfga({
  "defaultToCurrentScreen" : true,
  "secondsBetweenRepeat" : 0.1,
  "checkDefaultsOnLoad" : true,
  "focusCheckWidthMax" : 3000,
  "orderScreensLeftToRight" : true
});

// This output is from Slate's "Current Window Info" screen
/**
----------------- Screens -----------------
Left To Right ID: 1
  OS X ID: 0
  Resolution: 2560x1440
Left To Right ID: 0
  OS X ID: 1
  Resolution: 1440x900

**/


// Monitors
var cinemaDisplay = "1";
var laptopDisplay = "0";

// Operations
var lapChat = S.op("corner", {
  "screen" : laptopDisplay,
  "direction" : "top-left",
  "width" : "screenSizeX/9",
  "height" : "screenSizeY"
});

var lapMain = lapChat.dup({ "direction" : "top-right", "width" : "8*screenSizeX/9" });

var cinemaDisplayFull = S.op("move", {
  "screen" : cinemaDisplay,
  "x" : "screenOriginX",
  "y" : "screenOriginY",
  "width" : "screenSizeX",
  "height" : "screenSizeY"
});


var cinemaDisplayLeft = cinemaDisplayFull.dup({ "width" : "screenSizeX/3" });
var cinemaDisplayMid = cinemaDisplayLeft.dup({ "x" : "screenOriginX+screenSizeX/3" });
var cinemaDisplayRight = cinemaDisplayLeft.dup({ "x" : "screenOriginX+(screenSizeX*2/3)" });
var cinemaDisplayLeftTop = cinemaDisplayLeft.dup({ "height" : "screenSizeY/2" });
var cinemaDisplayLeftBot = cinemaDisplayLeftTop.dup({ "y" : "screenOriginY+screenSizeY/2" });
var cinemaDisplayMidTop = cinemaDisplayMid.dup({ "height" : "screenSizeY/2" });
var cinemaDisplayMidBot = cinemaDisplayMidTop.dup({ "y" : "screenOriginY+screenSizeY/2" });
var cinemaDisplayRightTop = cinemaDisplayRight.dup({ "height" : "screenSizeY/2" });
var cinemaDisplayRightBot = cinemaDisplayRightTop.dup({ "y" : "screenOriginY+screenSizeY/2" });

// common layout hashes
var lapMainHash = {
  "operations" : [lapMain],
  "ignore-fail" : true,
  "repeat" : true
};
var adiumHash = {
  "operations" : [lapChat, lapMain],
  "ignore-fail" : true,
  "title-order" : ["Contacts"],
  "repeat-last" : true
};
var mvimHash = {
  "operations" : [cinemaDisplayLeft],
  "repeat" : true
};
var iTermHash = {
  "operations" : [cinemaDisplayFull, cinemaDisplayRightBot, cinemaDisplayMidTop, cinemaDisplayMidBot],
  "sort-title" : true,
  "repeat" : true
};
var genBrowserHash = function(regex) {
  return {
    "operations" : [function(windowObject) {
      var title = windowObject.title();
      if (title !== undefined && title.match(regex)) {
        windowObject.doOperation(cinemaDisplayMidTop);
      } else {
        windowObject.doOperation(lapMain);
      }
    }],
    "ignore-fail" : true,
    "repeat" : true
  };
}

// 2 monitor layout
var twoMonitorLayout = S.lay("threeMonitor", {
  "Adium" : {
    "operations" : [lapChat ],
    "ignore-fail" : true,
    "title-order" : ["Contacts"],
    "repeat-last" : true
  },
  "MacVim" : mvimHash,
  "iTerm" : iTermHash,
  "Google Chrome" : genBrowserHash(/^Developer\sTools\s-\s.+$/),
  "Firefox" : genBrowserHash(/^Firebug\s-\s.+$/),
  "Safari" : lapMainHash,
  "Unibox" : lapMainHash,
  "Spotify" : {
    "operations" : [cinemaDisplayRightTop],
    "repeat" : true
  },
  "TextEdit" : {
    "operations" : [cinemaDisplayRightBot],
    "repeat" : true
  }
});

// 1 monitor layout
var oneMonitorLayout = S.lay("oneMonitor", {
  "Adium" : adiumHash,
  "MacVim" : lapMainHash,
  "iTerm" : lapMainHash,
  "Google Chrome" : lapMainHash,
  "Xcode" : lapMainHash,
  "Flex Builder" : lapMainHash,
  "GitX" : lapMainHash,
  "Ooyala Player Debug Console" : lapMainHash,
  "Firefox" : lapMainHash,
  "Safari" : lapMainHash,
  "Eclipse" : lapMainHash,
  "Spotify" : lapMainHash
});


// Defaults
S.def(2, twoMonitorLayout);
S.def(1, oneMonitorLayout);

// Layout Operations
var twoMonitor = S.op("layout", { "name" : twoMonitorLayout });
var oneMonitor = S.op("layout", { "name" : oneMonitorLayout });
var universalLayout = function() {
  // Should probably make sure the resolutions match but w/e
  S.log("SCREEN COUNT: "+S.screenCount());
  if (S.screenCount() === 3) {
    threeMonitor.run();
  } else if (S.screenCount() === 2) {
    twoMonitor.run();
  } else if (S.screenCount() === 1) {
    oneMonitor.run();
  }
};

// Batch bind everything. Less typing.
S.bnda({
  // Layout Bindings
  "padEnter:ctrl" : universalLayout,
  "space:ctrl" : universalLayout,

  // Basic Location Bindings
  "pad0:ctrl" : lapChat,
  "[:ctrl" : lapChat,
  "pad.:ctrl" : lapMain,
  "]:fn" : lapMain,
  "pad1:alt" : cinemaDisplayLeftBot,
  "pad2:alt" : cinemaDisplayMidBot,
  "pad3:alt" : cinemaDisplayRightBot,
  "pad4:alt" : cinemaDisplayLeftTop,
  "pad5:alt" : cinemaDisplayMidTop,
  "pad6:alt" : cinemaDisplayRightTop,
  "pad7:alt" : cinemaDisplayLeft,
  "pad8:alt" : cinemaDisplayMid,
  "pad9:alt" : cinemaDisplayRight,
  "pad=:alt" : cinemaDisplayFull,

  // Resize Bindings
  // NOTE: some of these may *not* work if you have not removed the expose/spaces/mission control bindings
  "right:ctrl" : S.op("resize", { "width" : "+10%", "height" : "+0" }),
  "left:ctrl" : S.op("resize", { "width" : "-10%", "height" : "+0" }),
  "up:ctrl" : S.op("resize", { "width" : "+0", "height" : "-10%" }),
  "down:ctrl" : S.op("resize", { "width" : "+0", "height" : "+10%" }),
  "right:alt" : S.op("resize", { "width" : "-10%", "height" : "+0", "anchor" : "bottom-right" }),
  "left:alt" : S.op("resize", { "width" : "+10%", "height" : "+0", "anchor" : "bottom-right" }),
  "up:alt" : S.op("resize", { "width" : "+0", "height" : "+10%", "anchor" : "bottom-right" }),
  "down:alt" : S.op("resize", { "width" : "+0", "height" : "-10%", "anchor" : "bottom-right" }),

  // Push Bindings
  // NOTE: some of these may *not* work if you have not removed the expose/spaces/mission control bindings
  "right:ctrl;shift" : S.op("push", { "direction" : "right", "style" : "bar-resize:screenSizeX/2" }),
  "left:ctrl;shift" : S.op("push", { "direction" : "left", "style" : "bar-resize:screenSizeX/2" }),
  "up:ctrl;shift" : S.op("push", { "direction" : "up", "style" : "bar-resize:screenSizeY/2" }),
  "down:ctrl;shift" : S.op("push", { "direction" : "down", "style" : "bar-resize:screenSizeY/2" }),

  // Nudge Bindings
  // NOTE: some of these may *not* work if you have not removed the expose/spaces/mission control bindings
  "right:ctrl;alt" : S.op("nudge", { "x" : "+10%", "y" : "+0" }),
  "left:ctrl;alt" : S.op("nudge", { "x" : "-10%", "y" : "+0" }),
  "up:ctrl;alt" : S.op("nudge", { "x" : "+0", "y" : "-10%" }),
  "down:ctrl;alt" : S.op("nudge", { "x" : "+0", "y" : "+10%" }),

  // Throw Bindings
  // NOTE: some of these may *not* work if you have not removed the expose/spaces/mission control bindings
  "right:ctrl;alt;cmd" : S.op("throw", { "screen" : "right", "width" : "screenSizeX", "height" : "screenSizeY" }),
  "left:ctrl;alt;cmd" : S.op("throw", { "screen" : "left", "width" : "screenSizeX", "height" : "screenSizeY" }),
  "up:ctrl;alt;cmd" : S.op("throw", { "screen" : "up", "width" : "screenSizeX", "height" : "screenSizeY" }),
  "down:ctrl;alt;cmd" : S.op("throw", { "screen" : "down", "width" : "screenSizeX", "height" : "screenSizeY" }),

    // Window Hints
  "esc:cmd" : S.op("hint"),

  // Switch currently doesn't work well so I'm commenting it out until I fix it.
  //"tab:cmd" : S.op("switch"),

  // Grid
  "esc:ctrl" : S.op("grid")
});

// Test Cases
S.src(".slate.test", true);
S.src(".slate.test.js", true);

// Log that we're done configuring
S.log("[SLATE] -------------- Finished Loading Config --------------");
