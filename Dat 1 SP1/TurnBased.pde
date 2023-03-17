String buttonText = "END TURN";
String onScreenText = "";
char input;
String output = "";
float btnX = 450;
float btnY = 350;
float btnW = 120;
float btnH = 60;
int begin;
int duration = 60;
int time = 60;


status gameStatus = status.PLAYER; //Reference to the enum status made in the tab STATE.java.

//Reference to the different classes:
Enemy enemy1;
Player player;
PanelController panelController;


void setup() {
  size(1920/2, 1080/2);
  frameRate(30);
  begin = millis();
  rectMode(CENTER);
  
  //Instantiates objects created from the classes references earlier. Enemy1 is an instance of the class Enemy, and player is an instance of the class Player.
  enemy1 = new Enemy(300, 10, true, 5, color(255,0,0), width-width/4, height/3-50);
  player = new Player(300, 15, true, 5, color(0, 255, 0), width/4, height-height/6-50);
  panelController = new PanelController(false); //Instantiates the panelcontroller.
  
  gameStatus = status.PLAYER; //Starts the gameloop at the players turn:
}

void draw() {
  //Starts the gameloop at the players turn:
  
  drawBackground(); //Calls the function drawBackground, that draws all the visual assets, except for the player and the enemy.
  panelController.drawButton(true, 100, 200, 100, 50, color(255,0,100), "Moves"); //Calls a function that draws the "moves" button, that also shows the panel.
  
  drawButton(); //Calls the function that draws the end turn button.
  
  drawUI(); //Draws every UI element, such as, the HP meters and the textfield.
  
  enemy1.Spawn(); //Calls the function that draws the enemy.
  player.Spawn(); //Calls the function that draws the player.
  gameLoop(); //Calls the function that keeps an eye on the gameloop, and runs it. 
  panelController.mouseOverCheck(mouseX, mouseY); //Calls the function that checks if the mouse is hovering over the "moves" button.
}

//Checks for player input via the keyboard.
void keyReleased() {
  
 
  if(gameStatus == status.PLAYER && player.attackPoints >= 1) { //If the player has more characters to use, meaning it has more attackpoints than 0, they can input.
    switch(key){
      case BACKSPACE: //I made a workaround for backspace, since processing takes backspace's ASCII input. This would result in the output string being filled with an unknown character. To fix this, i just remove the character, as it gets placed in the string. 
          if(output.length() > 0) {
            player.attackPoints +=1;
            output = output.substring(0, output.length()-1);
      break;
      }
      case 49: //this is spacebar:
        if(output.length() > 0){
            output = output + "";
            player.attackPoints -=1;
      break;
      }
      default://if any other key is pressed other than the defined cases.
        if(output.length() >= 0) {
          player.attackPoints -=1;
          output = output + key;
      break;
      }
  }
  
//Checks if the player has typed anything that the game recognizes as a command.
  switch(output) {
    case "heal":
      if(player.playerHP < 300) {
          player.heal(10); //Calls function that heals the player, the function runs inside the player class.
          output = output.substring(0, output.length()-output.length()); //This is string manipulation, that removes the length of the output from its own length. Basically resetting the textfield.
          onScreenText = "Player heals for 10 hp";
      }else {
          onScreenText = "Player is at max health!";
      }
    break;
    case "kick":
      enemy1.takeDamage(10); //function that deals damage to the enemy, this function runs inside the enemy class.
      output = output.substring(0, output.length()-output.length());
      onScreenText = "Player kicks for 10 damage!";
    break;
    case "strike":
      enemy1.takeDamage(20);
      output = output.substring(0, output.length()-output.length());
      onScreenText = "Player strikes for 20 damage!";
    break;
  }
  
  }else {
    
    //This is a backup check, so that the player can't go out of the strings' bounds
    if(gameStatus == status.PLAYER && player.attackPoints == 0) {
      switch(key){
        default:
          output = output.substring(0, output.length()-1);
          player.attackPoints +=1;
        break;
      }
    }
  } 
}

