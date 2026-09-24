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
 * Defines the Agent class to be used in the Team Management System.
 */
public class Agent implements Clickable {

  /**
   * The standard diameter of all Agents, protected for child class.
   */
  protected static int diameter = 20;

  /**
   * Reference to the application window, used for creating visual representations.
   */
  protected static processing.core.PApplet processing;

  /**
   * Reference to this Agent's assigned team or null if the agent does not have a team.
   */
  protected Team team;

  /**
   * The x-coord the Agent is actively moving to. Set to -1 when not in use.
   */
  private float destX = -1;

  /**
   * The y-coord the Agent is actively moving to. Set to -1 when not in use.
   */
  private float destY = -1;

  /**
   * Storing the previous x-pos of the mouse, used when dragging Agents around in the window.
   */
  private int oldMouseX;

  /**
   * Storing the previous y-pos of the mouse, used when dragging Agents around in the window.
   */
  private int oldMouseY;

  /**
   * The original x-coord of an agent when the mouse is pressed, used to determine if an agent was
   * dragged at all when the mouse gets released. Set to -1 when not in use.
   */
  private float originalX = -1;

  /**
   * The original y-coord of an agent when the mouse is pressed, used to determine if an agent was
   * dragged at all when the mouse gets released. Set to -1 when not in use.
   */
  private float originalY = -1;

  /**
   * Current x-potition of this Agent.
   */
  private float xPos;

  /**
   * Current y-position of this Agent.
   */
  private float yPos;

  /**
   * Used to indicate if this Agent is currently Active.
   */
  private boolean isActive;

  /**
   * Used to indicate if this Agent is currently being dragged.
   */
  protected boolean isDragging;


  /**
   * Constructs a new agent at the given (x,y) coordinate and initialized data fields with
   * non-default values.
   * 
   * @param x the initial x-coordinate of this agent
   * @param y the initial y-coordinate of this agent
   */
  public Agent(int x, int y) {

    this.xPos = x;
    this.yPos = y;
    isActive = false;
    isDragging = false;

    team = null;
  }

  /**
   * Sets the processing reference to be the same across the entire class
   * 
   * @param processing the processing library for all objects
   */
  public static void setProcessing(processing.core.PApplet processing) {
    Agent.processing = processing;
  }

  /**
   * Accesses the value of the class variable diameter.
   * 
   * @return the Diameter of every Agent's representation
   */
  public static int diameter() {
    return diameter;
  }

  /**
   * Reports wheather this Agent has been selected
   * 
   * @return true if Agent is Active, false otherwise.
   */
  public boolean isActive() {
    return this.isActive;
  }

  /**
   * Helper method, reports whether this Agent is currently moving. A moving agent will have
   * destination coordinates that are not (-1,-1);
   * 
   * @return true if this Agent is moving, false otherwise.
   */
  protected boolean isMoving() {
    if (this.destX == -1 || this.destY == -1) {
      return false;
    } else {
      return true;
    }
  }

  /**
   * Accesses the Team reference of this Agent
   * 
   * @return a direct reference to the team this Agent is a memeber of, or null if no team.
   */
  public Team getTeam() {
    return team;
  }

  /**
   * Accessor method for the current x-coordinate of this Agent
   * 
   * @return the current x-coordinate of this agent
   */
  public float getX() {
    return xPos;
  }

  /**
   * Accessor method for the current y-coordinate of this Agent
   * 
   * @return the current y-coordinate of this agent
   */
  public float getY() {
    return yPos;
  }

  /**
   * Helper method to determine the color to use for drawing this agent. When active, color should
   * be green (0, 255, 0), when part of a team, should be the team's color, else should be yellow.
   * 
   * @return an integer representing the color that this agent should be drawn in.
   */
  protected int getColor() {
    // Green for active
    if (isActive) {
      return processing.color(0, 255, 0);

      // Color of team
    } else if (team != null) {
      return team.getColor();

      // Yellow
    } else {
      return processing.color(255, 255, 0);
    }
  }

