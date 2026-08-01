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
    "Basic Mathematics", "Communication Skills", "Basic Science", "Basic Physics", "Basic Chemistry", "Fundamentals of ICT", 
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

// ─── B.Tech (Bachelor of Technology) Branch Info Database ───────────────────
const Map<String, BranchInfo> btechBranchInfoDb = {
  "Computer Science & Engineering": BranchInfo(
    name: "Computer Science & Engineering",
    description:
        "Focuses on algorithms, data structures, cloud computing, AI, software engineering, "
        "operating systems, and database design. Core undergraduate B.Tech program.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "4 Years",
    degree: "B.Tech in Computer Science & Engineering",
  ),
  "Information Technology": BranchInfo(
    name: "Information Technology",
    description:
        "Covers web engineering, network security, database management, cloud technologies, "
        "mobile computing, and IT project management.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "4 Years",
    degree: "B.Tech in Information Technology",
  ),
  "Artificial Intelligence & Data Science": BranchInfo(
    name: "Artificial Intelligence & Data Science",
    description:
        "Specialized degree in machine learning, deep learning, big data analytics, "
        "natural language processing, and computer vision.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "4 Years",
    degree: "B.Tech in AI & Data Science",
  ),
  "Electronics & Telecommunication": BranchInfo(
    name: "Electronics & Telecommunication",
    description:
        "Covers VLSI design, signal processing, wireless communication, embedded systems, "
        "microprocessors, and RF engineering.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "4 Years",
    degree: "B.Tech in Electronics & Telecommunication",
  ),
  "Mechanical Engineering": BranchInfo(
    name: "Mechanical Engineering",
    description:
        "Focuses on thermodynamics, robotics, CAD/CAM/CAE, finite element analysis, "
    "fluid dynamics, and advanced manufacturing.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "4 Years",
    degree: "B.Tech in Mechanical Engineering",
  ),
  "Civil Engineering": BranchInfo(
    name: "Civil Engineering",
    description:
        "Covers structural analysis, concrete technology, transportation, environmental "
        "engineering, surveying, and project management.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "4 Years",
    degree: "B.Tech in Civil Engineering",
  ),
  "Electrical Engineering": BranchInfo(
    name: "Electrical Engineering",
    description:
        "Covers smart power grids, renewable energy, power electronics, electric vehicles, "
        "control systems, and high voltage engineering.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "4 Years",
    degree: "B.Tech in Electrical Engineering",
  ),
  "Cyber Security": BranchInfo(
    name: "Cyber Security",
    description:
        "Specialized branch dealing with ethical hacking, network defense, cryptography, "
        "digital forensics, and security architecture.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "4 Years",
    degree: "B.Tech in Cyber Security",
  ),
};

