import { dimensionScores, maturitySnapshot } from "../mock/zeppelinData";

export function ResultsPage() {
  return (
    <>
      <section className="grid-3">
        <article className="metric-card">
          <p>Organization Diagnosis</p>
          <h2>{maturitySnapshot.overallScore}/100</h2>
        </article>
        <article className="metric-card">
          <p>CI vs CD Gap</p>
          <h2>{Math.abs(maturitySnapshot.ciScore - maturitySnapshot.cdScore)} pts</h2>
        </article>
        <article className="metric-card">
          <p>Assessment Cycle</p>
          <h2>{maturitySnapshot.cycle}</h2>
        </article>
      </section>

      <section className="panel">
        <h3>Maturity by Practice Dimension</h3>
        <p>Comparative view of maturity pillars used for decision-making.</p>
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
          <h3>Top Strengths</h3>
          <ul>
            {maturitySnapshot.strengths.map((item) => (
              <li key={item}>{item}</li>
            ))}
          </ul>
        </article>
        <article className="panel">
          <h3>Top Bottlenecks</h3>
          <ul>
            {maturitySnapshot.bottlenecks.map((item) => (
              <li key={item}>{item}</li>
            ))}
          </ul>
        </article>
        <article className="panel">
          <h3>Main Opportunities</h3>
          <ul>
            <li>Automate approval gates to reduce deploy lead time.</li>
            <li>Increase integration test baseline in critical services.</li>
            <li>Move security checks to early pipeline stages.</li>
          </ul>
        </article>
      </section>
    </>
  );
}
