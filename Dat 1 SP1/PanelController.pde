public class PanelController{ //The panelcontroller class is made to be able to make a lot of different panels with buttons. I only use this once, for one panel, so at the moment, its really only made to show that.
  
  float panelButtonX;
  float panelButtonY; 
  float panelButtonW;
  float panelButtonH;
  boolean buttonOn;
  boolean buttonDrawn;
  
  PanelController(boolean buttonOn){
    this.buttonOn = buttonOn;
  
  
  }

  //This function draws the panel with a boolean that asks if the panel should be shown, and which with the panelNr
  void drawPanel(boolean showPanel, int panelNr){
    
    if(showPanel == true) {
      switch(panelNr){
      case 0:
        fill(255,0,200);
        rect(width/2, height/2, 1920/4, 1080/4);
        fill(0);
        textSize(16);
        text("You can type these commands:", 260, 160);
        text("'strike' to deal 20 damage ", 260, 180);
        text("'kick' for 10 damage ", 260, 200);
        text("'heal' for 10 health ", 260, 220);
      default:
        fill(0,0,0,0);
        rect(width/2, height/2, 1920/2, 1080/2);
        break;
      }
    }else{
      fill(0,0,0,0);
      rect(width/2, height/2, 1920/2, 1080/2);
    }
  }
  
  //This function draws the button
  void drawButton(boolean buttonDrawn, float panelButtonX, float panelButtonY, float panelButtonW, float panelButtonH, color c, String text){
    rectMode(CORNER);
    this.buttonDrawn = buttonDrawn;
    this.panelButtonX = panelButtonX;
    this.panelButtonY = panelButtonY;
    this.panelButtonW = panelButtonW;
    this.panelButtonH = panelButtonH;
    fill(c);
    rect(panelButtonX, panelButtonY, panelButtonW, panelButtonH);
    fill(255);
    rectMode(CENTER);
    text(text, panelButtonX+10, panelButtonY+32);
  }

//This function checks if the user is hovering over the button, and then runs the drawPanel function on click.
public void mouseOverCheck(int mX, int mY) {
  if(buttonDrawn == true) {
    if(mX > panelButtonX && mX < panelButtonX + panelButtonW && mY > panelButtonY && mY < panelButtonY + panelButtonH && mousePressed){
          buttonOn = true;
          drawPanel(buttonOn, 0);
      }else {
        buttonOn = false;
        drawPanel(buttonOn, 0);
      }
    }
}






}
