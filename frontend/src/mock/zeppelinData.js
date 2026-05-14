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
    key: "quality",
    name: "Quality",
    focus: "CD.02, CI.04, CI.05",
    score: 60,
    strengthItem: { questionId: "CD.02" },
    bottleneckItem: { questionId: "CD.02" }
  },
  {
    key: "technical-solution",
    name: "Technical Solution",
    focus: "CI.08, CI.09",
    score: 60,
    strengthItem: { questionId: "CI.08" },
    bottleneckItem: { questionId: "CI.08" }
  },
  {
    key: "knowledge",
    name: "Knowledge",
    focus: "CD.14, CD.16, CD.17",
    score: 58,
    strengthItem: { questionId: "CD.17" },
    bottleneckItem: { questionId: "CD.14" }
  },
  {
    key: "development",
    name: "Development",
    focus: "CD.05, CI.01, CI.02",
    score: 42,
    strengthItem: { questionId: "CI.02" },
    bottleneckItem: { questionId: "CD.05" }
  },
  {
    key: "software-management",
    name: "Software Management",
    focus: "CI.03, CI.13, CD.03",
    score: 30,
    strengthItem: { questionId: "CI.03" },
    bottleneckItem: { questionId: "CD.03" }
  },
  {
    key: "business",
    name: "Business",
    focus: "CD.10, CD.11, CD.12",
    score: 28,
    strengthItem: { questionId: "CD.12" },
    bottleneckItem: { questionId: "CD.10" }
  },
  {
    key: "user-customer",
    name: "User/Customer",
    focus: "CD.01, CD.04, CD.06",
    score: 19,
    strengthItem: { questionId: "CD.01" },
    bottleneckItem: { questionId: "CD.06" }
  }
];

export const dimensionOverview = {
  dimensions: [
    {
      key: "development",
      name: "Development",
      agileCount: 8,
      ciPracticeCount: 3,
      ciCount: 3,
      cdCount: 1,
      experimentationCount: 0,
      practiceCount: 12
    },
    {
      key: "quality",
      name: "Quality",
      agileCount: 2,
      ciCount: 7,
      cdCount: 1,
      experimentationCount: 0,
      practiceCount: 10
    },
    {
      key: "software-management",
      name: "Software Management",
      agileCount: 10,
      ciCount: 2,
      cdCount: 4,
      experimentationCount: 0,
      practiceCount: 16
    },
    {
      key: "team",
      name: "Team",
      agileCount: 2,
      ciCount: 0,
      cdCount: 0,
      experimentationCount: 2,
      practiceCount: 4
    },
    {
      key: "technical-solution",
      name: "Technical Solution",
      agileCount: 1,
      ciCount: 2,
      cdCount: 0,
      experimentationCount: 0,
      practiceCount: 3
    },
    {
      key: "knowledge",
      name: "Knowledge",
      agileCount: 2,
      ciCount: 1,
      cdCount: 3,
      experimentationCount: 3,
      practiceCount: 9
    },
    {
      key: "operation",
      name: "Operation",
      agileCount: 0,
      ciCount: 0,
      cdCount: 0,
      experimentationCount: 2,
      practiceCount: 2
    },
    {
      key: "business",
      name: "Business",
      agileCount: 1,
      ciCount: 0,
      cdCount: 4,
      experimentationCount: 3,
      practiceCount: 8
    },
    {
      key: "user-customer",
      name: "User/Customer",
      agileCount: 0,
      ciCount: 0,
      cdCount: 4,
      experimentationCount: 3,
      practiceCount: 7
    }
  ],
  summary: {
    agileCount: 26,
    ciCount: 15,
    cdCount: 17,
    experimentationCount: 13,
    statementCount: 71
  }
};

