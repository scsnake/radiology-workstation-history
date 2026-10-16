# Workstation Automation & Clinical Script Archive (2003 – Present)

This repository is an archive of original self-authored scripts, desktop automation utilities, and workflow tools developed between 2003 and the present.

### Purpose & Archival Scope
- **Historical Record**: This repository serves solely as a personal record of coding experience, architecture ideas, and workflow automation concepts developed through the years.
- **Original Historical State (Not AI-Optimized)**: The code is preserved in its authentic historical form. It has **not been optimized, refactored, or rewritten by AI**.
- **No Warranty / Not Guaranteed Runnable**: These scripts are historical artifacts. They are **not guaranteed to be runnable or bug-fixed**, and they are not maintained for production use.
- **Data Privacy & Sanitization**: All patient health information (PHI) has been completely removed. System configuration tables, contact rosters, and network endpoints use synthetic mock data.

### Institutional & Data Anonymization Key
To preserve medical privacy and institutional confidentiality, all clinical identifiers, personnel names, and network endpoints use the following canonical sanitization conventions:

- **Hospitals**:
  - `N hospital`: Major national university teaching hospital (Northern Taiwan).
  - `C hospital`: Regional Catholic teaching hospital (clinical integration after July 2020).
- **Hospital Branches**: Initialized branch prefixes:
  - `Y branch`: Yunlin agricultural regional branch.
  - `H branch`: Hsinchu regional branch.
  - `J branch`: Jinshan branch.
  - `B branch`: Bei-Hu branch.
  - `ZD branch`: Zhudong branch.
  - `N總院` / `N Main Hospital`: Main hospital center campus.
- **Clinicians & Staff Names**: Two-to-three character personnel names are replaced with generic professional titles (`張醫師`, `王醫師`, `陳醫師`, `林醫師`, `游醫師`) or standard synthetic placeholders.
- **Patient Privacy (PHI)**: All patient records have been replaced with synthetic mock data (`0000001`, `王小明`, `T0000000001`). No real clinical records or chart numbers exist in this repository.
- **Network Endpoints & Domains**: Institutional top-level domains (`institutional live domains`) and intranet IPs are replaced with local simulation endpoints (`*.hospital-n.local`, `*.hospital-y.local`, `*.hospital-h.local`, `127.0.0.1:8000`).
- **Credentials & Accounts**: Usernames (`raduser`), passwords (`MOCK_PASSWORD`), and session tokens are simulated placeholders.

### Chronological Eras
The archive is organized into three chronological periods based on training stages and file timestamps:
- **Student Era (2003 – 2010)**: Early desktop utilities, shorthand migration, and window macros
- **Resident Era (2011 – 2015)**: Structured reporting tools, revision diffing, procedure databases, and workstation synchronization
- **Attending Era (2016 – Present)**: Workstation integration, template engines, DICOM/PACS wrappers, and AI review assistants


---

## Master Tools Catalog (105 Historical Tools)

> [!TIP]
> Open [`tools_catalog.html`](tools_catalog.html) or the live GitHub Pages site (`index.html`) for the interactive searchable catalog with in-browser editing and exclusion selection.

### Student Era (2003 – 2010) (8 Tools)

| Tool | Technology | Period | Description | Key Files |
| :--- | :--- | :--- | :--- | :--- |
| **[copyUSB (copyppt)](01-student-2003-2010/copyUSB)** | AutoHotkey v1 | 2008 – 2013 | This tool automatically copies presentation slides and teaching files across hospital computers. It detects USB drive insertion and backs up files without manual navigation. | `copyppt.ahk`, `copyUSB.ahk` |
| **[ICUbatch (orderBatch)](01-student-2003-2010/ICUbatch)** | AutoHotkey v1, DOM Automation | 2010/02 – 2013 | This tool accelerates order entry during ICU rotations. It automates repetitive entry of routine medication orders and laboratory requests in the hospital web portal. | `orderBatch.ahk`, `ICUbatch.ahk` |
| **[replyConsult](01-student-2003-2010/replyConsult)** | AutoHotkey v1, Template Automation | 2010/03 – 2015 | This tool assists clinicians in drafting consultation replies for emergency and procedure teams. It provides structured text templates for common radiological procedures. | `replyERconsult.ahk`, `angioconsult 2.ahk` |
| **[Y Branch Helper](01-student-2003-2010/YBranch)** | AutoHotkey v1 | 2010/02 – 2013 | This script adapts workstation window layouts for the N hospital Y branch. It streamlines interactions between local medical order systems and IMPAX PACS. | `Y分院IMPAX.ahk`, `Y分院醫令系統.ahk` |
| **[LZ FV Automation & DOM Experiments](01-student-2003-2010/LZ_FV_automation)** | AutoHotkey v1, COM, GDI+ | 2008 – 2009 | This project explores Internet Explorer DOM inspection, COM interfaces, and image pattern matching. It established the core automation techniques later used in clinical web portals. | `farmville.ahk`, `COM.ahk`, `IE HTML Element Spy.ahk` |
| **[RoboType Shorthand Migrator](01-student-2003-2010/robotype_cafe)** | AutoHotkey v1, Text Expansion | 2001 – 2014 | This tool converts legacy RoboType shorthand expansion databases into native AutoHotkey hotstrings for diagnostic phrasing. | `robotype2ahk.ahk`, `jw-robotype.ahk` |
| **[Lightweight Image Viewer](01-student-2003-2010/imageViewer)** | AutoHotkey v1, GDI+ | 2009 – 2016 | This utility provides lightweight image viewing and zoom navigation for teaching cases without heavy desktop software. | `imageViewer.ahk`, `imageViewer2.ahk` |
| **[LiuWordList](01-student-2003-2010/LiuWordList)** | AutoHotkey v1, GUI Automation | 2007 – 2010 | Automated dictionary reverse-engineering script for the Boshiamy (嘸蝦米) input method. Sequentially steps through candidate grids to dump mappings. | `LiuWordList.ahk`, `LiuWordList2.ahk` |

