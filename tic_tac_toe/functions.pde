void createBoard() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      board[i][j] = new Field(new PVector(i*size, j*size));
    }
  }
}

void grid() {
  push();
  int x = width / 3;
  int y = (height - offset) / 3 ;
  strokeWeight(4);
  line(x, 0, x, height - offset);
  line(x * 2, 0, x * 2, height - offset);
  line(0, y, width, y);
  line(0, y * 2, width, y*2);
  pop();
}

void showBoard() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      board[i][j].show();
    }
  }
}
void showScore() {
  push();
  String winner = checkWinner();
  textSize(64);
  textAlign(CENTER);
  switch(winner) {
  case "tie":
    fill(127);
    text("TIE", width/2, 680);
    break;
  case "X":
    fill(255, 0, 0);
    text("CPU WON!!!", width/2, 680);
    break;
  case "O":
    fill(0, 193, 0);
    text("YOU WON!!!", width/2, 680);
    break;
  }
  textSize(32);
  fill(0);
  text(scores[2], width/6, 790);
  text(scores[1], width/6 + size, 790);
  text(scores[0], width/6+ 2 * size, 790);

  fill(0, 193, 0);//
  text("WIN", width/6, 750);

  fill(127);
  text("TIE", width/6 + size, 750);

  fill(255, 0, 0);
  text("LOSE", width/6 + 2 * size, 750);

  pop();
}

void addScore(String w) {
  switch(w) {
  case "X":
    scores[0]++;
    break;
  case "tie":
    scores[1]++;
    break;
  case "O":
    scores[2]++;
    break;
  }
}


int strToScore(String s) {
  int result = 0;
  switch(s) {
  case "X": 
    result = 10; 
    break;
  case "O": 
    result = -10; 
    break;
  }
  return result;
}

void putRandom() {
  int x = int(random(3));
  int y = int(random(3));  
  board[x][y].setType(ai);
}
void aiMove() {
  int bestScore = MIN_INT;
  int best_i = 0;
  int best_j = 0;

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j].getType() == "") {
        board[i][j].setType(ai);
        int score = minimax(board, 0, false, MIN_INT, MAX_INT);//minimax(board, 0, false);
        board[i][j].setType("");
        if (score > bestScore) {
          bestScore = score;
          best_i = i;
          best_j = j;
        }
      }
    }
  }
  board[best_i][best_j].setType(ai);
}

int minimax(Field[][] board, int depth, boolean isMaximizingPlayer, int alpha, int beta) {
  String result = checkWinner();
  if (result != "") {
    return strToScore(result) - depth;
  }
  if (isMaximizingPlayer) {
    int bestVal = MIN_INT;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {  
        if (board[i][j].getType() == "") {
          board[i][j].setType(ai);
          int value = minimax(board, depth+1, false, alpha, beta);
          board[i][j].setType("");
          bestVal = max(bestVal, value);
          alpha = max(alpha, bestVal);
          if (beta <= alpha) break;
        }
      }
    }
    return bestVal;
  } else {
    int bestVal = MAX_INT;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].getType() == "") {
          board[i][j].setType(human);
          int value = minimax(board, depth+1, true, alpha, beta);
          board[i][j].setType("");
          bestVal = min(bestVal, value);
          alpha = min(alpha, bestVal);
          if (beta <= alpha) break;
        }
      }
    }
    return bestVal;
  }
}

String checkWinner() {

  for (int i = 0; i < 3; i++) {
    if (board[i][0].getType() == board[i][1].getType() && board[i][1].getType() == board[i][2].getType() && board[i][0].getType() != "") {
      return board[i][0].getType();
    }
  }

  for (int i = 0; i < 3; i++) {
    if (board[0][i].getType() == board[1][i].getType() && board[1][i].getType() == board[2][i].getType() && board[0][i].getType() != "") {
      return board[0][i].getType();
    }
  }

  if ((board[0][0].getType() == board[1][1].getType() && board[1][1].getType() == board[2][2].getType()||
    board[0][2].getType() == board[1][1].getType() && board[1][1].getType() == board[2][0].getType())&& board[1][1].getType() != "") {
    return board[1][1].getType();
  }

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j].getType() == "") {
        return "";
      }
    }
  }
  return "tie";
}

void printBoard() {
  println("****************");
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j].getType() == "") {
        print("-");
      } else {
        print(board[i][j].getType());
      }
    }
    println();
  }
}

void resetGame() {
  isEnd = false;
  ai_start = !ai_start;
  sound_played = false;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      board[i][j].setType("");
    }
  }
  if (ai_start) 
    putRandom();
}

void endGame() {
  isEnd = true;
  String winner = checkWinner();
  addScore(winner);
  switch(winner) {
  case "X":
    currSound = lose_sound;
    break;
  case "O":
    currSound = win_sound;
    break;
  case "tie":
    currSound = tie_sound;
    break;
  }
  if (!win_sound.isPlaying() && sound_played == false) {
    currSound.play();
    return;
  }
  sound_played = true;
}
