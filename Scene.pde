Scene currentScene = new StartScene();

abstract class Scene
{
  int tick = 0;
  
  abstract void setup();
  
  abstract void draw();
  
  abstract void mousePressed();
  
  abstract void mouseReleased();
  
  abstract void mouseMoved();
  
  ArrayList<Button> interactibles = new ArrayList<Button>();
  
  void present(Scene scene) {
    currentScene = scene;
    currentScene.setup();
  }
}
