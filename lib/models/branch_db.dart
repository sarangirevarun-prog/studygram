// ─── Branch Info Model ────────────────────────────────────────────────────────
class BranchInfo {
  final String name;
  final String description;
  final String website;
  final String url;           // Full https URL for launching
  final String affiliation;   // e.g. MSBTE / AICTE
  final String duration;      // e.g. "3 Years"
  final String degree;        // e.g. "Diploma in Computer Engineering"

  const BranchInfo({
    required this.name,
    required this.description,
    required this.website,
    required this.url,
    required this.affiliation,
    required this.duration,
    required this.degree,
  });
}

// ─── Diploma Branch Info Database ────────────────────────────────────────────
/// User-provided branch data with official websites and resource URLs.
const Map<String, BranchInfo> diplomaBranchInfoDb = {
  "Computer Engineering": BranchInfo(
    name: "Computer Engineering",
    description:
        "Covers programming, data structures, operating systems, networking, "
        "databases, and software development. One of the most sought-after "
        "technical diploma branches in modern industry.",
    website: "msbte.ac.in",
    url: "https://msbte.ac.in",
    affiliation: "MSBTE / AICTE",
    duration: "3 Years",
    degree: "Diploma in Computer Engineering",
  ),
  "Civil Engineering": BranchInfo(
    name: "Civil Engineering",
    description:
        "Focuses on construction technology, surveying, structural design, "
        "concrete technology, hydraulics, and environmental engineering. "
        "Essential for infrastructure and urban development.",
    website: "msbte.ac.in",
    url: "https://msbte.ac.in",
    affiliation: "MSBTE / AICTE",
    duration: "3 Years",
    degree: "Diploma in Civil Engineering",
  ),
  "Mechanical Engineering": BranchInfo(
    name: "Mechanical Engineering",
    description:
        "Includes thermodynamics, fluid mechanics, manufacturing processes, "
        "CAD/CAM, and theory of machines. Trains students for production, "
        "design, and industrial maintenance roles.",
    website: "msbte.ac.in",
    url: "https://msbte.ac.in",
    affiliation: "MSBTE / AICTE",
    duration: "3 Years",
    degree: "Diploma in Mechanical Engineering",
  ),
  "Electrical Engineering": BranchInfo(
    name: "Electrical Engineering",
    description:
        "Covers electrical circuits, power systems, control systems, electrical "
        "machines, and power electronics. Prepares graduates for energy sector "
        "and industrial automation roles.",
    website: "msbte.ac.in",
    url: "https://msbte.ac.in",
    affiliation: "MSBTE / AICTE",
    duration: "3 Years",
    degree: "Diploma in Electrical Engineering",
  ),
  "ENTC": BranchInfo(
    name: "Electronics & Telecommunication",
    description:
        "Studies digital electronics, microcontrollers, signals & systems, "
        "analog communication, and electromagnetics. Core branch for telecom, "
        "embedded systems, and IoT industries.",
    website: "msbte.ac.in",
    url: "https://msbte.ac.in",
    affiliation: "MSBTE / AICTE",
    duration: "3 Years",
    degree: "Diploma in Electronics & Telecommunication",
  ),
};

