import { fallbackDashboardData } from "../mock/analyticsFallback";
import {
  getConstrainingStage,
  getLeadingStage,
  mapStagesToJourney
} from "./stairwayStages";

function formatDelta(delta) {
  if (delta == null) return "No previous cycle available";
  if (delta > 0) return `+${delta} points versus the previous cycle`;
  if (delta < 0) return `${delta} points versus the previous cycle`;
  return "No score variation versus the previous cycle";
}

function formatScope(stages) {
  const activeStages = stages.filter((stage) => stage.available).map((stage) => stage.shortName);
  return activeStages.length ? activeStages.join(" / ") : "Not available";
}

function buildExecutiveReading(snapshot, leadingStage, constrainingStage) {
  if (!leadingStage || !constrainingStage) {
    return (
      snapshot.executiveSummary ||
      "The current analytics payload already consolidates the assessment cycle, but it does not yet expose the full stage-level view required for a stronger interpretation."
    );
  }

  if (leadingStage.key === constrainingStage.key) {
    return (
      snapshot.executiveSummary ||
      `The current cycle shows a balanced maturity profile around ${leadingStage.name}, with limited variation across the assessed stages.`
    );
  }

  return `The organization currently shows stronger maturity in ${leadingStage.name}, while ${constrainingStage.name} remains the main constraint for further progression across the Continuous Software Engineering path.`;
}

function buildStageInterpretation(stage) {
  if (!stage.available) {
    return "This stage is not exposed in the current analytics payload.";
  }

  if ((stage.bottleneckCount || 0) > (stage.strengthCount || 0)) {
    return `${stage.bottleneckCount} assessed practices still constrain progression in this stage.`;
  }

  if ((stage.strengthCount || 0) > 0) {
    return `${stage.strengthCount} assessed practices already reinforce this stage as part of the current maturity position.`;
  }

  return `${stage.answeredPractices || 0} assessed statements currently contribute to this stage score.`;
}

export function DashboardPage({ data, loading }) {
  // O dashboard resume o ciclo atual como artefato analitico, nao como painel comercial.
  const view = data || fallbackDashboardData;
  const stages = mapStagesToJourney(view.stageScores);
  const leadingStage = getLeadingStage(stages);
  const constrainingStage = getConstrainingStage(stages);
  const executiveReading = buildExecutiveReading(
    view.maturitySnapshot,
    leadingStage,
    constrainingStage
  );

  const assessmentContext = [
    { label: "Organization", value: view.maturitySnapshot.organization },
    { label: "Assessment cycle", value: view.maturitySnapshot.cycleLabel },
    { label: "Assessed statements", value: view.maturitySnapshot.answeredPractices },
    { label: "Assessment scope", value: formatScope(stages) }
  ];

  if (loading && !data) {
    return <section className="panel">Loading executive diagnostic view from backend...</section>;
  }

  return (
    <>
      <section className="panel">
        <p className="eyebrow">Analytics report</p>

        <div className="executive-hero">
          <div>
            <h3>Current maturity position in the CSE evolution path</h3>
            <p>{executiveReading}</p>

            <div className="assessment-context-grid">
              {assessmentContext.map((item) => (
                <article key={item.label} className="context-card">
                  <span>{item.label}</span>
                  <strong>{item.value}</strong>
                </article>
              ))}
            </div>
          </div>

          <aside className="executive-score-card">
            <span>Overall maturity score</span>
            <strong>{view.maturitySnapshot.overallScore}</strong>
            <small>{view.maturitySnapshot.overallLevel}</small>
            <p className="support-copy">
              {view.maturitySnapshot.executiveSummary || view.maturitySnapshot.overallInterpretation}
            </p>
            <p className="support-copy">{formatDelta(view.overallDelta)}</p>
          </aside>
        </div>
      </section>

      <section className="grid-4">
        <article className="metric-card">
          <p>Current maturity level</p>
          <h2>{view.maturitySnapshot.overallLevel}</h2>
          <small>Current analytical reading of the selected assessment cycle</small>
        </article>

        <article className="metric-card">
          <p>Leading stage</p>
          <h2>{leadingStage?.shortName || "N/A"}</h2>
          <small>{leadingStage?.name || "No stage data available"}</small>
        </article>

        <article className="metric-card">
          <p>Constraining stage</p>
          <h2>{constrainingStage?.shortName || "N/A"}</h2>
          <small>{constrainingStage?.name || "No stage data available"}</small>
        </article>

        <article className="metric-card">
          <p>Triggered recommendations</p>
          <h2>{view.maturitySnapshot.recommendationCount}</h2>
          <small>Improvement actions derived from low-adoption practices in this cycle</small>
        </article>
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Stage-level maturity overview</h3>
            <p>
              The diagnostic below situates the organization across the Stairway to Heaven stages
              and highlights where progression is stronger or still constrained.
            </p>
          </div>
        </div>

        <div className="journey-grid">
          {stages.map((stage, index) => (
            <article
              key={stage.key}
              className={`stage-card stage-card--journey ${stage.available ? "" : "stage-card--missing"}`.trim()}
            >
              <div className="stage-card__step">Stage {index + 1}</div>

              <div className="stage-card__head">
                <div>
                  <h4>{stage.name}</h4>
                  <span>{stage.currentLevel}</span>
                </div>
                <strong>{stage.available ? stage.score : "N/A"}</strong>
              </div>

              <div className="progress">
                <span style={{ width: `${stage.available ? stage.score : 0}%` }} />
              </div>

              <p>{buildStageInterpretation(stage)}</p>
            </article>
          ))}
        </div>
      </section>

      <section className="two-column-grid">
        <article className="panel support-panel">
          <h3>Adoption level distribution from the current cycle</h3>
          <p>
            This distribution consolidates the assessed statements by adoption level and indicates
            how much of the diagnostic still depends on local or immature practices.
          </p>

          <div className="level-rows">
            {view.adoptionLevels.map((item) => (
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
          <h3>Analytical reading for the current cycle</h3>
          <ul className="insight-list">
            <li className="insight-item">
              <small>Current position</small>
              <h4>{view.maturitySnapshot.overallLevel}</h4>
              <p>{executiveReading}</p>
            </li>

            <li className="insight-item">
              <small>Progression signal</small>
              <h4>{leadingStage?.name || "Stage evidence not available"}</h4>
              <p>
                {leadingStage
                  ? `${leadingStage.name} currently concentrates the strongest maturity signal in this cycle.`
                  : "The current payload does not expose enough stage evidence to rank progression."}
              </p>
            </li>

            <li className="insight-item">
              <small>Immediate pressure</small>
              <h4>{constrainingStage?.name || "No stage constraint available"}</h4>
              <p>
                {constrainingStage
                  ? `${view.maturitySnapshot.recommendationCount} recommendations remain open, with ${constrainingStage.name} concentrating the main constraints to further evolution.`
                  : "Recommendation pressure cannot be linked to a specific stage with the current payload."}
              </p>
            </li>
          </ul>
        </article>
      </section>

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
          <h3>Immediate next analytical priorities</h3>
          <ul className="insight-list">
            {view.recommendationsPreview.map((item) => (
              <li key={item.id} className="insight-item">
                <small>
                  {item.stage} / {item.questionId}
                </small>
                <h4>{item.title}</h4>
                <p>{item.expectedImpact || item.recommendation}</p>
              </li>
            ))}
          </ul>
        </article>
      </section>
    </>
  );
}
