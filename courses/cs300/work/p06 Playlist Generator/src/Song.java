// PROVIDED FILE - DO NOT SUBMIT THIS FILE TO GRADESCOPE


/**
 * A class to represent a song with a title, genre, and duration.
 */
public class Song {
  // Instance fields
  /**
   * Title of the song.
   */
  private String title;
  /**
   * Genre of the song.
   */
  private String genre;
  /**
   * Duration of the song in seconds.
   */
  private int duration; // Duration in seconds

  /**
   * Constructs a new Song object with the specified title, genre, and duration.
   *
   * @param title    the title of the song. We assume title is not null and is not blank.
   * @param genre    the genre of the song. We assume genre is not null and is not blank.
   * @param duration the duration of the song in seconds. We assume duration > 0.
   */
  public Song(String title, String genre, int duration) {
    this.title = title;
    this.genre = genre;
    this.duration = duration;
  }

  /**
   * Returns the title of the song.
   *
   * @return the title of the song
   */
  public String getTitle() {
    return title;
  }

  /**
   * Returns the genre of the song.
   *
   * @return the genre of the song
   */
  public String getGenre() {
    return genre;
  }

  /**
   * Returns the duration of the song in seconds.
   *
   * @return the duration of the song in seconds
   */
  public int getDuration() {
    return duration;
  }

  /**
   * Returns a string representation of the song, including its title, genre, and duration.
   *
   * @return a string representation of the song
   */
  @Override
  public String toString() {
    return title + " | Genre: " + genre + " | Duration: " + duration + "s]";
  }

  /**
   * Compares this song to the specified object for equality. Two songs are considered equal if they
   * have the same title, genre, and duration, ignoring case differences in the title and genre.
   *
   * @param anObject the object to compare with
   * @return if the given object represents an equivalent song
   */
  @Override
  public boolean equals(Object anObject) {
    // ensure anObject is instance of Song
    if (anObject instanceof Song) {
      Song s = (Song) anObject;
      // ensure both songs have the same title, genre, and duration. String comparison is case insensitive.
      return this.title.equalsIgnoreCase(s.title) && this.genre.equalsIgnoreCase(s.genre)
          && this.duration == s.duration;
    }
    return false;
  }
}
