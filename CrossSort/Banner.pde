
PGraphics generateBanner() {

  PGraphics graphics = createGraphics(width, height);

  int margin_top = 50;
  int margin_bottom = 50;
  int margin_left = 50;
  int margin_right = 50;
  float line_spacing = 1.0;
  int text_size = 12;
  int indent = 0;

  PFont mono = createFont("Andale Mono.ttf", text_size);

  String[] bannerText = {
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
    "Please see README.md for an explanation of what's going on here.",
    "",
    "CREDITS:",
    "  By Phillip David Stearns 2021 for GlitchTextiles GlitchTools", 
    "  Hat tip to Kim Asendorf's ASDFSort",
    "  GUI created with ControlP5 by Andreas Schlegel"
  };

  int x = 0, y = 0;

  graphics.noSmooth();
  graphics.beginDraw();
  graphics.noStroke();
  graphics.fill(0, 50);
  graphics.rect(margin_left/2, margin_top/2, 550, 260);
  graphics.textSize(text_size);
  graphics.textFont(mono);
  graphics.fill(255);
  for (int i = 0; i < bannerText.length; ++i) {
    if (i == 0) {
      x = indent + margin_left;
    } else {
      x = margin_left;
    }
    y = margin_top + int(text_size*line_spacing*i);
    graphics.text(bannerText[i], x, y);
  }  
  graphics.endDraw();
  return graphics;
}
