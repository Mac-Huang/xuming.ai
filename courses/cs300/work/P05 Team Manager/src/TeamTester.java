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

/**
 * A short tester class for verifying some of the Agent and Team behaviors in P05.
 */
public class TeamTester {

  /**
   * Verifies that an Agent’s initial position is set correctly upon creation.
   * 
   * This test should: - Create two agents at different (x,y) coordinates - Verify that their getX()
   * and getY() methods return the expected values - Verify that their initial positions match the
   * coordinates provided to their constructors
   * 
   * @return true if both agents are created with correct coordinates; false otherwise
   */
  public static boolean testAgentInitialPosition() {
    int expectedX1 = 102;
    int expectedX2 = 341;
    int expectedY1 = 342;
    int expectedY2 = 342;

    Agent ag1 = new Agent(expectedX1, expectedY1);
    Agent ag2 = new Agent(expectedX2, expectedY2);

    float actX1 = ag1.getX();
    float actX2 = ag2.getX();
    float actY1 = ag1.getY();
    float actY2 = ag2.getY();

    if (expectedX1 != actX1 || expectedY1 != actY1) {
      return false;
    }

    if (expectedX2 != actX2 || expectedY2 != actY2) {
      return false;
    }

    return true;
  }

  /**
   * Verifies that an Agent moves correctly when given a destination.
   * 
   * This test should: - Create an agent at a known position - Set a destination that is at least 10
   * pixels away in both x and y directions - Call the move() method once - Verify that the agent
   * has moved closer to the destination but has not reached it - Verify that the movement follows
   * the expected trajectory
   * 
   * @return true if agent movement behavior is correct; false otherwise
   */
  public static boolean testAgentMovement() {
    int ogX = 12;
    int ogY = 67;

    Agent agent = new Agent(ogX, ogY);

    // Agent is a total of 159 units away, should take 53 moves to get here
    int destX = 23;
    int destY = 91;

    agent.setDestination(destX, destY);

    // Verify agent moves closer
    agent.move();
    if (agent.getX() <= ogX && agent.getY() <= ogY) {
      return false;
    }

    // Then verifies that after 54 moves, agent has reached destination
    for (int i = 0; i < 54; ++i) {
      agent.move();
    }

    if (agent.getX() != destX || agent.getY() != destY) {
      return false;
    }

    return true;
  }

  /**
   * Verifies that an Agent without a destination remains stationary.
   * 
   * This test should: - Create an agent at a specific position - Record its initial position - Call
   * the move() method - Verify that the agent’s position has not changed
   * 
   * @return true if agent remains stationary when no destination is set; false otherwise
   */
  public static boolean testAgentStationary() {
    int ogX = 12;
    int ogY = 23;

    Agent agent = new Agent(ogX, ogY);

    // Re-verify that the original position of the made agent is recorded
    ogX = (int) agent.getX();
    ogY = (int) agent.getY();

    agent.move();

    if (ogX != 12 || ogY != 23) {
      return false;
    }

    return true;
  }

  /**
   * Verifies that creating a Team with multiple Leads throws an IllegalArgumentException.
   * 
   * This test should: - Create an ArrayList of Agents that includes multiple Lead instances -
   * Attempt to create a Team with this ArrayList - Verify that an IllegalStateException is thrown
   * 
   * @return true if the correct exception is thrown; false otherwise
   */
  public static boolean testMultipleLeadsException() {
    try {
      ArrayList<Agent> agents = new ArrayList<>();
      agents.add(new Agent(1, 1));
      agents.add(new Lead(23, 213));
      agents.add(new Lead(12, 341));

      new Team(2, agents);
      return false;

    } catch (IllegalStateException e) {
      return true;
    }
  }

  /**
   * Verifies behavior around empty teams.
   * 
   * This test should: - Create an empty ArrayList - Attempt to create a Team with this ArrayList -
   * Verify that an IllegalArgumentException is thrown - Add at least one Agent to the ArrayList and
   * create a valid team - Remove all agents from the team - Verify that the Team's size is now zero
   * 
   * @return
   */
  public static boolean testEmptyTeam() {
    ArrayList<Agent> l = new ArrayList<>();
    try {
      new Team(2, l);
      return false; // Team should not be created and exception thrown

    } catch (IllegalArgumentException e) {
      Agent ag1 = new Agent(1, 1);
      l.add(ag1);

      Team t = new Team(2, l);
      t.removeMember(ag1);
      int actualSize = t.getTeamSize();

      if (actualSize != 0) {
        return false;
      }

      return true;
    }
  }

