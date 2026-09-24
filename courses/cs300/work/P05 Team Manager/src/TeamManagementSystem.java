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

import java.util.ArrayList;
import java.util.Random;
import processing.core.PApplet;

/**
 * Responsible for managing and displaying the Team Management System
 */
public class TeamManagementSystem extends PApplet {

  // General data fields for this program
  /**
   * Random number generator used to create team colors
   */
  private Random randGen; // A random number generator for creating Team colors

  /**
   * Array list containing all clickable objects used to iterate through when calculating behaviors.
   */
  private ArrayList<Clickable> objects; // Storage for the interactive components of the program

  /**
   * ArrayList containing all teams
   */
  private ArrayList<Team> teams; // Storage for all Teams with at least one member

  /**
   * Background color of window
   */
  private int bgColor; // The background color of the application window

  // Selection-related fields:
  /**
   * Indicates whether the user is currently creating a selection box
   */
  private boolean isSelecting;

  /**
   * The x-coordinate where the user began creating a selection box
   */
  private int selectionStartX; //

  /**
   * The y-coordinate where the user began creating a selection box
   */
  private int selectionStartY;

  /**
   * Runs the operating window
   * 
   * @param args command-line arguments (unused)
   */
  public static void main(String[] args) {
    PApplet.main("TeamManagementSystem"); // PROVIDED
  }

  /**
   * Houses settings for general PApplet creation
   */
  @Override
  public void settings() {
    // #1 call PApplet's size() method giving it 800 as the width and 600 as the height
    size(800, 600);
  }

  /**
   * Sets up all of the processing references in required classes, image mode, and initializes
   * fields.
   */
  @Override
  public void setup() {
    // #2 add setProcessing calls (see writeup)
    Agent.setProcessing(this);
    Party.setProcessing(this);

    // #3 set the imageMode so the x,y coordinates indicate the center of an object
    imageMode(CENTER);

    // #4 initialize randGen and the ArrayLists
    randGen = new Random();
    objects = new ArrayList<>();
    teams = new ArrayList<>();

    // #5 initialize the bgColor with R = 81, G = 125, B = 168
    bgColor = color(81, 125, 168);

    // #7 add the party objects (see writeup for suggested locations, but feel free to change)
    // PImage created with loadImage and the location of the image
    Party cup = new Party(200, 125, loadImage("cup.png"));
    Party dice = new Party(600, 150, loadImage("dice.png"));
    Party ball = new Party(400, 450, loadImage("ball.png"));
    objects.add(cup);
    objects.add(dice);
    objects.add(ball);

    // #8 add one agent at the center of the screen
    objects.add(new Agent(400, 300));
  }

  /**
   * Draws background, selection box, and objects on screen
   */
  @Override
  public void draw() {
    // #6 draw the background using the bgColor value
    background(bgColor);

    // #14 draw the selection box if the user is currently selecting (see helper method below)
    if (isSelecting) {
      drawSelectionBox();
    }

    // #9 draw all Clickables in the objects list to the application window in the order they
    // appear
    for (Clickable ob : objects) {
      ob.draw();
    }

    // #11 use your helper method below to clear all empty teams from the teams list
    clearEmptyTeams();

    // #12 if there are any teams left, do the following:
    // (1) begin with a y-coordinate of 20 and a text size of 16
    // (2) set PApplet's fill to (0,255,0) if the team is active, or just (255) if it is not
    // (3) print "Team " and the team's ID letter at x=10 and the current y-coordinate
    // (4) move the y-coordinate down by 20 and repeat if there are any other teams
    int yCord = 0;
    textSize(16);

    for (int i = 0; i < teams.size(); i++) {
      yCord += 20;

      // Part 2
      if (teams.get(i).isActive()) {
        fill(color(0, 255, 0));
      } else {
        fill(255);
      }

      text("Team " + teams.get(i).getTeamID(), 10, yCord);
    }
  }

