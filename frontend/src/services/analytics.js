import { getAuthHeaders } from "./authHelper";
import {
  fallbackAnalyticsMeta,
  fallbackDashboardData,
  fallbackHistoryData,
  fallbackRecommendationsData,
  fallbackResultsData
} from "../mock/analyticsFallback";

// A base da API vem do ambiente para permitir troca de servidor sem editar o código.
const API_BASE = import.meta.env.VITE_API_BASE_URL || import.meta.env.VITE_API_URL || "";

// Padroniza a leitura das respostas do backend e transforma falhas em mensagens legíveis.
async function parseResponse(response, fallbackMessage) {
  const data = await response.json().catch(() => ({}));

  if (!response.ok) {
    const message =
      data.error || data.detail || data.message || `${fallbackMessage} (status ${response.status})`;
    const error = new Error(message);
    error.status = response.status;
    throw error;
  }

  return data;
}

// Converte os filtros da interface para query string.
function buildQuery(filters = {}) {
  const params = new URLSearchParams();

  if (filters.organizationId) params.set("organization_id", filters.organizationId);
  if (filters.questionnaireId) params.set("questionnaire_id", filters.questionnaireId);
  if (filters.stageScope) params.set("stage_scope", filters.stageScope);

  const query = params.toString();
  return query ? `?${query}` : "";
}

// Busca uma seção específica da camada analítica.
async function fetchAnalyticsSection(section, filters) {
  const query = buildQuery(filters);
  const response = await fetch(`${API_BASE}/api/questionnaire/analytics/${section}/${query}`, {
    credentials: "include"
  });

  return parseResponse(response, `Failed to load ${section} analytics.`);
}

// Busca o score de um estágio específico pelo nome curto.
function findStageScore(stageScores, shortName) {
  return stageScores.find((item) => item.short_name === shortName)?.score || 0;
}

// Converte um insight bruto do backend para um formato mais simples para os componentes.
function mapInsight(item) {
  return {
    id: item.id,
    questionId: item.question_id,
    stage: item.stage_short_name || item.stage_name || "",
    title: item.title,
    evidence: item.evidence,
    currentLevel: item.current_level,
    score: item.score
  };
}

// Faz a mesma padronização para as recomendações do roadmap.
function mapRecommendation(item) {
  return {
    id: item.id,
    questionId: item.question_id,
    questionDescription: item.question_description || "",
    stage: item.stage_short_name || item.stage_name || "",
    track: item.track,
    currentLevel: item.current_level,
    title: item.title,
    recommendation: item.recommendation,
    catalogRecommendation: item.catalog_recommendation || "",
    expectedImpact: item.expected_impact,
    priority: item.priority,
    nextStep: item.next_step,
    triggerRule: item.trigger_rule || "",
    referenceSource: item.reference_source || "",
    status: item.status,
    contextNote: item.context_note || "",
    dimensionName: item.dimension_name || "",
    elementName: item.element_name || ""
  };
}

// Normaliza os cards de score por estágio.
function mapStageScore(item) {
  return {
    key: item.key,
    name: item.name,
    shortName: item.short_name,
    score: item.score,
    currentLevel: item.current_level,
    answeredPractices: item.answered_practices,
    totalPractices: item.total_practices ?? item.answered_practices,
    strengthCount: item.strength_count,
    bottleneckCount: item.bottleneck_count
  };
}

// Prepara o payload bruto do dashboard para o formato que a tela entende.
function normalizeDashboard(payload) {
  const stageScores = payload.stage_scores.map(mapStageScore);

  return {
    selectedCycleEmpty: payload.selected_cycle_empty || false,
    maturitySnapshot: {
      organization: payload.organization.name,
      organizationType: payload.organization.type || "",
      cycleLabel: payload.cycle.label,
      answeredPractices: payload.snapshot.answered_practices,
      questionnaireStatus: payload.snapshot.questionnaire_status || "Incomplete",
      overallScore: payload.snapshot.overall_score,
      overallLevel: payload.snapshot.overall_level,
      ciScore: findStageScore(stageScores, "CI"),
      cdScore: findStageScore(stageScores, "CD"),
      recommendationCount: payload.snapshot.recommendation_count,
      executiveSummary: payload.snapshot.executive_summary,
      overallInterpretation: payload.snapshot.executive_summary
    },
    stageScores,
    adoptionLevels: payload.adoption_levels.map((item) => ({
      id: item.id,
      key: item.key,
      label: item.label,
      count: item.count,
      percentage: item.percentage,
      score: item.score
    })),
    strengths: payload.strengths.map(mapInsight),
    bottlenecks: payload.bottlenecks.map(mapInsight),
    recommendationsPreview: payload.recommendations_preview.map(mapRecommendation),
    overallDelta: payload.snapshot.overall_delta
  };
}

