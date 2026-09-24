//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Team Party Hopping
// Course: CS 300 Spring 2025
//
// Author: Jake Christofferson
// Email: ejchristoffe@wisc
// Lecturer: Mouna Kacem
//
//////////////////////// ASSISTANCE/HELP CITATIONS ////////////////////////////
//
// Persons: none
// Online Sources:
// https://www.baeldung.com/java-rgb-color-representation
// - This helped me create a color method and be able to represent colors
// as integers.
//
///////////////////////////////////////////////////////////////////////////////

/**
 * Interface which allows other classes to be able to be clicked.
 */
public interface Clickable {
  
  /**
   * Draws the clickable object into the view window.
   */
  void draw();
  
  /**
   * The behavior for each time the mouse is pressed.
   */
  void mousePressed();
  
  /**
   * The behavior for each time the mouse is released.
   */
  void mouseReleased();
  
  /**
   * Determines if the mouse is currently on top of the rendered object.
   * 
   * @return True if the cursor is over the object, otherwise false.
   */
  boolean isMouseOver();
  
}
