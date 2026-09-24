//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title:    Party Hopping 
// Course:   CS 300 Spring 2025
//
// Author:   Jake Christofferson
// Email:    ejchristoffe@wisc.edu
// Lecturer: Mouna Kacem
//
//////////////////////// ASSISTANCE/HELP CITATIONS ////////////////////////////
//
// Persons:         NONE
// Online Sources:  https://canvas.wisc.edu/courses/447785/files/43999876?wrap=1
//                  This source was the walkthrough on how to use and implement
//                  classes like Utility and Agent as well as the direction for 
//                  this project.
//
///////////////////////////////////////////////////////////////////////////////

import java.io.File;
import processing.core.PImage;

/**
 * Class for utilizing a GUI for moving around agents from three different locations 
 * at a "party". It is also possible to add and remove more agents using key presses.
 */
public class PartyHopping {
  
  // Holds the numeric value for the background color of the window
  private static int bgColor;
  
  // An array of PImage images to be referenced later
  private static PImage[] locationImages;
  
  // An array of Agent objects which will be used in the final application
  private static Agent[] agents;
  
  // An array of Party objects which will hold the different 
  // locations agents can move to.
  private static Party[] locations;

  /**
   * The main method which starts the rest of the program.
   * <p>
   * @param args, command-line arguments (unused)
   */
  public static void main(String[] args) {
    Utility.runApplication();
  }
  
  /**
   * Runs once at the start of the program and sets up important
   * variables and arrays.
   */
  public static void setup() {
    //Sets background color
    bgColor = Utility.color(81, 125, 168);
    
    //Initializes images in locationImages array
    locationImages = new PImage[3];
    locationImages[0] = Utility.loadImage("images" + File.separator + "cup.png");
    locationImages[1] = Utility.loadImage("images" + File.separator + "dice.png");
    locationImages[2] = Utility.loadImage("images" + File.separator + "ball.png");

    
    //Initializes the locations array of Party objects
    locations = new Party[3];
    locations[0] = new Party('a', 200, 175, locationImages[0]);
    locations[1] = new Party('b', 600, 200, locationImages[1]);
    locations[2] = new Party('c', 400, 435, locationImages[2]);
    
    //Initializes agents
    agents = new Agent[15]; //max of 15 agents
    agents[0] = new Agent(Utility.loadImage("images" + File.separator + "student.png"));
    Agent.setActiveImage(Utility.loadImage("images" + File.separator + "active.png"));
  }
  
  /**
   * Continually draws images while the program is running; how the 
   * applicaiton window is able to continually update.
   */
  public static void draw() {
    //continuously draws the background underneath everything
    Utility.background(bgColor);
    //System.out.println("Debug: bg drawn");
    
    //Draws our location images according to the array of Party objects, locations
    for (int i = 0; i < locations.length; ++i) {
      locations[i].draw();
    }
    //System.out.println("Debug: images drawn");
    
    //Draws agents
    for (int i = 0; i < agents.length; ++i) {
      if (agents[i] != null) {
        agents[i].draw();
      }
    }
    
    //System.out.println("x: " + Utility.mouseX() + ", y: " + Utility.mouseY());
  }
  
  /**
   * Determines when the mouse is pressed and what events will occur
   * if the mouse is pressed during certain times.
   */
  public static void mousePressed() {
    
    //starts at the end of agents array and iterates backwards
    for (int i = (agents.length - 1); i >= 0; i -= 1) {
      
      if (agents[i] != null) {
        
        //only activates the highest index agent
        if (isMouseOver(agents[i])) {
          agents[i].activate();
         System.out.println("Activated");
         break;
        } 
      }
    }
  }
  
  /**
   * Determines what will happen if a key is pressed at a certain time.
   * <p>
   * @param key, the character of the key that is pressed.
   */
  public static void keyPressed(char key) {
    System.out.print(key);
    
    //goes through all possible locations
    for (int i = 0; i < locations.length; ++i) {
      
      //sees if key pressed is the same as one of the possible locaiton ids
      if (key == locations[i].getID()) {
      
        //loops through all agents to find the highest index non-null agent
        for (int j = (agents.length - 1); j >= 0; j -= 1) {
          if ((agents[j] != null) && (agents[j].isActive())) {
            
            //sends agent to the location of the key that was pressed
            agents[j].setDestination(locations[i]);
            
          }          
        }
      }
    }
    
    //checks for key press '.' to add a new agent to lowest open spot in array
    if (key == '.') {
      
      for (int i = 0; i < agents.length; ++i) {
        
        if (agents[i] == null) {
          agents[i] = new Agent(Utility.loadImage("images" + File.separator + "student.png"));
          break;
        }
      }
    }
    
    //checks for key press'x' to remove the highest index active agent
    if (key == 'x') {
      
      for (int i = agents.length - 1; -1 < i; i -= 1) {
        
        if (agents[i] != null && agents[i].isActive()) {
          
          agents[i] = null;
          break;
        }
      }
    }
    
    //'m' will kill all active agents, not just the top index
    if (key == 'm') {
      
      for (int i = agents.length - 1; -1 < i; i -= 1) {
        
        if (agents[i] != null && agents[i].isActive()) {
          
          agents[i] = null;// notice how there is no break statement,  
                           // this is what causes all to get 'killed'
         
        }
      }
      
    }
    
  }
  
  /**
   * Determines wheather or not the mouse is currently hovering 
   * over an agent object in the application window.
   * <p>
   * @param agent, the agent object that we are checking if the mouse is hovering over.
   * @return true if the mouse is over an agent, and false if the mouse is 
   *         not over an agent at a given time.
   */
  public static boolean isMouseOver(Agent agent) {
    //data from agent
    float imageWidth = agent.width();
    float imageHeight = agent.height();
    float imageX = agent.getX();
    float imageY = agent.getY();
    
    //mouse data
    int mouseX = Utility.mouseX();
    int mouseY = Utility.mouseY();
    
    //calculating bounds for where the image is
    float lowerWidth = imageX - (imageWidth / 2);
    float upperWidth = imageX + (imageWidth / 2);
    float lowerHeight = imageY - (imageHeight / 2);
    float upperHeight = imageY + (imageHeight / 2);
    
    //see if mouse is over the range
    if (((lowerWidth <= mouseX) && (upperWidth >= mouseX)) 
        && ((lowerHeight <= mouseY) && (upperHeight >= mouseY))) {
      return true; 
    } else {
      return false;
    }
    
  }
  
}