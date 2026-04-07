import { fallbackDashboardData } from "../mock/analyticsFallback";
import { mapStagesToJourney } from "./stairwayStages";

const MATURITY_SCALE = [
  { value: 0, label: "Not adopted" },
  { value: 10, label: "Abandoned" },
  { value: 30, label: "Project/Product" },
  { value: 60, label: "Process" },
  { value: 100, label: "Institutionalized" }
];

function formatScope(stages) {
  const activeStages = stages.filter((stage) => stage.available).map((stage) => stage.name);
  return activeStages.length ? activeStages.join(", ") : "Not available";
}

function buildSummaryIntro(currentLevel, scope) {
  return `This summary situates the organization's current maturity classification within the Continuous Software Engineering stages covered by the selected assessment cycle (${scope}).`;
}

function buildStageInterpretation(stage) {
  if (!stage.available) {
    return "This stage is not represented in the current analytics payload.";
  }

  const answered = stage.answeredPractices || 0;
  const total = stage.totalPractices || answered;

  if (answered === total) {
    return `${answered} assessed statements inform the interpretation of this stage.`;
  }

  return `${answered} of ${total} statements were answered in this stage. Unanswered statements count as zero in this summary.`;
}

function renderScaleLabel(label) {
  return label.replace("/", "/\u2009");
}

function MaturityScale({ score, currentLevel, available }) {
  if (!available) {
    return (
      <div className="maturity-scale maturity-scale--missing">
        <p>No scale is available because this stage is not represented in the current payload.</p>
      </div>
    );
  }

  const safeScore = Math.max(0, Math.min(100, score || 0));

  return (
    <div className="maturity-scale" aria-label={`Maturity scale for score ${safeScore}`}>
      <div className="maturity-scale__header">
        <span>Maturity scale</span>
        <strong>{safeScore}/100</strong>
      </div>

      <div className="maturity-scale__track" aria-hidden="true">
        <div className="maturity-scale__line" />
        {MATURITY_SCALE.map((item) => (
          <span
            key={item.value}
            className="maturity-scale__tick"
            style={{ left: `${item.value}%` }}
          />
        ))}
        <span
          className="maturity-scale__marker"
          style={{ left: `${safeScore}%` }}
          title={`Score ${safeScore}`}
        />
      </div>

      <div className="maturity-scale__labels">
        {MATURITY_SCALE.map((item) => (
          <div
            key={item.value}
            className={`maturity-scale__label ${safeScore >= item.value ? "is-reached" : ""}`.trim()}
          >
            <strong>{item.value}</strong>
            <span>{renderScaleLabel(item.label)}</span>
          </div>
        ))}
      </div>

      <p className="maturity-scale__reading">Current position: {currentLevel}</p>
    </div>
  );
}

function buildCoverageSummary(stages) {
  const represented = stages.filter(
    (stage) => stage.available && (stage.answeredPractices || 0) > 0
  );
  const missing = stages.filter(
    (stage) => !stage.available || (stage.answeredPractices || 0) === 0
  );

  return {
    headline: `${represented.length}/${stages.length} stages represented`,
    detail: missing.length
      ? `Missing evidence in: ${missing.map((stage) => stage.shortName).join(", ")}`
      : "All stages contain at least one answered statement in this cycle."
  };
}

export function DashboardPage({ data, loading }) {
  // A Tela 1 foi reduzida para funcionar como resumo diagnostico inicial, sem excesso de agregacoes.
  const view = data || fallbackDashboardData;
  const stages = mapStagesToJourney(view.stageScores);
  const stageScope = formatScope(stages);
  const summaryIntro = buildSummaryIntro(view.maturitySnapshot.overallLevel, stageScope);
  const coverage = buildCoverageSummary(stages);

  const assessmentContext = [
    { label: "Assessment cycle", value: view.maturitySnapshot.cycleLabel },
    {
      label: "Questionnaire status",
      value: view.maturitySnapshot.questionnaireStatus || "Incomplete"
    }
  ];

  if (loading && !data) {
    return <section className="panel">Loading diagnostic summary...</section>;
  }

  if (view.selectedCycleEmpty) {
    return (
      <section className="panel">
        <p className="eyebrow">Diagnostic summary</p>
        <h3>No submitted answers for this cycle</h3>
        <p>
          The selected assessment cycle does not contain submitted answers yet. The diagnostic
          summary will become available after at least one response is recorded for this cycle.
        </p>
      </section>
    );
  }

  return (
    <>
      <section className="panel">
        <p className="eyebrow">Diagnostic summary</p>

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

              <article className="context-card context-card--coverage">
                <span>Assessment coverage</span>
                <strong>{coverage.headline}</strong>
                <p>{coverage.detail}</p>
              </article>
            </div>
          </div>

          <aside className="maturity-highlight-card">
            <span>Current maturity level</span>
            <strong>{view.maturitySnapshot.overallLevel}</strong>
            <p>
              This qualitative reading summarizes the organization&apos;s current position in the
              selected assessment cycle.
            </p>
          </aside>
        </div>
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Stage-level diagnostic overview</h3>
            <p>
              The stage-level reading below positions the organization within the Stairway to
              Heaven model. Scores range from 0 to 100, and unanswered statements are counted as
              zero in this dashboard summary.
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

              <MaturityScale
                score={stage.score}
                currentLevel={stage.currentLevel}
                available={stage.available}
              />

              <p>{buildStageInterpretation(stage)}</p>
            </article>
          ))}
        </div>
      </section>
    </>
  );
}
