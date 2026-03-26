# macOS EQ App — Execution Plan

* Do NOT jump ahead
* Do NOT build UI before audio works
* Always keep project runnable
* Commit after every step

---

# PHASE 1 — DSP CORE (C++)

## Step 1.1 — Setup

* Create project directory
* Initialize git
* Create folder structure

## Step 1.2 — Biquad Filter

* Implement `biquad.h`
* Implement `biquad.cpp`
* Add:

  * setPeakingEQ()
  * process()

## Step 1.3 — EQ Engine

* Implement `eq_engine.h`
* Implement:

  * vector of filters
  * frequency distribution (log scale)
  * setGain()
  * process()

## Step 1.4 — Stereo Support

* Modify process:

  * processLeft()
  * processRight()

## Step 1.5 — Signal Generator

* Create sine wave generator
* Generate test signal (440 Hz)

## Step 1.6 — Test Harness

* Build `test/main.cpp`
* Pass signal through EQ
* Print / log output

## CHECKPOINT 1

* Code compiles
* Output stable
* No crashes

---

# PHASE 2 — DSP IMPROVEMENTS

## Step 2.1 — Parameter Smoothing

* Implement linear interpolation
* Avoid sudden gain jumps

## Step 2.2 — Gain Limits

* Clamp gain range (-12 dB to +12 dB)

## Step 2.3 — Performance Check

* Ensure no dynamic allocation in process()

## CHECKPOINT 2

* No audio artifacts expected
* Stable under repeated calls

---

# PHASE 3 — macOS AUDIO PIPELINE

## Step 3.1 — Create macOS App (Xcode)

* New project (SwiftUI)

## Step 3.2 — Audio Engine Setup

* Use AVAudioEngine
* Create input/output nodes

## Step 3.3 — Audio Callback

* Tap audio buffer
* Extract float samples

## Step 3.4 — Bridge C++ DSP

* Create Objective-C++ file (.mm)
* Connect Swift → C++

## Step 3.5 — Process Audio

* Pass buffer → EQEngine
* Return processed buffer

## CHECKPOINT 3

* Audio plays through app
* No distortion / crash

---

# PHASE 4 — SYSTEM-WIDE AUDIO

## Step 4.1 — Virtual Audio Device Research

* Study CoreAudio / DriverKit

## Step 4.2 — Create Virtual Device

* Basic passthrough device

## Step 4.3 — Route System Audio

* macOS output → your device

## Step 4.4 — Insert DSP

* Inject EQEngine into pipeline

## CHECKPOINT 4

* Spotify / YouTube audio affected

---

# PHASE 5 — UI

## Step 5.1 — Sliders

* 12 sliders (SwiftUI)

## Step 5.2 — Bind to DSP

* Update gains in real time

## Step 5.3 — Presets

* Flat
* Bass Boost
* Vocal

## CHECKPOINT 5

* UI responsive
* Audio updates instantly

---

# PHASE 6 — PACKAGING

## Step 6.1 — Build .app

* Release build

## Step 6.2 — Zip

* Create app.zip

## Step 6.3 — GitHub Release

* Upload binary

## Step 6.4 — Documentation

* Setup instructions
* Permissions explanation

---

# PHASE 7 — POLISH

## Optional

* Spectrum analyzer
* Preset saving
* UI improvements
* Performance tuning

---

# FINAL CHECK

* App launches
* Audio routing works
* EQ works
* No crashes
* Clean repo

---
