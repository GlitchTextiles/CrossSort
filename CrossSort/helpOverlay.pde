
PGraphics generateHelp() {

  PGraphics overlay = createGraphics(width, height);

  int margin_top = 50;
  int margin_bottom = 50;
  int margin_left = 50;
  int margin_right = 50;
  float line_spacing = 1.0;
  int text_size = 12;
  int indent = 0;

  PFont mono = createFont("Andale Mono.ttf", text_size);

  String[] help = {
    "////////////////////////////////////////////////////////////////////////", 
    "///     //////////////////////////////////      ////////////////////////", 
    "//  ///  ////////////////////////////////  ////  ///////////////////////", 
    "/  //////////////////////////////////////  ////  ///////////////////  //", 
    "/  ////////  /   ////   ////   ////   ////  ////////   ///  /   ///    /", 
    "/  ////////    /  //  /  //  /  //  /  /////  /////  /  //    /  ///  //", 
    "/  ////////  ///////  /  ///  /////  /////////  ///  /  //  ////////  //", 
    "/  ////////  ///////  /  ////  /////  ///  ////  //  /  //  ////////  //", 
    "//  ///  //  ///////  /  //  /  //  /  //  ////  //  /  //  ////////  //", 
    "///     ///  ////////   ////   ////   ////      ////   ///  ////////   /", 
    "////////////////////////////////////////////////////////////////////////", 
    "", 
    "It's souped up pixel sorting, yo!", 
    "Written by Phillip David Stearns 2020", 
    "for GlitchTextiles' GlitchTools project.", 
    "Hat tip to Kim Asendorf's ASDFSort", 
    "", 
    "KeyBindings:", 
    "---------------------------------------------------------", 
    "", 
    "h        toggle this help overlay", 
    "o        open file dialog", 
    "s        save current frame", 
    "l        advance through different threshold logic options", 
    "r        reverse sort order"
  };

  int x = 0, y = 0;

  overlay.noSmooth();
  overlay.beginDraw();
  overlay.noStroke();
  overlay.fill(0, 192);
  overlay.rect(margin_left/2, margin_top/2, 550, 360);
  overlay.textSize(text_size);
  overlay.textFont(mono);
  overlay.fill(255);
  for (int i = 0; i < help.length; ++i) {
    if (i ==   0) {
      x = indent + margin_left;
    } else {
      x = margin_left;
    }
    y = margin_top + int(text_size*line_spacing*i);
    overlay.text(help[i], x, y);
  }  
  overlay.endDraw();
  return overlay;
}
