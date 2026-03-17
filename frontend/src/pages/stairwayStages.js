const normalizeStageValue = (value = "") => value.toLowerCase().replace(/[^a-z0-9]+/g, "");

export const STAIRWAY_STAGE_MODEL = [
  {
    key: "agile-rd-organization",
    name: "Agile R&D Organization",
    shortName: "ARO",
    aliases: ["agilerdorganization", "agilerd", "aro", "agile", "agilerdorganization"]
  },
  {
    key: "continuous-integration",
    name: "Continuous Integration",
    shortName: "CI",
    aliases: ["continuousintegration", "ci"]
  },
  {
    key: "continuous-deployment",
    name: "Continuous Deployment",
    shortName: "CD",
    aliases: ["continuousdeployment", "cd"]
  },
  {
    key: "experiment-system",
    name: "R&D as an Experiment System",
    shortName: "EXP",
    aliases: ["rdasanexperimentsystem", "experimentsystem", "experiment", "exp"]
  }
];

function findMatchingStage(stageScores, stageModel) {
  return stageScores.find((item) => {
    const candidates = [
      normalizeStageValue(item.name),
      normalizeStageValue(item.shortName),
      normalizeStageValue(item.key)
    ].filter(Boolean);

    return candidates.some((candidate) => stageModel.aliases.includes(candidate));
  });
}

export function mapStagesToJourney(stageScores = []) {
  return STAIRWAY_STAGE_MODEL.map((stageModel) => {
    const stage = findMatchingStage(stageScores, stageModel);

    if (!stage) {
      return {
        ...stageModel,
        available: false,
        score: null,
        currentLevel: "Not available in the current analytics payload",
        answeredPractices: 0,
        strengthCount: 0,
        bottleneckCount: 0
      };
    }

    return {
      ...stage,
      key: stageModel.key,
      name: stageModel.name,
      shortName: stageModel.shortName,
      available: true
    };
  });
}

export function getLeadingStage(stages = []) {
  return stages
    .filter((stage) => stage.available && typeof stage.score === "number")
    .sort((left, right) => right.score - left.score)[0];
}

export function getConstrainingStage(stages = []) {
  return stages
    .filter((stage) => stage.available && typeof stage.score === "number")
    .sort((left, right) => left.score - right.score)[0];
}
