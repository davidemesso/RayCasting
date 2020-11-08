ArrayList<Boundary> boundaries;
PVector startingPosition;
PVector endingPosition;

JSONArray map;

void settings()
{
  size(600, 600);
}

void setup()
{
  boundaries = new ArrayList<Boundary>();
  map = new JSONArray();
}

void draw()
{
  background(255);

  for(Boundary b : boundaries)
    b.show();
}



void mousePressed() {
  startingPosition = new PVector(mouseX, mouseY);
}

void mouseReleased() {
  endingPosition = new PVector(mouseX, mouseY);
  if(arePositionsDifferent(startingPosition, endingPosition))
    boundaries.add(new Boundary(startingPosition, endingPosition));
    
  JSONObject startingPoint = new JSONObject().setFloat("x",startingPosition.x).setFloat("y",startingPosition.y);
  JSONObject endingPoint = new JSONObject().setFloat("x",endingPosition.x).setFloat("y",endingPosition.y);
  JSONObject boundary = new JSONObject().setJSONObject("start",startingPoint).setJSONObject("end",endingPoint);
  map.append(boundary);
}

boolean arePositionsDifferent(PVector startingPosition, PVector endingPosition)
{
  return (startingPosition.x != endingPosition.x && 
          startingPosition.y != endingPosition.y);
}

void keyPressed()
{
  if(key == 's')
  {
    saveJSONArray(map, "../RayCasting/map.json");
    print(map);
  }
}
