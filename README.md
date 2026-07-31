# Supplementary Material: Test-Driven Modeling for MERODE

The repository contains the following elements:

- This README file containing the concrete DSL syntax and examples. 
- A .g4 grammar file containing the grammar of the DSL
- A .pdf file with supplementary material for the paper, including an detailed explaination of the design and implementation.
---

## 📘 Overview

This project introduces **Test-Driven Modeling (TDM)** to MERODE by adding:

- A **Domain-Specific Language (DSL)** for test scripts
- A **simulation engine** to execute these tests
- **Automated validation** for
    - Existence-Dependency Graph (EDG)
    - Finite State Machine (FSM) behavior
    - Attribute structures
    - Events, methods, and dependencies
    - Object lifecycle and transitions

The goal is to support both **model quality assurance** and **learning outcomes** in conceptual modeling education.

---

## 🎥 Tool Demonstration

Click the link below to watch a short demonstration of the tool.
[Demo Video](https://youtu.be/zIIWrEdE9Rw)


---

## 🎯 Motivation

MERODE currently supports **manual testing** through:

- The MERLIN-generated prototype
- TesCaV test coverage visualizer

But MERODE **has no automated testing**, no DSL, and no programmatic way to check correctness.

This project fills that gap and enables:

✔ Test-Driven Modeling (TDM)  
✔ Regression testing  
✔ Fast model feedback  
✔ Automated grading support  
✔ Educational exercises with immediate verification

---
# 📜 ModelTest DSL
The DSL supports two categories of assertions:
- Behaviour Assertions
- Structure Assertions

For the following examples, we use the house merode model :
![EDG](img/edg.png)
![FSM](img/fsm.png)
![FSM Illness](img/fsm-illness.png)
---

# 1️⃣ Behaviour Assertions
Used to validate **object lifecycles**, **state transitions**, and **event execution**.

### Example: Creating objects and verifying state
```
test testDiagnosisCreation {
    Doctor d1 = mecrdoctor();
    Patient p1 = mecrpatient();
    Illness i1 = mecrillness();
    Diagnosis dia = mecrdiagnosis(i1, p1, d1);
    assert dia.getState().getName() == "exists";
}
```
### Example: Full lifecycle flow
```
test testPatientFlow {
    patient p1 = mecrpatient();
    assert p1.getState().getName() == "exists";

    p1.meconsent();
    assert p1.getState().getName() == "inConsent";

    p1.merectractconsent();
    assert p1.getState().getName() != "inConsent";

    p1.meendpatient();
    assert p1.getState().getName() == "ended";
}
```
# 2️⃣ Structural Assertions

Used to validate the structure of the model:
- Objects exist
- Attributes exist
- Methods exist
- Events exist
- Dependencies exist
- Instances are distinct
- Attribute values match

These assertions target EDG + class structure.

### ✔ Test methods exist
```
test testLifecycleMethods {
    assert exists METHOD(MEcrPatient) | "Method MEendPatient does not exist";
    assert exists METHOD(MEcrPatient) | "Method MEendDoctor does not exist";
}
```

### ✔ Test objects exist
```
test testExistenceOfCoreObjects {
    assert exists OBJECT(Patient) | "Core object Patient does not exist";
    assert exists OBJECT(Doctor)  | "Core object Doctor does not exist";
    assert exists OBJECT(Illness) | "Core object Illness does not exist";
    assert exists OBJECT(Diagnosis) | "Core object Diagnosis does not exist";
}
```

### Test attributes object contains required properties (if modeled in future)
```
test testAttributesDefined {
    assert exists OBJECT(Patient).ATTRIBUTE(Shortname) | "PatientLC expected attribute Shortname missing";
    assert exists OBJECT(Doctor).ATTRIBUTE(Shortname)  | "Doctor shortname attribute missing";
    assert exists OBJECT(Illness).ATTRIBUTE(Shortname) | "Illness shortname attribute missing";
}
```

### Test state nodes exist in FSMs
```
test testPatientStates {
    assert exists OBJECT(Illness).FSM(IllnessLC);
    fsm illnesslc = OBJECT(Illness).FSM(IllnessLC);
    assert exists illnesslc.STATE(low);
    assert exists illnesslc.STATE(high);
}
```

### Test object creation distinctness

```
test testPatientInstanceDistinctness {
    Patient p1 = mecrpatient();
    Patient p2 = mecrpatient();
    assert exists p1 | "Patient instance p1 was not created";
    assert exists p2 | "Patient instance p2 was not created";
    assert p1 != p2  | "Patient instances should be distinct but are equal";
}
```

# 🧪 Additional Showcase Tests

The following tests are used to demonstrate the DSL features using the Teach-Merode model:


![TEACH-EDG](img/teach-edg.png)
![TEACH-FSM](img/teach-fsm.png)

### ✔ Faculty creation state check #1
```
test testShowcase2 {
Faculty f1 = mecrfaculty("Informatics", "IT");
assert f1.getState().getName() != "exists";
}
```

### ✔ Faculty creation state check #2 (string comparison)
```
test testShowcase2 {
String s1 = "exists";
assert mecrfaculty("Informatics", "IT").getState().getName() == s1;
}
```

### ✔ Faculty creation state check #3 (incorrect state expected)
```
test testShowcase2 {
Faculty f1 = mecrfaculty("Informatics", "IT");
State state = f1.getState();
assert state.getName() == "exists2";
}
```

### ✔ Object instance existence + distinctness

```
test testShowcase1 {
Person p1 = mecrperson("John", "A+");
Person p2 = mecrperson("Max", "A+");
assert exists p1;
assert exists p2;
assert p1 != p2;
}
```

### ✔ Faculty existence assertion
```
test testShowcase2 {
Faculty f1 = mecrfaculty("Informatics", "IT");
assert exists f1;
}
```


### ✔ Attribute value extraction
```
test testShowcase2 {
Faculty f1 = mecrfaculty("Informatics", "IT");
String shortname = f1.getShortname();
assert shortname == "Informatics";
}
```