export const processOverview = {
  rows: [
    {
      key: "business-alignment",
      name: "Business Alignment",
      agileScore: 87,
      ciScore: null,
      cdScore: 65,
      experimentationScore: 81,
      organizationScore: 73,
      practiceCount: 21
    },
    {
      key: "continuous-planning-monitoring-and-control",
      name: "Continuous Planning, Monitoring and Control",
      agileScore: 53,
      ciScore: 52,
      cdScore: 42,
      experimentationScore: 50,
      organizationScore: 50,
      practiceCount: 31
    },
    {
      key: "continuous-quality-assurance",
      name: "Continuous Quality Assurance",
      agileScore: 43,
      ciScore: 46,
      cdScore: 60,
      experimentationScore: 30,
      organizationScore: 46,
      practiceCount: 23
    },
    {
      key: "continuous-improvement-and-innovation",
      name: "Continuous Improvement & Innovation",
      agileScore: 48,
      ciScore: 30,
      cdScore: 46,
      experimentationScore: 66,
      organizationScore: 50,
      practiceCount: 24
    },
    {
      key: "continuous-knowledge-management",
      name: "Continuous Knowledge Management",
      agileScore: 50,
      ciScore: 30,
      cdScore: 45,
      experimentationScore: 68,
      organizationScore: 53,
      practiceCount: 20
    },
    {
      key: "continuous-software-measurement",
      name: "Continuous Software Measurement",
      agileScore: 30,
      ciScore: 40,
      cdScore: 73,
      experimentationScore: 20,
      organizationScore: 41,
      practiceCount: 16
    }
  ],
  summary: {
    processCount: 6,
    agileScore: 50,
    ciScore: 44,
    cdScore: 55,
    experimentationScore: 63,
    organizationScore: 52
  }
};

