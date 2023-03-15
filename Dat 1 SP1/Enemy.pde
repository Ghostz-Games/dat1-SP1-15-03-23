class Enemy {

int enemyHP;
int attackPoints;
boolean isAlive;
float speed;
color c;
int x;
int y;

//Constructs the enemy with an amount of HP, Attackpoints, if its alive or not, how fast it is (not used yet), its color, and its position.
Enemy(int enemyHP_, int attackPoints_, boolean isAlive_, float speed_, color c_, int x_, int y_) {

  enemyHP = enemyHP_;
  attackPoints = attackPoints_;
  isAlive = isAlive_;
  speed = speed_;
  c = c_;
  x = x_;
  y = y_;
  
}

//Draws the enemy
void Spawn() {
  fill(c);
  rect(x, y, 100,100);
  

}

//Enemy takes damage
float takeDamage(float damage) {
  enemyHP -= damage;
  spawnParticles(damage);
  return enemyHP;
}

//heals the enemy
float heal(float healing) {
  enemyHP += healing;
  spawnCircle(healing);
  return enemyHP;
}

//This is my particle spawner, which spawns particles as the enemy takes damage. 
void spawnParticles(float amount){
  int randomSize = (int)random(10,40); 
  for(int i = 0; i<=amount; i++){
     fill(c, 100);
     int randomOffsetY = (int)random(-100,100);
     int randomOffsetX = (int)random(-100,100);
     rect(x+randomOffsetY, y+randomOffsetX, randomSize, randomSize);
     
   }
   
}

//This is a circle effect spawner, which spawns a few circles, corresponding to the amount the enemy heals.
void spawnCircle(float heal){
  color col = color(#FAFF03);
  for(int i = 0; i<=heal; i++){
  fill(col, 255-(10*i));
  ellipse(x,y,100-(10*i),100-(10*i));
  }
  
}












}