  /**
   * Swiches the active status of this Agent to the opposite: if false, make true and vise versa.
   */
  public void toggleActive() {
    if (isActive) {
      this.isActive = false;
    } else {
      this.isActive = true;
    }
  }

  /**
   * Sets the team of this agent to be the provided value. If this agent was already a member of a
   * team.
   * 
   * @param t the new team to add this agent to.
   */
  public void setTeam(Team t) {
    // Gets rid of previous team
    if (this.team != null) {
      this.team.removeMember(this);
    }

    // Assigns to new team
    if (t != null) {
      t.addMember(this);
    }
    this.team = t;
  }

  /**
   * Sets destination coordinates of this agent to be the provided values and deactivates the Agent
   * 
   * @param x this agent's new destination X-coord
   * @param y this agent's new destination y-coord
   */
  public void setDestination(float x, float y) {
    isActive = false;
    this.destX = x;
    this.destY = y;
  }

  /**
   * Renders this agent to the application window after making any required updates to its position,
   * that is, if being dragged or if moving to a destination. Agents are rendered as a circle of the
   * class' diameter at their specific x,y coordinates, drawn in the color returned by the helper
   * method getColor().
   */
  public void draw() {
    move();
    processing.fill(getColor());
    processing.circle(xPos, yPos, diameter);
  }

  /**
   * Helper method, sets this agent to be dragging and initializes the oldMouseX and oldMouseY
   * fields to the current location of the mouse.
   */
  protected void startDragging() {
    isDragging = true;

    // Must cast in order to have x and y pos converted.
    oldMouseX = (int) xPos;
    oldMouseY = (int) yPos;
  }

  /**
   * Helper method, sets this agent to no longer be dragging.
   */
  protected void stopDragging() {
    isDragging = false;
  }

  /**
   * Helper method containing the logic to update this agent's position correctly while being
   * dragged.
   */
  protected void drag() {
    startDragging();
    xPos = processing.mouseX - oldMouseX;
    yPos = processing.mouseY - oldMouseY;

    // Storing current mouse location as previous coordinates for next time
    oldMouseX = processing.mouseX;
    oldMouseY = processing.mouseY;
  }

  /**
   * Helper method to move an agent 3 units toward its destination, if one is set; if the agent is
   * within 3 units of its destination, moves the agent directly to its destination and resets the
   * destination coordinates to (-1,-1).
   */
  protected void move() {
    // Check if destination is set
    if (isMoving()) {
      float dx = destX - xPos;
      float dy = destY - yPos;
      float totalDistance = (float) Math.sqrt(dx * dx + dy * dy);

      // Seeing if within 3 units of destination
      if (totalDistance <= 3.0) {
        xPos = destX;
        destX = -1;

        yPos = destY;
        destY = -1;
      } else {
        // Move 3 units towards destingation
        xPos += (dx / totalDistance) * 3;
        yPos += (dy / totalDistance) * 3;
      }
    }
  }

  /**
   * Defines the behavior of this agent when it is clicked on. This method is called only when the
   * mouse is over the agent.
   */
  public void mousePressed() {
    // Only update when mouse if over and mouse gets pressed
    if (isMouseOver() && !isMoving()) {
      startDragging();

      // Update only if not is moving
      originalX = xPos;
      originalY = yPos;

    }
  }

  /**
   * Defines the behavior of this agent when the mouse is released.
   */
  public void mouseReleased() {

    stopDragging();

    if (xPos == originalX && yPos == originalY) {
      isActive = true;
    }

    this.originalX = -1;
    this.originalY = -1;
  }

  /**
   * Determines whether the mouse is over this agent.
   */
  public boolean isMouseOver() {

    // since diameter is 20, radius is 10
    if ((processing.mouseX > xPos - 10 && processing.mouseX < xPos + 10)
        && (processing.mouseY > yPos - 10 && processing.mouseY < yPos + 10)) {

      return true;

    } else {
      return false;
    }
  }
}
