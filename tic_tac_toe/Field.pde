class Field {
  PVector vec;
  String type;

  Field(PVector vec) {
    this.vec = vec;
    this.type = "";
  }

  void setType(String type) {
    this.type = type;
  }

  String getType() {
    return this.type;
  }

  void show() {
    push();
    int sizeText = int(size*0.75);
    textAlign(CENTER);
    textSize(sizeText);
    if (this.type == "X") {
      fill(#FFA4BC);
    } else {
      fill(#75A4FF);
    }
    text(this.type, vec.x+size/2, vec.y+size/2+sizeText/3);
    pop();
  }
  boolean isMouseOver() {
    if (mouseX > vec.x && mouseX < vec.x + size && 
      mouseY > vec.y && mouseY < vec.y + size) {
      return true;
    }
    return false;
  }
}
