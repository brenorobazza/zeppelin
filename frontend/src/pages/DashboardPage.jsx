import { fallbackDashboardData } from "../mock/analyticsFallback";
import { mapStagesToJourney } from "./stairwayStages";

function formatScope(stages) {
  const activeStages = stages.filter((stage) => stage.available).map((stage) => stage.shortName);
  return activeStages.length ? activeStages.join(" / ") : "Not available";
}

function buildSummaryIntro(currentLevel, scope) {
  return `This summary presents the current maturity classification for the selected assessment cycle and situates the diagnostic across the assessed CSE stages (${scope}).`;
}

function buildStageInterpretation(stage) {
  if (!stage.available) {
    return "This stage is not available in the current analytics payload.";
  }

  return `${stage.answeredPractices || 0} assessed statements currently contribute to this stage reading.`;
}

export function DashboardPage({ data, loading }) {
  // A Tela 1 foi reduzida para funcionar como resumo diagnostico inicial, sem excesso de agregacoes.
  const view = data || fallbackDashboardData;
  const stages = mapStagesToJourney(view.stageScores);
  const stageScope = formatScope(stages);
  const summaryIntro = buildSummaryIntro(view.maturitySnapshot.overallLevel, stageScope);

  const assessmentContext = [
    { label: "Assessment cycle", value: view.maturitySnapshot.cycleLabel },
    { label: "Assessed statements", value: view.maturitySnapshot.answeredPractices },
    { label: "Assessment scope", value: stageScope }
  ];

  if (loading && !data) {
    return <section className="panel">Loading diagnostic summary from backend...</section>;
  }

  return (
    <>
      <section className="panel">
        <p className="eyebrow">Diagnostic overview</p>

        <div className="diagnostic-summary-layout">
          <div>
            <h3>Current maturity position</h3>
            <p>{summaryIntro}</p>

            <div className="assessment-context-grid assessment-context-grid--compact">
              {assessmentContext.map((item) => (
                <article key={item.label} className="context-card">
                  <span>{item.label}</span>
                  <strong>{item.value}</strong>
                </article>
              ))}
            </div>
          </div>

          <aside className="maturity-highlight-card">
            <span>Current maturity level</span>
            <strong>{view.maturitySnapshot.overallLevel}</strong>
            <p>
              This qualitative interpretation summarizes the organization&apos;s current position in
              the selected assessment cycle.
            </p>
          </aside>
        </div>
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Stage-level diagnostic overview</h3>
            <p>
              The stage reading below positions the organization across the Stairway to Heaven
              model without introducing additional aggregate indicators.
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
    </>
  );
}
