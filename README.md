# Dashboarding
## todo
 - [ ] Flesh out feature list
 - [ ] Come up with estimated time of completion for each feature
 - [ ] Create timeline with those estimations

## District Information

This part is pretty simple; it just needs to be a map showing some info about the district and the candidates running in it.

## Election Results

Election results is something we'll need to touch on, but isn't as important for the MVP version.

Virginia has live reporting but we don't need to worry about this until next year.
https://results.elections.virginia.gov/vaelections/2022%20November%20General/Site/Statistics/Index.html

Historic results from this link in CSV form
https://apps.elections.virginia.gov/SBE_CSV/ELECTIONS/ELECTIONRESULTS/

## Finance Data

Finance data we need is mostly going to be a tracker for the candidate running in the district and their cash on hand + Dominion specific data. 
Finance stuff is only going to be up to date as they file their finances, which is quarterly for federal and I'm not actually sure about state.

Simple CSV files available for state candidate finances, but we'll need to calculate COH I think.
https://apps.elections.virginia.gov/SBE_CSV/CF/

For federal candidates we'll need to get finance data from the FEC.
They have an API documentation here which will return a detailed JSON response with everything we need.

## Polling Data

This is you guys, I'm gonna need help with this one because I don't really know what you do for them.

I'll get with you to talk about what I've done and what needs to be done first in a little bit but I have some other things I need to get done as well.
