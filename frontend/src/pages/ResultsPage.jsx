import { fallbackDashboardData, fallbackResultsData } from "../mock/analyticsFallback";
import {
  getConstrainingStage,
  getLeadingStage,
  mapStagesToJourney
} from "./stairwayStages";

function formatStageSpread(leadingStage, constrainingStage) {
  if (!leadingStage || !constrainingStage) return "N/A";
  return `${leadingStage.score - constrainingStage.score} points`;
}

function buildResultsReading(leadingStage, constrainingStage) {
  if (!leadingStage || !constrainingStage) {
    return "This analytical view consolidates the available assessment evidence and highlights where the current payload still needs richer stage-level detail.";
  }

  return `The current cycle indicates that ${leadingStage.name} is the strongest maturity signal, while ${constrainingStage.name} concentrates the main constraints that still prevent a more even progression across the CSE path.`;
}

export function ResultsPage({ data, overview, loading }) {
  // Esta tela aprofunda o diagnostico exibido no dashboard.
  const view = data || fallbackResultsData;
  const overviewData = overview || fallbackDashboardData;
  const stages = mapStagesToJourney(view.stageScores);
  const leadingStage = getLeadingStage(stages);
  const constrainingStage = getConstrainingStage(stages);
  const analyticalReading = buildResultsReading(leadingStage, constrainingStage);

  if (loading && !data) {
    return <section className="panel">Loading diagnostic results from backend...</section>;
  }

  return (
    <>
      <section className="panel">
        <p className="eyebrow">Analytical report</p>
        <div className="section-head">
          <div>
            <h3>Analytical view of CSE practice adoption</h3>
            <p>
              This page deepens the current assessment cycle and clarifies what is already mature,
              what constrains progression and which improvement opportunities follow from the
              diagnostic evidence.
            </p>
          </div>
        </div>

        <article className="insight-item">
          <small>Analytical reading</small>
          <h4>{view.summary.overallLevel}</h4>
          <p>{analyticalReading}</p>
        </article>
      </section>

      {/* Resumo quantitativo inicial do diagnostico. */}
      <section className="grid-4">
        <article className="metric-card">
          <p>Overall maturity score</p>
          <h2>{view.summary.overallScore}</h2>
          <small>Consolidated analytical score for the selected cycle</small>
        </article>

        <article className="metric-card">
          <p>Current maturity level</p>
          <h2>{view.summary.overallLevel}</h2>
          <small>Stage-independent reading of the current maturity position</small>
        </article>

        <article className="metric-card">
          <p>Assessed statements</p>
          <h2>{view.summary.answeredPractices}</h2>
          <small>Statements consolidated into the analytical report for this cycle</small>
        </article>

        <article className="metric-card">
          <p>Stage spread</p>
          <h2>{formatStageSpread(leadingStage, constrainingStage)}</h2>
          <small>Distance between the strongest and most constrained stages</small>
        </article>
      </section>

      <section className="two-column-grid">
        <article className="panel support-panel">
          <h3>Adoption level distribution from the current cycle</h3>
          <p>
            The current analytics payload exposes the global distribution of adoption levels across
            all assessed statements in this cycle.
          </p>

          <div className="level-rows">
            {overviewData.adoptionLevels.map((item) => (
              <div key={item.key} className="level-row">
                <div className="level-row__meta">
                  <strong>{item.label}</strong>
                  <small>{item.count} statements</small>
                </div>
                <div className="progress">
                  <span style={{ width: `${item.percentage}%` }} />
                </div>
                <strong>{item.percentage}%</strong>
              </div>
            ))}
          </div>
        </article>

        <article className="panel">
          <h3>Adoption profile by stage</h3>
          <p>
            Stage scores indicate how close each Stairway to Heaven stage is to a process-level or
            institutionalized operating mode.
          </p>

          <div className="stage-profile-list">
            {stages.map((item) => (
              <article key={item.key} className={`stage-profile-item ${item.available ? "" : "stage-profile-item--missing"}`.trim()}>
                <div className="stage-profile-item__head">
                  <div>
                    <h4>{item.name}</h4>
                    <span>{item.currentLevel}</span>
                  </div>
                  <strong>{item.available ? item.score : "N/A"}</strong>
                </div>

                <div className="progress">
                  <span style={{ width: `${item.available ? item.score : 0}%` }} />
                </div>

                <p>
                  {item.available
                    ? `${item.answeredPractices || 0} statements currently feed this stage, with ${item.bottleneckCount || 0} practices still below process level.`
                    : "This stage is not yet represented in the current analytics payload."}
                </p>
              </article>
            ))}
          </div>
        </article>
      </section>

      {/* Comparacao por estagio para evidenciar onde os estagios estao mais maduros ou mais atrasados. */}
      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Stage-level maturity overview</h3>
            <p>
              The diagnosis below highlights the four CSE stages and makes explicit which ones are
              already supporting the current position and which still constrain further evolution.
            </p>
          </div>
        </div>

        <div className="journey-grid">
          {stages.map((item, index) => (
            <article
              key={item.key}
              className={`stage-card stage-card--journey ${item.available ? "" : "stage-card--missing"}`.trim()}
            >
              <div className="stage-card__step">Stage {index + 1}</div>
              <div className="stage-card__head">
                <div>
                  <h4>{item.name}</h4>
                  <span>{item.currentLevel}</span>
                </div>
                <strong>{item.available ? item.score : "N/A"}</strong>
              </div>

              <div className="progress">
                <span style={{ width: `${item.available ? item.score : 0}%` }} />
              </div>

              <p>
                {item.available
                  ? `${item.answeredPractices || 0} statements contribute to this score, with ${item.strengthCount || 0} strong signals and ${item.bottleneckCount || 0} constraining practices.`
                  : "No direct evidence for this stage is available in the current dataset."}
              </p>
            </article>
          ))}
        </div>
      </section>

      {/* Agrupamento por tema de pratica para facilitar a leitura dos resultados. */}
      <section className="panel">
        <h3>Diagnosis by practice theme</h3>
        <p>
          These themes organize the available evidence by practice cluster, helping translate raw
          assessment statements into a more readable diagnostic view.
        </p>

        <div className="dimension-grid">
          {view.practiceThemes.map((item) => (
            <article key={item.key} className="dimension-card dimension-card--detailed">
              <div className="dimension-card__head">
                <div>
                  <h4>{item.name}</h4>
                  <span>{item.focus}</span>
                </div>
                <strong>{item.score}</strong>
              </div>

              <div className="progress">
                <span style={{ width: `${item.score}%` }} />
              </div>

              <div className="dimension-card__evidence">
                <div>
                  <span>Strength</span>
                  <strong>{item.strength}</strong>
                </div>
                <div>
                  <span>Bottleneck</span>
                  <strong>{item.bottleneck}</strong>
                </div>
              </div>
            </article>
          ))}
        </div>
      </section>

      {/* Fechamento analitico: forcas, gargalos e oportunidades de melhoria. */}
      <section className="grid-3">
        <article className="panel">
          <h3>Practices already supporting the current maturity position</h3>
          <ul className="insight-list">
            {view.strengths.map((item) => (
              <li key={item.id} className="insight-item">
                <small>
                  {item.stage} / {item.questionId}
                </small>
                <h4>{item.title}</h4>
                <p>{item.evidence}</p>
              </li>
            ))}
          </ul>
        </article>

        <article className="panel">
          <h3>Practices constraining progression to the next CSE stage</h3>
          <ul className="insight-list">
            {view.bottlenecks.map((item) => (
              <li key={item.id} className="insight-item">
                <small>
                  {item.stage} / {item.questionId}
                </small>
                <h4>{item.title}</h4>
                <p>{item.evidence}</p>
              </li>
            ))}
          </ul>
        </article>

        <article className="panel">
          <h3>Improvement opportunities derived from the assessment</h3>
          <ul className="insight-list">
            {view.opportunities.map((item) => (
              <li key={item.id} className="insight-item">
                <small>
                  {item.stage} / {item.questionId}
                </small>
                <h4>{item.title}</h4>
                <p>{item.expectedImpact}</p>
              </li>
            ))}
          </ul>
        </article>
      </section>
    </>
  );
}
