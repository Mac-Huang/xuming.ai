// DO NOT SUBMIT THIS SOURCE FILE TO GRADESCOPE
/**
 * This enumeration defines the different types of Hobbemoun
 *
 * @author Kendall and Ruifeng
 *
 */
public enum HobbemounType {

  /**
   * Normal Type
   */
  NORMAL(5),
  /**
   * Psychic Type
   */
  PSYCHIC(5),
  /**
   * Water Type
   */
  WATER(4),
  /**
   * Electric Type
   */
  ELECTRIC(4),
  /**
   * Ground Type
   */
  GROUND(3),
  /**
   * Ice Type
   */
  ICE(3),
  /**
   * Flying Type
   */
  FLYING(3),
  /**
   * Dragon Type
   */
  DRAGON(3),
  /**
   * Ghost Type
   */
  GHOST(2),
  /**
   * Grass Type
   */
  GRASS(2),
  /**
   * Fire Type
   */
  FIRE(2),
  /**
   * Rock Type
   */
  ROCK(2),
  /**
   * Fighting Type
   */
  FIGHTING(1),
  /**
   * Poison Type
   */
  POISON(1),
  /**
   * Bug Type
   */
  BUG(1);

  private int value;

  /**
   * Constructor for HobbemounType
   *
   * @param value the value of the HobbemounType
   */
  private HobbemounType(int value) {
    this.value = value;
  }

  /**
   * Gets the value of the HobbemounType
   *
   * @return the value of the HobbemounType
   */
  public int getValue() {
    return this.value;
  }


}