// ─── B.Tech Branch → Subjects Database ───────────────────────────────────────
const Map<String, List<String>> btechBranchSubjectsDb = {
  "Computer Science & Engineering": [
    "Engineering Mathematics I", "Engineering Physics", "Programming for Problem Solving", "Basic Electrical Engg", "Engineering Graphics",
    "Engineering Mathematics II", "Engineering Chemistry", "Data Structures", "Digital Logic Design", "Python Programming",
    "Discrete Mathematics", "Object Oriented Programming (Java)", "Computer Organization & Architecture", "Database Management Systems", "Theory of Computation",
    "Design & Analysis of Algorithms", "Operating Systems", "Computer Networks", "Software Engineering", "Artificial Intelligence",
    "Compiler Design", "Web Technology", "Cloud Computing", "Machine Learning", "Information Security", "Capstone Project Part I",
    "Distributed Systems", "Deep Learning", "Internet of Things", "Big Data Analytics", "Cyber Security", "Capstone Project Part II"
  ],
  "Information Technology": [
    "Engineering Mathematics I", "Engineering Physics", "Basic Electronics", "Programming in C", "Engineering Graphics",
    "Engineering Mathematics II", "Engineering Chemistry", "Data Structures & Algorithms", "Digital Electronics", "Object Oriented Programming",
    "Discrete Structures", "Database Management Systems", "Computer Networks", "Operating Systems", "Web Technology",
    "Software Engineering", "Design & Analysis of Algorithms", "Network Security", "Java Programming", "Cloud Infrastructure",
    "Mobile Application Development", "Information Theory & Coding", "Data Mining & Warehousing", "Machine Learning", "DevOps Engineering",
    "Enterprise Resource Planning", "Big Data Engineering", "Blockchain Technology", "Major Project"
  ],
  "Artificial Intelligence & Data Science": [
    "Engineering Mathematics I", "Linear Algebra & Statistics", "Python for Data Science", "Digital Logic", "Engineering Graphics",
    "Engineering Mathematics II", "Data Structures in C++", "Probability & Random Processes", "Computer Architecture", "Object Oriented Programming",
    "Database Systems for Data Science", "Discrete Structures", "Machine Learning Foundations", "Operating Systems", "Algorithm Design",
    "Deep Learning & Neural Networks", "Natural Language Processing", "Big Data Analytics", "Computer Vision", "Reinforcement Learning",
    "Data Visualization", "AI Ethics & Governance", "MLOps", "Generative AI", "Capstone Project"
  ],
  "Electronics & Telecommunication": [
    "Engineering Mathematics I", "Engineering Physics", "Basic Electrical Engineering", "Engineering Graphics", "Programming in C",
    "Engineering Mathematics II", "Engineering Chemistry", "Electronic Devices & Circuits", "Network Theory", "Digital System Design",
    "Signals & Systems", "Electromagnetic Field Theory", "Analog Circuits", "Microprocessors & Microcontrollers", "Data Structures",
    "Digital Signal Processing", "Analog & Digital Communication", "Control Systems", "VLSI Design", "Antenna & Wave Propagation",
    "Embedded Systems", "Optical Communication", "Wireless Networks", "RF & Microwave Engg", "Project Part I",
    "Cellular Networks", "Satellite Communication", "Robotics & Automation", "Project Part II"
  ],
  "Mechanical Engineering": [
    "Engineering Mathematics I", "Engineering Physics", "Engineering Mechanics", "Basic Electrical", "Engineering Graphics",
    "Engineering Mathematics II", "Engineering Chemistry", "Thermodynamics", "Materials Engineering", "Manufacturing Processes I",
    "Fluid Mechanics", "Strength of Materials", "Kinematics of Machinery", "Manufacturing Processes II", "Applied Thermodynamics",
    "Dynamics of Machinery", "Heat Transfer", "Design of Machine Elements", "Fluid Machinery", "CAD/CAM",
    "Automobile Engineering", "Refrigeration & Air Conditioning", "Finite Element Analysis", "Industrial Engineering", "Mechatronics",
    "Power Plant Engineering", "Robotics & Automation", "Total Quality Management", "Major Project"
  ],
  "Civil Engineering": [
    "Engineering Mathematics I", "Engineering Physics", "Engineering Mechanics", "Basic Electrical", "Engineering Graphics",
    "Engineering Mathematics II", "Engineering Chemistry", "Building Technology", "Surveying I", "Strength of Materials",
    "Fluid Mechanics", "Surveying II", "Structural Analysis I", "Concrete Technology", "Geotechnical Engineering I",
    "Structural Analysis II", "Hydraulics & Hydraulic Machines", "Design of Reinforced Concrete Structures", "Geotechnical Engineering II", "Environmental Engineering I",
    "Design of Steel Structures", "Transportation Engineering", "Environmental Engineering II", "Construction Planning & Management", "Quantity Surveying & Valuation",
    "Irrigation & Water Resources Engg", "Town Planning", "Bridge Engineering", "Major Project"
  ],
  "Electrical Engineering": [
    "Engineering Mathematics I", "Engineering Physics", "Basic Electrical Engineering", "Engineering Mechanics", "Engineering Graphics",
    "Engineering Mathematics II", "Engineering Chemistry", "Electric Circuit Analysis", "Electrical Machines I", "Analog Electronics",
    "Electromagnetic Fields", "Electrical Machines II", "Digital Electronics", "Power Systems I", "Control Systems",
    "Power Electronics", "Power Systems II", "Microprocessors & Microcontrollers", "High Voltage Engineering", "Electrical Machine Design",
    "Switchgear & Protection", "Renewable Energy Systems", "Electric Drives", "Smart Grid Technologies", "Power Quality",
    "Electric Vehicle Technology", "Industrial Automation & PLC", "Project Work"
  ],
  "Cyber Security": [
    "Engineering Mathematics I", "Engineering Physics", "Computer Fundamentals", "Programming in C", "Engineering Graphics",
    "Engineering Mathematics II", "Data Structures", "Discrete Structures", "Computer Networks", "Digital Logic",
    "Operating Systems", "Object Oriented Programming", "Database Systems", "Cryptography & Network Security", "Ethical Hacking",
    "Software Security", "Linux System Administration", "Cyber Laws & Information Security", "Digital Forensics", "Web Application Security",
    "Penetration Testing & Vulnerability Analysis", "Cloud Security", "Mobile Device Security", "Malware Analysis", "Security Auditing",
    "Blockchain for Cyber Security", "Security Operations Center (SOC)", "Major Project"
  ],
};

