import { useMemo, useState } from "react";
import { fallbackRecommendationsData } from "../mock/analyticsFallback";

function getRoadmapLaneCopy(lane) {
  if (lane.key === "Adopt now") {
    return {
      title: "Practices to adopt",
      description: ""
    };
  }

  if (lane.key === "Consolidate") {
    return {
      title: "Practices to consolidate",
      description: ""
    };
  }

  return {
    title: lane.title,
    description: lane.description
  };
}

function buildRecommendationTitle(item) {
  return item.questionDescription || item.title || item.questionId || "Recommendation";
}

function buildAnswerProgress(answered, total) {
  return `${answered || 0}/${total || 0} statements answered`;
}

function getRecommendationBody(item) {
  return item.catalogRecommendation || item.recommendation || "";
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
  const assessmentContext = [
    { label: "Assessment cycle", value: view.selectedCycleLabel || "Current cycle" },
    {
      label: "Questionnaire status",
      value: view.summary.questionnaireStatus || "Under assessment"
    },
    {
      label: "Answer progress",
      value: buildAnswerProgress(
        view.summary.answeredPractices,
        view.summary.expectedPractices
      )
    }
  ];

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

  if (!view.summary.isQuestionnaireComplete) {
    return (
      <section className="panel">
        <h3>Recommendations</h3>

        <div className="assessment-context-grid assessment-context-grid--dashboard">
          {assessmentContext.map((item) => (
            <article key={item.label} className="context-card">
              <span>{item.label}</span>
              <strong>{item.value}</strong>
            </article>
          ))}

          <article className="context-card context-card--coverage">
            <span>Assessment coverage</span>
            <strong>{view.summary.coverageHeadline}</strong>
            <p>{view.summary.coverageDetail}</p>
          </article>
        </div>

        <p className="support-copy">
          Recommendations become available only after the selected assessment cycle is completed.
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
        </div>
      </section>

      {/* Cada trilha concentra um tipo de acao priorizada para a organizacao. */}
      <section className="roadmap-grid roadmap-grid--two">
        {groupedTracks.map((lane) => (
          <article key={lane.key} className="panel roadmap-lane">
            <div>
              <h3>{lane.title}</h3>
              {lane.description ? <p>{lane.description}</p> : null}
            </div>

            {lane.items.length === 0 ? (
              <div className="empty-state">No recommendations match the selected filters.</div>
            ) : (
              lane.items.map((item) => {
                const recommendationBody = getRecommendationBody(item);

                return (
                  <div key={item.id} className="roadmap-card">
                    <div className="roadmap-card__meta">
                      <span className="tag">{item.questionId}</span>
                      <strong className="roadmap-card__question">
                        {buildRecommendationTitle(item)}
                      </strong>
                    </div>

                    <dl className="roadmap-card__details">
                      <div>
                        <dt>Dimension group</dt>
                        <dd>{item.dimensionName || "Not available"}</dd>
                      </div>
                    </dl>

                    {recommendationBody ? (
                      <details className="roadmap-reference">
                        <summary>Recommendations</summary>
                        <p>{recommendationBody}</p>
                      </details>
                    ) : null}
                  </div>
                );
              })
            )}
          </article>
        ))}
      </section>
    </>
  );
}