  /**
   * Finds all empty teams to be cleared from the screen
   */
  public void clearEmptyTeams() {
    // #10 implement this method - remove all teams with NO members from the teams list
    for (Team t : teams) {
      if (t.getTeamSize() <= 0) {
        teams.remove(t);
      }
    }
  }

  /**
   * Method to draw the selection box. (To be called in draw() method)
   */
  public void drawSelectionBox() {
    // #13 implement this method, see below for details:

    float upLeftX;
    float upLeftY;
    float width;
    float height;
    // The user's selection box is defined by the selectionStartX/selectionStartY coordinates and
    // the current position of the mouse. However, PApplet's rectangle drawing method requires the
    // coordinates of the upper left corner of the rectangle (which may not correspond to either of
    // those points) and the width/height of the rectangle to draw.

    // Start is the top left section and mouse is the bottom right
    if (selectionStartX <= mouseX && selectionStartY <= mouseY) {
      upLeftX = selectionStartX;
      upLeftY = selectionStartY;
      width = mouseX - selectionStartX;
      height = mouseY - selectionStartY;

      // Start is the top right and mouse is the bottom left
    } else if (selectionStartX > mouseX && selectionStartY <= mouseY) {
      upLeftX = mouseX;
      upLeftY = selectionStartY;
      width = selectionStartX - mouseX;
      height = mouseY - selectionStartY;

      // Start is the bottom left and mouse is the top right
    } else if (selectionStartX <= mouseX && selectionStartY > mouseY) {
      upLeftX = selectionStartX;
      upLeftY = mouseY;
      width = mouseX - selectionStartX;
      height = selectionStartY - mouseY;

      // Start can only be bottom right and mouse top left
    } else {
      upLeftX = mouseX;
      upLeftY = mouseY;
      width = selectionStartX - mouseX;
      height = selectionStartY - mouseY;
    }

    fill(color(135, 185, 201));
    rect(upLeftX, upLeftY, width, height);
  }

  /**
   * Iterates through cickable objects and slection box logic to see what should happen when an
   * object is clicked.
   */
  @Override
  public void mousePressed() {
    // #15 if the mouse is over any of the Clickable objects, call only that object's
    // mousePressed method and end the method
    for (Clickable ob : objects) {
      if (ob.isMouseOver()) {
        ob.mousePressed();
        return;
      }
    }

    // #16 if the mouse is NOT over any of the Clickable objects, set isSelecting to true and
    // initialize the selectionStartX and selectionStartY values to the current mouse location
    isSelecting = true;
    selectionStartX = mouseX;
    selectionStartY = mouseY;
  }

  /**
   * Iterates through cickable objects and slection box logic to see what should happen when an
   * object has the mouse released.
   */
  @Override
  public void mouseReleased() {
    // #17 if the user is creating a selection box:
    // (1) determine whether all selected agents belong to a single team (see helper method below)
    // (2) if they do not, create a team out of the selected agents (see helper method below)
    // (3) either way, set isSelecting back to false
    if (isSelecting) {
      ArrayList<Agent> selectedAgents = getAllSelectedAgents();
      Team team = detectTeam();

      if (team == null && !selectedAgents.isEmpty()) {
        createTeam(selectedAgents);
      }
    }
    isSelecting = false;

    // #18 clear any empty teams (see helper method above)
    clearEmptyTeams();

    // #19 call mouseReleased() on all Clickable objects
    for (Clickable o : objects) {
      o.mouseReleased();
    }
  }

  /**
   * Detects a vaild team using the selection box and then creates said team.
   * 
   * @return reference to created team or null if no team could be found/created/
   */
  public Team detectTeam() {
    // #20 find all agents within the selection box (this method will only be called when the
    // user was creating a selection box -- see helper method below)
    ArrayList<Agent> selectedAgents = getAllSelectedAgents();

    // #21 if no agents were selected, return null
    if (selectedAgents.isEmpty()) {
      return null;
    }

    Team primaryTeam = selectedAgents.get(0).getTeam();
    for (Agent a : selectedAgents) {
      if (a.getTeam() != primaryTeam) {
        return null;
      }

    }

    // #22 if all selected agents are on the same (non-null) team, return a reference to that
    // team, otherwise return null
    return primaryTeam;
  }

