import {
  adoptionLevels,
  adoptionLevelStageOverview,
  historySeries,
  maturitySnapshot,
  dimensionOverview,
  processOverview,
  elementOverview,
  practiceThemes,
  recommendations,
  recommendationTracks,
  stageScores
} from "./zeppelinData";

// Simula a estrutura do backend analítico para fins de demonstração.
function resolveLevelFromScore(score) {
  if (score >= 100) return "Institutionalized";
  if (score >= 60) return "Realized at process level";
  if (score >= 30) return "Realized at project/product level";
  if (score >= 10) return "Abandoned";
  return "Not adopted";
}

// Converte os dados mockados para o mesmo formato usado na interface real.
function mapInsight(item) {
  return {
    id: item.id,
    questionId: item.questionId,
    stage: item.stage,
    title: item.title,
    evidence: item.evidence
  };
}

// Faz a mesma conversao para recomendacoes.
function mapRecommendation(item) {
  return {
    id: item.id,
    questionId: item.questionId,
    questionDescription: item.questionDescription || item.title || "",
    stage: item.stage,
    track: item.track,
    currentLevel: item.currentLevel,
    title: item.title,
    recommendation: item.recommendation,
    catalogRecommendation: item.catalogRecommendation || item.recommendation,
    expectedImpact: item.expectedImpact,
    priority: item.priority,
    triggerRule: item.triggerRule || "",
    referenceSource: item.referenceSource || "Mock recommendations catalog",
    nextStep: item.nextStep,
    status: item.status,
    contextNote: item.contextNote || "",
    dimensionName: item.dimensionName || "",
    elementName: item.elementName || ""
  };
}

function buildFallbackDimensionScoreOverview() {
  const dimensions = dimensionOverview.dimensions.map((item) => {
    const matchingTheme = practiceThemes.find((theme) => theme.name === item.name);
    return {
      key: item.key,
      name: item.name,
      organizationScore: matchingTheme?.score ?? 0,
      practiceCount: item.practiceCount ?? 0
    };
  });

  const scoredDimensions = dimensions.filter((item) => item.organizationScore > 0);
  const organizationScore = scoredDimensions.length
    ? Math.round(
        scoredDimensions.reduce((total, item) => total + item.organizationScore, 0) /
          scoredDimensions.length
      )
    : 0;

  return {
    dimensions,
    summary: {
      organizationScore
    }
  };
}

// Dashboard em modo demonstracao.
export const fallbackDashboardData = {
  maturitySnapshot: {
    ...maturitySnapshot,
    questionnaireStatus: "Under Assessment",
    isQuestionnaireComplete: false
  },
  stageScores,
  adoptionLevels,
  strengths: maturitySnapshot.strengths.map(mapInsight),
  bottlenecks: maturitySnapshot.bottlenecks.map(mapInsight),
  recommendationsPreview: recommendations.slice(0, 3).map(mapRecommendation),
  overallDelta: historySeries[historySeries.length - 1].overall - historySeries[historySeries.length - 2].overall
};

// Results em modo demonstracao.
export const fallbackResultsData = {
  summary: {
    answeredPractices: maturitySnapshot.answeredPractices,
    questionnaireStatus: "Under Assessment",
    stageGap: Math.abs(maturitySnapshot.ciScore - maturitySnapshot.cdScore),
    calibratedProfile: maturitySnapshot.calibratedProfile,
    overallScore: maturitySnapshot.overallScore,
    overallLevel: resolveLevelFromScore(maturitySnapshot.overallScore)
  },
  adoptionLevelStageOverview,
  stageScores,
  practiceThemes,
  dimensionScoreOverview: buildFallbackDimensionScoreOverview(),
  dimensionOverview,
  processOverview,
  elementOverview,
  strengths: maturitySnapshot.strengths.map(mapInsight),
  bottlenecks: maturitySnapshot.bottlenecks.map(mapInsight),
  opportunities: recommendations.slice(0, 3).map(mapRecommendation)
};