export const elementOverview = {
  rows: [
    {
      key: "development-continuous-planning-activities",
      dimensionName: "Development",
      elementName: "Continuous planning activities",
      agileCount: 6,
      ciCount: 1,
      cdCount: 0,
      experimentationCount: 0,
      practiceCount: 7
    },
    {
      key: "development-continuous-requirements-engineering",
      dimensionName: "Development",
      elementName: "Continuous requirements engineering",
      agileCount: 1,
      ciCount: 0,
      cdCount: 0,
      experimentationCount: 0,
      practiceCount: 1
    },
    {
      key: "development-focus-on-feature",
      dimensionName: "Development",
      elementName: "Focus on Feature",
      agileCount: 1,
      ciCount: 0,
      cdCount: 0,
      experimentationCount: 0,
      practiceCount: 1
    },
    {
      key: "development-modularized-architecture-and-design",
      dimensionName: "Development",
      elementName: "Modularized architecture and design",
      agileCount: 0,
      ciCount: 2,
      cdCount: 1,
      experimentationCount: 0,
      practiceCount: 3
    },
    {
      key: "quality-audits",
      dimensionName: "Quality",
      elementName: "Audits",
      agileCount: 2,
      ciCount: 1,
      cdCount: 1,
      experimentationCount: 0,
      practiceCount: 4
    },
    {
      key: "quality-automated-tests",
      dimensionName: "Quality",
      elementName: "Automated Tests",
      agileCount: 0,
      ciCount: 2,
      cdCount: 0,
      experimentationCount: 0,
      practiceCount: 2
    },
    {
      key: "quality-code-coverage",
      dimensionName: "Quality",
      elementName: "Code coverage",
      agileCount: 0,
      ciCount: 1,
      cdCount: 0,
      experimentationCount: 0,
      practiceCount: 1
    },
    {
      key: "quality-pull-request",
      dimensionName: "Quality",
      elementName: "Pull-Request",
      agileCount: 0,
      ciCount: 1,
      cdCount: 0,
      experimentationCount: 0,
      practiceCount: 1
    },
    {
      key: "quality-regular-builds",
      dimensionName: "Quality",
      elementName: "Regular Builds",
      agileCount: 0,
      ciCount: 2,
      cdCount: 0,
      experimentationCount: 0,
      practiceCount: 2
    },
    {
      key: "software-management-agile-practice",
      dimensionName: "Software Management",
      elementName: "Agile Practice",
      agileCount: 10,
      ciCount: 1,
      cdCount: 1,
      experimentationCount: 0,
      practiceCount: 12
    },
    {
      key: "software-management-continuous-delivery",
      dimensionName: "Software Management",
      elementName: "Continuous delivery",
      agileCount: 0,
      ciCount: 0,
      cdCount: 1,
      experimentationCount: 0,
      practiceCount: 1
    },
    {
      key: "software-management-continuous-deployment-of-releases",
      dimensionName: "Software Management",
      elementName: "Continuous deployment of releases",
      agileCount: 0,
      ciCount: 0,
      cdCount: 2,
      experimentationCount: 0,
      practiceCount: 2
    },
    {
      key: "software-management-continuous-integration-of-work",
      dimensionName: "Software Management",
      elementName: "Continuous integration of work",
      agileCount: 0,
      ciCount: 1,
      cdCount: 0,
      experimentationCount: 0,
      practiceCount: 1
    },
    {
      key: "team-contemporary-and-continuously-evolving-skills",
      dimensionName: "Team",
      elementName: "Contemporary and continuously evolving skills",
      agileCount: 1,
      ciCount: 0,
      cdCount: 0,
      experimentationCount: 2,
      practiceCount: 3
    },
    {
      key: "team-self-reflection-and-discipline",
      dimensionName: "Team",
      elementName: "Self-reflection and discipline",
      agileCount: 1,
      ciCount: 0,
      cdCount: 0,
      experimentationCount: 0,
      practiceCount: 1
    },
    {
      key: "technical-solution-branching-strategies",
      dimensionName: "Technical Solution",
      elementName: "Branching strategies",
      agileCount: 0,
      ciCount: 1,
      cdCount: 0,
      experimentationCount: 0,
      practiceCount: 1
    },
    {
      key: "technical-solution-code-review",
      dimensionName: "Technical Solution",
      elementName: "Code review",
      agileCount: 1,
      ciCount: 0,
      cdCount: 0,
      experimentationCount: 0,
      practiceCount: 1
    },
    {
      key: "technical-solution-version-control",
      dimensionName: "Technical Solution",
      elementName: "Version control",
      agileCount: 0,
      ciCount: 1,
      cdCount: 0,
      experimentationCount: 0,
      practiceCount: 1
    },
    {
      key: "knowledge-capturing-decisions-and-rationale",
      dimensionName: "Knowledge",
      elementName: "Capturing decisions and rationale",
      agileCount: 1,
      ciCount: 0,
      cdCount: 1,
      experimentationCount: 3,
      practiceCount: 5
    },
    {
      key: "knowledge-continuous-learning",
      dimensionName: "Knowledge",
      elementName: "Continuous learning",
      agileCount: 0,
      ciCount: 0,
      cdCount: 1,
      experimentationCount: 0,
      practiceCount: 1
    },
    {
      key: "knowledge-sharing-knowledge",
      dimensionName: "Knowledge",
      elementName: "Sharing Knowledge",
      agileCount: 1,
      ciCount: 1,
      cdCount: 1,
      experimentationCount: 0,
      practiceCount: 3
    },
    {
      key: "operation-logging-and-monitoring",
      dimensionName: "Operation",
      elementName: "Logging and monitoring",
      agileCount: 0,
      ciCount: 0,
      cdCount: 0,
      experimentationCount: 1,
      practiceCount: 1
    },
    {
      key: "operation-reusable-infrastructure",
      dimensionName: "Operation",
      elementName: "Reusable infrastructure",
      agileCount: 0,
      ciCount: 0,
      cdCount: 0,
      experimentationCount: 1,
      practiceCount: 1
    },
    {
      key: "business-appropriate-product-idea",
      dimensionName: "Business",
      elementName: "Appropriate product idea",
      agileCount: 0,
      ciCount: 0,
      cdCount: 1,
      experimentationCount: 2,
      practiceCount: 3
    },
    {
      key: "business-management-commitment",
      dimensionName: "Business",
      elementName: "Management commitment",
      agileCount: 1,
      ciCount: 0,
      cdCount: 3,
      experimentationCount: 1,
      practiceCount: 5
    },
    {
      key: "user-customer-involved-users-other-stakeholders",
      dimensionName: "User/Customer",
      elementName: "Involved users other stakeholders",
      agileCount: 0,
      ciCount: 0,
      cdCount: 2,
      experimentationCount: 0,
      practiceCount: 2
    },
    {
      key: "user-customer-learning-from-usage-data-and-feedback",
      dimensionName: "User/Customer",
      elementName: "Learning from usage data and feedback",
      agileCount: 0,
      ciCount: 0,
      cdCount: 1,
      experimentationCount: 3,
      practiceCount: 4
    },
    {
      key: "user-customer-proactive-customers",
      dimensionName: "User/Customer",
      elementName: "Proactive customers",
      agileCount: 0,
      ciCount: 0,
      cdCount: 1,
      experimentationCount: 0,
      practiceCount: 1
    }
  ],
  summary: {
    agileCount: 26,
    ciCount: 15,
    cdCount: 17,
    experimentationCount: 13,
    statementCount: 71
  }
};

