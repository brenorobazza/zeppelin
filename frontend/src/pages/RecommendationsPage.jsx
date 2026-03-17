import { useMemo, useState } from "react";
import { fallbackRecommendationsData } from "../mock/analyticsFallback";

function getPriorityClass(priority) {
  if (priority === "High") return "high";
  if (priority === "Medium") return "medium";
  return "low";
}

export function RecommendationsPage({ data, loading }) {
  // Esta e a tela que transforma o diagnostico em um roadmap acionavel.
  const view = data || fallbackRecommendationsData;
  const [stage, setStage] = useState("All");
  const [track, setTrack] = useState("All");
  const [priority, setPriority] = useState("All");

  // Os filtros apenas mudam a leitura visual; os dados originais continuam intactos.
  const filtered = useMemo(
    () =>
      view.recommendations.filter((item) => {
        const matchesStage = stage === "All" || item.stage === stage;
        const matchesTrack = track === "All" || item.track === track;
        const matchesPriority = priority === "All" || item.priority === priority;
        return matchesStage && matchesTrack && matchesPriority;
      }),
    [view.recommendations, stage, track, priority]
  );

  // Depois do filtro, reorganizamos os itens dentro das trilhas do roadmap.
  const groupedTracks = view.recommendationTracks.map((lane) => ({
    ...lane,
    items: filtered.filter((item) => item.track === lane.key)
  }));

  if (loading && !data) {
    return <section className="panel">Loading roadmap recommendations from backend...</section>;
  }

  return (
    <>
      {/* Resumo executivo das recomendacoes geradas para o ciclo atual. */}
      <section className="grid-3">
        <article className="metric-card">
          <p>Triggered recommendations</p>
          <h2>{view.summary.triggeredRecommendations}</h2>
          <small>Generated only for practices below process level</small>
        </article>

        <article className="metric-card">
          <p>Adopt-first items</p>
          <h2>{view.summary.adoptNowCount}</h2>
          <small>Practices still absent or abandoned</small>
        </article>

        <article className="metric-card">
          <p>Consolidation items</p>
          <h2>{view.summary.consolidateCount}</h2>
          <small>Practices that exist locally and should scale to process level</small>
        </article>
      </section>

      {/* Explica a regra de geracao das recomendacoes e oferece filtros de leitura. */}
      <section className="two-column-grid">
        <article className="panel">
          <h3>How this roadmap is generated</h3>
          <p>
            The dissertation defines a deterministic gap-analysis rule so the system recommends only
            what still needs adoption or consolidation.
          </p>

          <ul className="insight-list">
            <li className="insight-item">
              <small>Gap analysis rule</small>
              <h4>Not adopted or Abandoned</h4>
              <p>Trigger adoption-oriented recommendations focused on establishing the practice.</p>
            </li>
            <li className="insight-item">
              <small>Gap analysis rule</small>
              <h4>Realized at project/product level</h4>
              <p>Trigger consolidation-oriented recommendations to scale the practice to process level.</p>
            </li>
            <li className="insight-item">
              <small>Gap analysis rule</small>
              <h4>Realized at process level or Institutionalized</h4>
              <p>No recommendation is triggered, because the practice is treated as already mature.</p>
            </li>
          </ul>
        </article>

        <article className="panel support-panel">
          <h3>Filters</h3>
          <p>Use the filters below to read the roadmap by stage, recommendation track and priority.</p>

          <div className="btn-row">
            <select value={stage} onChange={(event) => setStage(event.target.value)}>
              <option>All</option>
              {view.availableStages.map((item) => (
                <option key={item}>{item}</option>
              ))}
            </select>

            <select value={track} onChange={(event) => setTrack(event.target.value)}>
              <option>All</option>
              {view.availableTracks.map((item) => (
                <option key={item}>{item}</option>
              ))}
            </select>

            <select value={priority} onChange={(event) => setPriority(event.target.value)}>
              <option>All</option>
              {view.availablePriorities.map((item) => (
                <option key={item}>{item}</option>
              ))}
            </select>
          </div>
        </article>
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
              <div className="empty-state">No recommendations match the current filters.</div>
            ) : (
              lane.items.map((item) => (
                <div key={item.id} className="roadmap-card">
                  <div className="roadmap-card__meta">
                    <span className="tag">
                      {item.stage} / {item.questionId}
                    </span>
                    <span className={`pill ${getPriorityClass(item.priority)}`}>{item.priority}</span>
                  </div>

                  <h4>{item.title}</h4>
                  <p>{item.recommendation}</p>

                  <dl className="roadmap-card__details">
                    <div>
                      <dt>Current level</dt>
                      <dd>{item.currentLevel}</dd>
                    </div>
                    <div>
                      <dt>Expected impact</dt>
                      <dd>{item.expectedImpact}</dd>
                    </div>
                    <div>
                      <dt>Next step</dt>
                      <dd>{item.nextStep}</dd>
                    </div>
                    <div>
                      <dt>Status</dt>
                      <dd>{item.status}</dd>
                    </div>
                  </dl>

                  {item.contextNote ? <p className="roadmap-card__note">{item.contextNote}</p> : null}
                </div>
              ))
            )}
          </article>
        ))}
      </section>
    </>
  );
}