### Resident Era (2011 – 2015) (48 Tools)

| Tool | Technology | Period | Description | Key Files |
| :--- | :--- | :--- | :--- | :--- |
| **[VFSS2 (Swallowing Study PDF Engine)](02-resident-2011-2015/VFSS2)** | AutoHotkey v1, LibHaru C Library (HPDF) | 2011/08 – 2017 | This tool generates clinical reports for Videofluoroscopic Swallowing Studies. It records dynamic examination parameters through a GUI and produces standardized PDF reports directly. | `VFSS2 20140824 pretty form.ahk`, `HPDF.ahk`, `VFSS3.ahk` |
| **[bone_age (Bone Age Reporting Assistant)](02-resident-2011-2015/bone_age)** | AutoHotkey v1, RIS/IMPAX Polling | 2012/02 – 2021 | This assistant calculates pediatric bone age based on Greulich and Pyle standards. It extracts patient age and gender from PACS to generate formatted assessment reports. | `boneage_CTH.ahk`, `boneage report.ahk` |
| **[diff_match_patch (Report Revision Diff)](02-resident-2011-2015/diff_match_patch)** | AutoHotkey v1, C++, C#, JavaScript | 2012/11 – 2015 | This tool analyzes text revisions between preliminary drafts and finalized reports. It applies the diff-match-patch algorithm to highlight modifications for workflow review and training feedback. | `diff_match_patch.cpp`, `DiffMatchPatch.cs`, `diff_match_patch.js` |
| **[scsnake sync](02-resident-2011-2015/scsnake_sync)** | AutoHotkey v1, AHKsock (TCP Sockets) | 2013/06 – 2019 | This daemon synchronizes scripts, hotstrings, and settings across reading room computers. It communicates over the local hospital network using lightweight TCP sockets. | `autoSync.ahk`, `AHKsock - client.ahk`, `AlwaysSync.ahk` |
| **[RadCapture](02-resident-2011-2015/RadCapture)** | AutoHotkey v1, GDI+ | 2014/07 – 2014/08 | This utility captures and crops diagnostic imaging findings directly from high-resolution medical monitors. It helps users collect teaching cases during routine reading. | `RadCapture.ahk`, `Copy of ScreenCapture.ahk` |
| **[g0v Campaign Finance Digitization](02-resident-2011-2015/g0v_campaign_finance)** | AutoHotkey v1 | 2014/04 – 2017 | This script contributed to the g0v civic hackathon for crowdsourced document verification. It accelerates image inspection and data entry for public audit records. | `政治獻金數位化.ahk` |
| **[DigiSign (Electronic Digital Signing)](02-resident-2011-2015/DigiSign)** | AutoHotkey v1, Smart Card Dialog Automation | 2014/05 – 2021 | This helper automates confirmation dialogs for hospital smart-card digital signing. It manages certificate verification prompts during high-volume report sign-off. | `DigiSign.ahk`, `電子簽章.ahk`, `closePop.ahk` |
| **[Peer Hotstrings (Reporting Shortcuts)](02-resident-2011-2015/peer_hotstrings_RadiologyAHK)** | AutoHotkey v1 | 2011 – 2015 | This collaborative repository provides standardized reporting hotstrings. It offers structured diagnostic phrasing across thoracic, musculoskeletal, neurological, and abdominal imaging. | `AutoCorrect.ahk`, `radiology.ahk`, `TYY.ahk`, `CWL.AHK` |
| **[Subspecialty Reporting Templates](02-resident-2011-2015/Residency_R3_Templates)** | AutoHotkey v1 | 2008 – 2015 | This collection provides specialized report templates for advanced imaging rotations. It covers breast imaging (ultrasound, mammography) and thoracic imaging (chest CT, cardiac MRI). | `Chest.ahk`, `BREAST.ahk`, `HYSbreast.ahk`, `HYScMR.ahk` |
| **[dotnet RIS Interop](02-resident-2011-2015/dotnet_RIS_interop)** | C#, VB.NET, AutoHotkey v1, CLR.ahk | 2011 – 2019 | This library bridges AutoHotkey to hospital RIS client controls using C# and .NET interop. It reads data directly from DataGrid controls without screen scraping. | `getDataGrid.cs`, `getDataGrid.ahk`, `CLR.ahk` |
| **[TMS Reader](02-resident-2011-2015/TMS_reader)** | AutoHotkey v1 | 2013 – 2018 | This tool parses schedules and course records from the hospital Teaching Management System. It presents clinical training credits in a clear dashboard. | `TMS reader.ahk`, `TMS reader GUI.ahk` |
| **[easyPortal & dontLogout](02-resident-2011-2015/easyPortal)** | AutoHotkey v1, HTTPRequest | 2011/07 – 2017 | This background service maintains authenticated web sessions on the hospital clinical portal. It sends periodic heartbeat requests to prevent session timeouts during busy shifts. | `dontLogout.ahk`, `easyPortal.ahk`, `HTTPRequest.ahk` |
| **[searchLab (Clinical Lab Lookup)](02-resident-2011-2015/searchLab)** | AutoHotkey v1, GUI, Web Scraping | 2012 – 2019 | This tool provides an in-situ clinical laboratory lookup overlay during report writing to check creatinine, eGFR, and tumor markers. | `searchLab.ahk`, `searchLab2.ahk`, `searchLab 2019.ahk` |
| **[Angiography Workflow & Consultation](02-resident-2011-2015/angio_workflow)** | AutoHotkey v1, Template Automation | 2012 – 2017 | This collection coordinates interventional angiography consultations, procedure scheduling, and structured procedure note replies. | `angioSchedule.ahk`, `AngioConsult.ahk`, `ReplyConsultation.ahk` |
| **[Contrast Media Dose Calculator](02-resident-2011-2015/ContrastDose)** | AutoHotkey v1, Clinical Formula | 2012 – 2014 | This clinical helper calculates contrast media injection volumes and flow rates based on patient body weight and renal function. | `ContrastDose.ahk` |
| **[Breast Ultrasound Reporting Aid](02-resident-2011-2015/breastUS)** | AutoHotkey v1, Structured Templates | 2014 – 2015 | This helper assists breast ultrasound examinations with structured lesion measurement templates and BI-RADS assessment descriptors. | `breastUS.ahk` |
| **[CT Gantry Tilt Calculator](02-resident-2011-2015/gantryAngle)** | AutoHotkey v1, Math Geometry | 2014 – 2015 | This geometry helper calculates CT gantry tilt angles and reformatted plane coordinates for specialized head and neck imaging protocols. | `gantryAngle.ahk` |
| **[Interventional Procedure Notes](02-resident-2011-2015/interventional_notes)** | AutoHotkey v1, Clinical Documentation | 2012 – 2015 | This suite formats structured procedure notes for radiofrequency ablation (RFA) and transcatheter arterial embolization (TAE). | `RFA note.ahk`, `TAE.ahk`, `followTAE.ahk` |
| **[CT Event & Injection Logger](02-resident-2011-2015/CTeventLog)** | AutoHotkey v1, Logging | 2012 – 2017 | This logger records contrast administration times, injection phases, and scan parameters during complex computed tomography protocols. | `CTeventLog.ahk` |
| **[IMPAX Display & UI Utilities](02-resident-2011-2015/impax_ui_tools)** | AutoHotkey v1, Win32 Hooks | 2012 – 2017 | This tool suite resolves display glitches, focus stealing, and viewport magnification behaviors in Agfa IMPAX 6 workstations. | `AntiImpaxFlash.ahk`, `Show_Impax6_icon.ahk`, `mammoMagMove.ahk` |
| **[Regional Branch Workstation Suite](02-resident-2011-2015/YCH_workstation)** | AutoHotkey v1, Workstation Automation | 2014 – 2025 | This comprehensive suite customizes reporting workflows for regional branch hospital stations across radiography, mammography, and BMD. | `YCH_main.ahk`, `YCH_XR.ahk`, `YCH_mammo.ahk`, `YCH_BMD.ahk` |
| **[Radiology Scheduling & Roster Tools](02-resident-2011-2015/radiology_scheduling)** | Python, AutoHotkey v1 | 2014 – 2015 | This utility parses, manages, and synchronizes on-call rosters and departmental duty schedules into calendar formats. | `writeSchedule.py`, `loadRadSchedule.ahk` |
| **[AVS Laboratory Data Parser](02-resident-2011-2015/AVSgetLab)** | AutoHotkey v1, DOM Parsing | 2012 – 2017 | This parser extracts aldosterone and cortisol values from clinical web portals during adrenal venous sampling procedures. | `AVSgetLab.ahk` |
| **[Preliminary Report Checker](02-resident-2011-2015/checkRReport)** | AutoHotkey v1, Text Diff | 2013 – 2019 | This helper checks report submission status and compares modifications made across preliminary drafts. | `checkRReport.ahk` |
| **[Examination Archive to SQLite](02-resident-2011-2015/examWord2Sqlite)** | AutoHotkey v1, SQLite DBA | 2014 – 2019 | This tool extracts examination findings from Word documents and archives structured report records into an SQLite database. | `examWord2Sqlite.ahk` |
| **[DICOM Series Name Extractor](02-resident-2011-2015/fetchSeriesName)** | AutoHotkey v1, Win32 Automation | 2015 | This helper inspects PACS viewer controls and extracts active DICOM series descriptions directly into the report template. | `fetchSeriesName.ahk` |
| **[Clinical Reference Mail Synchronizer](02-resident-2011-2015/GmailSync)** | AutoHotkey v1, Background Sync | 2014 | This background daemon monitors local Google Drive folders for synchronized clinical attachments and teaching articles. | `GmailSync.ahk` |
| **[Hotstring Helper & Sorter](02-resident-2011-2015/Hotstring_Helper)** | AutoHotkey v1, Tooling | 2013 – 2019 | This developer utility manages reporting hotstring collections, finds duplicate abbreviations, and sorts entries alphabetically. | `Hotstring Helper.ahk`, `HotstringFindDuplicate.ahk`, `HotstringSort.ahk` |
| **[Intravenous Procedure Record Logger](02-resident-2011-2015/IVrecord)** | AutoHotkey v1, Clinical Forms | 2015 – 2017 | This tool logs patient IV catheter placements, procedure times, and contrast volumes with auditable timestamps. | `IVrecord.ahk` |
| **[JYS Mouse Viewport Accelerator](02-resident-2011-2015/JYS_mouse)** | AutoHotkey v1, Input Remap | 2015 – 2017 | This utility maps mouse gestures and wheel triggers for rapid PACS viewport panning and window leveling adjustments. | `JYS_mouse.ahk` |
| **[NHI Guideline & Form Assistant](02-resident-2011-2015/NHI_tools)** | AutoHotkey v1, Web & DB | 2014 – 2017 | This suite checks National Health Insurance pre-authorization criteria and fills clinical indication forms for advanced CT/MRI examinations. | `NHIfollow.ahk`, `NHIform.ahk` |
| **[Radiology Quality Assurance Logger](02-resident-2011-2015/RadQA)** | AutoHotkey v1, Sockets, Peer Review | 2015 – 2019 | This peer review helper records discrepancy cases, diagnostic discussions, and teaching points into an auditable database. | `RadQA.ahk` |
| **[Radiology Report Data Mining](02-resident-2011-2015/reportMining)** | AutoHotkey v1, Data Extraction | 2012 – 2021 | This suite performs batch data mining across historical radiology archives for research cohorts (mammography, chest CT). | `reportMining.ahk`, `batchImpax.ahk`, `getChestCTList.ahk` |
| **[Turnaround Time Counter](02-resident-2011-2015/reportTimer)** | AutoHotkey v1, Metrics | 2015 | This non-intrusive floating stopwatch measures examination turnaround times and personal reading speed across report shifts. | `reportTimer.ahk` |
| **[RIS Numbering & Formatting Helper](02-resident-2011-2015/RisHelper)** | AutoHotkey v1, Text Processing | 2015 – 2019 | This helper injects auto-numbering, paragraph indentations, and standard heading structures directly into hospital RIS editors. | `RisHelper.ahk`, `AutoNum.ahk` |
| **[Surgical Pathology Correlator](02-resident-2011-2015/updateOpPatho)** | AutoHotkey v1, HTML5, Data Matching | 2013 – 2020 | This application correlates radiology report findings with post-operative surgical pathology results for diagnostic feedback. | `searchPatho.ahk`, `matchPathoList.ahk`, `getFullPatho.ahk` |
| **[Reporting Volume & Workload Auditor](02-resident-2011-2015/WorkloadComparison)** | AutoHotkey v1, Reporting Metrics | 2015 – 2017 | This tool compares monthly reporting volume, RVU calculations, and modality distributions against departmental statistical records. | `績效比對.ahk` |
| **[RAD_DB](02-resident-2011-2015/RAD_DB)** | AutoHotkey v1, ADODB/Jet OLEDB, MS Access COM, portalLib | 2011 – 2015 | Angiography and interventional radiology procedure database pipeline. Records TACE and procedure records with portal demographic integration. | `writeToDb.ahk`, `writeToRis.ahk`, `closeUpdate.ahk`, `Procedure Note.cmd` |
| **[portalLib](02-resident-2011-2015/portalLib)** | AutoHotkey v1, HTTP Client, SOAP/XML | 2012 – 2018 | Foundational client library for N hospital HIS and medical web portal. Automates authentication, patient demographics, lab reports, and imaging history retrieval. | `portalLib.ahk`, `HTTPRequest.ahk`, `xpath.ahk` |
| **[kln_OPD_history_parser](02-resident-2011-2015/kln_OPD_history_parser)** | AutoHotkey v1, portalLib, HTML Parser | 2013 – 2014 | Bulk outpatient clinical history scraper. Extracts diagnostic codes, medication history, and SOAP progress notes into structured CSV format. | `getOPDdataFull.ahk`, `HtmlToCSV2.ahk` |
| **[Annie_helpers](02-resident-2011-2015/Annie_helpers)** | AutoHotkey v1, GUI, Web Filtering | 2013 | Office productivity suite developed for clinical administrative support, including site blockers, Excel macros, and automated credential typing. | `Blocked Keywords.txt`, `blockFB.ahk`, `blockWeb.ahk`, `blockWeb.ico` |
| **[Bombard](02-resident-2011-2015/Bombard)** | AutoHotkey v1, HTTP Client, portalLib | 2012 | Adverse clinical event reporting portal automation. Streamlines submission of patient safety and equipment incident reports. | `aviso.txt`, `bombard.ahk`, `full.ini`, `full.txt` |
| **[cleanLab](02-resident-2011-2015/cleanLab)** | AutoHotkey v1, GUI, Regex | 2012 | Interactive GUI utility for cleaning, parsing, and standardizing pasted laboratory result blocks into compact tabular clinical notes. | `cleanLab.ahk`, `cleanLab.png` |
| **[filterSCI](02-resident-2011-2015/filterSCI)** | AutoHotkey v1, HTTP Client | 2015 | Scientific citation index validator. Queries medical journal titles against TU Wien SCI database to verify indexing metrics and impact factors. | `filterSCI.ahk` |
| **[Sleipnir_helpers](02-resident-2011-2015/Sleipnir_helpers)** | AutoHotkey v1, COM Automation | 2013 | Browser COM interop bridge for the Sleipnir dual-engine browser, extracting active DOM document instances for hospital portal scripting. | `sleipnir.ahk` |
| **[archCal](02-resident-2011-2015/archCal)** | AutoHotkey v1, Transparent Overlay GUI | 2013 | Curved trajectory and archery degree-wheel transparent visual overlay attached to mouse cursor for geometric angle estimation. | `archCal.ahk`, `archCal.ini`, `degree-wheel.gif` |
| **[ChartReviewExport](02-resident-2011-2015/ChartReviewExport)** | AutoHotkey v1, Portal HTTP API | 2013 – 2014 | Automated medical chart review query pipeline. Fetches historical radiology and pathology reports by chart number into tabular review records. | `ChartReviewExport.ahk` |
| **[UserScript_Path_Converter](02-resident-2011-2015/UserScript_Path_Converter)** | AutoHotkey v1, String Manipulation | 2012 | Development path switcher for Seahorse and Greasemonkey userscripts, transforming local file URLs to workstation network paths. | `remote or local conversion.ahk` |

