import processing.sound.*;

Field[][] board = new Field[3][3];
String ai = "X";
String human = "O";
boolean ai_start = false;
int size;
int offset = 200;
int[] scores = new int[3];//X,tie,O
boolean isEnd = false;
boolean sound_played = false;
SoundFile human_sound;
SoundFile win_sound;
SoundFile tie_sound;
SoundFile lose_sound;
SoundFile currSound;

void setup() {
  size(600, 800);
  human_sound = new SoundFile(this, "click.mp3"); 
  win_sound = new SoundFile(this, "win.mp3");
  tie_sound = new SoundFile(this, "tie.mp3");
  lose_sound = new SoundFile(this, "lose.mp3");
  size = width / 3;
  createBoard();
}

void draw() {
  background(#F6F5F4);
  grid();
  showBoard();
  showScore();
}
void mouseClicked() {
  if (isEnd) {
    resetGame();
  } else {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isMouseOver() && board[i][j].getType() == "") {
          board[i][j].setType(human);
          human_sound.play();
          if (checkWinner() != "") { 
            endGame();
            return;
          } 
          aiMove();
          if (checkWinner() != "") { 
            endGame();
          } 
          return;
        }
      }
    }
  }
}

void keyPressed() {
  if (key == 'r') {
    resetGame();
  }
}
