# CaseNoter — Staff Getting-Started Guide Brief

**For:** Whoever is writing the staff-facing guide
**What is CaseNoter:** A small app that lets Housing Hope staff write Apricot case notes fast. It runs entirely on their Windows PC — no install, no admin rights, no cloud account to create.

---

## What staff receive

A zip from the [GitHub releases page](https://github.com/GearUnclear/casenoter/releases) containing three files:

| File | What it is | Changes? |
|------|-----------|----------|
| `casenoter-helper.exe` (~6 MB) | The background helper that bridges the app to Apricot. | Rarely. One-time delivery. |
| `casenoter.html` (~130 KB) | The app itself. | Yes — when the app is updated, a new HTML is emailed out. Staff save it over the old one. |
| `STAFF_README.txt` (~3 KB) | Quick-start instructions (plain text). | Your guide is the polished version of this. |

All three ship together in the initial zip. After that, only `casenoter.html` gets re-sent (via email, since it's small and email doesn't block .html files). The exe and README are one-time.

---

## First-time setup (the flow to document)

### 1. Create a folder

Staff should make a folder somewhere they won't lose it. `C:\CaseNoter\` is a fine default. Put both files in it, side by side.

### 2. Run the helper

Double-click `casenoter-helper.exe`. Two things will happen:

- **SmartScreen warning** (first time only): Windows shows a blue "Windows protected your PC" popup. Staff click **"More info"** then **"Run anyway"**. This is normal for unsigned programs. Screenshot this for the guide — it's the #1 thing that scares people.
- **A black command-prompt window opens.** This is the helper running. It stays open the whole time they use CaseNoter. Closing it stops the app. They don't need to type anything in it.

### 3. Browser opens automatically

The helper launches their default browser to `http://127.0.0.1:8765`. If it doesn't open for some reason, they can type that address manually.

### 4. Finish setup

The app shows a setup page asking for three things:

1. **Master passphrase** — they choose this. Minimum 8 characters. It encrypts everything on their computer. **There is no recovery if they forget it.** Tell them to write it down somewhere safe (not a sticky note on the monitor).
2. **Confirm passphrase** — type it again.
3. **Apricot API credentials** — Client ID and Client Secret. Staff do **not** obtain these themselves. They must use the Client ID and Client Secret provided by their administrator (Dane) and paste those values into setup.

**Who gives them API credentials?** Staff cannot obtain these credentials themselves. Their administrator (Dane) must provide the Client ID and Client Secret. Document this as an administrator-provided step, not a staff self-service step.

With the passphrase and credentials entered, staff click **"Set up CaseNoter."** The app then builds a local copy of participant enrollments. This takes about **1 to 3 minutes** the first time — the data is pulled in batches of 5,000 records from Apricot, and there are roughly 30,000 records total. After that, startup is quick. The sync of contact notes (as displayed) can take a few minutes as well. Encourage users to be mindful of this initial load time — it occurs once per day currently.

---

## Daily use (the flow after setup)

1. Double-click `casenoter-helper.exe` (the black window opens).
2. Browser opens to CaseNoter.
3. Type passphrase to unlock.
4. Search for a participant, pick Contact Documentation or Meeting Narrative, fill it in, save.

That's it. The guide should make daily use feel like second nature — it's the same 4 steps every time.

---

## Writing a case note (the core workflow)

1. **Search** — type a name or HMIS number. Only participants with a Housing enrollment appear.
2. **Pick the participant** — their Housing enrollment info shows up.
3. **Choose note type** — Contact Documentation or Meeting Narrative. This is asked immediately after picking a participant, before any form fields.
4. **Enrollment auto-maps** — CaseNoter figures out which Housing program enrollment matches the note's date. The matched enrollment is highlighted. Staff should glance at it and confirm it's right (especially if someone has multiple enrollments).
5. **Fill in the form** — the fields match what they see in Apricot (Date Contacted, Contact Type, Summary, etc.).
6. **Other Residents Present** — if applicable, fuzzy-search for other residents to link.
7. **Save** — click "Save note to Apricot." Done.

---

## Things staff need to understand

### "Pending" notes and offline resilience

Notes are encrypted and saved locally *first*, then synced to Apricot. If the internet drops mid-save, the note is safe on their computer. The top bar shows a "pending" indicator. When they're back online, click "sync now." A note is only deleted from their computer after Apricot confirms it saved (201 response).

### Re-sync button

The participant/enrollment cache refreshes itself every 2 weeks. If a brand-new enrollment isn't showing up, click **"Re-sync"** in the top bar to force a fresh pull. This takes 1–3 minutes.

### Lock vs. close

- **Lock** (in the app): locks the screen, requires passphrase again. The helper keeps running.
- **Close the black window**: stops the helper entirely. The browser tab goes dead.

### Updating the app

When they receive a new `casenoter.html` by email: save it into their CaseNoter folder, replacing the old one. Refresh the browser. The helper exe stays the same — they never need a new one unless told otherwise.

---

## Common problems to cover in the guide

| Problem | What's happening | Fix |
|---------|-----------------|-----|
| Blue "Windows protected your PC" popup | SmartScreen blocking unsigned exe | Click "More info" then "Run anyway" |
| Browser doesn't open | Helper is running but didn't launch browser | Manually go to `http://127.0.0.1:8765` |
| "Helper not detected" warning on the page | Helper exe isn't running or was closed | Make sure the black command window is open |
| Can't find a participant | They may not have a Housing enrollment, or the cache is stale | Click Re-sync; if still missing, they genuinely have no Housing enrollment |
| "Forgot my passphrase" | No recovery possible | Must reset: delete `casenoter_data` folder, clear browser data for `127.0.0.1:8765`, redo first-time setup |
| Note stuck as "pending" | Internet was down when they saved, or Apricot is down | Click "sync now" when connection is back |
| Enrollment doesn't match | Multiple Housing enrollments or dates don't line up | Staff can manually pick the right enrollment from the list |

---

## How to fully reset (for your screenshots / testing)

To get back to the first-time setup screen:

1. Close the helper (close the black window).
2. Delete the `casenoter_data` folder (next to the exe).
3. Open Chrome, press F12, go to Application > Storage > click "Clear site data" (make sure you're on `http://127.0.0.1:8765`).
4. Re-launch the helper. You'll see the first-time setup screen.

---

## Tone and audience notes

- Staff are **not technical**. They are housing case workers. Avoid jargon.
- Use screenshots liberally, especially for SmartScreen and the first-time setup screen.
- The word "server" will confuse people. Call it "the helper" or "the background program."
- The black command window will worry people. Reassure them it's normal and they don't need to type in it.
- "127.0.0.1" will confuse people. If you need to reference it, say "the app runs on your own computer, not on the internet" — that's the important part.
- Keep it short. These are busy people writing case notes between client meetings.