// Recommendations em modo demonstracao.
export const fallbackRecommendationsData = {
  selectedCycleLabel: maturitySnapshot.cycleLabel,
  summary: {
    triggeredRecommendations: maturitySnapshot.recommendationCount,
    adoptNowCount: recommendations.filter((item) => item.track === "Adopt now").length,
    consolidateCount: recommendations.filter((item) => item.track === "Consolidate").length,
    answeredPractices: maturitySnapshot.answeredPractices,
    expectedPractices: stageScores.reduce(
      (total, item) => total + (item.totalPractices || item.answeredPractices || 0),
      0
    ),
    representedStages: stageScores.filter((item) => (item.answeredPractices || 0) > 0).length,
    totalStages: stageScores.length,
    missingStages: stageScores
      .filter((item) => (item.answeredPractices || 0) === 0)
      .map((item) => item.shortName),
    coverageHeadline: `${stageScores.filter((item) => (item.answeredPractices || 0) > 0).length}/${stageScores.length} stages represented`,
    coverageDetail: `Missing evidence in: ${stageScores
      .filter((item) => (item.answeredPractices || 0) === 0)
      .map((item) => item.shortName)
      .join(", ")}`,
    questionnaireStatus: "Under Assessment",
    isQuestionnaireComplete: false
  },
  recommendationTracks: recommendationTracks.map((lane) => ({
    ...lane,
    items: recommendations
      .filter((item) => item.track === lane.key)
      .map(mapRecommendation)
  })),
  recommendations: recommendations.map(mapRecommendation),
  availableStages: ["CI", "CD"],
  availablePracticeGroups: Array.from(
    new Set(recommendations.map((item) => item.dimensionName).filter(Boolean))
  ),
  availableTracks: recommendationTracks.map((item) => item.key),
  availablePriorities: ["High", "Medium", "Low"]
};

// History em modo demonstracao.
export const fallbackHistoryData = {
  summary: {
    overallDelta: historySeries[historySeries.length - 1].overall - historySeries[0].overall,
    agileDelta: historySeries[historySeries.length - 1].agile - historySeries[0].agile,
    ciDelta: historySeries[historySeries.length - 1].ci - historySeries[0].ci,
    cdDelta: historySeries[historySeries.length - 1].cd - historySeries[0].cd,
    experimentationDelta:
      historySeries[historySeries.length - 1].experimentation - historySeries[0].experimentation,
    recommendationReduction:
      historySeries[0].recommendationCount -
      historySeries[historySeries.length - 1].recommendationCount,
    institutionalizedGrowth:
      historySeries[historySeries.length - 1].adoptionLevels.institutionalized -
      historySeries[0].adoptionLevels.institutionalized
  },
  insufficientData: historySeries.length < 2,
  historySeries: historySeries.map((item, index) => ({
    id: "",
    cycle: item.cycle,
    period: item.period,
    overall: item.overall,
    overallLevel: resolveLevelFromScore(item.overall),
    complete: true,
    agile: item.agile,
    ci: item.ci,
    cd: item.cd,
    experimentation: item.experimentation,
    stages: [
      {
        key: "agile",
        name: "Agile R&D Organization",
        shortName: "Agile",
        score: item.agile
      },
      {
        key: "ci",
        name: "Continuous Integration",
        shortName: "CI",
        score: item.ci
      },
      {
        key: "cd",
        name: "Continuous Deployment",
        shortName: "CD",
        score: item.cd
      },
      {
        key: "experimentation",
        name: "R&D as an Experiment System",
        shortName: "Experimentation",
        score: item.experimentation
      }
    ],
    recommendationCount: item.recommendationCount,
    delta: index === 0 ? null : item.overall - historySeries[index - 1].overall,
    adoptionLevels: item.adoptionLevels
  }))
};

// Metadados minimos para o layout principal em fallback.
export const fallbackAnalyticsMeta = {
  organizationName: maturitySnapshot.organization,
  organizationType: maturitySnapshot.organizationType,
  cycleOptions: [],
  selectedCycleLabel: maturitySnapshot.cycleLabel
};