export const adoptionLevelStageOverview = {
  stages: [
    { key: "agile", title: "Agile R&D Organization" },
    { key: "ci", title: "Continuous Integration" },
    { key: "cd", title: "Continuous Deployment" },
    { key: "experimentation", title: "R&D as an Experiment System" }
  ],
  levels: [
    {
      key: "not-adopted",
      label: "Not adopted",
      weight: 0,
      agileCount: 0,
      ciCount: 0,
      cdCount: 4,
      experimentationCount: 8,
      organizationCount: 12
    },
    {
      key: "abandoned",
      label: "Abandoned",
      weight: 22,
      agileCount: 0,
      ciCount: 0,
      cdCount: 0,
      experimentationCount: 0,
      organizationCount: 0
    },
    {
      key: "project-product-level",
      label: "Realized at project/product level",
      weight: 38,
      agileCount: 2,
      ciCount: 0,
      cdCount: 6,
      experimentationCount: 5,
      organizationCount: 13
    },
    {
      key: "process-level",
      label: "Realized at process level",
      weight: 68,
      agileCount: 20,
      ciCount: 15,
      cdCount: 7,
      experimentationCount: 0,
      organizationCount: 42
    },
    {
      key: "institutionalized",
      label: "Institutionalized",
      weight: 100,
      agileCount: 4,
      ciCount: 0,
      cdCount: 0,
      experimentationCount: 0,
      organizationCount: 4
    }
  ],
  totals: {
    agileCount: 26,
    ciCount: 15,
    cdCount: 17,
    experimentationCount: 13,
    organizationCount: 71
  },
  degreeOfAdoption: {
    agileScore: 71,
    ciScore: 68,
    cdScore: 41,
    experimentationScore: 15,
    organizationScore: 53
  }
};

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
    questionDescription: "Code is integrated constantly and automatically.",
    stage: "CI",
    dimensionName: "Continuous Integration",
    elementName: "Continuous integration cadence",
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
    questionDescription:
      "Data is collected for metrics that make it possible to evaluate the continuous integration process.",
    stage: "CI",
    dimensionName: "Continuous Integration",
    elementName: "Software measurement",
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
    questionDescription:
      "Practices are in place to share knowledge and lessons learned about continuous integration.",
    stage: "CI",
    dimensionName: "Knowledge Sharing and Collaboration",
    elementName: "Sharing knowledge",
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
    questionDescription:
      "There is collaboration between development and operations to sustain the deployment flow.",
    stage: "CD",
    dimensionName: "Continuous Deployment",
    elementName: "Dev and Ops collaboration",
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
    questionDescription:
      "The release process is automated and traceable across the delivery pipeline.",
    stage: "CD",
    dimensionName: "Continuous Deployment",
    elementName: "Release automation",
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
    questionDescription:
      "Business and operations feedback are used to continuously refine delivery priorities.",
    stage: "CD",
    dimensionName: "Business Alignment",
    elementName: "Learning from usage data and feedback",
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
    questionDescription:
      "New features can be exposed quickly to customers for early validation and learning.",
    stage: "CD",
    dimensionName: "Continuous Deployment",
    elementName: "Controlled rollout",
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
    questionDescription:
      "Delivery flow metrics are collected and used to evaluate the continuous deployment process.",
    stage: "CD",
    dimensionName: "Continuous Deployment",
    elementName: "Delivery measurement",
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
    questionDescription:
      "Knowledge and lessons learned about continuous deployment are actively shared across teams.",
    stage: "CD",
    dimensionName: "Knowledge Sharing and Collaboration",
    elementName: "Deployment knowledge sharing",
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
    agile: 45,
    ci: 55,
    cd: 49,
    experimentation: 20,
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
    agile: 62,
    ci: 64,
    cd: 58,
    experimentation: 28,
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
    agile: 71,
    ci: 69,
    cd: 64,
    experimentation: 15,
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
