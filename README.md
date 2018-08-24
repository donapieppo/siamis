Unibo-Siam Conference Management System
=============

Rails application used to organize Siam-is8 conference in Bologna, Italy.

### Main features

  - Users with [https://github.com/plataformatec/devise|Devise]
  - Users can be in (scientific | organizing | management | local) committee  with different roles
  - Authors can manage Plenaries / Minitutorials
  - Authors can submit and manage Minisymposia / Presentations / Posters
  - Authors can manage their presentations in Minisymposia
  - Various tools for administrators

## Requirements

*  Rails 5
*  Ruby 2.3+

## Languages 

*  English

## Database main tables 

### conference_sessions

This is the main table in the database. The field 

`t.string "type", limit: 18` in 'Minisymposium', 'Minitutorial', 'Plenary', 'PosterSession', 'ContributedSession', 'ConferenceBreak'`

In `app/models` you find the general 

`class ConferenceSession < ApplicationRecord` 

and two main subclasses

`class MonoConferenceSession < ConferenceSession ` and
`class MultipleConferenceSession < ConferenceSession`

In particular

`class Minitutorial < MonoConferenceSession`
`class Plenary < MonoConferenceSession`
`class PanelSession < MonoConferenceSession`

are subclasses of MonoConferenceSession which means that the
session includes only one presentation

`class Minisymposium < MultipleConferenceSession`

instead includes many presentations.

