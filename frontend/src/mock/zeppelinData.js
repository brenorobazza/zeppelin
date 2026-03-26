export const maturitySnapshot = {
  organization: "Zeppelin Labs",
  organizationType: "Internal IT Department",
  calibratedProfile: "IT Department calibration profile",
  cycle: "Cycle 03",
  cycleLabel: "March 2026 diagnostic session",
  updatedAt: "Updated on March 12, 2026",
  answeredPractices: 32,
  overallScore: 67,
  ciScore: 69,
  cdScore: 64,
  recommendationCount: 9,
  executiveSummary:
    "This cycle consolidates the CI/CD subset of the Zeppelin instrument and translates the answered practices into a calibrated diagnosis, highlighting what is already mature, where adoption is still local and which improvements should be prioritized next.",
  overallInterpretation:
    "Continuous Integration is already operating close to process level, while Continuous Deployment still depends on stronger release automation, feedback loops and cross-team coordination to scale safely.",
  strengths: [
    {
      id: 1,
      questionId: "CI.08",
      stage: "CI",
      title: "Version control is already a mature foundation",
      evidence:
        "Code, tests and scripts are already managed in a common repository with traceable history and shared conventions."
    },
    {
      id: 2,
      questionId: "CI.06",
      stage: "CI",
      title: "Automated builds are part of the regular delivery routine",
      evidence:
        "Build execution is frequent enough to support a stable integration rhythm and reduce manual verification work."
    },
    {
      id: 3,
      questionId: "CD.01",
      stage: "CD",
      title: "Customer participation already informs part of the delivery flow",
      evidence:
        "The organization identifies key consumers and uses their feedback during planning and release discussions."
    }
  ],
  bottlenecks: [
    {
      id: 1,
      questionId: "CD.03",
      stage: "CD",
      title: "Automatic releases are not yet consistently institutionalized",
      evidence:
        "Production rollout still depends on manual checkpoints, which slows delivery and weakens traceability between validation and release."
    },
    {
      id: 2,
      questionId: "CD.07",
      stage: "CD",
      title: "Immediate customer validation after deployment is still limited",
      evidence:
        "New features are not always exposed in a way that allows rapid customer testing and evidence collection."
    },
    {
      id: 3,
      questionId: "CI.10",
      stage: "CI",
      title: "External collaboration rules are context-sensitive and fragile",
      evidence:
        "Security policies and access governance still make it hard to standardize how external contributors participate in the codebase."
    }
  ]
};

export const assessmentQuestions = [
  {
    id: 1,
    dimension: "Continuous Integration",
    question: "CI.03 - Is code integrated constantly and automatically into the shared repository?"
  },
  {
    id: 2,
    dimension: "Continuous Integration",
    question: "CI.11 - Is data collected to evaluate the continuous integration process?"
  },
  {
    id: 3,
    dimension: "Continuous Deployment",
    question: "CD.03 - Are new functionalities delivered automatically through releases?"
  },
  {
    id: 4,
    dimension: "Continuous Deployment",
    question: "CD.12 - Is product and business alignment maintained through short, data-driven cycles?"
  }
];

export const answerScale = [
  "Not adopted",
  "Abandoned",
  "Realized at project/product level",
  "Realized at process level",
  "Institutionalized"
];

export const stageScores = [
  {
    key: "ci",
    name: "Continuous Integration",
    score: 69,
    currentLevel: "Realized at process level",
    diagnosis:
      "Integration practices are stable enough to support frequent code integration, automated builds and repository traceability, but test depth and data-driven improvement still vary between teams.",
    whyItMatters:
      "Continuous Integration provides the foundation required for sustainable Continuous Deployment. Without strong CI, later delivery stages become inconsistent."
  },
  {
    key: "cd",
    name: "Continuous Deployment",
    score: 64,
    currentLevel: "Between project/product and process level",
    diagnosis:
      "Delivery capability exists, but automation of releases, customer validation and business-operation feedback loops are still not consistently institutionalized.",
    whyItMatters:
      "Continuous Deployment can appear advanced while still lacking the automation and feedback foundations required for coherent maturity."
  }
];