// ─── B.Tech Scheme → Year → Semester → Subjects Database ───────────────────
const Map<String, Map<String, Map<int, Map<int, List<String>>>>> btechBranchSemestersDb = {
  "Computer Science & Engineering": {
    "Autonomous / Choice Based": {
      1: {
        1: ["Engineering Mathematics I", "Engineering Physics", "Programming for Problem Solving", "Basic Electrical Engg", "Engineering Graphics"],
        2: ["Engineering Mathematics II", "Engineering Chemistry", "Data Structures", "Digital Logic Design", "Python Programming"],
      },
      2: {
        3: ["Discrete Mathematics", "Object Oriented Programming (Java)", "Computer Organization & Architecture", "Database Management Systems", "Theory of Computation"],
        4: ["Design & Analysis of Algorithms", "Operating Systems", "Computer Networks", "Software Engineering", "Artificial Intelligence"],
      },
      3: {
        5: ["Compiler Design", "Web Technology", "Cloud Computing", "Machine Learning", "Information Security"],
        6: ["Distributed Systems", "Deep Learning", "Internet of Things", "Big Data Analytics", "Cyber Security"],
      },
      4: {
        7: ["Generative AI & LLMs", "DevOps & CI/CD", "Blockchain Fundamentals", "Enterprise Architecture"],
        8: ["Capstone Project Part II", "Industrial Internship", "Seminar & Industry Elective"],
      },
    },
  },
  "Information Technology": {
    "Autonomous / Choice Based": {
      1: {
        1: ["Engineering Mathematics I", "Engineering Physics", "Basic Electronics", "Programming in C", "Engineering Graphics"],
        2: ["Engineering Mathematics II", "Engineering Chemistry", "Data Structures & Algorithms", "Digital Electronics", "Object Oriented Programming"],
      },
      2: {
        3: ["Discrete Structures", "Database Management Systems", "Computer Networks", "Operating Systems", "Web Technology"],
        4: ["Software Engineering", "Design & Analysis of Algorithms", "Network Security", "Java Programming", "Cloud Infrastructure"],
      },
      3: {
        5: ["Mobile Application Development", "Information Theory & Coding", "Data Mining & Warehousing", "Machine Learning", "DevOps Engineering"],
        6: ["Enterprise Resource Planning", "Big Data Engineering", "Blockchain Technology", "Major Project"],
      },
      4: {
        7: ["Cyber Security Architecture", "Advanced Cloud Architectures", "Full Stack Web Development"],
        8: ["Major Internship", "Industry Project & Viva"],
      },
    },
  },
  "Artificial Intelligence & Data Science": {
    "Autonomous / Choice Based": {
      1: {
        1: ["Engineering Mathematics I", "Linear Algebra & Statistics", "Python for Data Science", "Digital Logic", "Engineering Graphics"],
        2: ["Engineering Mathematics II", "Data Structures in C++", "Probability & Random Processes", "Computer Architecture", "Object Oriented Programming"],
      },
      2: {
        3: ["Database Systems for Data Science", "Discrete Structures", "Machine Learning Foundations", "Operating Systems", "Algorithm Design"],
        4: ["Deep Learning & Neural Networks", "Natural Language Processing", "Big Data Analytics", "Computer Vision", "Reinforcement Learning"],
      },
      3: {
        5: ["Data Visualization", "AI Ethics & Governance", "MLOps", "Generative AI", "Capstone Project"],
        6: ["Advanced LLM Engineering", "Automated ML", "Edge AI & Embedded ML"],
      },
      4: {
        7: ["AI in Healthcare & Finance", "Scalable Data Pipelines", "Research Seminar"],
        8: ["Degree Capstone Project", "Industrial Internship"],
      },
    },
  },
  "Electronics & Telecommunication": {
    "Autonomous / Choice Based": {
      1: {
        1: ["Engineering Mathematics I", "Engineering Physics", "Basic Electrical Engineering", "Engineering Graphics", "Programming in C"],
        2: ["Engineering Mathematics II", "Engineering Chemistry", "Electronic Devices & Circuits", "Network Theory", "Digital System Design"],
      },
      2: {
        3: ["Signals & Systems", "Electromagnetic Field Theory", "Analog Circuits", "Microprocessors & Microcontrollers", "Data Structures"],
        4: ["Digital Signal Processing", "Analog & Digital Communication", "Control Systems", "VLSI Design", "Antenna & Wave Propagation"],
      },
      3: {
        5: ["Embedded Systems", "Optical Communication", "Wireless Networks", "RF & Microwave Engg", "Project Part I"],
        6: ["Cellular Networks", "Satellite Communication", "Robotics & Automation", "Project Part II"],
      },
      4: {
        7: ["5G/6G Wireless Communication", "IoT & Sensor Networks", "System on Chip Design"],
        8: ["Industry Internship", "Final Project Presentation"],
      },
    },
  },
};

