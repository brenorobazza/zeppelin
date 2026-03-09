export const maturitySnapshot = {
  organization: "Zeppelin Labs",
  cycle: "Q1 2026",
  updatedAt: "March 2026",
  overallScore: 74,
  ciScore: 78,
  cdScore: 70,
  strengths: [
    "Build success rate above 95% for core repositories.",
    "Standard pipeline templates adopted by most squads.",
    "Fast feedback loop in pull request validation."
  ],
  bottlenecks: [
    "Manual approvals still gate production releases.",
    "Security scans happen too late in deployment flow.",
    "Rollback runbooks are inconsistent across teams."
  ]
};

export const assessmentQuestions = [
  {
    id: 1,
    dimension: "Continuous Integration",
    question: "How consistently are automated builds triggered on every pull request?"
  },
  {
    id: 2,
    dimension: "Quality Engineering",
    question: "How broadly are automated tests covering critical application flows?"
  },
  {
    id: 3,
    dimension: "Continuous Delivery",
    question: "How standardized is the deployment process across products and squads?"
  },
  {
    id: 4,
    dimension: "Security",
    question: "At which stage are security checks executed in your delivery pipeline?"
  }
];

export const answerScale = [
  "Not adopted",
  "Abandoned",
  "Project/Product level",
  "Partially institutionalized",
  "Institutionalized"
];

export const dimensionScores = [
  { name: "Planning & Governance", score: 82 },
  { name: "Continuous Integration", score: 78 },
  { name: "Quality Engineering", score: 69 },
  { name: "Continuous Delivery", score: 70 },
  { name: "Observability", score: 64 },
  { name: "Security in Pipeline", score: 58 }
];

export const recommendations = [
  {
    id: 1,
    practice: "Policy-as-code for deployment approvals",
    pillar: "CD",
    currentLevel: "Project/Product level",
    suggestion: "Replace manual approvals with policy rules integrated into the pipeline.",
    expectedImpact: "Reduce lead time and increase release frequency.",
    estimatedEffort: "Medium",
    priority: "High",
    status: "Planned"
  },
  {
    id: 2,
    practice: "Shift security scans left",
    pillar: "CI",
    currentLevel: "Partially institutionalized",
    suggestion: "Run SAST and dependency checks at pull request stage.",
    expectedImpact: "Lower vulnerability leakage to release stage.",
    estimatedEffort: "Medium",
    priority: "High",
    status: "In progress"
  },
  {
    id: 3,
    practice: "Mandatory integration test baseline",
    pillar: "CI",
    currentLevel: "Abandoned",
    suggestion: "Enforce minimum integration coverage for critical backend services.",
    expectedImpact: "Increase confidence and reduce regressions in releases.",
    estimatedEffort: "High",
    priority: "Medium",
    status: "Planned"
  },
  {
    id: 4,
    practice: "Standard rollback playbook",
    pillar: "CD",
    currentLevel: "Project/Product level",
    suggestion: "Create a common rollback runbook and drills for all squads.",
    expectedImpact: "Faster mitigation during production incidents.",
    estimatedEffort: "Low",
    priority: "Medium",
    status: "Completed"
  }
];

export const historySeries = [
  { period: "Q2 2025", overall: 56, ci: 60, cd: 52 },
  { period: "Q3 2025", overall: 61, ci: 65, cd: 58 },
  { period: "Q4 2025", overall: 68, ci: 72, cd: 64 },
  { period: "Q1 2026", overall: 74, ci: 78, cd: 70 }
];
