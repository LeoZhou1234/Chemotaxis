import java.util.ArrayList;

int MAX_OBJECTS = 10;
int CANVAS_X = 300;
int CANVAS_Y = 300;

public Food findNearestFood(ArrayList<Food> foodArr, float x, float y) {
  float minDist = 1e9;
  Food nearestFood = foodArr.get(0);
  for (int i = 0; i < foodArr.size(); i++) {
    Food currFood = foodArr.get(i);
    float currDist = dist(currFood.x, currFood.y, x, y);
    if (currDist < minDist) {
      minDist = currDist;
      nearestFood = currFood;
    }
  }
  return nearestFood;
}

class Food {
  float x, y;
  
  public Food(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public void show() {
    fill(190, 30, 30);
    ellipse(x, y, 5, 5);
  }
}

class Walker {
  float x, y; 
  int size, col;
  
  public Walker() {
    x = (float)(Math.random()*301);
    y = (float)(Math.random()*301);
    size = 5;
    col = color((int)(Math.random()*155)+100, (int)(Math.random()*155)+100, (int)(Math.random()*155)+100);
  }
  
  private void checkBoundaries() {
    if (x > CANVAS_X) x--;
    if (x < 0) x++;
    if (y > CANVAS_Y) y--;
    if (y < 0) y++;
  }
  
  public void biasedWalk(float goalX, float goalY) {
    double prob = Math.random();
    float dist = max(10.0/(size + 5), 0.5);
    if (prob < 0.2) {
      x -= (x < goalX ? dist : -dist);
    } else if (prob >= 0.6) {
      x += (x < goalX ? dist : -dist);;
    }
    prob = Math.random();
    if (prob < 0.2) {
      y -= (y < goalY ? dist : -dist);
    } else if (prob >= 0.6) {
      y += (y < goalY ? dist : -dist);
    }
    checkBoundaries();
  }
  
  public void randomWalk() {
    x += (int)(Math.random()*3) - 1;
    y += (int)(Math.random()*3) - 1;
    checkBoundaries();
  }
  
  public void grow() {
    size++;
  }
  
  public void reset() {
    x = (float)Math.random()*301;
    y = (float)Math.random()*301;
    size = 5;
    col = color((int)(Math.random()*155)+100, (int)(Math.random()*155)+100, (int)(Math.random()*155)+100);
  }
  
  public void show() {
    noStroke();
    fill(col);
    ellipse(x, y, size, size);
  }
}

Walker[] walkerArr;
ArrayList<Food> foodArr;

void setup() {
  size(300, 300);
  walkerArr = new Walker[MAX_OBJECTS];
  foodArr = new ArrayList<Food>();
  for (int i = 0; i < MAX_OBJECTS; i++) {
    walkerArr[i] = new Walker();
  }
}

void draw() {
  fill(50, 50, 50, 30);
  rect(0, 0, CANVAS_X, CANVAS_Y);

  for (Food food: foodArr) {
    food.show();
  }
  
  for (Walker walker : walkerArr) {
    if (foodArr.size() > 0) {
      Food nearestFood = findNearestFood(foodArr, walker.x, walker.y);
      walker.biasedWalk(nearestFood.x, nearestFood.y);
      if (dist(nearestFood.x, nearestFood.y, walker.x, walker.y) <= walker.size/2) {
        foodArr.remove(nearestFood);
        walker.grow();
      }
    } else {
      walker.randomWalk();
    }
    walker.show();
  }
}

void mousePressed() {
  foodArr.add(new Food(mouseX, mouseY));
}

void keyPressed() {
  if (key == 'r') {
    for (int i = 0; i < MAX_OBJECTS; i++) {
      walkerArr[i]= new Walker();
    }
    foodArr.clear();
  }
}
     
