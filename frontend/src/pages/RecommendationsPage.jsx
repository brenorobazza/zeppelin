import { useMemo, useState } from "react";
import { fallbackRecommendationsData } from "../mock/analyticsFallback";

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

function buildRoadmapSummary(total, stage) {
  const stageLabel = stage === "All" ? "all stages" : `stage ${stage}`;
  return `Showing ${total} recommendations for ${stageLabel}.`;
}

function buildRecommendationTitle(item) {
  return item.questionId || item.title || "Recommendation";
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

export function RecommendationsPage({ data, loading }) {
  // Esta e a tela que transforma o diagnostico em um roadmap acionavel.
  const view = data || fallbackRecommendationsData;
  const [stage, setStage] = useState("All");

  // Os filtros apenas mudam a leitura visual; os dados originais continuam intactos.
  const filtered = useMemo(
    () =>
      view.recommendations.filter((item) => {
        const matchesStage = stage === "All" || item.stage === stage;
        return matchesStage;
      }),
    [view.recommendations, stage]
  );

  // Depois do filtro, reorganizamos os itens dentro das trilhas do roadmap.
  const groupedTracks = view.recommendationTracks.map((lane) => ({
    ...lane,
    ...getRoadmapLaneCopy(lane),
    items: filtered.filter((item) => item.track === lane.key)
  }));
  const roadmapSummary = buildRoadmapSummary(filtered.length, stage);

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
        </article>

        <article className="metric-card">
          <p>Practices to adopt</p>
          <h2>{view.summary.adoptNowCount}</h2>
        </article>

        <article className="metric-card">
          <p>Practices to consolidate</p>
          <h2>{view.summary.consolidateCount}</h2>
        </article>
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Recommended actions for the current cycle</h3>
            <p>Review the recommended actions by stage.</p>
          </div>
        </div>

        <div className="roadmap-toolbar">
          <div className="roadmap-filters roadmap-filters--one">
            <label className="roadmap-filter-field">
              <span>Filter by stage</span>
              <select value={stage} onChange={(event) => setStage(event.target.value)}>
                <option value="All">All stages</option>
                {view.availableStages.map((item) => (
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
                    <span className="tag">{item.questionId}</span>
                  </div>

                  <dl className="roadmap-card__details">
                    <div>
                      <dt>Current adoption level</dt>
                      <dd>{normalizeCurrentLevel(item.currentLevel)}</dd>
                    </div>
                    <div>
                      <dt>Original practice statement</dt>
                      <dd>{item.questionDescription || "Not available"}</dd>
                    </div>
                  </dl>

                  {item.catalogRecommendation ? (
                    <details className="roadmap-reference">
                      <summary>More context and source</summary>
                      <div className="roadmap-card__details roadmap-card__details--compact">
                        <div>
                          <dt>Practice group</dt>
                          <dd>{item.dimensionName || "Not available"}</dd>
                        </div>
                        <div>
                          <dt>Element</dt>
                          <dd>{item.elementName || "Not available"}</dd>
                        </div>
                      </div>
                      <p>{item.catalogRecommendation}</p>
                    </details>
                  ) : null}
                </div>
              ))
            )}
          </article>
        ))}
      </section>
    </>
  );
}

