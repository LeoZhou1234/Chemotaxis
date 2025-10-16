import java.util.Vector;

int NUM_OBJECTS = 10;

public Food findNearestFood(Vector<Food> foodArr, int x, int y) {
  int minDist = Integer.MAX_VALUE;
  Food nearestFood = foodArr.get(0);
  System.out.println();
  for (int i = 0; i < foodArr.size(); i++) {
    Food currFood = foodArr.get(i);
    float currDist = dist(currFood.x, currFood.y, x, y);
    if (currDist < minDist) {
      minDist = (int)currDist;
      nearestFood = currFood;
    }
  }
  return nearestFood;
}

class Food {
  int x, y;
  
  public Food(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public void show() {
    fill(190, 30, 30);
    ellipse(x, y, 5, 5);
  }
}

class Walker {
  int x, y, size, col;
  
  public Walker() {
    x = (int)(Math.random()*301);
    y = (int)(Math.random()*301);
    size = 5;
    col = color((int)(Math.random()*155)+100, (int)(Math.random()*155)+100, (int)(Math.random()*155)+100);
  }
  
  public void walk(int goalX, int goalY) {
    double prob = Math.random();
    if (prob < 0.2) {
      x -= (x < goalX ? 1 : -1);
    } else if (prob >= 0.6) {
      x += (x < goalX ? 1 : -1);;
    }
    prob = Math.random();
    if (prob < 0.2) {
      y -= (y < goalY ? 1 : -1);
    } else if (prob >= 0.6) {
      y += (y < goalY ? 1 : -1);
    }
  }
  
  public void grow() {
    size++;
  }
  
  public void reset() {
    x = (int)(Math.random()*301);
    y = (int)(Math.random()*301);
    size = 5;
    col = color((int)(Math.random()*155)+100, (int)(Math.random()*155)+100, (int)(Math.random()*155)+100);
  }
  
  public void show() {
    noStroke();
    fill(col);
    ellipse(x, y, size, size);
  }
}

//Jumper jumper = new Jumper();
Walker[] walkerArr;
Vector<Food> foodArr;

void setup() {
  size(300, 300);
  walkerArr = new Walker[NUM_OBJECTS];
  foodArr = new Vector<Food>();
  for (int i = 0; i < NUM_OBJECTS; i++) {
    walkerArr[i] = new Walker();
  }
}

void draw() {
  fill(50, 50, 50, 30);
  rect(0, 0, 300, 300);

  for (Food food: foodArr) {
    food.show();
  }
  
  for (Walker walker : walkerArr) {
    if (foodArr.size() > 0) {
      Food nearestFood = findNearestFood(foodArr, walker.x, walker.y);
      walker.walk(nearestFood.x, nearestFood.y);
      if (dist(nearestFood.x, nearestFood.y, walker.x, walker.y) <= walker.size) {
        foodArr.remove(nearestFood);
        walker.grow();
      }
    } else {
      walker.walk(width/2, height/2);
    }
    walker.show();
  }
}

void mousePressed() {
  foodArr.add(new Food(mouseX, mouseY));
}

void keyPressed() {
  if (key == 'r') {
    for (int i = 0; i < NUM_OBJECTS; i++) {
      walkerArr[i]= new Walker();
    }
    foodArr.clear();
  }
}
      