### Attending Era (2016 – Present) (49 Tools)

| Tool | Technology | Period | Description | Key Files |
| :--- | :--- | :--- | :--- | :--- |
| **[autorun_core (Workstation Hub)](03-attending-2016-present/autorun_core)** | AutoHotkey v1, Win32 API, COM, Gaming Mouse Mapping | 2013 – Present | This central hub manages global hotkeys, window arrangements, and input hardware on reading room workstations. It integrates MMO gaming mouse keypads and houses over 350 reusable Win32 and COM libraries. | `autorun.ahk`, `RazerNaga.ahk`, `autorun_thread.ahk` |
| **[scsnake Package Manager](03-attending-2016-present/scsnake_package_manager)** | AutoHotkey v1, JSON, HTTP, MD5 | 2016 – 2019 | This intranet package manager distributes modular clinical tools to reading room workstations. It resolves package dependencies, verifies MD5 checksums, and enables drag-and-drop updates. | `package_info.json`, `scsPackageManager.ahk`, `createPackageInfo.ahk` |
| **[MammoSR (Mammography Structured Reporting)](03-attending-2016-present/MammoSR)** | AutoHotkey v1, HTML5, JavaScript, IMPAX Integration | 2016 – 2020 | This structured reporting engine supports national breast cancer screening programs. It provides an HTML5 interface for BI-RADS categorization, synchronizes active study context with Agfa IMPAX, and generates PDF reports. | `MammoSR.ahk`, `output.html`, `MammoSRPrintClient.ahk` |
| **[RisTyper (Smart Editor Overlay)](03-attending-2016-present/RisTyper)** | AutoHotkey v1, Win32 GUI | 2016 – 2019 | This non-intrusive editor overlay sits directly above hospital RIS report controls. Users toggle the interface with CapsLock to access automatic numbering and dual-monitor focus switching. | `RisTyper.ahk`, `ReadMe.txt` |
| **[textHotkey (Caret Accelerator)](03-attending-2016-present/textHotkey)** | AutoHotkey v1, Win32 Text Manipulation | 2016 – 2019 | This text navigation engine accelerates caret movement inside report editors. It moves, selects, and deletes text by word (Ctrl), clause (Alt), or full sentence (Win), and swaps adjacent lines. | `textHotkey.ahk`, `ReadMe.txt` |
| **[RadTemplate (DSL Template Engine)](03-attending-2016-present/RadTemplate)** | AutoHotkey v1, Domain-Specific Language | 2016 – 2019 | This dynamic template engine parses custom Domain-Specific Language files into interactive forms. It converts inline control tags into text boxes, dropdowns, and automated mathematical formulas. | `RadTemplate.ahk`, `RadTemplate2.ahk`, `ReadMe.txt` |
| **[showLungCAD (AI Nodule Assistant)](03-attending-2016-present/showLungCAD)** | AutoHotkey v1, C++, DICOM, REST | 2016 – 2019 | This clinical assistant reviews lung nodule detections from self-trained and deployed deep learning system. It features 3D morphological region growing to measure lesion volumes and provides single-key feedback. | `showLungCAD.ahk`, `Orthanc2Dicom.ahk`, `ReadMe.txt` |
| **[urgentReport (Critical Findings Paging)](03-attending-2016-present/urgentReport)** | AutoHotkey v1, HTML5, DataTables, SMS API | 2016 – 2019 | This alert system facilitates communication of critical imaging findings to primary care teams. It monitors acute cases and provides a single-click SMS paging bridge for emergency notifications. | `urgentReport.ahk`, `selectCT.ahk`, `ReadMe.txt` |
| **[portalMessage](03-attending-2016-present/portalMessage)** | AutoHotkey v1, SMS Gateway | 2016 – 2019 | This communication utility broadcasts announcements and urgent messages through hospital SMS gateways. Users address clinical teams and on-call groups using aliases. | `portalMessage.ahk`, `ReadMe.txt` |
| **[diffReport](03-attending-2016-present/diffReport)** | AutoHotkey v1, HTML/CSS | 2016 – 2019 | This comparison viewer displays text revisions between draft and finalized radiology reports. It shows side-by-side modifications before electronic signature submission. | `diffReport.ahk`, `ReadMe.txt` |
| **[LDCTreport (Low Dose CT Screening)](03-attending-2016-present/LDCTreport)** | AutoHotkey v1 | 2016 – 2019 | This structured reporting tool supports Low Dose Chest CT lung screening. It follows Fleischner 2017 guidelines to record nodule characteristics and generate follow-up recommendations. | `LDCTreport.ahk`, `ReadMe.txt` |
| **[EBMpreload](03-attending-2016-present/EBMpreload)** | AutoHotkey v1, PACS Integration | 2016 – 2019 | This accelerator preloads upcoming patient examinations in the EBM PACS viewer. It eliminates image loading delays during high-volume radiography reading sessions. | `EBMpreload.ahk`, `ReadMe.txt` |
| **[COM Classes Framework & UIAutomationServer](03-attending-2016-present/COM_Classes_Framework)** | AutoHotkey v1, C#, Win32 COM, UIAutomation | 2012 – 2019 | This library provides object-oriented abstractions for Win32 COM interfaces and Microsoft UI Automation. It enables reliable control of hospital software and accessibility trees without visual scraping. | `CCF.ahk`, `CCFramework.ahk`, `README.md` |
| **[FinishReportAnalysis](03-attending-2016-present/FinishReportAnalysis)** | JavaScript, pandas-js, SheetJS, HTML5 | 2019/05 | This client-side analytics dashboard calculates reporting volume and turnaround times from exported RIS data. It runs entirely inside the browser using JavaScript dataframe libraries. | `main.js`, `index.html`, `dataframe.min.js` |
| **[AutoCXR (Chest Radiograph Assistant)](03-attending-2016-present/AutoCXR)** | AutoHotkey v1, Workstation Automation | 2018 | This tool assists high-volume chest radiograph interpretation with one-key normal template fills and negative finding verifications. | `AutoCXR.ahk` |
| **[DICOM Query & Fetch Client](03-attending-2016-present/dicomFetch)** | AutoHotkey v1, DCM4CHE, DICOM | 2018 – 2021 | This client queries remote hospital PACS and DICOM archives to fetch prior imaging studies into local workstation cache. | `dicomFetch.ahk`, `dicomFetch - VAB.ahk` |
| **[EBM PACS Viewport Accelerator](03-attending-2016-present/EBMhelper)** | AutoHotkey v1, Win32 Automation | 2017 – 2019 | This helper synchronizes viewport arrangements, zoom factors, and slice navigation across multi-monitor EBM PACS setups. | `EBMhelper.ahk` |
| **[GE Senographe Workstation Helper](03-attending-2016-present/GE_Mammo_Script)** | AutoHotkey v1, Workstation Hooks | 2017 | This script streamlines interactions with GE Senographe mammography acquisition and review stations. | `GE_Mammo_Script.ahk` |
| **[Automated Report Search & Downloader](03-attending-2016-present/getSearchReport)** | AutoHotkey v1, RIS Automation | 2016 – 2017 | This tool automates multi-parameter queries inside hospital RIS to search, aggregate, and download cohort reports for clinical studies. | `getSearchReport.ahk`, `parseSearchReport.ahk` |
| **[IMPAX Batch Study Driver](03-attending-2016-present/ImpaxBatchOpen)** | AutoHotkey v1, COM & Context Server | 2017 – 2021 | This enterprise driver drives Agfa IMPAX 6 to open patient examinations in batch sequences by accession number or chart ID. | `ImpaxBatch.ahk`, `ImpaxBatchAccNo.ahk`, `get_patho_report.ahk` |
| **[IMPAX Study Tagger & Bookmarker](03-attending-2016-present/ImpaxTag)** | AutoHotkey v1, Overlay GUI | 2017 – 2019 | This overlay tool allows radiologists to tag, bookmark, and categorize interesting cases directly while reviewing studies in IMPAX. | `ImpaxTag.ahk`, `showMagicResult.ahk` |
| **[Mammography Prior Review Helper](03-attending-2016-present/MammoHelper)** | AutoHotkey v1, Context Sync | 2018 – 2021 | This assistant automatically loads and compares prior mammograms, historical breast biopsies, and pathology reports. | `OldExamHelper.ahk` |
| **[Remote Reading Room RIS Mirror](03-attending-2016-present/mirrorRIS)** | AutoHotkey v1, SSH Tunnel, Sockets | 2017 – 2019 | This client-server daemon synchronizes active examination states between on-site hospital RIS and remote reading workstations over SSH tunnels. | `mirrorRIS.ahk`, `mirroRIS_server.ahk`, `sshTunneling.ahk` |
| **[Deferred Reporting Queue Manager](03-attending-2016-present/reportLater)** | AutoHotkey v1, Worklist Filter | 2018 – 2019 | This floating list manager allows readers to defer complex examinations and prioritize urgent emergency studies. | `reportLater.ahk` |
| **[Examination Turnaround Analytics](03-attending-2016-present/reportSpentTime)** | AutoHotkey v1, Analytics | 2019 | This utility measures and logs real-time minutes spent on each examination type to assess reporting cognitive load and efficiency. | `reportSpentTime.ahk` |
| **[RIS Background Polling Server](03-attending-2016-present/RisServer)** | AutoHotkey v1, Inter-Process IPC | 2017 – 2019 | This server runs silently in the background to poll active study identifiers from RIS and broadcast changes to satellite tools. | `RisServer.ahk`, `RisImpaxPolling.ahk` |
| **[Automated DICOM Series Exporter](03-attending-2016-present/SaveDICOM)** | AutoHotkey v1, File System | 2020 | This tool monitors PACS export directories and automatically organizes exported DICOM series and key images into structured folders. | `saveDicom.ahk` |
| **[Siemens syngo.via Workstation Bridge](03-attending-2016-present/syngoVia_integration)** | AutoHotkey v1, Window Hooks, Interop | 2016 – 2019 | This integration bridge drives Siemens syngo.via advanced visualization software directly from routine reading room hotkeys. | `syngoVia.ahk`, `syngoVia2.ahk`, `RAID2Syngovia.ahk` |
| **[Vacuum-Assisted Biopsy Assistant](03-attending-2016-present/VAB_study)** | AutoHotkey v1, Image Navigation | 2018 | This specialized tool aggregates mammographic calcification targets and historical biopsy markers for vacuum-assisted biopsy planning. | `VAB_prior_mammo.ahk` |
| **[Clinical Order & Procedure Analyzer](03-attending-2016-present/ClinicalOrders)** | AutoHotkey v1, Table Parsing, JXON | 2018 | This tool parses hospital clinical order tables and procedure codes to audit departmental productivity and compliance. | `analysis.ahk`, `performance.ahk` |
| **[Coronary CTA Reporting Suite](03-attending-2016-present/CCTA_tools)** | AutoHotkey v1, Structured Reporting | 2017 – 2018 | This suite formats Coronary CT Angiography reports, records coronary artery stenosis scores (CAD-RADS), and parses batch CCTA data. | `coronary CTA table.ahk`, `20180705 ConvertCCTAReports.ahk`, `20180705 GetCCTAReports.ahk` |
| **[Hologic SecurView Workstation Helper](03-attending-2016-present/HologicWS)** | AutoHotkey v1, UI Automation | 2020 | This helper coordinates keyboard shortcuts and view arrangements on dedicated Hologic SecurView mammography workstations. | `HologicWS.ahk` |
| **[Philips IntelliSpace Portal Helper](03-attending-2016-present/Philips_ISP)** | AutoHotkey v1, Automation | 2018 | This automation script searches and opens advanced visualization studies inside Philips IntelliSpace Portal. | `PhilipsISP.ahk` |
| **[Toshiba / Canon Workstation Helper](03-attending-2016-present/Toshiba_Workstation)** | AutoHotkey v1, .NET & Win32 Interop | 2016 – 2017 | This bridge connects hospital RIS and IMPAX context with Toshiba / Canon CT and MRI analysis workstations. | `Toshiba.ahk` |
| **[Firefox Clinical Portal Automation](03-attending-2016-present/FirefoxLogin)** | AutoHotkey v1, WebExtensions | 2016 – 2020 | This utility automates secure authentication and session management for modern web-based clinical reporting portals in Firefox. | `FirefoxLogin.ahk`, `FirefoxLoginAppTest.ahk` |
| **[Ward Round & Consultation Helper](03-attending-2016-present/WardRun)** | AutoHotkey v1, Mobile Workflow | 2016 – 2017 | This tool streamlines bedside clinical consultations and ward rounding note generation on mobile workstation carts. | `WardRun.ahk` |
| **[Workstation Desktop Enhancement Utilities](03-attending-2016-present/desktop_utilities)** | AutoHotkey v1, Win32 Hooks | 2013 – 2018 | A collection of lightweight Windows desktop utilities for reading room dual-monitor setups (desktop toggling, window pinning, wallpaper settings). | `ImprovedShowDesktop.ahk`, `WinEventHook Messages.ahk`, `setTargets.ahk`, `changeBackground.ahk` |
| **[ImpaxContextServer](03-attending-2016-present/ImpaxContextServer)** | VB.NET WinForms, WM_COPYDATA, Agfa/Mitra COM | 2014 – 2016 | Agfa IMPAX Context Server background bridge via WM_COPYDATA messaging. Listens for external IPC commands and issues COM DoAction calls to IMPAX. | `BuildString.Designer.vb`, `BuildString.vb`, `ImpaxContextServer.Designer.vb`, `ImpaxContextServer.resx` |
| **[scsnake_IPC](03-attending-2016-present/scsnake_IPC)** | VB.NET WinForms, WM_COPYDATA | 2016 – 2017 | Lightweight WM_COPYDATA IPC receiver template providing structured inter-process messaging between AutoHotkey scripts and .NET services. | `scsnake_IPC.sln`, `scsnake_IPC\scsnake_IPC.Designer.vb`, `scsnake_IPC\scsnake_IPC.resx`, `scsnake_IPC\scsnake_IPC.vb` |
| **[convertForm](03-attending-2016-present/convertForm)** | AutoHotkey v1, RisImpax, String Parsing | 2020 | Emergency on-call fee claim assistant. Parses weekend and holiday report tables from RIS to compute on-call duty hours and populate claim forms. | `convertForm.ahk` |
| **[FastHotkey](03-attending-2016-present/FastHotkey)** | AutoHotkey v1 Class Engine, Keyboard Hook | 2016 – 2017 | High-performance class-based hotstring compiler and engine. Pre-compiles hotstring dictionaries into indexed classes for instantaneous text expansion. | `FastHotkey - lazy.ahk`, `FastHotkey - lowlevelhook.ahk`, `FastHotkey.ahk`, `FastHotkey_Class.ahk` |
| **[dcm4che_wrapper](03-attending-2016-present/dcm4che_wrapper)** | AutoHotkey v1, dcm4che CLI, DICOM Dictionary | 2017 – 2018 | Wrapper library for dcm4che findscu and movescu commands, enabling DICOM C-FIND and C-MOVE queries directly from AutoHotkey workflows. | `dcm4che.ahk`, `DicomTagName.ahk` |
| **[cth_ris_bridge](03-attending-2016-present/cth_ris_bridge)** | AutoHotkey v1, IE COM, DOM Automation | 2021 – 2023 | C hospital RIS automation bridge. Integrates worklist extraction, accession navigation, and report field synchronization. | `CTH_RIS.ahk`, `getPlace.ahk` |
| **[RazerNaga](03-attending-2016-present/RazerNaga)** | AutoHotkey v1, Low-level Mouse Hook | 2017 – 2019 | Ergonomic 12-button Razer Naga mouse button mapping and smart scroll engine customized for IMPAX, RIS, and EBM image navigation. | `RazerNaga.ahk`, `getEBMSquareLoc.ahk` |
| **[searchOpHx](03-attending-2016-present/searchOpHx)** | AutoHotkey v1, Portal HTTP API | 2018 – 2019 | Automated surgical and admission history cross-referencing tool. Identifies post-operative and orthopedics cases during RIS worklist reading. | `searchOpHx.ahk` |
| **[monitorWebsite](03-attending-2016-present/monitorWebsite)** | AutoHotkey v1, HTTP, MD5 Hashing | 2016 – 2018 | Intranet website change detector. Monitors hospital duty rosters, departmental bulletins, and web notices using periodic MD5 hash comparison. | `monitorWebsite.ahk`, `website_list.txt` |
| **[annualMeetingScraper](03-attending-2016-present/annualMeetingScraper)** | AutoHotkey v1, HTTP Scraping | 2016 | RSROC annual radiological meeting abstract submission query and status scraper. | `annualMeetingScraper.ahk` |
| **[PacsIE_suite](03-attending-2016-present/PacsIE_suite)** | AutoHotkey v1, IE COM, Scintilla, HTTP/SOAP, AES | 2016 – 2019 | Comprehensive web automation suite including PacsIE portal integration, simpleRIS Scintilla editor, miniPACS prefetching, and feedRIS batching. | `20171006104857update.bat`, `8-lex_advancedhighlight.ahk`, `autoFeed.ahk`, `B.ico` |
| **[selectCT](03-attending-2016-present/selectCT)** | AutoHotkey v1, DataTables HTML, dcm4che | 2019 | Interactive CT worklist picker with sortable DataTables HTML UI, DICOM C-FIND queries, and automatic RIS study shifting. | `selectCT.ahk`, `selectCT_Query.ahk`, `shiftCT.ahk`, `datatable.html` |