// ─── Branch → Subjects Database (Flat list for search) ───────────────────────
const Map<String, List<String>> branchSubjectsDb = {
  "Computer Engineering": [
    "Basic Mathematics", "Communication Skills", "Basic Science", "Fundamentals of ICT", 
    "Engineering Workshop", "Yoga & Meditation", "Engineering Graphics",
    "Applied Mathematics", "Electrical & Electronics", "Programming in C", "Linux Basics", 
    "Professional Communication", "Social & Life Skills", "Web Page Designing",
    "Data Structure Using C", "Database Management", "Digital Techniques", "OOP Using C++", 
    "Computer Graphics", "Indian Constitution",
    "Environmental Education", "Java Programming", "Data Communication & Net", 
    "Microprocessor Programming", "Python Programming", "UI/UX Design",
    "Operating System", "Software Engineering", "Entrepreneurship Dev", "Seminar & Project Init", 
    "Internship", "Cloud Computing",
    "Management", "Emerging Trends", "Software Testing", "Client Side Scripting", 
    "Mobile App Development", "Capstone Project", "Machine Learning",
    "English", "Basic Electronics", "Elements of Electrical Engg", 
    "Object Oriented Programming using C++", "Data Structures", "Database Management System", 
    "Data Communication and Computer Network", "Microprocessors", 
    "Computer Peripherals and Hardware Maintenance", "Advanced Java Programming", 
    "Advanced Computer Network", "Client Side Scripting with JavaScript", 
    "Programming with Python", "Emerging Trends in CO & IT", "Network and Information Security"
  ],
  "Civil Engineering": [
    "Surveying", "Concrete Tech", "Hydraulics", "Soil Mechanics", 
    "Structural Analysis", "Building Construction", "Transportation Engg", 
    "Environmental Engg", "Estimating & Costing", "Irrigation Engg", 
    "Concrete Technology", "Design of Structures",
    "English", "Applied Science", "Basic Mathematics", "Applied Mechanics", 
    "Construction Materials", "Basic Surveying", "Advanced Surveying", 
    "Highway Engineering", "Mechanics of Structures", "Theory of Structures", 
    "Geotechnical Engineering", "Design of Steel & RC Structures", 
    "Public Health Engineering", "Contracts & Accounts", "Maintenance & Repairs", 
    "Construction Management"
  ],
  "Mechanical Engineering": [
    "Thermodynamics", "Fluid Mechanics", "CAD/CAM", "Theory of Machines", 
    "Manufacturing Processes", "Material Science", "Strength of Materials", 
    "Thermal Engineering", "Machine Design", "Industrial Engineering", 
    "Refrigeration & AC", "Automobile Engineering",
    "English", "Applied Science", "Basic Mathematics", "Applied Mechanics", 
    "Engineering Drawing", "Workshop Practice", "Mechanical Engineering Materials", 
    "Basic Electrical & Electronics", "Fluid Mechanics & Machinery", 
    "Elements of Machine Design", "Power Engineering", "Advanced Manufacturing Processes"
  ],
  "Electrical Engineering": [
    "Electrical Circuits", "Power Systems", "Control Systems", "Electrical Machines", 
    "Power Electronics", "Electrical Measurements", "Digital Electronics", 
    "Microprocessors", "Switchgear & Protection", "Electrical Estimation", 
    "Utilisation of Elec Energy", "Industrial Drives",
    "English", "Applied Science", "Basic Mathematics", "Basic Electrical Engineering", 
    "Electrical Materials", "Engineering Graphics", "Electrical Power Generation", 
    "Electrical Machines I", "Digital Electronics & Microcontrollers", 
    "Electrical Machines II", "Transmission & Distribution", "Electrical Estimation & Costing"
  ],
  "ENTC": [
    "Digital Electronics", "Microcontrollers", "Signals & Systems", "Electromagnetics", 
    "Analog Communication", "Network Analysis", "Electronic Devices & Ckts", 
    "Linear Integrated Ckts", "Mobile Communication", "Embedded Systems", 
    "Fiber Optic Comm", "VLSI Design",
    "English", "Applied Science", "Basic Mathematics", "Electronic Components & Devices", 
    "Basic Electronics", "Engineering Graphics", "Digital Techniques", "Applied Electronics", 
    "Electric Circuits & Networks", "Control Systems & PLC", "Audio Video Engineering", 
    "Mobile & Wireless Communication", "VLSI with VHDL", "Consumer Electronics"
  ],
};