export const practiceThemes = [
  {
    key: "architecture",
    name: "Architecture and Modularity",
    focus: "CI.01, CI.02 and CD.05",
    score: 72,
    strength:
      "The architecture is modular enough to support automated builds and tests in most core services.",
    bottleneck:
      "Independent deployment is still constrained by a few tightly coupled components and release dependencies."
  },
  {
    key: "automation",
    name: "Automation and Release Flow",
    focus: "CI.03 to CI.07 and CD.02 to CD.03",
    score: 63,
    strength:
      "Integration automation is already routine, which lowers the cost of validating code changes before merge.",
    bottleneck:
      "Release automation still depends on manual gates and does not yet behave as a fully reliable production flow."
  },
  {
    key: "metrics",
    name: "Metrics and Continuous Improvement",
    focus: "CI.11 to CI.14 and CD.13 to CD.16",
    score: 61,
    strength:
      "Some operational data is already stored and can support process analysis and quality discussions.",
    bottleneck:
      "Metrics are not yet consistently turned into systematic improvement plans for CI and CD."
  },
  {
    key: "feedback",
    name: "Customer and Business Feedback",
    focus: "CD.01, CD.04 and CD.06 to CD.12",
    score: 66,
    strength:
      "Customer and business signals already influence prioritization in key products.",
    bottleneck:
      "The information flow between business, operations and development still depends on local routines instead of shared short cycles."
  },
  {
    key: "knowledge",
    name: "Knowledge Sharing and Collaboration",
    focus: "CI.10, CI.15 and CD.17",
    score: 58,
    strength:
      "Teams already exchange delivery knowledge informally through reviews and operational collaboration.",
    bottleneck:
      "Knowledge sharing and collaboration with external contributors remain weakly formalized and sensitive to organizational context."
  }
];

export const adoptionLevels = [
  {
    key: "not-adopted",
    label: "Not adopted",
    count: 2,
    percentage: 6,
    description: "Practices that are still absent from the current operating model."
  },
  {
    key: "abandoned",
    label: "Abandoned",
    count: 1,
    percentage: 3,
    description: "Practices that were attempted but did not remain active."
  },
  {
    key: "project",
    label: "Project/Product level",
    count: 8,
    percentage: 25,
    description: "Practices applied locally, but not yet scaled to the wider process."
  },
  {
    key: "process",
    label: "Process level",
    count: 9,
    percentage: 28,
    description: "Practices already embedded in the regular process of multiple teams."
  },
  {
    key: "institutionalized",
    label: "Institutionalized",
    count: 12,
    percentage: 38,
    description: "Practices treated as organizational foundation and not triggering recommendations."
  }
];

export const recommendationTracks = [
  {
    key: "Adopt now",
    title: "Adopt first",
    description: "Practices marked as Not adopted or Abandoned in the current cycle."
  },
  {
    key: "Consolidate",
    title: "Consolidate to process level",
    description: "Practices currently realized only at project/product level that need broader institutionalization."
  }
];

