# Virginia Dashboard
## Timeline
![example](/examples/download.png)

## Mockup Screenshots
### Statewide Ex. 
![example](/examples/Dashboard_Ex-State.svg)

### Congressional District Ex.
![example](/examples/Dashboard_Ex-District.svg)

## District Information

This part is pretty simple; it just needs to be a map showing some info about the district and the candidates running in it.

We can use tool tips to communicate basic information the way VPAP does:
![example](/examples/VPAP.png)

More complex information can be conveyed to the side or bottom of the map:
![example](/examples/SideBar.png)

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

## Important Links 
https://help.displayr.com/hc/en-us/articles/4403869071247

https://app.displayr.com/Dashboard?project_id=-995416#page=d10d9703-0b53-4bdc-a331-cf9878b4e80f


### Notes for jacob
here is a list of tools I've found really helpful in my development

vscode > R studio is my preference  there are reasons for this like support for any language, but one of the best features is the git integration. You can pull this repository onto your computer by selecting clone a repository after opening vscode and telling where to download to. After doing this all you'll need to do is edit files, save them and when you're done click commit and push. All of our changes will be synced up automatically.

`run commands formatted like this in powershell which is included with windows`

1. [python](https://www.python.org/downloads/release/python-3112/) + pipx
   * used to install radian
   * after installing python :
   * `py -3 -m pip install --user pipx`
   * `py -3 -m pipx ensurepath`
2. radian
   * modern revision of the R console
   * `pipx install -U radian`
   * `Get-Command radian` will show your radian path used below
3. [vscode](https://code.visualstudio.com/) with R extensions 
   1. R
      * change setting: File > Preferences > Settings > Extensions > R > Plot: Use Httpgd [x]
      * change setting: File > Preferences > Settings > Extensions > R > Rterm: Windows to your radian path (likely "C:\Python311\Scripts\radian.exe")
   2. R Debugger
4. R packages used by the R extension
   * install.packages("languageserver")
   * install.packages("styler")
   * install.packages("lintr") - make sure you copy the .lintr file into your project root or most everything will be underlined.
   * install.packages("httpgd")
    