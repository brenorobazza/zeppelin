import {
  adoptionLevels,
  historySeries,
  maturitySnapshot,
  dimensionOverview,
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

// Dashboard em modo demonstracao.
export const fallbackDashboardData = {
  maturitySnapshot: {
    ...maturitySnapshot,
    questionnaireStatus: "Incomplete"
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
    questionnaireStatus: "Incomplete",
    stageGap: Math.abs(maturitySnapshot.ciScore - maturitySnapshot.cdScore),
    calibratedProfile: maturitySnapshot.calibratedProfile,
    overallScore: maturitySnapshot.overallScore,
    overallLevel: resolveLevelFromScore(maturitySnapshot.overallScore)
  },
  stageScores,
  practiceThemes,
  dimensionOverview,
  strengths: maturitySnapshot.strengths.map(mapInsight),
  bottlenecks: maturitySnapshot.bottlenecks.map(mapInsight),
  opportunities: recommendations.slice(0, 3).map(mapRecommendation)
};

// Recommendations em modo demonstracao.
export const fallbackRecommendationsData = {
  summary: {
    triggeredRecommendations: maturitySnapshot.recommendationCount,
    adoptNowCount: recommendations.filter((item) => item.track === "Adopt now").length,
    consolidateCount: recommendations.filter((item) => item.track === "Consolidate").length
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
    ciDelta: historySeries[historySeries.length - 1].ci - historySeries[0].ci,
    cdDelta: historySeries[historySeries.length - 1].cd - historySeries[0].cd,
    recommendationReduction:
      historySeries[0].recommendationCount -
      historySeries[historySeries.length - 1].recommendationCount,
    institutionalizedGrowth:
      historySeries[historySeries.length - 1].adoptionLevels.institutionalized -
      historySeries[0].adoptionLevels.institutionalized
  },
  historySeries: historySeries.map((item, index) => ({
    id: "",
    cycle: item.cycle,
    period: item.period,
    overall: item.overall,
    overallLevel: resolveLevelFromScore(item.overall),
    ci: item.ci,
    cd: item.cd,
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