  /**
   * Gets all agents in the selection box and creates an arrayList containing selected agents.
   * 
   * @return all selected agents that were in the selection box.
   */
  public ArrayList<Agent> getAllSelectedAgents() {
    // #23 find the bounds of the selection box described by the selectionStart coordinates and
    // the current mouse location
    float leftB, rightB, upB, lowB;

    if (selectionStartX > mouseX) {
      rightB = selectionStartX;
      leftB = mouseX;
    } else {
      leftB = selectionStartX;
      rightB = mouseX;
    }

    if (selectionStartY > mouseY) {
      lowB = selectionStartY;
      upB = mouseY;
    } else {
      upB = selectionStartY;
      lowB = mouseY;
    }

    // #24 add to this list all agents whose center (x,y) coordinate is within the bounds of
    // the selection box:
    ArrayList<Agent> agents = new ArrayList<>();

    // For all Clickables, see which are Agents, then which Agents are within the bounds of
    // selection box
    for (Clickable c : objects) {
      if (c instanceof Agent) {
        Agent a = (Agent) c;
        float xVal = a.getX();
        float yVal = a.getY();
        if ((xVal >= leftB && xVal <= rightB) && (yVal >= upB && yVal <= lowB)) {
          agents.add(a);
        }
      }
    }

    return agents;
  }

  /**
   * Creates team containing Agents passed into this method.
   * 
   * @param selected the ArrayList of agents to create a new team.
   */
  public void createTeam(ArrayList<Agent> selected) {
    // #25 if no agents were selected, end the method
    if (selected.isEmpty()) {
      return;

    } else {
      // #26 generate a random color for this team with R, G, and B values between 0 and 255
      int r = randGen.nextInt(256);
      int g = randGen.nextInt(256);
      int b = randGen.nextInt(256);
      int teamColor = color(r, g, b);

      // #27 attempt to create a new team using the selected agents and this color
      try {
        Team newT = new Team(teamColor, selected);

        // #28 if the team is created successfully, add it to the teams list; otherwise do nothing
        teams.add(newT);
      } catch (IllegalArgumentException | IllegalStateException e) {
        System.out.println("DEBUG error making team");
        return;
      }
    }
  }

  /**
   * Contains the logic of what should happen when certain keys are pressed.
   */
  @Override
  public void keyPressed() {
    // #29 if the key is a '.', add a normal agent at the mouse's current location
    if (key == '.') {
      objects.add(new Agent(mouseX, mouseY));
    }

    // #30 if the key is a ',', add a team lead at the mouse's current location
    if (key == ',') {
      objects.add(new Lead(mouseX, mouseY));
    }

    // #31 if the key is an 'r' and the mouse is over an agent, remove that agent
    if (key == 'r') {

      for (int i = objects.size() - 1; i >= 0; i--) {
        Clickable a = objects.get(i);
        if (a instanceof Agent && a.isMouseOver()) {
          objects.remove(i);
        }
      }
    }

    // #32 if the key is the lower-case version of any of the existing Team IDs, have that
    // Team's members line up
    for (Team t : teams) {
      if (key == Character.toLowerCase(t.getTeamID())) {
        t.lineUp();
      }
    }
  }

  /**
   * Finds the first team in the teams list with all members active and returns reference to that
   * team.
   * 
   * @return a reference to the found team, otherwise a null referece if all members are not active.
   */
  public Team getActiveTeam() {
    // #33 find the first team in the teams list with all members active and return it
    for (Team t : teams) {
      if (t.isActive()) {
        return t;
      }
    }
    // #34 if no team has all members active, return null
    return null;
  }

}
