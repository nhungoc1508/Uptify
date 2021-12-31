# Uptify

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Uptify is an app for getting statistics of user's Spotify usage.

### App Evaluation
- **Category:** Music
- **Mobile:** iOS
- **Story:** User of the app can get in-depth insights into their own music listening habits from statistics of their Spotify usage.
- **Market:** Frequent Spotify users who want to get insights into their listening history and habits.
- **Habit:** Spotify users are usually curious about their listening habits and want to view by year/month/etc.
- **Scope:** TBA

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can log in with their Spotify account
* User can see information from different time windows: last month, last 6 months, all time
* User can see their top artists
* User can see their top individual tracks

**Optional Nice-to-have Stories**

* User can get recommendations of artists based on their top artists
* User can get recommendations of tracks based on their top tracks

**Nice-to-have Stories that are not yet possible with Spotify API**

* User can see their top albums
* User can see their top genres
* User can select custom time window (minimum 7 days)
* User can see their top tracks from an artist
* User can see their top tracks from a genre
* User can see total time they spent listening to an artist
* User can see total times they play a track

### 2. Screen Archetypes

* **Login**
   * Log In View: User can log in using their Spotify account
* **Stream**
   * Category View: User can choose a category to view (artists, tracks)
   * Statistics View: User can see statistics in a category from a chosen time window
* **Detail - Optional**
    * Detail View: User can see statistics related to a specific artist/track e.g.
        * Top tracks from an artist

### 3. Navigation

**Flow Navigation** (Screen to Screen)

* Log In View
   * → Category View
* Category View
   * → Statistics View
* Statistics View
    * → Detail View
    * → Category View
* Detail View
    * → Category View

## Wireframes

[Wireframe diagrams go here]

### Interactive Prototype
[Interactive prototypes go here]

## Schema 

The app does not store user data. It only analyzes existing user's Spotify data.

### Networking
Spotify Web API: https://developer.spotify.com/documentation/web-api/reference/#/
SpotifyLogin: https://github.com/spotify/SpotifyLogin/

| HTTP verb | Endpoint | Description |
| - | - | - |
| GET | /me/top/artists | Get user's top artists |
| GET | /me/top/tracks | Get user's top tracks |
| GET | /recommendations | Get recommended tracks |