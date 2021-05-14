void keyReleased() {
  switch(key) {
  case 'o':
    open_file();
    break;
  case 's':
    save_file();
    break;
  case 'l':
    threshold_mode++;
    threshold_mode%=6;
    redraw();
  case 'r':
    reverse=!reverse;
    redraw();
    break;
  case 'h':
    help=!help;
    break;
  }
}