// Prepara os dados usados pela tela de resultados.
function normalizeResults(payload) {
  return {
    selectedCycleEmpty: payload.selected_cycle_empty || false,
    selectedCycleLabel: payload.cycle?.label || "",
    summary: {
      answeredPractices: payload.summary.answered_practices,
      questionnaireStatus: payload.summary.questionnaire_status || "Incomplete",
      stageGap: payload.summary.stage_gap,
      calibratedProfile: payload.organization.type || "Current organization profile",
      overallScore: payload.summary.overall_score,
      overallLevel: payload.summary.overall_level
    },
    adoptionLevelStageOverview: {
      stages: (payload.adoption_level_stage_overview?.stages || []).map((item) => ({
        key: item.key,
        title: item.title
      })),
      levels: (payload.adoption_level_stage_overview?.levels || []).map((item) => ({
        key: item.key,
        label: item.label,
        weight: item.weight,
        agileCount: item.agile_count,
        ciCount: item.ci_count,
        cdCount: item.cd_count,
        experimentationCount: item.experimentation_count,
        organizationCount: item.organization_count
      })),
      totals: {
        agileCount: payload.adoption_level_stage_overview?.totals?.agile_count ?? 0,
        ciCount: payload.adoption_level_stage_overview?.totals?.ci_count ?? 0,
        cdCount: payload.adoption_level_stage_overview?.totals?.cd_count ?? 0,
        experimentationCount:
          payload.adoption_level_stage_overview?.totals?.experimentation_count ?? 0,
        organizationCount:
          payload.adoption_level_stage_overview?.totals?.organization_count ?? 0
      },
      degreeOfAdoption: {
        agileScore:
          payload.adoption_level_stage_overview?.degree_of_adoption?.agile_score ?? null,
        ciScore: payload.adoption_level_stage_overview?.degree_of_adoption?.ci_score ?? null,
        cdScore: payload.adoption_level_stage_overview?.degree_of_adoption?.cd_score ?? null,
        experimentationScore:
          payload.adoption_level_stage_overview?.degree_of_adoption?.experimentation_score ??
          null,
        organizationScore:
          payload.adoption_level_stage_overview?.degree_of_adoption?.organization_score ?? null
      }
    },
    stageScores: payload.stage_scores.map(mapStageScore),
    dimensionOverview: {
      dimensions: (payload.dimension_overview?.dimensions || []).map((item) => ({
        key: item.key,
        name: item.name,
        ciScore: item.ci_score,
        cdScore: item.cd_score,
        organizationScore: item.organization_score,
        ciPracticeCount: item.ci_practice_count,
        cdPracticeCount: item.cd_practice_count,
        practiceCount: item.practice_count
      })),
      summary: {
        ciScore: payload.dimension_overview?.summary?.ci_score ?? null,
        cdScore: payload.dimension_overview?.summary?.cd_score ?? null,
        organizationScore: payload.dimension_overview?.summary?.organization_score ?? 0,
        statementCount: payload.dimension_overview?.summary?.statement_count ?? 0
      }
    },
    elementOverview: {
      rows: (payload.element_overview?.rows || []).map((item) => ({
        key: item.key,
        dimensionName: item.dimension_name,
        elementName: item.element_name,
        ciScore: item.ci_score,
        cdScore: item.cd_score,
        organizationScore: item.organization_score
      })),
      summary: {
        ciScore: payload.element_overview?.summary?.ci_score ?? null,
        cdScore: payload.element_overview?.summary?.cd_score ?? null,
        organizationScore: payload.element_overview?.summary?.organization_score ?? 0
      }
    },
    practiceThemes: payload.dimensions.map((item) => ({
      key: item.key,
      name: item.name,
      focus: item.focus,
      score: item.score,
      currentLevel: item.current_level,
      strength: item.strength,
      bottleneck: item.bottleneck,
      answeredPractices: item.answered_practices,
      strengthItem: item.strength_item ? mapInsight(item.strength_item) : null,
      bottleneckItem: item.bottleneck_item ? mapInsight(item.bottleneck_item) : null
    })),
    strengths: payload.strengths.map(mapInsight),
    bottlenecks: payload.bottlenecks.map(mapInsight),
    opportunities: payload.opportunities.map(mapRecommendation)
  };
}

// Agrupa recomendações nas trilhas do roadmap para leitura mais estratégica.
function normalizeRecommendations(payload) {
  const recommendationTracks = payload.tracks.map((lane) => ({
    key: lane.key,
    title: lane.title,
    description: lane.description,
    count: lane.count,
    items: lane.items.map(mapRecommendation)
  }));

  return {
    selectedCycleEmpty: payload.selected_cycle_empty || false,
    selectedCycleLabel: payload.cycle?.label || "",
    summary: {
      triggeredRecommendations: payload.summary.triggered_recommendations,
      adoptNowCount: payload.summary.adopt_now_count,
      consolidateCount: payload.summary.consolidate_count
    },
    recommendationTracks,
    recommendations: payload.items.map(mapRecommendation),
    availableStages: payload.filters.available_stages || [],
    availablePracticeGroups: payload.filters.available_practice_groups || [],
    availableTracks: payload.filters.available_tracks || [],
    availablePriorities: payload.filters.available_priorities || []
  };
}

