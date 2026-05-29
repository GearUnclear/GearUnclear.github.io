CaseNoter — quick start
=======================

CaseNoter writes Apricot case notes fast. It comes as two files that live
together in one folder:

  casenoter-helper.exe   the background bridge to Apricot (install once)
  casenoter.html         the app itself (you'll be re-emailed this now and then)

You do NOT need administrator rights, and you do NOT need to install anything.


First time
----------
1. Make a folder for it, e.g.  C:\casenoter\
2. Put BOTH files in that folder, side by side.
3. Double-click  casenoter-helper.exe
     - Windows may show a blue "Windows protected your PC" box the first time.
       Click "More info" -> "Run anyway". (This is normal for new programs.)
     - A small black window opens and stays open — that's the helper. Leave it
       running while you use CaseNoter. Closing it closes the app.
4. Your browser opens to CaseNoter automatically. If it doesn't, open your
   browser and go to:  http://127.0.0.1:8765
5. The first screen asks you to:
     - choose a MASTER PASSPHRASE (you'll type this each time you open the app),
       and
     - paste your Apricot API Client ID and Client Secret (from your
       administrator / account.bonterra.network/api-creds).
   Everything is encrypted on your computer with that passphrase. There is no
   way to recover it if you forget it — write it down somewhere safe.


Every day after that
---------------------
1. Double-click  casenoter-helper.exe  (the black window).
2. The browser opens CaseNoter.
3. Type your passphrase to unlock.


Writing a note
--------------
1. Search for the participant by name or HMIS number. (Only people with a
   Housing enrollment show up.)
2. Pick the participant, then choose Contact Documentation or Meeting Narrative.
3. The form appears. CaseNoter automatically figures out which Housing program
   to attach the note to, based on the note's date — check the highlighted
   enrollment and adjust if needed.
4. Fill in the note. Add other residents present if any.
5. Click "Save note to Apricot."


Good to know
------------
- Notes are saved on your computer first (encrypted), then sent to Apricot. If
  your internet drops, the note is safe and the top bar shows "pending — sync
  now." Click it once you're back online. A note is only removed from your
  computer once Apricot confirms it saved.
- "Re-sync" (top bar) refreshes the list of participants and enrollments. It
  refreshes itself every couple of weeks, but click it if someone's brand-new
  enrollment isn't showing up yet.
- "Lock" locks the app without closing it. You'll need your passphrase again.


When you get a new casenoter.html by email
-------------------------------------------
Just save it into your CaseNoter folder, replacing the old one. The helper exe
stays the same — you don't need a new one. Refresh the browser.
