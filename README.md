# Housing Hope Data Team Infobase

Internal staff site for Housing Hope's data team. Hosted on GitHub Pages at [housinghopehelp.xyz](https://housinghopehelp.xyz).

## What this is

A static website that serves as a reference hub for Housing Hope staff — mostly training docs, system guides, and quick-access tools for day-to-day data work. Not a web app, just a collection of HTML pages with mixed styling (mostly Bootstrap, with some page-specific stylesheets).

## Site contents

- **Crisis page** — incident reporting steps and emergency contacts
- **Definitions** — HUD homelessness categories (chronic, literal, etc.)
- **Unit Designations** — dictionary of housing unit type codes
- **Program Enrollment (Prog)** — how to identify and enroll clients in programs
- **Entry/Exit** — adding/removing family members from programs
- **Updates** — move-in and assessment update procedures
- **Flowchart** — ADP system workflow
- **HMIS Updates 2025** — system changes for the year
- **Documents** — downloadable PDFs and forms (assessments, ROIs, housing plans)

## Python tools

A couple of utility scripts that staff download and run locally:

- `fscpanel.py` — tkinter-based GUI tool for processing housing data
- `adpnote.py` — PyQt5-based ADP payroll helper
- `RemotePythonInstaller.bat` — sets up Python + dependencies on staff machines

## Tech

Static HTML/CSS/JS with mixed page styling. No build step, no framework — just files served by GitHub Pages. Python tooling includes pandas, requests, tkinter, PyQt5, Pillow, and fuzzywuzzy.

## Access and visibility

The repository and GitHub Pages site are public. `robots.txt` and page-level `noindex` tags are configured to reduce search engine indexing, but they are not access controls.