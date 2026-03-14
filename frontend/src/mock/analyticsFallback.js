import {
  adoptionLevels,
  historySeries,
  maturitySnapshot,
  practiceThemes,
  recommendations,
  recommendationTracks,
  stageScores
} from "./zeppelinData";

function resolveLevelFromScore(score) {
  if (score >= 100) return "Institutionalized";
  if (score >= 60) return "Realized at process level";
  if (score >= 30) return "Realized at project/product level";
  if (score >= 10) return "Abandoned";
  return "Not adopted";
}

function mapInsight(item) {
  return {
    id: item.id,
    questionId: item.questionId,
    stage: item.stage,
    title: item.title,
    evidence: item.evidence
  };
}

function mapRecommendation(item) {
  return {
    id: item.id,
    questionId: item.questionId,
    stage: item.stage,
    track: item.track,
    currentLevel: item.currentLevel,
    title: item.title,
    recommendation: item.recommendation,
    expectedImpact: item.expectedImpact,
    priority: item.priority,
    nextStep: item.nextStep,
    status: item.status,
    contextNote: item.contextNote || ""
  };
}

export const fallbackDashboardData = {
  maturitySnapshot,
  stageScores,
  adoptionLevels,
  recommendationsPreview: recommendations.slice(0, 3).map(mapRecommendation),
  overallDelta: historySeries[historySeries.length - 1].overall - historySeries[historySeries.length - 2].overall
};

export const fallbackResultsData = {
  summary: {
    answeredPractices: maturitySnapshot.answeredPractices,
    stageGap: Math.abs(maturitySnapshot.ciScore - maturitySnapshot.cdScore),
    calibratedProfile: maturitySnapshot.calibratedProfile
  },
  stageScores,
  practiceThemes,
  strengths: maturitySnapshot.strengths.map(mapInsight),
  bottlenecks: maturitySnapshot.bottlenecks.map(mapInsight),
  opportunities: recommendations.slice(0, 3).map(mapRecommendation)
};

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
  availableTracks: recommendationTracks.map((item) => item.key),
  availablePriorities: ["High", "Medium", "Low"]
};

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

export const fallbackAnalyticsMeta = {
  organizationName: maturitySnapshot.organization,
  organizationType: maturitySnapshot.organizationType,
  cycleOptions: [],
  selectedCycleLabel: maturitySnapshot.cycleLabel
};
