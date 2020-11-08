class Ray
{
  PVector position;
  PVector direction;
  float angle;
  
  Ray(PVector position, float angle)
  {
    this.position = position;
    this.direction = PVector.fromAngle(angle);
    this.angle = angle;
  }
  
  public void show()
  {
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    line(0, 0, direction.x * 10, direction.y * 10);
    popMatrix();
  }
  
  public PVector cast(Boundary boundary)
  {
    // FOR INFORMATION ON LINE-LINE COLLISION https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
    float x1 = boundary.start.x;
    float y1 = boundary.start.y;
    float x2 = boundary.end.x;
    float y2 = boundary.end.y;

    float x3 = position.x;
    float y3 = position.y;
    float x4 = position.x + direction.x;
    float y4 = position.y + direction.y;
    
    float denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if(denom == 0)
      return null;
      
    float t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom;
    float u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denom;
    if (!(t > 0 && t < 1 && u > 0)) 
      return null;
      
    PVector pt = new PVector();
    pt.x = x1 + t * (x2 - x1);
    pt.y = y1 + t * (y2 - y1);
    return pt;
  }
}
