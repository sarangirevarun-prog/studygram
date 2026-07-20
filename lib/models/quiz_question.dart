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
    website: "msbte.org.in",
    url: "https://msbte.org.in",
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
    website: "msbte.org.in",
    url: "https://msbte.org.in",
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
    website: "msbte.org.in",
    url: "https://msbte.org.in",
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
    website: "msbte.org.in",
    url: "https://msbte.org.in",
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
    website: "msbte.org.in",
    url: "https://msbte.org.in",
    affiliation: "MSBTE / AICTE",
    duration: "3 Years",
    degree: "Diploma in Electronics & Telecommunication",
  ),
};

// ─── Quiz Question Model ──────────────────────────────────────────────────────
class QuizQuestion {
  final String question;
  final List<String> options;
  final int answerIndex;
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answerIndex,
  });
}

// ─── Branch → Subjects Database ──────────────────────────────────────────────
const Map<String, List<String>> branchSubjectsDb = {
  "Computer Engineering":   ["JAVA", "Python", "MIC", "UI/UX", "DCN", "EES"],
  "Civil Engineering":      ["Surveying", "Concrete Tech", "Hydraulics", "Soil Mechanics", "Structural Analysis"],
  "Mechanical Engineering": ["Thermodynamics", "Fluid Mechanics", "CAD/CAM", "Theory of Machines", "Manufacturing Processes"],
  "Electrical Engineering": ["Electrical Circuits", "Power Systems", "Control Systems", "Electrical Machines", "Power Electronics"],
  "ENTC":                   ["Digital Electronics", "Microcontrollers", "Signals & Systems", "Electromagnetics", "Analog Communication"],
};

// ─── Quiz Questions ───────────────────────────────────────────────────────────
const List<QuizQuestion> javaQuizQuestions = [
  QuizQuestion(
    question: "Which of the following is NOT a core feature of Java?",
    options: ["Dynamic Linking", "Architecture Neutral", "Direct pointer manipulation", "Object-oriented design"],
    answerIndex: 2,
  ),
  QuizQuestion(
    question: "What is the size of a double variable in Java?",
    options: ["16 bits", "32 bits", "64 bits", "128 bits"],
    answerIndex: 2,
  ),
  QuizQuestion(
    question: "Which package contains the standard Random class in Java?",
    options: ["java.lang", "java.util", "java.io", "java.net"],
    answerIndex: 1,
  ),
  QuizQuestion(
    question: "Which of the following is a valid declaration of a boolean variable?",
    options: ["boolean b1 = 1;", "boolean b2 = 'false';", "boolean b3 = false;", "boolean b4 = \"true\";"],
    answerIndex: 2,
  ),
  QuizQuestion(
    question: "What does JVM stand for in Java's execution process?",
    options: ["Java Virtual Machine", "Java Very Minimum", "Java Visual Memory", "Joint Vector Method"],
    answerIndex: 0,
  ),
];