// Resolve pequenas variações de nome nas chaves de histórico.
function getHistoryCount(cycle, key) {
  if (cycle.adoption_levels[key] != null) return cycle.adoption_levels[key];

  const aliases = {
    "not-adopted": ["nao-adotada", "not-adopted"],
    abandoned: ["abandonada", "abandoned"],
    project: [
      "realizada-no-nivel-de-projeto-produto",
      "project-product-level",
      "realized-at-project-product-level"
    ],
    process: [
      "realizada-no-nivel-de-processo",
      "process-level",
      "realized-at-process-level"
    ],
    institutionalized: ["institucionalizada", "institutionalized"]
  };

  const candidates = aliases[key] || [key];
  const matchedKey = Object.keys(cycle.adoption_levels || {}).find((itemKey) =>
    candidates.includes(itemKey)
  );
  return matchedKey ? cycle.adoption_levels[matchedKey] : 0;
}

// Converte o histórico bruto em um formato pronto para comparação entre ciclos.
function normalizeHistory(payload) {
  const historySeries = payload.cycles.map((item, index) => {
    const ci = item.stage_scores.find((stage) => stage.short_name === "CI")?.score || 0;
    const cd = item.stage_scores.find((stage) => stage.short_name === "CD")?.score || 0;

    return {
      id: item.id ? String(item.id) : "",
      cycle: `Cycle ${index + 1}`,
      period: item.label,
      overall: item.overall_score,
      overallLevel: item.overall_level,
      ci,
      cd,
      recommendationCount: item.recommendation_count,
      delta: index === 0 ? null : item.overall_score - payload.cycles[index - 1].overall_score,
      adoptionLevels: {
        notAdopted: getHistoryCount(item, "not-adopted"),
        abandoned: getHistoryCount(item, "abandoned"),
        project: getHistoryCount(item, "project"),
        process: getHistoryCount(item, "process"),
        institutionalized: getHistoryCount(item, "institutionalized")
      }
    };
  });

  const first = historySeries[0];
  const last = historySeries[historySeries.length - 1];

  return {
    selectedCycleEmpty: payload.selected_cycle_empty || false,
    selectedCycleLabel: payload.cycle?.label || "",
    summary: {
      overallDelta: payload.summary.overall_delta,
      ciDelta: last ? last.ci - first.ci : 0,
      cdDelta: last ? last.cd - first.cd : 0,
      recommendationReduction: payload.summary.recommendation_reduction,
      institutionalizedGrowth: last
        ? last.adoptionLevels.institutionalized - first.adoptionLevels.institutionalized
        : 0
    },
    historySeries
  };
}

// O layout principal precisa de metadados globais, como nome da empresa e lista de ciclos.
function normalizeMeta(dashboardPayload, historyPayload) {
  return {
    organizationName: dashboardPayload.organization.name,
    organizationType: dashboardPayload.organization.type || "",
    selectedCycleLabel: dashboardPayload.cycle.label,
    cycleOptions: historyPayload.cycles
      .filter((item) => item.id != null)
      .map((item, index) => ({
        id: String(item.id),
        label: item.label,
        shortLabel: `Cycle ${index + 1}`,
        answeredPractices: item.answered_practices || 0
      }))
  };
}

// Carrega todas as seções em paralelo para manter consistência entre as páginas.
export async function loadAnalyticsBundle(filters = {}) {
  const [dashboardPayload, resultsPayload, recommendationsPayload, historyPayload] =
    await Promise.all([
      fetchAnalyticsSection("dashboard", filters),
      fetchAnalyticsSection("results", filters),
      fetchAnalyticsSection("recommendations", filters),
      fetchAnalyticsSection("history", filters)
    ]);

  return {
    meta: normalizeMeta(dashboardPayload, historyPayload),
    dashboard: normalizeDashboard(dashboardPayload),
    results: normalizeResults(resultsPayload),
    recommendations: normalizeRecommendations(recommendationsPayload),
    history: normalizeHistory(historyPayload)
  };
}

// Entrega um conjunto de dados de demonstração quando o backend não estiver disponível.
export function getFallbackAnalyticsBundle() {
  return {
    meta: fallbackAnalyticsMeta,
    dashboard: fallbackDashboardData,
    results: fallbackResultsData,
    recommendations: fallbackRecommendationsData,
    history: fallbackHistoryData
  };
}

// Lê da URL o contexto atual da análise.
export function getAnalyticsFiltersFromUrl() {
  const url = new URL(window.location.href);
  return {
    organizationId: url.searchParams.get("organization_id") || "",
    questionnaireId: url.searchParams.get("questionnaire_id") || "",
    stageScope: url.searchParams.get("stage_scope") || "all"
  };
}

// Atualiza a URL sem recarregar a página, preservando o contexto escolhido pelo usuário.
export function updateAnalyticsFiltersInUrl(filters) {
  const url = new URL(window.location.href);
  const values = {
    organization_id: filters.organizationId,
    questionnaire_id: filters.questionnaireId,
    stage_scope: filters.stageScope && filters.stageScope !== "all" ? filters.stageScope : ""
  };

  Object.entries(values).forEach(([key, value]) => {
    if (value) {
      url.searchParams.set(key, value);
    } else {
      url.searchParams.delete(key);
    }
  });

  window.history.replaceState({}, "", `${url.pathname}${url.search}${url.hash}`);
}
