// Provided File -- DO NOT SUBMIT THIS FILE TO GRADESCOPE

import java.util.ArrayList;

/**
 * A class to represent a playlist containing a list of songs. It supports adding songs, calculating
 * the total duration, and generating a formatted summary of the playlist.
 */
public class Playlist {
  // Instance fields
  /**
   * List of songs in the playlist.
   */
  private ArrayList<Song> songs;
  /**
   * Total duration of all songs in the playlist, in seconds.
   */
  private int totalDuration;

  // ANSI color codes for console output
  /**
   * ANSI escape code to reset text formatting.
   */
  public static final String ANSI_RESET = "\u001B[0m";
  /**
   * ANSI escape code for bright yellow text.
   */
  public static final String ANSI_BRIGHT_YELLOW = "\u001B[93m";

  /**
   * Constructs an empty {@code Playlist}.
   */
  public Playlist() {
    this.songs = new ArrayList<>();
    this.totalDuration = 0;
  }

  /**
   * Constructs a new {@code Playlist} with the specified songs and total duration. This constructor
   * is private and used internally for creating modified playlists.
   *
   * @param songs         the list of songs in the playlist. We assume songs is not null.
   * @param totalDuration the total duration of the playlist in seconds. We assume totalDuration > 0
   */
  private Playlist(ArrayList<Song> songs, int totalDuration) {
    this.songs = new ArrayList<>(songs);
    this.totalDuration = totalDuration;
  }

  /**
   * Returns a copy of the list of songs in the playlist.
   *
   * @return a list of songs in the playlist
   */
  public ArrayList<Song> getSongs() {
    return new ArrayList<>(songs);
  }

  /**
   * Returns the number of songs in the playlist.
   *
   * @return the number of songs in the playlist
   */
  public int size() {
    return this.getSongs().size();
  }

  /**
   * Returns the total duration of all songs in the playlist, in seconds.
   *
   * @return the total duration of the playlist in seconds
   */
  public int getTotalDuration() {
    return totalDuration;
  }

  /**
   * Determines if a song can be added to the playlist without exceeding the specified maximum
   * duration.
   *
   * @param song        the song to check. We assume song is not null.
   * @param maxDuration the maximum allowed duration for the playlist. We assume maxDuration is > 0.
   * @return if the song can be added without exceeding the maximum duration
   */
  public boolean canAddSong(Song song, int maxDuration) {
    return (totalDuration + song.getDuration()) <= maxDuration;
  }

  /**
   * Creates a new {@code Playlist} by adding the specified song. This method returns a new playlist
   * instance, leaving the original playlist unchanged.
   *
   * @param song the song to add to the playlist. We assume song is not null.
   * @return a new {@code Playlist} containing the original songs plus the added song
   */
  public Playlist addSong(Song song) {
    ArrayList<Song> newSongs = new ArrayList<>(songs);
    newSongs.add(song);
    return new Playlist(newSongs, totalDuration + song.getDuration());
  }

  /**
   * Returns a string representation of the playlist, including a summary of the songs and the total
   * duration.
   *
   * @return a formatted string representing the playlist
   */
  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append(ANSI_BRIGHT_YELLOW + "\uD83C\uDFB6Playlist Summary\uD83C\uDFB6\n" + ANSI_RESET);
    sb.append("-------------------------\n");
    for (int i = 0; i < songs.size(); i++) {
      Song song = songs.get(i);
      sb.append((i + 1) + ". " + songs.get(i).toString() + "\n");
    }
    sb.append("-------------------------\n");
    sb.append("Total Duration: " + totalDuration + " seconds\n");
    sb.append("Enjoy your music! \uD83C\uDFA7\n");
    return sb.toString();
  }

  /**
   * Compares the specified object with this playlist for equality. Returns true if and only if the
   * specified object is also a Playlist, both playlists have the same duration and have equal list
   * of songs.
   *
   * @param o the object to be compared for equality with this playlist
   * @return true if the specified object is equal to this playlist
   */
  @Override
  public boolean equals(Object o) {
    // ensure o is instance of Playlist
    if (o instanceof Playlist) {
      Playlist otherPlaylist = (Playlist) o;
      // ensure both playlists have the same duration and have equal list of songs
      // (both list of songs have the same size and elements in the two list of songs are equal).
      if (this.totalDuration == otherPlaylist.totalDuration && this.songs.size() == otherPlaylist.size()) {
        for (Song song : this.songs) {
          if (!otherPlaylist.songs.contains(song)) {
            return false; // different playlists
          }
        }
        return true;// equal playlists
      }
    }
    return false; // o is not a Playlist or playlists do not have equal durations and equal list of songs
  }

}
