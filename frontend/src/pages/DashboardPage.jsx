import { dimensionScores, maturitySnapshot, recommendations } from "../mock/zeppelinData";

export function DashboardPage({ onNavigate }) {
  return (
    <>
      <section className="grid-3">
        <article className="metric-card">
          <p>Overall Maturity Score</p>
          <h2>{maturitySnapshot.overallScore}</h2>
        </article>
        <article className="metric-card">
          <p>Continuous Integration</p>
          <h2>{maturitySnapshot.ciScore}</h2>
        </article>
        <article className="metric-card">
          <p>Continuous Delivery</p>
          <h2>{maturitySnapshot.cdScore}</h2>
        </article>
      </section>

      <section className="panel">
        <h3>Executive Dimension View</h3>
        <p>Strategic snapshot of CI/CD maturity dimensions.</p>
        {dimensionScores.map((item) => (
          <div key={item.name} style={{ marginBottom: "0.62rem" }}>
            <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "0.22rem" }}>
              <span>{item.name}</span>
              <strong>{item.score}</strong>
            </div>
            <div className="progress">
              <span style={{ width: `${item.score}%` }} />
            </div>
          </div>
        ))}
      </section>

      <section className="grid-3">
        <article className="panel">
          <h3>Strengths</h3>
          <ul>
            {maturitySnapshot.strengths.map((item) => (
              <li key={item}>{item}</li>
            ))}
          </ul>
        </article>
        <article className="panel">
          <h3>Bottlenecks</h3>
          <ul>
            {maturitySnapshot.bottlenecks.map((item) => (
              <li key={item}>{item}</li>
            ))}
          </ul>
        </article>
        <article className="panel">
          <h3>Priority Recommendations</h3>
          <ul>
            {recommendations.slice(0, 3).map((item) => (
              <li key={item.id}>{item.practice}</li>
            ))}
          </ul>
          <div className="btn-row">
            <button className="btn-primary-ui" type="button" onClick={() => onNavigate("recommendations")}>
              View Recommendations
            </button>
          </div>
        </article>
      </section>
    </>
  );
}