  /**
   * Verifies that a Team can be created successfully with exactly one Lead.
   * 
   * This test should: - Create an ArrayList with one Lead and multiple regular Agents - Create a
   * Team with this ArrayList - Verify that the Team is created successfully - Verify that the Team
   * size matches the ArrayList size - Verify that all Agents are properly added to the Team -
   * Verify that the hasLead method correctly reports that this team has a Lead
   * 
   * @return true if Team creation succeeds with correct composition; false otherwise
   */
  public static boolean testValidTeamCreation() {
    ArrayList<Agent> agents = new ArrayList<>();
    agents.add(new Agent(1, 1));
    agents.add(new Agent(1, 1));
    agents.add(new Lead(1, 1));
    try {
      Team t = new Team(2, agents);

      // Sizes should be the same
      if (agents.size() != t.getTeamSize()) {
        return false;
      }

      if (!(t.contains(agents.get(0))) && !(t.contains(agents.get(1)))
          && !(t.contains(agents.get(2)))) {
        return false;
      }

      if (!t.hasLead()) {
        return false;
      }

    } catch (IllegalStateException e) {
      return false;
    } catch (IllegalArgumentException e) {
      return false;
    }

    return true;
  }

  /**
   * Verifies that a new Agent can be added to an existing Team.
   * 
   * This test should: - Create a valid Team with one Lead and at least one Agent - Create a new
   * Agent - Add the new Agent to the Team using addAgent() - Verify that the Team size has
   * increased - Verify that the new Agent is now a member of the Team
   * 
   * @return true if Agent is successfully added to Team; false otherwise
   */
  public static boolean testAddAgentToTeam() { 
    ArrayList<Agent> agts = new ArrayList<>();
    agts.add(new Agent(1,1));
    agts.add(new Lead(1,1));
    
    Team t = new Team(1, agts);
    int oldSize = t.getTeamSize();
    
    Agent toAdd = new Agent(2,2);
    t.addMember(toAdd);
    int newSize = t.getTeamSize();
    
    if (oldSize == newSize) {
      return false;
    }
    
    if (!t.contains(toAdd)) {
      return false;
    }
    
    return true;
  }

  /**
   * Verifies that Team’s center coordinates are calculated correctly.
   * 
   * This test should: - Create a Team with at least three Agents at known positions - Calculate the
   * expected center coordinates manually - Compare the expected values with getCenterX() and
   * getCenterY() results - Verify that adding a new Agent updates the center coordinates correctly
   * 
   * @return true if center coordinates are calculated correctly; false otherwise
   */
  public static boolean testTeamCenter() {
    // Set up agents to go into team.
    Agent a1 = new Agent(12, 234);
    Agent a2 = new Agent(14, 521);
    Agent a3 = new Agent(79, 345);
    ArrayList<Agent> agents = new ArrayList<>();
    agents.add(a1);
    agents.add(a2);
    agents.add(a3);

    Team team = new Team(20, agents);

    float expectedX = 45.5f;
    float expectedY = 377.5f;

    float actualX = team.getCenterX();
    float actualY = team.getCenterY();

    // Comparing using float comparisons
    if (!(Math.abs(expectedX - actualX) < 0.00001f)) {
      return false;
    }

    if (!(Math.abs(expectedY - actualY) < 0.00001f)) {
      return false;
    }

    return true; // Tests passed
  }

  /**
   * Runs all tests and displays results
   * 
   * @param args unused
   */
  public static void main(String[] args) {
    System.out.println("-----------------------------------------------------------");
    System.out
        .println("testAgentInitialPosition: " + (testAgentInitialPosition() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("testAgentMovement: " + (testAgentMovement() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("testAgentStationary: " + (testAgentStationary() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println(
        "testMultipleLeadsException: " + (testMultipleLeadsException() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("testEmptyTeam: " + (testEmptyTeam() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("testValidTeamCreation: " + (testValidTeamCreation() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("testAddAgentToTeam: " + (testAddAgentToTeam() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
    System.out.println("testTeamCenter: " + (testTeamCenter() ? "Pass" : "Failed!"));
    System.out.println("-----------------------------------------------------------");
  }

}
