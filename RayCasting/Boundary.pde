class Boundary
{
  PVector start;
  PVector end;
  
  Boundary(PVector start, PVector end)
  {
    this.start = start;
    this.end   = end;
  }
  
  public void show()
  {
    stroke(255);
    line(start.x, start.y, end.x, end.y);
  }
}
