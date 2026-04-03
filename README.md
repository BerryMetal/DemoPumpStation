# Pump Station Demo (IEC 61131-3 ST, OOP + Testable Architecture)

---

## 🚀 Overview

This project demonstrates how modern engineering practices can be applied to PLC development using Structured Text (ST).

The example models a multi-pump station with:

	* multiple identical pump units
	* a single shared VFD (Variable Frequency Drive)
	* bypass contactor switching
	* demand-based unit allocation

---
## System Description

The pump station operates with the following simplified logic:

	- Only one unit at a time is controlled by the VFD
	- Additional running units are switched to bypass (AC line)
	- When demand increases:
		* current VFD unit → bypass
		* next available unit → VFD
	- When demand decreases:
		* one bypass unit is stopped
	- Faulted units are skipped
	- Motor synchronization ("catch-up") is out of scope

## Limitations

This is a demo project, not a full industrial solution.

## Not included:

	- real fieldbus communication
	- motor synchronization
	- PID / flow control
	- timing behavior
	- safety logic
	- full alarm management

## Intended Use

	- Technical presentations
	- Architecture discussions
	- OOP in ST demonstrations
	- Unit testing examples for PLC
	- Internal engineering training

## Final Note

This project is intentionally small.