// ─── M.Tech (Master of Technology) Branch Info Database ───────────────────
const Map<String, BranchInfo> mtechBranchInfoDb = {
  "Computer Science & Engineering": BranchInfo(
    name: "Computer Science & Engineering",
    description:
        "Post-graduate program focusing on advanced algorithms, parallel computing, "
        "high performance computing, quantum computing, and research methodologies.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "2 Years",
    degree: "M.Tech in Computer Science & Engineering",
  ),
  "Artificial Intelligence & Data Science": BranchInfo(
    name: "Artificial Intelligence & Data Science",
    description:
        "Advanced specialization in deep learning architectures, AI research, "
        "large language models, cognitive computing, and statistical learning theory.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "2 Years",
    degree: "M.Tech in AI & Data Science",
  ),
  "VLSI & Embedded Systems": BranchInfo(
    name: "VLSI & Embedded Systems",
    description:
        "Focuses on SoC design, CMOS analog & digital IC design, FPGA architectures, "
        "embedded Linux, and real-time operating systems.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "2 Years",
    degree: "M.Tech in VLSI & Embedded Systems",
  ),
  "Structural Engineering": BranchInfo(
    name: "Structural Engineering",
    description:
        "Advanced study of earthquake engineering, prestressed concrete, bridge design, "
        "non-linear structural dynamics, and computational mechanics.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "2 Years",
    degree: "M.Tech in Structural Engineering",
  ),
  "Thermal Engineering": BranchInfo(
    name: "Thermal Engineering",
    description:
        "Covers advanced heat transfer, computational fluid dynamics (CFD), cryogenic "
        "engineering, energy conservation, and combustion theory.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "2 Years",
    degree: "M.Tech in Thermal Engineering",
  ),
  "Power Systems": BranchInfo(
    name: "Power Systems",
    description:
        "Specializes in smart grid control, FACTS controllers, power system dynamics, "
        "renewable integration, and high voltage DC transmission.",
    website: "aicte-india.org",
    url: "https://www.aicte-india.org",
    affiliation: "AICTE / University",
    duration: "2 Years",
    degree: "M.Tech in Power Systems",
  ),
};

// ─── M.Tech Branch → Subjects Database ───────────────────────────────────────
const Map<String, List<String>> mtechBranchSubjectsDb = {
  "Computer Science & Engineering": [
    "Advanced Algorithms & Complexity", "Advanced Computer Architecture", "Mathematical Foundations of CS", "Research Methodology & IPR",
    "Advanced Operating Systems", "Advanced Database Systems", "Distributed Computing & Cloud Architectures", "Machine Learning Techniques",
    "Specialized Elective I (Quantum / Security)", "Dissertation Phase I",
    "Specialized Elective II (Big Data Analytics)", "Dissertation Phase II & Research Publication"
  ],
  "Artificial Intelligence & Data Science": [
    "Statistical Learning Theory", "Advanced Machine Learning", "Deep Learning Architectures", "Research Methodology & IPR",
    "Natural Language Processing & Transformers", "Computer Vision & Pattern Recognition", "Reinforcement Learning & Decision Making", "MLOps & Scalable AI",
    "Master Dissertation Phase I", "Master Dissertation Phase II & Thesis Defense"
  ],
  "VLSI & Embedded Systems": [
    "CMOS Digital IC Design", "VLSI Architecture & CAD Algorithms", "Embedded System Hardware & Software", "Research Methodology",
    "Analog & Mixed Signal IC Design", "Real Time Operating Systems (RTOS)", "Low Power VLSI Design", "FPGA System Design",
    "Dissertation Stage 1", "Dissertation Stage 2 & Defense"
  ],
  "Structural Engineering": [
    "Advanced Structural Analysis", "Theory of Elasticity & Plasticity", "Dynamics of Structures", "Research Methodology & IPR",
    "Earthquake Resistant Design of Structures", "Prestressed Concrete Design", "Finite Element Method in Engineering", "Bridge Engineering",
    "Master Thesis Phase I", "Master Thesis Phase II & Defense"
  ],
  "Thermal Engineering": [
    "Advanced Thermodynamics", "Advanced Heat & Mass Transfer", "Advanced Fluid Mechanics", "Research Methodology",
    "Computational Fluid Dynamics (CFD)", "Design of Thermal Equipment", "Cryogenic Engineering", "Energy Audit & Management",
    "M.Tech Project Phase I", "M.Tech Project Phase II"
  ],
  "Power Systems": [
    "Advanced Power System Analysis", "Power System Dynamics & Stability", "Modern Control Theory", "Research Methodology",
    "Power Electronics Applications in Power Systems", "Smart Grid Technologies & Microgrids", "Power System Protection & Relay", "EHV AC & HVDC Transmission",
    "Master Thesis Phase I", "Master Thesis Phase II"
  ],
};

