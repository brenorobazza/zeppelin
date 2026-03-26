import { useMemo, useState } from "react";
import { fallbackRecommendationsData } from "../mock/analyticsFallback";

function getPriorityClass(priority) {
  if (priority === "High") return "high";
  if (priority === "Medium") return "medium";
  return "low";
}

function getRoadmapLaneCopy(lane) {
  if (lane.key === "Adopt now") {
    return {
      title: "Practices to adopt",
      description: "Practices that are still absent or have not been sustained."
    };
  }

  if (lane.key === "Consolidate") {
    return {
      title: "Practices to consolidate",
      description:
        "Practices already used locally, but not yet established at process level."
    };
  }

  return {
    title: lane.title,
    description: lane.description
  };
}

function buildRoadmapSummary(total, stage, priority) {
  const stageLabel = stage === "All" ? "all stages" : `stage ${stage}`;
  const priorityLabel = priority === "All" ? "all priorities" : `${priority.toLowerCase()} priority`;
  return `Showing ${total} recommendations for ${stageLabel} and ${priorityLabel}.`;
}

function buildRecommendationTitle(item) {
  if (item.track === "Adopt now") return `${item.questionId} - establish this practice`;
  if (item.track === "Consolidate") return `${item.questionId} - consolidate this practice`;
  return item.title;
}

function buildRecommendationSummary(item) {
  if (item.track === "Adopt now") {
    return "Establish this practice as a repeatable routine with clear ownership, execution criteria, and evidence of adoption.";
  }

  if (item.track === "Consolidate") {
    return "Expand this practice from local use to a shared process with documented expectations and broader team adoption.";
  }

  return item.recommendation;
}

function normalizeCurrentLevel(level) {
  const value = (level || "").trim().toLowerCase();

  if (value === "not adopted" || value === "nao adotado" || value === "não adotado") {
    return "Not adopted";
  }

  if (value === "abandoned" || value === "abandonado") {
    return "Abandoned";
  }

  if (
    value === "realized at project/product level" ||
    value === "project/product level" ||
    value === "realizado ao nivel de projeto/produto" ||
    value === "realizado ao nível de projeto/produto"
  ) {
    return "Project/Product level";
  }

  if (
    value === "between project/product and process level" ||
    value === "entre nivel de projeto/produto e processo" ||
    value === "entre nível de projeto/produto e processo"
  ) {
    return "Between project/product and process level";
  }

  if (
    value === "realized at process level" ||
    value === "process level" ||
    value === "realizado ao nivel de processo" ||
    value === "realizado ao nível de processo"
  ) {
    return "Process level";
  }

  if (value === "institutionalized" || value === "institucionalizado") {
    return "Institutionalized";
  }

  return level || "Not informed";
}

function buildExpectedOutcome(item) {
  if (item.track === "Adopt now") {
    return `Establish a stable adoption baseline for ${item.stage} in the next assessment cycle.`;
  }

  if (item.track === "Consolidate") {
    return `Move this ${item.stage} practice from local use to a consistent process-level capability.`;
  }

  return item.expectedImpact || "Clarify the expected outcome for this recommendation.";
}

function buildSuggestedNextStep(item) {
  if (item.track === "Adopt now") {
    return `Assign an owner for ${item.questionId}, identify the main blockers, and define a short pilot for adoption.`;
  }

  if (item.track === "Consolidate") {
    return `Review how ${item.questionId} is currently performed and define the changes required to standardize it across teams.`;
  }

  return item.nextStep || "Define the next implementation step for this recommendation.";
}

function normalizeStatus(status) {
  const value = (status || "").trim().toLowerCase();

  if (value === "suggested" || value === "sugerido") return "Suggested";
  if (value === "planned" || value === "planejado") return "Planned";
  if (value === "in progress" || value === "em andamento") return "In progress";
  if (value === "completed" || value === "concluido" || value === "concluído") {
    return "Completed";
  }

  return status || "Suggested";
}

