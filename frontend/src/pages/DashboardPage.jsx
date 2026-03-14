import { fallbackDashboardData } from "../mock/analyticsFallback";

function getPriorityClass(priority) {
  if (priority === "High") return "high";
  if (priority === "Medium") return "medium";
  return "low";
}

export function DashboardPage({ onNavigate, data, loading }) {
  const view = data || fallbackDashboardData;
  const {
    adoptionLevels,
    maturitySnapshot,
    overallDelta,
    recommendationsPreview,
    stageScores,
    strengths,
    bottlenecks
  } = {
    ...view,
    strengths: view?.strengths || view?.maturitySnapshot?.strengths || [],
    bottlenecks: view?.bottlenecks || view?.maturitySnapshot?.bottlenecks || []
  };
  const adoptFirstCount = adoptionLevels
    .filter((item) => ["Not adopted", "Abandoned"].includes(item.label))
    .reduce((sum, item) => sum + item.count, 0);

  if (loading && !data) {
    return <section className="panel">Loading diagnosis data from backend...</section>;
  }

  return (
    <>
      <section className="panel executive-hero">
        <div>
          <p className="eyebrow">Calibrated Zeppelin diagnosis</p>
          <h3>What is the overall result of the current cycle?</h3>
          <p>{maturitySnapshot.executiveSummary}</p>

          <div className="hero-meta">
            {maturitySnapshot.organizationType ? <span className="tag">{maturitySnapshot.organizationType}</span> : null}
            <span className="tag">{maturitySnapshot.answeredPractices} CI/CD practices</span>
            <span className="tag">{maturitySnapshot.cycleLabel}</span>
          </div>
        </div>

        <aside className="executive-score-card">
          <span>Overall Zeppelin score</span>
          <strong>{maturitySnapshot.overallScore}</strong>
          <small>{overallDelta >= 0 ? `+${overallDelta}` : overallDelta} vs previous cycle</small>
          <p>{maturitySnapshot.overallInterpretation}</p>
        </aside>
      </section>

      <section className="grid-4">
        <article className="metric-card">
          <p>Continuous Integration</p>
          <h2>{maturitySnapshot.ciScore}</h2>
          <small>Current stage score</small>
        </article>

        <article className="metric-card">
          <p>Continuous Deployment</p>
          <h2>{maturitySnapshot.cdScore}</h2>
          <small>Current stage score</small>
        </article>

        <article className="metric-card">
          <p>Triggered recommendations</p>
          <h2>{maturitySnapshot.recommendationCount}</h2>
          <small>Only low-adoption practices generate guidance</small>
        </article>

        <article className="metric-card">
          <p>Adopt-first actions</p>
          <h2>{adoptFirstCount}</h2>
          <small>Practices still absent or abandoned</small>
        </article>
      </section>

      <section className="two-column-grid">
        <article className="panel">
          <div className="section-head">
            <div>
              <h3>Stage maturity</h3>
              <p>The current diagnosis is organized around the two stages assessed in the dissertation.</p>
            </div>
          </div>

          <div className="stage-grid">
            {stageScores.map((item) => (
              <article key={item.key} className="stage-card">
                <div className="stage-card__head">
                  <div>
                    <h4>{item.name}</h4>
                    <span>{item.currentLevel}</span>
                  </div>
                  <strong>{item.score}</strong>
                </div>

                <div className="progress">
                  <span style={{ width: `${item.score}%` }} />
                </div>

                <p>
                  {item.answeredPractices} answered practices, {item.strengthCount || 0} mature items and{" "}
                  {item.bottleneckCount || 0} low-maturity items.
                </p>
              </article>
            ))}
          </div>
        </article>

        <article className="panel support-panel">
          <h3>Adoption level distribution</h3>
          <p>
            Recommendations are triggered only for practices rated as Not adopted, Abandoned or
            Project/Product level.
          </p>

          <div className="level-rows">
            {adoptionLevels.map((item) => (
              <div key={item.key} className="level-row">
                <div className="level-row__meta">
                  <strong>{item.label}</strong>
                  <small>{item.count} practices</small>
                </div>

                <div className="progress">
                  <span style={{ width: `${item.percentage}%` }} />
                </div>

                <span>{item.percentage}%</span>
              </div>
            ))}
          </div>
        </article>
      </section>

      <section className="grid-3">
        <article className="panel">
          <h3>Current strengths</h3>
          <ul className="insight-list">
            {strengths.map((item) => (
              <li key={item.id} className="insight-item">
                <div className="insight-item__row">
                  <small>
                    {item.stage} / {item.questionId}
                  </small>
                </div>
                <h4>{item.title}</h4>
                <p>{item.evidence}</p>
              </li>
            ))}
          </ul>
        </article>

        <article className="panel">
          <h3>Main bottlenecks</h3>
          <ul className="insight-list">
            {bottlenecks.map((item) => (
              <li key={item.id} className="insight-item">
                <div className="insight-item__row">
                  <small>
                    {item.stage} / {item.questionId}
                  </small>
                </div>
                <h4>{item.title}</h4>
                <p>{item.evidence}</p>
              </li>
            ))}
          </ul>
        </article>

        <article className="panel">
          <h3>What should happen next?</h3>
          <ul className="insight-list">
            {recommendationsPreview.map((item) => (
              <li key={item.id} className="insight-item">
                <div className="insight-item__row">
                  <small>
                    {item.stage} / {item.questionId}
                  </small>
                  <span className={`pill ${getPriorityClass(item.priority)}`}>{item.priority}</span>
                </div>
                <h4>{item.title}</h4>
                <p>{item.nextStep}</p>
              </li>
            ))}
          </ul>

          <div className="btn-row">
            <button className="btn-secondary-ui" type="button" onClick={() => onNavigate("results")}>
              Open Results
            </button>
            <button className="btn-primary-ui" type="button" onClick={() => onNavigate("recommendations")}>
              Open Roadmap
            </button>
          </div>
        </article>
      </section>
    </>
  );
}
