ArrayList<Boundary> boundaries;
Particle particle;
int sceneWidth;
boolean render2D = true;
boolean fishEyeCorrection = true;

boolean loadMap = true;
JSONArray map;

void settings() 
{
  size(1200, 600);
}

void setup()
{ 
  sceneWidth = width/2;
  
  particle = new Particle(new PVector(sceneWidth/6, height/2), 50);
  boundaries = new ArrayList<Boundary>();
  
  // External walls
  boundaries.add(new Boundary(new PVector(0, 0), new PVector(sceneWidth, 0)));
  boundaries.add(new Boundary(new PVector(0, 0), new PVector(0, height)));
  boundaries.add(new Boundary(new PVector(sceneWidth, 0), new PVector(sceneWidth, height)));
  boundaries.add(new Boundary(new PVector(0, height), new PVector(sceneWidth, height)));
  
  if(loadMap)
  {
    map = loadJSONArray("map.json");
    for(int i = 0; i < map.size(); i++)
    {
      JSONObject wall  = map.getJSONObject(i);
      JSONObject start = wall.getJSONObject("start");
      JSONObject end   = wall.getJSONObject("end");
      PVector startPoint = new PVector(start.getFloat("x"),start.getFloat("y"));
      PVector endPoint   = new PVector(end.getFloat("x"),end.getFloat("y"));
      print(startPoint);
      print(endPoint);
      Boundary b = new Boundary(startPoint, endPoint);
      boundaries.add(b);
    }
  }
  else
  {
    for(int i = 0; i < int(random(6, 11)); i++)
    {
      PVector start = generateRandomPointInMap();
      PVector end = generateRandomPointInMap();
      boundaries.add(new Boundary(start, end));
    }
  }
}

void draw()
{
  background(0);
  
  particle.update(boundaries);
  particle.cast(boundaries);
  particle.render();
  
  if(render2D)
    for(Boundary b : boundaries)
      b.show();
}

PVector generateRandomPointInMap()
{
  return new PVector(int(random(0, sceneWidth)),int(random(0, height)));
}

void keyReleased() {
  if(keyCode == RIGHT)
    particle.rotationVel = 0;
  if(keyCode == LEFT)
    particle.rotationVel = 0;
  if(keyCode == UP)
    particle.vel = 0;
  if(keyCode == DOWN)
    particle.vel = 0;
}

void keyPressed()
{
  if(keyCode == RIGHT)
    particle.rotationVel = 4;
  if(keyCode == LEFT)
    particle.rotationVel = -4;
  if(keyCode == UP)
    particle.vel = 2;
  if(keyCode == DOWN)
    particle.vel = -2;
  if(key == 'r')
    render2D = !render2D;
  if(key == 'f')
    fishEyeCorrection = !fishEyeCorrection;
}