---

## Flagship Systems & Innovations

### 1. MammoSR & PacsIE Suite
Comprehensive web and PACS automation suite for breast cancer screening and clinical reporting.
- **Workflow**: Intercepts study metadata from IMPAX and web controls via COM and UI Automation.
- **simpleRIS & miniPACS**: Scintilla report editor with autosave recovery and prior image prefetching.
- **Output**: Generates standardized, formatted clinical reports and embeds digital signatures.

### 2. RadTemplate (DSL Template Engine)
An interactive reporting template parser that replaces static text snippets with dynamic forms.
- Form fields defined inline: `[text]`, `[dropdown1|dropdown2]`, `{multi|select}`, `[//w300]`.
- Built-in mathematical evaluation: `[//v=VAR**2*pi]` for automatic organ volume and clearance calculations.

### 3. RisTyper, FastHotkey & textHotkey
High-efficiency reporting overlay that sits directly on top of workstation editor controls.
- Single-key toggle between PACS viewports and report editors.
- Semantic navigation: moves and deletes text by word (`Ctrl`), clause (`Alt`), or full sentence (`Win`).
- Class-compiled hotstring dictionary for instantaneous phrase expansion.

### 4. showLungCAD & 3D Region Growing
An AI-assisted lung screening tool integrating CAD nodule detections directly into the workstation viewer.
- Communicates with AI inference backends and PACS via REST and DICOM protocols.
- Includes a 3D morphological region growing module to segment lesion volume with interactive feedback.
- One-key feedback loop (`Win+P` for False Positive, `Win+N` for False Negative) to assist dataset curation.

### 5. scsnake Package Manager (`scsPackageManager`)
An intranet-based modular package manager designed to deploy script updates across reading room workstations.
- Validates modules via MD5 checksums.
- Resolves dependencies between packages.
- Provides drag-and-drop updating for non-technical users.

---

## Technical Stack
- **Primary Languages**: AutoHotkey v1.1 (Unicode / UTF-8 BOM), JavaScript, Python, C#, VB.NET, C++
- **Libraries & Protocols**: Win32 API, COM / OLE, Microsoft UIAutomation, LibHaru (HPDF), GDI+, AHKsock, REST, DICOM
- **Environment**: Windows 7 / 10 Workstations

---

## License
Released under the [MIT License](LICENSE) with Archival & Medical Disclaimer. Provided solely for historical, educational, and portfolio reference. Not intended, warranted, or maintained for clinical diagnosis or patient care.