export const recommendations = [
  {
    id: 1,
    questionId: "CI.03",
    stage: "CI",
    track: "Adopt now",
    currentLevel: "Not adopted",
    title: "Increase integration frequency with smaller commits",
    recommendation:
      "Break work into smaller tasks, commit after each completed task and ensure each developer integrates code at least once a day.",
    expectedImpact:
      "Reduce integration risk and shorten the time between implementation and validation.",
    priority: "High",
    status: "Planned",
    nextStep:
      "Pilot a daily integration rule in one core repository and monitor the volume of failed merges for two weeks.",
    contextNote:
      "Some teams struggle to decompose work into sufficiently small tasks, so rollout should begin with a manageable pilot."
  },
  {
    id: 2,
    questionId: "CI.11",
    stage: "CI",
    track: "Consolidate",
    currentLevel: "Realized at project/product level",
    title: "Collect CI metrics that actually guide improvement",
    recommendation:
      "Track canceled builds, failed builds and integration frequency, then use those metrics to define team goals and improvement actions.",
    expectedImpact:
      "Turn CI from a technical routine into a measurable process with visible quality signals.",
    priority: "High",
    status: "Planned",
    nextStep:
      "Choose three CI metrics, create a shared dashboard and review the results in the next retrospective."
  },
  {
    id: 3,
    questionId: "CI.15",
    stage: "CI",
    track: "Consolidate",
    currentLevel: "Realized at project/product level",
    title: "Formalize knowledge sharing around CI",
    recommendation:
      "Create short learning routines such as internal talks, tutorials or guild sessions so teams understand how to sustain an efficient CI process.",
    expectedImpact:
      "Reduce isolated knowledge, improve onboarding and reinforce shared pipeline practices.",
    priority: "Medium",
    status: "Planned",
    nextStep:
      "Schedule one monthly CI learning session and publish a lightweight repository of pipeline conventions."
  },
  {
    id: 4,
    questionId: "CD.02",
    stage: "CD",
    track: "Adopt now",
    currentLevel: "Abandoned",
    title: "Rebuild the flow between development and operations",
    recommendation:
      "Design the deployment pipeline jointly across development and operations, adding the quality gates needed before production promotion.",
    expectedImpact:
      "Reduce friction between teams and create a consistent path toward automatic deployment.",
    priority: "High",
    status: "Planned",
    nextStep:
      "Run a joint workshop to map the current deployment path and define which validations must be automated first.",
    contextNote:
      "Cross-team coordination is a common practical barrier, so this action should begin with explicit ownership."
  },
  {
    id: 5,
    questionId: "CD.03",
    stage: "CD",
    track: "Adopt now",
    currentLevel: "Not adopted",
    title: "Automate release generation and traceability",
    recommendation:
      "Use structured branching, automated testing, package traceability and release history so approved functionality can be promoted automatically to production.",
    expectedImpact:
      "Lower release lead time and improve trust in the deployment pipeline.",
    priority: "High",
    status: "Planned",
    nextStep:
      "Automate one release path end-to-end and publish release notes directly from the pipeline.",
    contextNote:
      "Mobile products and highly controlled domains may retain some manual steps, so the first automation target should be chosen carefully."
  },
  {
    id: 6,
    questionId: "CD.04",
    stage: "CD",
    track: "Consolidate",
    currentLevel: "Realized at project/product level",
    title: "Close the business-operation feedback loop",
    recommendation:
      "Use usage analytics, customer support channels and product signals so operations and business can jointly prioritize new functionality and improvements.",
    expectedImpact:
      "Make release decisions more evidence-based and align delivery with business value.",
    priority: "Medium",
    status: "Planned",
    nextStep:
      "Define which customer signals matter most and assign clear responsibilities for collecting and reviewing them."
  },
  {
    id: 7,
    questionId: "CD.07",
    stage: "CD",
    track: "Consolidate",
    currentLevel: "Realized at project/product level",
    title: "Expose new features for faster customer validation",
    recommendation:
      "Use controlled rollout mechanisms so customers can test new features soon after deployment and the team can gather rapid evidence.",
    expectedImpact:
      "Shorten the learning loop between release and customer validation.",
    priority: "Medium",
    status: "In progress",
    nextStep:
      "Pilot one feature flag workflow for a high-uncertainty feature and define how feedback will be collected."
  },
  {
    id: 8,
    questionId: "CD.13",
    stage: "CD",
    track: "Consolidate",
    currentLevel: "Realized at project/product level",
    title: "Use DORA-style metrics to evaluate delivery flow",
    recommendation:
      "Track lead time, deployment frequency, change fail percentage and recovery time, then connect the results to concrete improvement actions.",
    expectedImpact:
      "Give the organization a consistent way to evaluate CD evolution and justify improvement priorities.",
    priority: "Medium",
    status: "Planned",
    nextStep:
      "Choose one product area, establish the four baseline metrics and review them monthly with engineering leadership."
  },
  {
    id: 9,
    questionId: "CD.17",
    stage: "CD",
    track: "Consolidate",
    currentLevel: "Realized at project/product level",
    title: "Create a repeatable knowledge-sharing routine for CD",
    recommendation:
      "Turn informal delivery knowledge into explicit talks, tutorials and shared guidance so the CD process is not dependent on a few people.",
    expectedImpact:
      "Increase consistency of deployment practices and reduce operational dependence on tacit knowledge.",
    priority: "Low",
    status: "Planned",
    nextStep:
      "Publish one simple CD playbook and review it with the teams involved in releases."
  }
];

export const historySeries = [
  {
    cycle: "Cycle 01",
    period: "April 2024 baseline",
    overall: 52,
    ci: 55,
    cd: 49,
    recommendationCount: 15,
    adoptionLevels: {
      notAdopted: 6,
      abandoned: 2,
      project: 12,
      process: 7,
      institutionalized: 5
    }
  },
  {
    cycle: "Cycle 02",
    period: "May 2025 recalibrated",
    overall: 61,
    ci: 64,
    cd: 58,
    recommendationCount: 11,
    adoptionLevels: {
      notAdopted: 4,
      abandoned: 1,
      project: 11,
      process: 8,
      institutionalized: 8
    }
  },
  {
    cycle: "Cycle 03",
    period: "March 2026 current",
    overall: 67,
    ci: 69,
    cd: 64,
    recommendationCount: 9,
    adoptionLevels: {
      notAdopted: 2,
      abandoned: 1,
      project: 8,
      process: 9,
      institutionalized: 12
    }
  }
];
