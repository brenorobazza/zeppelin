import { fallbackDashboardData } from "../mock/analyticsFallback";
import { mapStagesToJourney } from "./stairwayStages";

function buildAnswerProgress(answered, total) {
  return `${answered || 0}/${total || 0} statements answered`;
}

function buildStageAnswerValue(stage) {
  const answered = stage.answeredPractices || 0;
  const total = stage.totalPractices || answered;
  return `${answered}/${total}`;
}

function buildStageScoreValue(stage) {
  return stage.available ? `${stage.score}/100` : "N/A";
}

function buildStageLevelValue(stage) {
  return stage.available ? stage.currentLevel : "Not available";
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
      ? `Missing: ${missing.map((stage) => stage.shortName).join(", ")}`
      : "All stages represented."
  };
}

export function DashboardPage({ data, loading }) {
  // A Tela 1 foi reduzida para funcionar como resumo diagnostico inicial, sem excesso de agregacoes.
  const view = data || fallbackDashboardData;
  const stages = mapStagesToJourney(view.stageScores);
  const coverage = buildCoverageSummary(stages);
  const totalStatements = stages.reduce(
    (total, stage) => total + (stage.totalPractices || stage.answeredPractices || 0),
    0
  );
  const stageSummaryRows = stages.map((stage) => ({
    key: stage.key,
    name: stage.name,
    score: buildStageScoreValue(stage),
    level: buildStageLevelValue(stage),
    answers: buildStageAnswerValue(stage)
  }));
  const overallSummaryRow = {
    key: "overall",
    name: "Overall",
    score: `${view.maturitySnapshot.overallScore || 0}/100`,
    level: view.maturitySnapshot.overallLevel || "Not available",
    answers: `${view.maturitySnapshot.answeredPractices || 0}/${totalStatements}`
  };
  const isQuestionnaireUnderAssessment =
    !view.maturitySnapshot.isQuestionnaireComplete;

  const assessmentContext = [
    { label: "Assessment cycle", value: view.maturitySnapshot.cycleLabel },
    {
      label: "Questionnaire status",
      value: view.maturitySnapshot.questionnaireStatus || "Under Assessment"
    },
    {
      label: "Answer progress",
      value: buildAnswerProgress(view.maturitySnapshot.answeredPractices, totalStatements)
    }
  ];

  if (loading && !data) {
    return <section className="panel">Loading summary...</section>;
  }

  if (view.selectedCycleEmpty) {
    return (
      <section className="panel">
        <p className="eyebrow">Diagnostic summary</p>
        <h3>No submitted answers for this cycle</h3>
        <p>No answers submitted yet.</p>
      </section>
    );
  }

  return (
    <>
      <section className="panel">
        <p className="eyebrow">Diagnostic summary</p>
        <h3>Current maturity position</h3>

        <div className="assessment-context-grid assessment-context-grid--dashboard">
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
      </section>

      {isQuestionnaireUnderAssessment ? (
        <section className="panel">
          <div className="section-head">
            <div>
              <h3>Stage summary</h3>
              <p>Complete the cycle to view scores.</p>
            </div>
          </div>
        </section>
      ) : (
        <section className="panel">
          <div className="section-head">
            <div>
              <h3>Stage summary</h3>
            </div>
          </div>

          <table className="table">
            <thead>
              <tr>
                <th>Stage</th>
                <th>Score</th>
                <th>Level</th>
                <th>Answers</th>
              </tr>
            </thead>
            <tbody>
              {stageSummaryRows.map((row) => (
                <tr key={row.key}>
                  <td>
                    <strong>{row.name}</strong>
                  </td>
                  <td>{row.score}</td>
                  <td>{row.level}</td>
                  <td>{row.answers}</td>
                </tr>
              ))}
              <tr>
                <td>
                  <strong>{overallSummaryRow.name}</strong>
                </td>
                <td>{overallSummaryRow.score}</td>
                <td>{overallSummaryRow.level}</td>
                <td>{overallSummaryRow.answers}</td>
              </tr>
            </tbody>
          </table>

          <p className="support-copy">See Results for the full analysis.</p>
        </section>
      )}
    </>
  );
}
