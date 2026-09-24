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
 * Models a Party to send Agents to by clicking on the party.
 */
public class Party implements Clickable {

  /**
   * A reference to the TeamManagementSystem for this application window
   */
  private static TeamManagementSystem tms;

  /**
   * The image associated with this Party
   */
  private processing.core.PImage image;

  /**
   * The x-position of the center of this Party
   */
  private float x;

  /**
   * The y-position of the center of this Party
   */
  private float y;

  /**
   * Constructs a Party represented by the given image at the given (x,y) coordinates
   * 
   * @param x     the x-position of this Party
   * @param y     the y-position of this Party
   * @param image the image representing this party
   */
  public Party(int x, int y, processing.core.PImage image) {
    this.x = x;
    this.y = y;
    this.image = image;
  }

  /**
   * Initializes the class TeamManagementSystem reference to the provided value.
   * 
   * @param processing
   */
  public static void setProcessing(TeamManagementSystem processing) {
    tms = processing;
  }

  /**
   * Accessor method for the current x-coordinate of this Party
   * 
   * @return
   */
  public float getX() {
    return this.x;
  }

  /**
   * Accessor method for the current y-coordinate of this Party
   * 
   * @return
   */
  public float getY() {
    return this.y;
  }

  /**
   * Draws the image associated with this party to its (x,y) location
   */
  public void draw() {
    tms.image(image, x, y);
  }

  /**
   * Required by clickable interface, but does nothing
   */
  public void mousePressed() {
    // Intentionally left empty
  }

  /**
   * Defines the behavior of this party when mouse is released. If the mouse is over this party, the
   * Party gets the active team from the TeamManagementSystem and sends them to this party.
   */
  public void mouseReleased() {
    Team activeTeam = tms.getActiveTeam();

    if (activeTeam != null && isMouseOver()) {
      activeTeam.sendToParty(this);
    }
  }

  /**
   * Determins wheather the mouse if over this party
   * 
   * @return true if the mouse is anywhere over the image of this party, false otherwise.
   */
  public boolean isMouseOver() {
    // Getting where the image actually is
    int height = image.height;
    int width = image.width;

    int leftBound = (int) (x - (width / 2));
    int rightBound = (int) (x + (width / 2));

    int topBound = (int) (y - (height / 2));
    int bottomBound = (int) (y + (height / 2));

    // is the mouse in the bounds, if so return true. Else, return false.

    return tms.mouseX >= leftBound && tms.mouseX <= rightBound && tms.mouseY >= topBound
        && tms.mouseY <= bottomBound;
  }
}

