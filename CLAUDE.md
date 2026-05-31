# CLAUDE.md — Claude Code Workshop
## Project: AI Running Coach

> **Budget note:** This project runs on a Windows 11 laptop with Git and PowerShell as the baseline.
> All AI intelligence is delivered through Claude Code (claude-sonnet-4-6) and the `running-coach`
> skill. Data lives in Markdown and CSV flat files. Stack is deliberately lean, free-or-cheap,
> and expandable — each layer below is optional and easy to install when ready.

---

## Table of Contents

1. [Project Purpose](#1-project-purpose)
2. [Architecture](#2-architecture)
3. [Folder Structure](#3-folder-structure)
4. [Tech Stack](#4-tech-stack)
   - [Baseline (installed now)](#baseline-installed-now)
   - [Tier 1 — Easy wins, free, install in minutes](#tier-1--easy-wins-free-install-in-minutes)
   - [Tier 2 — Richer data & visualisation](#tier-2--richer-data--visualisation)
   - [Tier 3 — Automation & integrations](#tier-3--automation--integrations)
5. [Coach Persona & Style Rules](#5-coach-persona--style-rules)
6. [Workflow — How to Generate a Weekly Plan](#6-workflow--how-to-generate-a-weekly-plan)
7. [Training Data Format](#7-training-data-format)
8. [Knowledge Base Index](#8-knowledge-base-index)
9. [Logic & Decision Rules](#9-logic--decision-rules)
10. [Git Workflow](#10-git-workflow)
11. [Quick Reference — Invoke the Coach](#11-quick-reference--invoke-the-coach)

---

## 1. Project Purpose

Build a personal AI running coach that:
- Ingests last week's training reports and HRV data
- Draws on a curated knowledge base of training principles
- Produces a personalised, HR-zone-based training plan for the coming week
- Adapts tone and depth to the runner's current fitness journey stage

---

## 2. Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER INTERFACE                           │
│              Claude Code CLI / Desktop App                      │
│         (type questions, share screenshots, ask for plans)      │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                       AI LAYER                                  │
│                                                                 │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │           Claude Code  (claude-sonnet-4-6)              │   │
│   │                                                         │   │
│   │   ┌───────────────────────────────────────────────┐     │   │
│   │   │        running-coach Skill                    │     │   │
│   │   │  • HRV readiness analysis                     │     │   │
│   │   │  • Zone-based plan builder (80/20 rule)       │     │   │
│   │   │  • Training report interpreter                │     │   │
│   │   │  • Injury & nutrition guidance                │     │   │
│   │   └───────────────────────────────────────────────┘     │   │
│   └─────────────────────────────────────────────────────────┘   │
└──────────────────────────┬──────────────────────────────────────┘
                           │  reads / writes
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                      DATA LAYER                                 │
│                   (flat files in Git)                           │
│                                                                 │
│  ┌──────────────────┐  ┌─────────────────┐  ┌───────────────┐  │
│  │  Knowledge Base  │  │Training Reports │  │ Weekly Plans  │  │
│  │  (.md files)     │  │ (.md / .csv)    │  │  (.md files)  │  │
│  │                  │  │                 │  │               │  │
│  │ • HR zones       │  │ • Run sessions  │  │ • Zone tables │  │
│  │ • HRV logic      │  │ • HRV data      │  │ • Session why │  │
│  │ • Race paces     │  │ • RPE & notes   │  │ • Coach notes │  │
│  │ • Injury guides  │  │ • Weekly totals │  │               │  │
│  └──────────────────┘  └─────────────────┘  └───────────────┘  │
└──────────────────────────┬──────────────────────────────────────┘
                           │  versioned by
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                    VERSION CONTROL                               │
│                       Git 2.54                                  │
│          Full training history · rollback · diffs               │
└─────────────────────────────────────────────────────────────────┘

   OPTIONAL FUTURE LAYERS (see Tech Stack §4)
   ┌──────────────┐   ┌──────────────┐   ┌──────────────────────┐
   │   Python     │   │  SQLite DB   │   │  Streamlit / Marimo  │
   │  (Tier 1)    │──▶│  (Tier 2)    │──▶│  local dashboard     │
   │  parse CSVs  │   │  history     │   │  (Tier 2)            │
   └──────────────┘   └──────────────┘   └──────────────────────┘
```

### Data flow for weekly plan generation

```
[You fill in Training Report] ──▶ [running-coach reads report + KB]
                                          │
                              ┌───────────▼────────────┐
                              │  HRV readiness check   │
                              │  Load trend analysis   │
                              │  Zone balance review   │
                              └───────────┬────────────┘
                                          │
                              ┌───────────▼────────────┐
                              │  Generate weekly plan  │
                              │  (zone-labelled table) │
                              └───────────┬────────────┘
                                          │
                              [Saved to Weekly Plans\]
                              [Committed to Git]
```

---

## 3. Folder Structure

```
C:\Claude-GIT\
├── CLAUDE.md                              ← You are here — project bible
├── Working Documents\
│   ├── Knowledge Base\                    ← Training science refs, zone tables, injury guides
│   │   ├── hr-zones.md
│   │   ├── hrv-interpretation.md
│   │   ├── race-equivalence.md            ← (to add)
│   │   ├── 80-20-principles.md            ← (to add)
│   │   ├── injury-protocols.md            ← (to add)
│   │   └── nutrition-guidelines.md        ← (to add)
│   ├── Training Reports\                  ← Weekly exports from wearable / manual logs
│   │   └── TEMPLATE_week-report.md        ← Copy & fill in each week
│   └── Weekly Plans\                      ← Coach-generated plans, one per week
│       └── YYYY-MM-DD_plan.md
```

### What goes where

| Folder | Contents | Format |
|--------|----------|--------|
| `Knowledge Base\` | HR zone tables, 80/20 principles, race equivalence, injury protocols | `.md` |
| `Training Reports\` | Last week's run data — distance, time, HR, HRV, RPE notes | `.md` or `.csv` |
| `Weekly Plans\` | Coach-generated plans, dated `YYYY-MM-DD_plan.md` | `.md` |

---

## 4. Tech Stack

### Baseline (installed now)

| Layer | Tool | Status | Cost |
|-------|------|--------|------|
| AI Engine | Claude Code (claude-sonnet-4-6) | ✅ Running | Claude Code subscription |
| Running Coach Skill | `anthropic-skills:running-coach` | ✅ Active | Included |
| Scripting | PowerShell 5.1 | ✅ Installed | Free |
| Version Control | Git 2.54 | ✅ Installed | Free |
| Data Format | Markdown + CSV | ✅ No install | Free |

---

### Tier 1 — Easy wins, free, install in minutes

These require one installer download each. No accounts, no config complexity.

| Tool | What it adds | Install | Cost |
|------|-------------|---------|------|
| **Python 3.12** | Parse Garmin/Strava CSVs, data processing | `winget install Python.Python.3.12` or python.org | Free |
| **uv** (Python pkg manager) | Fast, zero-config package installs — replaces pip | `winget install astral-sh.uv` | Free |
| **VS Code** | Better editor with Markdown preview, Git UI | `winget install Microsoft.VisualStudioCode` | Free |
| **Obsidian** | Visual Knowledge Base editor, links between notes | obsidian.md — one-click installer | Free |
| **SQLite** (via Python) | Persistent runner history DB, no server needed | `uv add sqlite-utils` (once Python installed) | Free |

> **Recommended first install:** Python 3.12 + uv. Unlocks everything in Tier 2.
> Run in PowerShell: `winget install Python.Python.3.12 astral-sh.uv`

---

### Tier 2 — Richer data & visualisation

Requires Python (Tier 1). All installable with one `uv add` command.

| Library / Tool | What it adds | Install command | Cost |
|---------------|-------------|-----------------|------|
| **pandas** | Parse and analyse CSV exports from Garmin/Strava | `uv add pandas` | Free |
| **matplotlib** | Zone distribution charts, weekly load graphs | `uv add matplotlib` | Free |
| **Marimo** | Interactive local notebook — replace Excel for analysis | `uv add marimo` | Free |
| **Streamlit** | Local web dashboard for plans and history | `uv add streamlit` | Free |
| **sqlite-utils** | Query training history from CLI or Python | `uv add sqlite-utils` | Free |
| **rich** | Beautiful terminal output for coach summaries | `uv add rich` | Free |

> **Recommended combo:** pandas + matplotlib + Marimo gives you a full local analytics notebook
> with zero cloud dependency.

---

### Tier 3 — Automation & integrations

For when the project matures. Some require free API keys.

| Tool | What it adds | Notes | Cost |
|------|-------------|-------|------|
| **Strava API** | Auto-pull weekly runs — no manual logging | Free developer account at strava.com | Free tier |
| **Garmin Connect API** (unofficial) | Pull HRV, sleep, run data from Garmin | `uv add garminconnect` | Free |
| **Whoop API** | Pull recovery/HRV/strain scores | Free dev access via whoop.com/developers | Free |
| **Node.js** | Full local web UI, richer interactivity | `winget install OpenJS.NodeJS.LTS` | Free |
| **ntfy.sh** | Push notifications to phone (e.g. plan ready) | No install — HTTP POST from PowerShell | Free tier |

---

## 5. Coach Persona & Style Rules

### Hat 1 — Conversational Coach (daily queries, quick questions)
- Tone: warm, direct, encouraging without being hollow
- Style: plain prose, 2–4 paragraphs, running community language (Z2, PR, taper, decoupling)
- Beginner → extra warmth, keep it simple and actionable
- Advanced → technical depth, zone percentages, acute/chronic load ratios

### Hat 2 — Plan Builder (weekly plan generation)
- Tone: authoritative, structured, evidence-based
- Style: always produce a table with zone labels on every session
- Always explain the *why* behind each session type
- Lead with HRV/readiness data before prescribing load
- Apply 80/20 rule: ~80% Z1–Z2, ~20% Z3–Z5

### Hat 3 — Report Analyst (reading training data)
- Tone: clinical but supportive, like a coach reviewing film
- Style: structured 5-point output — Summary → Zone Balance → Load Trend → Adjustments → Flags
- Flag overreaching, Z3 grey-zone excess, HR decoupling, load spikes before they become injuries

### Shared rules across all hats
- Always zone-first, pace-second
- Never dismiss pain; recommend a sports physio for anything persisting >2 weeks
- Never try new nutrition on race day (remind the runner)
- Rest and low-HRV days are part of the plan, not failure

---

## 6. Workflow — How to Generate a Weekly Plan

```
Step 1  Copy TEMPLATE_week-report.md → rename to YYYY-MM-DD_week-report.md
        Drop into Working Documents\Training Reports\

Step 2  Fill in your sessions, HRV data, and runner profile

Step 3  In Claude Code, invoke the coach:
        /running-coach   ← or just describe what you need in plain language

Step 4  Coach reads Training Reports + Knowledge Base, applies HRV readiness logic,
        outputs a zone-labelled weekly plan

Step 5  Save the generated plan to Working Documents\Weekly Plans\YYYY-MM-DD_plan.md

Step 6  Commit both files to Git
        git add "Working Documents/"
        git commit -m "Week YYYY-MM-DD: report + plan"
```

---

## 7. Training Data Format

Use this template when logging a week manually:

```markdown
# Week Report — 2026-MM-DD to 2026-MM-DD

## Runner Profile (update if changed)
- Max HR: ___
- LTHR: ___
- Current weekly mileage: ___ km
- Goal race: ___ / Date: ___
- Injury flags: ___

## HRV Summary
- HRV baseline (7-day avg): ___ ms
- Today's HRV: ___ ms
- Trend: Rising / Stable / Declining
- Resting HR trend: ___
- Sleep quality this week: ___

## Sessions

| Date | Type | Distance | Duration | Avg HR | Zone | RPE | Notes |
|------|------|----------|----------|--------|------|-----|-------|
|      |      |          |          |        |      |     |       |

## Weekly Totals
- Total distance: ___ km
- Total time: ___
- Zone distribution: Z1 ___% / Z2 ___% / Z3 ___% / Z4 ___% / Z5 ___%
- Subjective fatigue (1–10): ___
```

---

## 8. Knowledge Base Index

Files to maintain in `Working Documents\Knowledge Base\`:

| File | Contents | Status |
|------|----------|--------|
| `hr-zones.md` | Zone boundaries by max HR % and LTHR %, RPE equivalents | ✅ Created |
| `hrv-interpretation.md` | HRV readiness framework, app-specific notes | ✅ Created |
| `race-equivalence.md` | Target paces by goal time for 5K / 10K / HM / Marathon | To add |
| `80-20-principles.md` | Polarised training theory, session type ratios | To add |
| `injury-protocols.md` | Common running injuries, causes, management steps | To add |
| `nutrition-guidelines.md` | Pre/during/post run fueling, race day protocols | To add |

---

## 9. Logic & Decision Rules

### HRV Readiness → Training Prescription

| HRV vs Baseline | Resting HR | Signal | Action |
|----------------|------------|--------|--------|
| >10% above | Normal/low | Green | Quality session OK (Z4/Z5) |
| ±5% | Normal | Amber | Planned session as written |
| 5–10% below | Elevated | Amber-low | Reduce to Z1–Z2 only |
| >10% below | Elevated | Red | Rest or full recovery day |

### Load Progression Rules
- Never increase weekly volume >10% week-over-week (10% rule)
- Acute:Chronic load ratio target: 0.8–1.3 (>1.5 = injury risk)
- Every 4th week: deload (reduce volume 20–30%, maintain some Z4)
- Taper final week before race: reduce volume 20–30%, keep intensity

### Zone Distribution Target
- 80% of weekly volume in Z1–Z2
- 20% in Z3–Z5
- Flag if Z3 ("grey zone") exceeds 15% of total — inefficient and fatiguing

---

## 10. Git Workflow

```powershell
# After generating a plan or adding a report:
git add "Working Documents/"
git commit -m "Week YYYY-MM-DD: plan generated / report added"

# View training history:
git log --oneline

# See what changed in a specific week:
git show <commit-hash>
```

Keep commit messages dated and descriptive. This builds a full, searchable training history.

---

## 11. Quick Reference — Invoke the Coach

```
# Generate a weekly plan:
/running-coach

# Analyse an HRV screenshot or PDF report:
Share the file in the conversation → coach interprets it automatically

# Ask a quick running question:
Just ask in plain language — the running-coach skill is always active

# Install Tier 1 stack (PowerShell):
winget install Python.Python.3.12 astral-sh.uv Microsoft.VisualStudioCode
```

---

*Last updated: 2026-05-31 | Model: claude-sonnet-4-6 | Stack: Claude Code + PowerShell + Git*
