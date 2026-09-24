import java.util.Objects;

/**
 * Instantiable class representing a single freeze/thaw record.
 */
public class LakeRecord {
  /**
   * The winter season (e.g., "2020-21").
   */
  private String winter;
  /**
   * The date the lake froze (e.g., "December 15")
   */
  private String freezeDate;
  /**
   * The date the lake thawed (e.g., "March 10")
   */
  private String thawDate;
  /**
   * The total number of days that the lake was frozen
   */
  private int daysOfIceCover;
  /**
   * Placeholder value for missing data
   */
  public static final int MISSING = -1;

  /**
   * Constructor to initialize a freeze-thaw record.
   * 
   * @param winter         The winter season (e.g., "2020-21").
   * @param freezeDate     The date the lake froze (e.g., "December 15") (nullable if not available)
   * @param thawDate       The date the lake thawed (nullable if not available).
   * @param daysOfIceCover The total frozen duration, MISSING if unknown.
   */
  public LakeRecord(String winter, String freezeDate, String thawDate, int daysOfIceCover) {
    this.winter = winter;
    this.freezeDate = freezeDate;
    this.thawDate = thawDate;
    this.daysOfIceCover = daysOfIceCover;
  }

  /**
   * Gets the winter season.
   * 
   * @return The winter season as a string.
   */
  public String getWinter() {
    return winter;
  }

  /**
   * Gets an integer representation of the winter
   * Ex. "1959-60" -> 1959
   *
   * @return The year in which the winter started as an int
   */
  public int getYear() {
    return Date.extractYear(winter);
  }

  /**
   * Gets the freeze-over date.
   * 
   * @return The freeze date as a string, or null if unavailable.
   */
  public String getFreezeDate() {
    return freezeDate;
  }

  /**
   * Gets the thaw date.
   * 
   * @return The thaw date as a string, or null if unavailable.
   */
  public String getThawDate() {
    return thawDate;
  }

  /**
   * Gets the total duration the lake remained frozen.
   * 
   * @return The number of frozen days.
   */
  public int getDaysOfIceCover() {
    return daysOfIceCover;
  }

  /**
   * Checks whether the record has both freeze and thaw dates specified.
   * 
   * @return True if both dates exist, false otherwise.
   */
  public boolean hasCompleteData() {
    return freezeDate != null && thawDate != null;
  }

  /**
   * Computes and updates the freeze duration if it's missing.
   */
  public void updateDuration() {
    if (daysOfIceCover == MISSING && hasCompleteData()) {
      int noOfDays = Date.daysBetween(winter, freezeDate, thawDate);
      if (noOfDays != -1) {
        daysOfIceCover = noOfDays;
      }
    }
  }

  /**
   * Merges this record with another record from the same winter. The freeze date remains the
   * earliest, the thaw date the latest, and durations are summed.
   * 
   * @param other Another LakeRecord from the same winter.
   */
  public void mergeWith(LakeRecord other) {
    if (!this.winter.equals(other.getWinter())) {
      throw new IllegalArgumentException("Cannot merge records from different winters!");
    }

    // Determine the earliest freeze date using Date.compareDates()
    if (other.getFreezeDate() != null && (this.freezeDate == null
        || Date.compareDates(other.getFreezeDate(), this.freezeDate) < 0)) {
      this.freezeDate = other.getFreezeDate();
    }

    // Determine the latest thaw date using Date.compareDates()
    if (other.getThawDate() != null && (this.thawDate == null
        || Date.compareDates(other.getThawDate(), this.thawDate) > 0)) {
      this.thawDate = other.getThawDate();
    }

    // Update freeze duration
    if (this.freezeDate != null && this.thawDate != null) {
      this.daysOfIceCover += other.daysOfIceCover;
    }
  }



  /**
   * Converts the record into a readable string.
   * 
   * @return A string representation of the record.
   */
  @Override
  public String toString() {
    return winter + " | Freeze: " + (freezeDate != null ? freezeDate : "Unknown") + " | Thaw: "
        + (thawDate != null ? thawDate : "Unknown") + " | Days: " + daysOfIceCover;
  }

  /**
   * Returns true if the two LakeRecords are equal, defined as having equal
   * the same winter, freeze date, thaw date, and total days of ice cover.
   *
   * @param o Another object to be tested for equality
   * @return boolean indicating whether the two objects are equal
   */
  @Override
  public boolean equals(Object o) {
    if (o instanceof LakeRecord) {
      LakeRecord other = (LakeRecord) o;
      return (this.winter.equals(other.getWinter()) &&
              Objects.equals(this.thawDate, other.getThawDate()) &&
              Objects.equals(this.freezeDate, other.getFreezeDate()) &&
              this.daysOfIceCover == other.getDaysOfIceCover());
    }
    return false;
  }

  /**
   * Creates a copy of the LakeRecord
   * @return a new LakeRecord with identical values
   */
  public LakeRecord copy() {
    return new LakeRecord(this.winter, this.freezeDate, this.thawDate, this.daysOfIceCover);
  }
}
