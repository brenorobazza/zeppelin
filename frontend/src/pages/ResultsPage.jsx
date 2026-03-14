import { fallbackResultsData } from "../mock/analyticsFallback";

export function ResultsPage({ data, loading }) {
  // Esta tela aprofunda o diagnostico exibido no dashboard.
  const view = data || fallbackResultsData;

  if (loading && !data) {
    return <section className="panel">Loading diagnostic results from backend...</section>;
  }

  return (
    <>
      {/* Resumo quantitativo inicial do diagnostico. */}
      <section className="grid-3">
        <article className="metric-card">
          <p>Assessed practices</p>
          <h2>{view.summary.answeredPractices}</h2>
          <small>CI and CD practices from the Zeppelin instrument subset</small>
        </article>

        <article className="metric-card">
          <p>CI vs CD gap</p>
          <h2>{view.summary.stageGap}</h2>
          <small>Difference between the two maturity stages</small>
        </article>

        <article className="metric-card">
          <p>Calibration profile</p>
          <h2>{view.summary.calibratedProfile.replace(" calibration profile", "")}</h2>
          <small>Selected to keep the diagnosis coherent with the organization type</small>
        </article>
      </section>

      {/* Comparacao por estagio para evidenciar onde CI e CD estao mais maduros ou mais atrasados. */}
      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Where are the main strengths and bottlenecks?</h3>
            <p>
              The diagnosis below combines stage scores with the main practice themes used to
              interpret the CI/CD subset of Zeppelin.
            </p>
          </div>
        </div>

        <div className="stage-grid">
          {view.stageScores.map((item) => (
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
                {item.answeredPractices || 0} practices contribute to this score, with{" "}
                {item.bottleneckCount || 0} items still below process level.
              </p>
            </article>
          ))}
        </div>
      </section>

      {/* Agrupamento por tema de pratica para facilitar a leitura dos resultados. */}
      <section className="panel">
        <h3>Diagnosis by practice theme</h3>
        <p>
          These themes summarize the most relevant clusters of CI/CD questions discussed in the
          dissertation and make the results easier to interpret in the TCC.
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
          <h3>What is already mature?</h3>
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
          <h3>What is still blocking maturity?</h3>
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
          <h3>Improvement opportunities that follow from the diagnosis</h3>
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