// ─── M.Tech Scheme → Year → Semester → Subjects Database ───────────────────
const Map<String, Map<String, Map<int, Map<int, List<String>>>>> mtechBranchSemestersDb = {
  "Computer Science & Engineering": {
    "PG Choice Based": {
      1: {
        1: ["Advanced Algorithms & Complexity", "Advanced Computer Architecture", "Mathematical Foundations of CS", "Research Methodology & IPR"],
        2: ["Advanced Operating Systems", "Advanced Database Systems", "Distributed Computing & Cloud Architectures", "Machine Learning Techniques"],
      },
      2: {
        3: ["Specialized Elective I (Quantum / Security)", "Dissertation Phase I"],
        4: ["Specialized Elective II (Big Data Analytics)", "Dissertation Phase II & Research Publication"],
      },
    },
  },
  "Artificial Intelligence & Data Science": {
    "PG Choice Based": {
      1: {
        1: ["Statistical Learning Theory", "Advanced Machine Learning", "Deep Learning Architectures", "Research Methodology & IPR"],
        2: ["Natural Language Processing & Transformers", "Computer Vision & Pattern Recognition", "Reinforcement Learning & Decision Making", "MLOps & Scalable AI"],
      },
      2: {
        3: ["Master Dissertation Phase I"],
        4: ["Master Dissertation Phase II & Thesis Defense"],
      },
    },
  },
  "VLSI & Embedded Systems": {
    "PG Choice Based": {
      1: {
        1: ["CMOS Digital IC Design", "VLSI Architecture & CAD Algorithms", "Embedded System Hardware & Software", "Research Methodology"],
        2: ["Analog & Mixed Signal IC Design", "Real Time Operating Systems (RTOS)", "Low Power VLSI Design", "FPGA System Design"],
      },
      2: {
        3: ["Dissertation Stage 1"],
        4: ["Dissertation Stage 2 & Defense"],
      },
    },
  },
};

// ─── Helper utilities for selecting course-specific databases ───────────────
Map<String, BranchInfo> getBranchInfoDbForCourse(String courseKey) {
  final cleanKey = courseKey.toLowerCase().trim();
  if (cleanKey == "b.tech" || cleanKey == "btech" || cleanKey == "degree") {
    return btechBranchInfoDb;
  } else if (cleanKey == "m.tech" || cleanKey == "mtech") {
    return mtechBranchInfoDb;
  }
  return diplomaBranchInfoDb;
}

Map<String, List<String>> getBranchSubjectsDbForCourse(String courseKey) {
  final cleanKey = courseKey.toLowerCase().trim();
  if (cleanKey == "b.tech" || cleanKey == "btech" || cleanKey == "degree") {
    return btechBranchSubjectsDb;
  } else if (cleanKey == "m.tech" || cleanKey == "mtech") {
    return mtechBranchSubjectsDb;
  }
  return branchSubjectsDb;
}

Map<String, Map<String, Map<int, Map<int, List<String>>>>> getBranchSemestersDbForCourse(String courseKey) {
  final cleanKey = courseKey.toLowerCase().trim();
  if (cleanKey == "b.tech" || cleanKey == "btech" || cleanKey == "degree") {
    return btechBranchSemestersDb;
  } else if (cleanKey == "m.tech" || cleanKey == "mtech") {
    return mtechBranchSemestersDb;
  }
  return branchSemestersDb;
}

