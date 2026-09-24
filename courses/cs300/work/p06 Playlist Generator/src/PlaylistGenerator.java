//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title:    Playlist Generator
// Course:   CS 300 Spring 2025
//
// Author:   Jake Christofferson  
// Email:    ejchristoffe@wisc.edu 
// Lecturer: Mouna Kacem
//
//////////////////// PAIR PROGRAMMERS COMPLETE THIS SECTION ///////////////////
// 
// Partner Name:    Sri Chirumanilla
// Partner Email:   chirumanilla@wisc.edu
// Partner Lecturer's Name: Mouna Kacem
// 
// VERIFY THE FOLLOWING BY PLACING AN X NEXT TO EACH TRUE STATEMENT:
//   _x_ Write-up states that pair programming is allowed for this assignment.
//   _x_ We have both read and understand the course Pair Programming Policy.
//   _x_ We have registered our team prior to the team registration deadline.
//
//////////////////////// ASSISTANCE/HELP CITATIONS ////////////////////////////
//
// Persons: none
// Online Sources: 
//  https://www.geeksforgeeks.org/introduction-to-backtracking-2/
//  - Helped understand what backtracking is and how we should implement it in
//    our program
//
//  Zybooks chapter 7.8
//  - Helped us understand how to create all permutations of a list
//
///////////////////////////////////////////////////////////////////////////////

import java.util.ArrayList;

/**
 * A utility class for generating playlists based on different strategies. This class provides
 * methods to generate playlists using simple, permutation-based, and optimal backtracking
 * approaches.
 */
public class PlaylistGenerator {

  /**
   * RECURSIVE method: Generates a simple playlist by adding the first available songs until the
   * maximum duration is reached.
   *
   * @param songs       the list of available songs
   * @param playlist    the current playlist being generated
   * @param maxDuration the maximum allowed duration for the playlist
   * @return a playlist containing songs that fit within the specified duration
   */
  public static Playlist simplePlaylist(ArrayList<Song> songs, Playlist playlist, int maxDuration) {
    if (songs.isEmpty() || playlist.getTotalDuration() >= maxDuration) {
      return playlist;
    }

    // Recursive
    Song first = songs.remove(0);

    if (playlist.getTotalDuration() + first.getDuration() <= maxDuration) {
      playlist = playlist.addSong(first);

    }

    // Recursively add the next song using the same list, now with the newly added song
    return simplePlaylist(songs, playlist, maxDuration);
  }

  /**
   * RECURSIVE method: Generates all permutations of the given song list.
   *
   * @param songs  the list of songs to permute
   * @param index  the current index for generating permutations
   * @param result the list to store ALL the generated permutations
   */
  public static void generatePermutations(ArrayList<Song> songs, int index,
      ArrayList<ArrayList<Song>> result) {
    if (songs.isEmpty() || index < 0 || index > songs.size() - 1) {
      
      return;
    }
    // Base Case
    if (index == songs.size() - 1) {
      ArrayList<Song> songCopy = new ArrayList<>(songs);
      result.add(songCopy);
      return;
    }

    // Recursive
    for (int i = index; i < songs.size(); ++i) {

      Song swap = songs.get(index);
      songs.set(index, songs.get(i));
      songs.set(i, swap);

      generatePermutations(songs, index + 1, result);

      swap = songs.get(index);
      songs.set(index, songs.get(i));
      songs.set(i, swap);
      
    }
  }

  /**
   * Generates the best possible playlist by evaluating all permutations of the song list. It
   * selects the permutation that maximizes the total playlist duration without exceeding the limit.
   *
   * @param songs       the list of available songs
   * @param maxDuration the maximum allowed duration for the playlist
   * @return the best possible playlist based on all song permutations
   */
  public static Playlist bestPermutationPlaylist(ArrayList<Song> songs, int maxDuration) {
    ArrayList<ArrayList<Song>> allPerms = new ArrayList<>();
    generatePermutations(songs, 0, allPerms);

    // Holds our current longest playlist
    Playlist bestPlaylist = new Playlist();


    for (int i = 0; i < allPerms.size() - 1; ++i) {

      ArrayList<Song> currPerm = allPerms.get(i);

      // Make the permutation constrained by maxDuration
      Playlist playlist = simplePlaylist(currPerm, new Playlist(), maxDuration);

      if (playlist.getTotalDuration() > bestPlaylist.getTotalDuration()) {
        bestPlaylist = playlist;
      }
    }

    return bestPlaylist; // default return statement
  }


  /**
   * RECURSIVE method: Generates an optimal playlist using a backtracking approach to maximize the
   * total duration while staying within the maximum allowed duration.
   *
   * @param songs       the list of available songs
   * @param playlist    the current playlist being generated
   * @param maxDuration the maximum allowed duration for the playlist
   * @return the optimal playlist with the maximum possible duration based on the backtracking
   *         approach
   */
  public static Playlist optimalPlaylist(ArrayList<Song> songs, Playlist playlist,
      int maxDuration) {

    // Make sure playlist isn't already full
    if (playlist.getTotalDuration() >= maxDuration) {
      return playlist;
    }

    // Means we found a dead end
    if (songs.isEmpty()) {

      return playlist;
    }

    // Copy current working playlist so new iterations can be stored and worked on correctly
    Playlist copyOfCurrent = new Playlist();
    copyOfCurrent = simplePlaylist(playlist.getSongs(), copyOfCurrent, maxDuration);

    // All possibilities if we do not use the new song
    Playlist withoutSong = optimalPlaylist(new ArrayList<>(songs.subList(1, songs.size())),
        copyOfCurrent, maxDuration);

    Song song = songs.get(0);

    /*
     * See if song can be added, if it can add it to the working playlist and then use recurstion to
     * iterate through all other possibilites. If song cannot be added just return the best possible
     * playlist from withoutSong
     */
    if (playlist.canAddSong(song, maxDuration)) {

      copyOfCurrent = copyOfCurrent.addSong(song);
      Playlist withSong = optimalPlaylist(new ArrayList<>(songs.subList(1, songs.size())),
          copyOfCurrent, maxDuration);

      // Pick witch playlist is better
      if (withSong.getTotalDuration() > withoutSong.getTotalDuration()) {
        return withSong;
      } else {
        return withoutSong;
      }

    }
    return withoutSong;
  }


}
