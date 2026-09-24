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
 * Models a Team for the Team Party Hopping project
 */
public class Team {

  /**
   * A shared variable containing the identifier character to be used by the next team that is
   * suzzessfully created. Initialized to 'A'
   */
  private static char idGenerator = 'A';

  /**
   * The color in which this team's members are drawn in the application window when not active.
   */
  private int color;

  /**
   * A list of the current members of this Team
   */
  private ArrayList<Agent> members;

  /**
   * This team's unique identifer, set at construction
   */
  private final char TEAM_ID;

  /**
   * Attempts to create a new team from the provitded list of Agents, advancing the idGenerator to
   * the next valuse only if the team can be created successfully.
   * 
   * @param color  the color for this team's agents
   * @param agents a list of the agents to be added to this team.
   * @throws IllegalArgumentException if the agents list is empty
   * @throws IllegalStateException    if the agents list contains more than one Lead.
   */
  public Team(int color, ArrayList<Agent> agents)
      throws IllegalArgumentException, IllegalStateException {

    int leadCount = 0; // Will be used to keep track of how many Leads are in agents list.

    if (agents.isEmpty()) {
      throw new IllegalArgumentException("Error creating Team: no Agents found");
    }

    // Find # of leaders in array
    for (Agent ag : agents) {
      if (ag instanceof Lead) {
        ++leadCount;
      }
    }

    if (leadCount > 1) {
      throw new IllegalStateException("Error creating Team: More than one Lead found");
    }

    this.color = color;
    this.members = agents;
    TEAM_ID = idGenerator++;
  }

  /**
   * Accessor method for the color value of this team
   * 
   * @return the color value of this team.
   */
  public int getColor() {
    return this.color;
  }

  /**
   * Accessor method for the team's ID character
   * 
   * @return the team ID value as a char
   */
  public char getTeamID() {
    return TEAM_ID;
  }

  /**
   * Accessor method for the total number of agents on this team
   * 
   * @return the size of this team
   */
  public int getTeamSize() {
    return members.size();
  }

  /**
   * Reports whether this team currently has a Lead member
   * 
   * @return true if this team currently has a Lead member, false otherwise
   */
  public boolean hasLead() {
    for (Agent eg : members) {
      if (eg instanceof Lead) {
        return true;
      }
    }

    return false;
  }

  /**
   * Adds the given agent to this team's list. If the agent is already present, this does nothing.
   * 
   * @param a the agent to add to the list.
   * @throws IllegalStateException if the agent is a Lead that is not already in the list.
   */
  public void addMember(Agent a) throws IllegalStateException {
    if (a instanceof Lead && hasLead()) {
      throw new IllegalStateException("Error: cannot have more than one Lead per Team");

    } else {
      members.add(a);
    }
  }

  /**
   * Removes the provided agent from this team
   * 
   * @param a the agent to remove
   * @return true if the agent was removed successfully, false otherwise
   */
  public boolean removeMember(Agent a) {
    for (int i = 0; i < members.size(); ++i) {

      // == is okay here since we are comparing references to agents
      if (a == members.get(i)) {
        members.remove(a);
        return true;
      }
    }

    return false; // Made it through not finding the reference
  }

  /**
   * Accessor to determine whether a given agent is a memeber of this Team.
   * 
   * @param a the agent that may be a member of this team
   * @return true if this agent is in the members list, false otherwise
   */
  public boolean contains(Agent a) {
    if (members.contains(a)) {
      return true;

    } else {
      return false;
    }
  }

  /**
   * Activates ALL memebers of this team
   */
  public void selectAll() {

    for (Agent ag : members) {
      if (ag.getTeam() == null) {
        return;
      }
      // Only want to toggle inactive Agents to active and leave the already active agents alone
      if (!ag.isActive()) {
        ag.toggleActive();
      }
    }
  }

  /**
   * Checks wether ALL member of a team have been selected
   * 
   * @return true if ALL members in this Team are active, false otherwise
   */
  public boolean isActive() {
    
    for (Agent ag : members) {
      
      // If one member is inactive, then the ALL members are not active
      if (!ag.isActive()) {
        return false;
      }
    }
    
    return true;
  }

  /**
   * Finds the 'center' x-coordinate of this team, defined as being halfway between the left and
   * rightmost agents on this team.
   * 
   * @return the center x-coordinate of this team.
   */
  public float getCenterX() {
    float leftmostAgentX = 800;
    float rightmostAgentX = 0;
    
    // find left and right most agents
    for (int i = 0; i < members.size(); ++i) {
      if (members.get(i).getX() < leftmostAgentX) {
        leftmostAgentX = members.get(i).getX();
        
      } else if (members.get(i).getX() > rightmostAgentX) {
        rightmostAgentX = members.get(i).getX();
      }
    }
    
    // Calculate middle point
    float midX = (rightmostAgentX + leftmostAgentX) / 2;
    
    return (float) midX;
  }

  /**
   * Finds the 'center' y-coordinate of this team, defined as being halfway between the left and
   * rightmost agents on this team.
   * 
   * @return the center y-coordinate of this team.
   */
  public float getCenterY() {
    float topmostAgentY = 600;
    float bottommostAgentY = 0;
    
    // find left and right most agents
    for (int i = 0; i < members.size(); ++i) {
      if (members.get(i).getY() < topmostAgentY) {
        topmostAgentY = members.get(i).getY();
        
      } else if (members.get(i).getY() > bottommostAgentY) {
        bottommostAgentY = members.get(i).getY();
      }
    }
    
    // Calculate middle point
    float midY = (bottommostAgentY + topmostAgentY) / 2;
    
    return (float) midY;
  }

  /**
   * Updates the destination of all team members to that the current team formation will be
   * maintained, but after movement is completed the team will be centered over the given Party.
   * 
   * @param p the party to move the team to
   */
  public void sendToParty(Party p) {
    float partyLocX = p.getX();
    float partyLocY = p.getY();
    
    // Gives the x and y contributions that each agent needs to move
    float differenceX = partyLocX - getCenterX();
    float differenceY = partyLocY - getCenterY();
    
    // Add the difference to all Agents so they keep their orientation
    for (Agent ag : members) {
      ag.setDestination(ag.getX() + differenceX, ag.getY() + differenceY);
    }
  }

  /**
   * Updates the destination of all team members so that the team formation becomes a line centered
   * at getCenterX/getCenterY. Each member should be allocated their diameter + 3 pixels worth of
   * space in the line, to avoid overlapping with the agent next to them.
   */
  public void lineUp() {
    int teamSize = members.size();
    int lineUpWidth = (teamSize * 20) + ((teamSize - 1) * 3 ); 
    
    float lineUpY = getCenterY();
    float lineUpX = getCenterX() - (lineUpWidth / 2);
    float xOffset = 10; // Starts as radius of agent
    
    
    for (Agent ag : members) {
      ag.setDestination(lineUpX + xOffset, lineUpY);
      xOffset += Agent.diameter + 3; // move to the right to place the next Agent
    }
  }
}
