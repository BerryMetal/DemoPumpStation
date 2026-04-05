# Pump Station Demo (IEC 61131-3 ST, OOP + Testable Architecture)

---
## 🚀 Overview

This project demonstrates how modern engineering practices can be applied to PLC development using Structured Text (ST).

The example models a multi-pump station with:

- multiple identical pump units
- a single shared VFD (Variable Frequency Drive)
- bypass contactor switching
- demand-based unit allocation

---
## System Description

The pump station operates with the following simplified logic:

- Only one unit at a time is controlled by the VFD
- Additional running units are switched to bypass (AC line)
- When demand increases:
 - current VFD unit → bypass
 - next available unit → VFD
- When demand decreases:
 - one bypass unit is stopped
- Faulted units are skipped
- Motor synchronization ("catch-up") is out of scope

---
## Limitations

This is a demo project, not a full industrial solution.

---
## Not included:

- real fieldbus communication
- motor synchronization
- PID / flow control
- timing behavior
- safety logic
- full alarm management

---
## Intended Use

- Technical presentations
- Architecture discussions
- OOP in ST demonstrations
- Unit testing examples for PLC
- Internal engineering training

---
## Final Note

This project is intentionally small.

---

# Suggested Pump Station Modbus Register Map

## General
- Addressing is **zero-based**
- 1 register = **1 word (16 bits)**
- `DWORD` = **2 consecutive registers**
- PDO layout:
  1. Controller block
  2. Pump blocks (repeated)

---

# 1. PDI (Holdings)
**Direction:** SCADA → Controller  
**Base address:** `0`

## Layout

| Address | Size (regs) | Name | Type | Description |
|--------:|------------:|------|------|-------------|
| 0 | 1 | controlWord | word | Bit-coded control commands |
| 1 | 1 | setpointPower | word | Encoded real value |

## controlWord bits

| Bit | Name | Description |
|----:|------|-------------|
| 0 | startCmd | Start command |
| 1 | stopCmd | Stop command |
| 2..15 | reserved | Must be 0 |

---

# 2. PDO (Inputs)
**Direction:** Controller → SCADA  
**Base address:** `0`

---

## 2.1 Controller Block

| Address | Size | Name | Type | Description |
|--------:|-----:|------|------|-------------|
| 0 | 1 | controllerStateWord | word | Bit-coded controller state |
| 1 | 1 | vfdUnitId | word | Active VFD unit |
| 2 | 1 | requestedPower | word | Encoded real |
| 3 | 1 | vfdFrequency | word | Encoded real |
| 4 | 1 | activePower | word | Encoded real |

### controllerStateWord bits

| Bit | Name | Description |
|----:|------|-------------|
| 0 | isStarted | Station running |
| 1 | vfdStatus | VFD status |
| 2..15 | reserved | Reserved |

---

## 2.2 Pump Block (repeated)

Each pump occupies **5 registers**

| Offset | Size | Name | Type | Description |
|-------:|-----:|------|------|-------------|
| +0..+1 | 2 | id | dword | Pump ID |
| +2 | 1 | role | word | Pump role |
| +3 | 1 | stateWord | word | Pump state bits |
| +4 | 1 | power | word | Encoded real |

### stateWord bits

| Bit | Name | Description |
|----:|------|-------------|
| 0 | available | Pump available |
| 1 | faulted | Pump faulted |
| 2 | active | Pump active |
| 3..15 | reserved | Reserved |

---

# 3. Address Calculation

## Controller block

0..4

## Pump blocks

First pump starts at address `5`
pumpBase(index) = 5 + index * 5


---

# 4. Example (4 pumps)

## Controller

| Address | Name |
|--------:|------|
| 0 | controllerStateWord |
| 1 | vfdUnitId |
| 2 | requestedPower |
| 3 | vfdFrequency |
| 4 | activePower |

## Pump 0

| Address | Name |
|--------:|------|
| 5 | id (low/high) |
| 6 | id (high/low) |
| 7 | role |
| 8 | stateWord |
| 9 | power |

## Pump 1

| Address | Name |
|--------:|------|
| 10 | id |
| 11 | id |
| 12 | role |
| 13 | stateWord |
| 14 | power |

## Pump 2

| Address | Name |
|--------:|------|
| 15 | id |
| 16 | id |
| 17 | role |
| 18 | stateWord |
| 19 | power |

## Pump 3

| Address | Name |
|--------:|------|
| 20 | id |
| 21 | id |
| 22 | role |
| 23 | stateWord |
| 24 | power |

---

# 5. Notes

- Pump ID uses 2 registers (DWORD)
- Register order depends on implementation of:
  - `writeDword()`
- Real values use project-specific scaling:
  - `realToModbusRounded()`
  - `wordToRealValue()`