//The function that draws all the background assets. 
void drawBackground() {
  //Variables to control the position of the battleplatforms
  int enemyPlatX = width-width/4;
  int enemyPlatY = height/3;
  int playerPlatX = width/4;
  int playerPlatY = height-height/6;
  
  background(0, 0, 0);
  fill(255);
  
  //Battleplatforms
  ellipse(enemyPlatX, enemyPlatY, 300, 40);
  ellipse(playerPlatX, playerPlatY, 300, 40);
  rectMode(CENTER);
  
  //textField
  fill(200);
  rect(playerPlatX+450, playerPlatY, 500,60);
  
  
}

//The function that draws the "END TURN" button.
void drawButton() {
  
  rectMode(CORNER);
  fill(#FCFC03);
  rect(btnX,btnY,btnW,btnH);
  fill(0);
  textSize(16);
  text(buttonText, btnX+15, btnY+35);
  }


//This is the gameLoop function that controls what happens in the game, and when.
void gameLoop() {
  
  if(player.playerHP <= 0) {
      gameStatus = status.LOSE;
  }
  
  if(enemy1.enemyHP <= 0) {
      gameStatus = status.WIN;
  }
  
  
  //this is a state machine, that checks if its the players turn, the enemies turn, if the player has won or lost.
  switch(gameStatus){
    case PLAYER:
      buttonText = "END TURN";
      //turn timeR:  
      if(time > 0){
        time = duration - (millis() - begin)/1000; //Starts the countdown timer for the player.
      }else if(time <= 0) {
        gameStatus = status.ENEMY;
      }
    break;
    case ENEMY:
      buttonText = "ENEMY TURN"; //During the enemy turn, i create a pseudo AI, which taktes a random number, and does the command that corresponds to that number.
      int action = (int)random(0,3);      
      if(action == 0) {
        onScreenText = "The enemy cube strikes for 20 damage!";
        player.takeDamage(20);
        player.attackPoints = 15;
        gameStatus = status.PLAYER;
      
      } else if (action == 1) {
          onScreenText = "The enemy cube kicks for 10 damage!";
          player.takeDamage(10);
          player.attackPoints = 15;
          gameStatus = status.PLAYER;
          
      } else if (action == 2 && enemy1.enemyHP < 300) { //Only if the enemy has taken damage, can it heal.
          onScreenText = "The enemy cube heals itself for 10 HP!";
          enemy1.heal(10);
          player.attackPoints = 15;
          gameStatus = status.PLAYER;
      }
      begin = millis(); //Resets the countdown timer.
      time = duration - (millis() - begin)/1000;
    break;
    case WIN:
      fill(0,255,0);
      rect(0, 0,  width*2, height*2);
      fill(255);
      text("YOU WIN!", width/2, height/2);
      enemy1.isAlive = false;
    break;
    case LOSE:
      fill(255,0,0);
      rect(0, 0,  width*2, height*2);
      fill(255);
      text("YOU LOSE!", width/2, height/2);
      player.isAlive = false;
    break;
  }
}

void drawUI(){
  int textX = 460; //X position of the textfield for userinput.
  int textY = 460; //Y position of the textfield for userinput.
  //AttackPointsCounter
  textSize(30);
  fill(255);
  text(player.attackPoints, textX*1.28, textY/1.2);
  text(time, width-60, 60);
  
  fill(255,0,0);
  rectMode(CORNER);
  
  //HP METERS
  fill(255);
  text(enemy1.enemyHP, width/8, height/7);
  fill(255,0,0);
  rect(width/8, height/7, enemy1.enemyHP, 20);
  fill(255);
  text(player.playerHP, (width-width/3)+player.playerHP-45, height-height/3);
  fill(0,200,0);
  rect(width-width/3, height-height/3, player.playerHP, 20);
  rectMode(CENTER);
  
  //text on screen:
  fill(255);
  text(onScreenText, width/2-200, height/2);
  
  //input text
  textSize(30); //Change the text size of the textfield where the user inputs.
  fill(0);
  text(output, textX, textY);
  
}


//Function that checks if the  mouse is released. This is used for the end turn button.
void mouseReleased() {
  if(mouseX > btnX && mouseX < btnX + btnW && mouseY > btnY && mouseY < btnY + btnH){
        buttonText = "ENEMY TURN";
        output = output.substring(0, output.length()-output.length());
        gameStatus = status.ENEMY;
  }  
}