export function RecommendationsPage({ data, loading }) {
  // Esta e a tela que transforma o diagnostico em um roadmap acionavel.
  const view = data || fallbackRecommendationsData;
  const [stage, setStage] = useState("All");
  const [priority, setPriority] = useState("All");

  // Os filtros apenas mudam a leitura visual; os dados originais continuam intactos.
  const filtered = useMemo(
    () =>
      view.recommendations.filter((item) => {
        const matchesStage = stage === "All" || item.stage === stage;
        const matchesPriority = priority === "All" || item.priority === priority;
        return matchesStage && matchesPriority;
      }),
    [view.recommendations, stage, priority]
  );

  // Depois do filtro, reorganizamos os itens dentro das trilhas do roadmap.
  const groupedTracks = view.recommendationTracks.map((lane) => ({
    ...lane,
    ...getRoadmapLaneCopy(lane),
    items: filtered.filter((item) => item.track === lane.key)
  }));
  const roadmapSummary = buildRoadmapSummary(filtered.length, stage, priority);

  if (loading && !data) {
    return <section className="panel">Loading the improvement roadmap...</section>;
  }

  if (view.selectedCycleEmpty) {
    return (
      <section className="panel">
        <p className="eyebrow">Recommendations</p>
        <h3>No submitted answers for this cycle</h3>
        <p>
          The selected assessment cycle does not contain submitted answers yet. Recommendations
          will be generated after the cycle receives recorded answers.
        </p>
      </section>
    );
  }

  return (
    <>
      {/* Resumo executivo das recomendacoes geradas para o ciclo atual. */}
      <section className="grid-3">
        <article className="metric-card">
          <p>Recommendations generated</p>
          <h2>{view.summary.triggeredRecommendations}</h2>
          <small>Practices below process level are converted into recommended actions</small>
        </article>

        <article className="metric-card">
          <p>Practices to adopt</p>
          <h2>{view.summary.adoptNowCount}</h2>
          <small>Practices still classified as Not adopted or Abandoned</small>
        </article>

        <article className="metric-card">
          <p>Practices to consolidate</p>
          <h2>{view.summary.consolidateCount}</h2>
          <small>Practices that exist locally but still need to reach process level</small>
        </article>
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Recommended actions for the current cycle</h3>
            <p>Review the suggested actions by stage and priority.</p>
          </div>
        </div>

        <div className="roadmap-toolbar">
          <div className="roadmap-filters">
            <label className="roadmap-filter-field">
              <span>Filter by stage</span>
              <select value={stage} onChange={(event) => setStage(event.target.value)}>
                <option value="All">All stages</option>
                {view.availableStages.map((item) => (
                  <option key={item}>{item}</option>
                ))}
              </select>
            </label>

            <label className="roadmap-filter-field">
              <span>Filter by priority</span>
              <select value={priority} onChange={(event) => setPriority(event.target.value)}>
                <option value="All">All priorities</option>
                {view.availablePriorities.map((item) => (
                  <option key={item}>{item}</option>
                ))}
              </select>
            </label>
          </div>

          <div className="roadmap-toolbar__meta">
            <p className="roadmap-summary">{roadmapSummary}</p>

            <details className="roadmap-help">
              <summary>
                <span className="roadmap-help__icon">?</span>
                <span>About the rule</span>
              </summary>
              <div className="roadmap-help__content">
                <p>
                  Recommendations are generated through a rule-based gap analysis that identifies
                  practices that still require adoption or consolidation.
                </p>
                <ul className="roadmap-help__list">
                  <li>
                    <strong>Not adopted or Abandoned:</strong> prioritize adoption.
                  </li>
                  <li>
                    <strong>Project/Product level:</strong> prioritize consolidation at process
                    level.
                  </li>
                  <li>
                    <strong>Process level or Institutionalized:</strong> no action is generated for
                    the current cycle.
                  </li>
                </ul>
              </div>
            </details>
          </div>
        </div>
      </section>

      {/* Cada trilha concentra um tipo de acao priorizada para a organizacao. */}
      <section className="roadmap-grid roadmap-grid--two">
        {groupedTracks.map((lane) => (
          <article key={lane.key} className="panel roadmap-lane">
            <div>
              <h3>{lane.title}</h3>
              <p>{lane.description}</p>
            </div>

            {lane.items.length === 0 ? (
              <div className="empty-state">No recommendations match the selected filters.</div>
            ) : (
              lane.items.map((item) => (
                <div key={item.id} className="roadmap-card">
                  <div className="roadmap-card__meta">
                    <span className="tag">
                      {item.stage} / {item.questionId}
                    </span>
                    <span className={`pill ${getPriorityClass(item.priority)}`}>{item.priority}</span>
                  </div>

                  <h4>{buildRecommendationTitle(item)}</h4>
                  <p>{buildRecommendationSummary(item)}</p>

                  <dl className="roadmap-card__details">
                    <div>
                      <dt>Current adoption level</dt>
                      <dd>{normalizeCurrentLevel(item.currentLevel)}</dd>
                    </div>
                    <div>
                      <dt>Expected outcome</dt>
                      <dd>{buildExpectedOutcome(item)}</dd>
                    </div>
                    <div>
                      <dt>Suggested next step</dt>
                      <dd>{buildSuggestedNextStep(item)}</dd>
                    </div>
                    <div>
                      <dt>Status</dt>
                      <dd>{normalizeStatus(item.status)}</dd>
                    </div>
                  </dl>
                </div>
              ))
            )}
          </article>
        ))}
      </section>
    </>
  );
}
