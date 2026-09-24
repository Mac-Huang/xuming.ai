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
 * Defines the Leader of a team of Agents. Every Team can have at most one Lead, and clicking on
 * that Team's Lead selects ALL members of the Team at the same time.
 */
public class Lead extends Agent {

  /**
   * Constructs a new Lead at the given x,y coordinates.
   * 
   * @param x the x-position of this Lead
   * @param y the y-position of this Lead
   */
  public Lead(int x, int y) {
    super(x, y);
  }

  /**
   * Draws the same as an Agent, but the Lead has an inverted black triangle over the circle in the
   * color corresponding to this Lead's selection/team status.
   */
  @Override
  public void draw() { //TODO UPDATE TRIANGLE TO BE CORRECT
    super.draw();
    processing.fill(0);
    processing.triangle
      (getX() - (diameter / 3), getY() - (diameter / 5),
      getX() + (diameter / 3), getY() + (diameter / 5), 
      getX(),getY() + (diameter / 3));
  }

  /**
   * Defines the specific behavior of this team when the mouse is released. If this lead was
   * activated by the mouse being released, this method activates ALL member of this lead's team if
   * this lead has a team.
   */
  @Override
  public void mouseReleased() {
    // Does the normal mouseReleased function
    super.mouseReleased();
    
    // Checks if Lead is active, if so select all agents in team.
    if (isActive() && getTeam() != null) {
      getTeam().selectAll();
    }
  }
}
