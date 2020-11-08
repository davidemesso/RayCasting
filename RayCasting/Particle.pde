class Particle
{
  PVector position;
  ArrayList<Ray> rays;
  ArrayList<Float> distances;

  float vel = 0;
  int rotationVel = 0;
  
  Particle(PVector position, int FOV)
  {
    this.position = position;
    rays = new ArrayList<Ray>();
    distances = new ArrayList<Float>();
    
    for(float i = -FOV/2; i < FOV/2; i+= 0.5)
      rays.add(new Ray(new PVector(position.x, position.y), radians(i)));
  }
  
  public void updatePosition(PVector position)
  {
    this.position = position;
    for (Ray ray : rays) 
      ray.position = position;
  }
  
  public void show() 
  {
    if(render2D)
    {
      fill(255);
      ellipse(position.x, position.y, 4, 4);
    }
  }
  
  public void update(ArrayList<Boundary> boundaries)
  {
    Ray director = rays.get(rays.size()/2);
    PVector velocity = new PVector(director.direction.x * vel, director.direction.y * vel);
    PVector newPosition = new PVector(position.x + velocity.x, position.y + velocity.y);
    
    boolean canMove = true;
    for(Boundary b : boundaries)
      if(intersect(newPosition, b))
        canMove = false;
    
    if(canMove)
      updatePosition(newPosition);    
    this.rotate(rotationVel);
    show();
  }
  
  public void cast(ArrayList<Boundary> boundaries)
  {
    distances.clear();
    for(Ray r : rays)
    {
      float maxDistance = Integer.MAX_VALUE;
      PVector closest = null;
      for(Boundary b : boundaries)
      {
        float distance = Integer.MAX_VALUE;
        PVector point = r.cast(b);
        if(point != null)
        {
          distance = PVector.dist(r.position, point);
          if(fishEyeCorrection)
          {
            float a = r.direction.heading() - rays.get(rays.size()/2).direction.heading();
            distance *= cos(a);
          }
          
          if(distance < maxDistance)
          {
            maxDistance = distance;
            closest = point;
          }
        }
      }
      if(closest != null)
      {
        line(position.x, position.y, closest.x, closest.y);
        distances.add(maxDistance);
      }
    }
  }
  
  public void rotate(int value)
  {
    for(Ray r : rays)
    {
      float newAngle = r.angle + radians(value);
      r.direction = PVector.fromAngle(newAngle);
      r.angle = newAngle;
    }
  }
  
  boolean intersect(PVector newPosition, Boundary wall)
  { 
    // FOR INFORMATION ON LINE-CIRCLE COLLISION https://stackoverflow.com/questions/1073336/circle-line-segment-collision-detection-algorithm
    PVector d = PVector.sub(wall.end, wall.start);
    PVector f = PVector.sub(wall.start, newPosition);
    float a = PVector.dot(d, d);
    float b = PVector.dot(PVector.mult(f, 2), d);
    float c = PVector.dot(f, f)-4;
    float discriminant = b*b-4*a*c;
    
    if(!(discriminant < 0 ))
    {
      discriminant = sqrt( discriminant );
      float t1 = (-b - discriminant)/(2*a);
      float t2 = (-b + discriminant)/(2*a);
    
      if( t1 >= 0 && t1 <= 1 )
        return true ;
      if( t2 >= 0 && t2 <= 1 )
        return true ;
      return false ;
    }
    return false;
  }
  
  void render()
  {
    int scale = 2;
    int offset = width/2; 
    if(!render2D)
    {
      scale = 1;
      offset = 0;
    }
    int w = width/scale /distances.size();
    
    for(int i = 0; i < distances.size(); i++)
    {
      float distance = distances.get(i);
      float b = map(distance, 0, width/scale, 220, 0);
      float h = map(distance, 0, width, height, 0);
      noStroke();
      fill(b);
      rectMode(CENTER);
      
      rect(offset + w * i + w/2, height/2, w +1, h);
    }
  }
}