// ─── Branch → Scheme → Year → Semester → Subjects Database ───────────────────
// Schemes: "K Scheme", "I Scheme"
// Years: 1 (1st Year), 2 (2nd Year), 3 (3rd Year)
// Semesters: 1 to 6
// - Year 1: Semester 1 & 2
// - Year 2: Semester 3 & 4
// - Year 3: Semester 5 & 6
const Map<String, Map<String, Map<int, Map<int, List<String>>>>> branchSemestersDb = {
  "Computer Engineering": {
    "K Scheme": {
      1: {
        1: ["Basic Mathematics", "Communication Skills", "Basic Science", "Fundamentals of ICT", "Engineering Workshop", "Yoga & Meditation", "Engineering Graphics"],
        2: ["Applied Mathematics", "Electrical & Electronics", "Programming in C", "Linux Basics", "Professional Communication", "Social & Life Skills", "Web Page Designing"],
      },
      2: {
        3: ["Data Structure Using C", "Database Management", "Digital Techniques", "OOP Using C++", "Computer Graphics", "Indian Constitution"],
        4: ["Environmental Education", "Java Programming", "Data Communication & Net", "Microprocessor Programming", "Python Programming", "UI/UX Design"],
      },
      3: {
        5: ["Operating System", "Software Engineering", "Entrepreneurship Dev", "Seminar & Project Init", "Internship", "Cloud Computing"],
        6: ["Management", "Emerging Trends", "Software Testing", "Client Side Scripting", "Mobile App Development", "Capstone Project", "Machine Learning"],
      },
    },
    "I Scheme": {
      1: {
        1: ["English", "Basic Science", "Basic Mathematics"],
        2: ["Applied Mathematics", "Basic Electronics", "Elements of Electrical Engg", "Programming in C", "Web Page Designing"],
      },
      2: {
        3: ["Object Oriented Programming using C++", "Data Structures", "Computer Graphics", "Database Management System", "Digital Techniques"],
        4: ["Java Programming", "Software Engineering", "Data Communication and Computer Network", "Microprocessors", "Computer Peripherals and Hardware Maintenance"],
      },
      3: {
        5: ["Operating System", "Advanced Java Programming", "Software Testing", "Advanced Computer Network", "Client Side Scripting with JavaScript"],
        6: ["Management", "Programming with Python", "Mobile Application Development", "Emerging Trends in CO & IT", "Network and Information Security"],
      },
    },
  },
  "Civil Engineering": {
    "K Scheme": {
      1: {
        1: ["Surveying", "Concrete Tech"],
        2: ["Hydraulics", "Soil Mechanics"],
      },
      2: {
        3: ["Structural Analysis", "Building Construction"],
        4: ["Transportation Engg", "Environmental Engg"],
      },
      3: {
        5: ["Estimating & Costing", "Irrigation Engg"],
        6: ["Concrete Technology", "Design of Structures"],
      },
    },
    "I Scheme": {
      1: {
        1: ["English", "Applied Science", "Basic Mathematics"],
        2: ["Applied Mechanics", "Construction Materials", "Basic Surveying"],
      },
      2: {
        3: ["Advanced Surveying", "Highway Engineering", "Mechanics of Structures"],
        4: ["Theory of Structures", "Geotechnical Engineering", "Hydraulics"],
      },
      3: {
        5: ["Design of Steel & RC Structures", "Estimating & Costing", "Public Health Engineering"],
        6: ["Contracts & Accounts", "Maintenance & Repairs", "Construction Management"],
      },
    },
  },
  "Mechanical Engineering": {
    "K Scheme": {
      1: {
        1: ["Thermodynamics", "Fluid Mechanics"],
        2: ["CAD/CAM", "Theory of Machines"],
      },
      2: {
        3: ["Manufacturing Processes", "Material Science"],
        4: ["Strength of Materials", "Thermal Engineering"],
      },
      3: {
        5: ["Machine Design", "Industrial Engineering"],
        6: ["Refrigeration & AC", "Automobile Engineering"],
      },
    },
    "I Scheme": {
      1: {
        1: ["English", "Applied Science", "Basic Mathematics"],
        2: ["Applied Mechanics", "Engineering Drawing", "Workshop Practice"],
      },
      2: {
        3: ["Strength of Materials", "Mechanical Engineering Materials", "Basic Electrical & Electronics"],
        4: ["Theory of Machines", "Thermal Engineering", "Fluid Mechanics & Machinery"],
      },
      3: {
        5: ["Elements of Machine Design", "Power Engineering", "Advanced Manufacturing Processes"],
        6: ["Industrial Engineering", "Automobile Engineering", "Refrigeration & AC"],
      },
    },
  },
  "Electrical Engineering": {
    "K Scheme": {
      1: {
        1: ["Electrical Circuits", "Power Systems"],
        2: ["Control Systems", "Electrical Machines"],
      },
      2: {
        3: ["Power Electronics", "Electrical Measurements"],
        4: ["Digital Electronics", "Microprocessors"],
      },
      3: {
        5: ["Switchgear & Protection", "Electrical Estimation"],
        6: ["Utilisation of Elec Energy", "Industrial Drives"],
      },
    },
    "I Scheme": {
      1: {
        1: ["English", "Applied Science", "Basic Mathematics"],
        2: ["Basic Electrical Engineering", "Electrical Materials", "Engineering Graphics"],
      },
      2: {
        3: ["Electrical Circuits", "Electrical Measurements", "Electrical Power Generation"],
        4: ["Electrical Machines I", "Digital Electronics & Microcontrollers", "Power Electronics"],
      },
      3: {
        5: ["Electrical Machines II", "Switchgear & Protection", "Transmission & Distribution"],
        6: ["Electrical Estimation & Costing", "Utilisation of Electrical Energy", "Industrial Drives"],
      },
    },
  },
  "ENTC": {
    "K Scheme": {
      1: {
        1: ["Digital Electronics", "Microcontrollers"],
        2: ["Signals & Systems", "Electromagnetics"],
      },
      2: {
        3: ["Analog Communication", "Network Analysis"],
        4: ["Electronic Devices & Ckts", "Linear Integrated Ckts"],
      },
      3: {
        5: ["Mobile Communication", "Embedded Systems"],
        6: ["Fiber Optic Comm", "VLSI Design"],
      },
    },
    "I Scheme": {
      1: {
        1: ["English", "Applied Science", "Basic Mathematics"],
        2: ["Electronic Components & Devices", "Basic Electronics", "Engineering Graphics"],
      },
      2: {
        3: ["Digital Techniques", "Applied Electronics", "Electric Circuits & Networks"],
        4: ["Analog Communication", "Microcontrollers", "Linear Integrated Circuits"],
      },
      3: {
        5: ["Control Systems & PLC", "Audio Video Engineering", "Mobile & Wireless Communication"],
        6: ["Optical Fiber Communication", "VLSI with VHDL", "Consumer Electronics"],
      },
    },
  },
};
