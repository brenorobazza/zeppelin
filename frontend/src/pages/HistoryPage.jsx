import { historySeries } from "../mock/zeppelinData";

export function HistoryPage() {
  const baselineCycle = historySeries[0];
  const currentCycle = historySeries[historySeries.length - 1];
  const overallDelta = currentCycle.overall - baselineCycle.overall;
  const ciDelta = currentCycle.ci - baselineCycle.ci;
  const cdDelta = currentCycle.cd - baselineCycle.cd;
  const recommendationReduction = baselineCycle.recommendationCount - currentCycle.recommendationCount;
  const institutionalizedGrowth =
    currentCycle.adoptionLevels.institutionalized - baselineCycle.adoptionLevels.institutionalized;

  return (
    <>
      <section className="grid-4">
        <article className="metric-card">
          <p>Overall evolution</p>
          <h2>{overallDelta >= 0 ? `+${overallDelta}` : overallDelta}</h2>
          <small>From baseline to current cycle</small>
        </article>

        <article className="metric-card">
          <p>CI evolution</p>
          <h2>{ciDelta >= 0 ? `+${ciDelta}` : ciDelta}</h2>
          <small>Continuous Integration gain across cycles</small>
        </article>

        <article className="metric-card">
          <p>CD evolution</p>
          <h2>{cdDelta >= 0 ? `+${cdDelta}` : cdDelta}</h2>
          <small>Continuous Deployment gain across cycles</small>
        </article>

        <article className="metric-card">
          <p>Recommendations reduced</p>
          <h2>{recommendationReduction}</h2>
          <small>Fewer low-maturity practices needing intervention</small>
        </article>
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <h3>What changed between cycles?</h3>
            <p>
              The history below shows how CI, CD and the number of triggered recommendations moved
              between assessment cycles.
            </p>
          </div>
        </div>

        <div className="history-cycles history-cycles--three">
          {historySeries.map((item, index) => {
            const previous = historySeries[index - 1];
            const delta = previous ? item.overall - previous.overall : 0;

            return (
              <article key={item.cycle} className="history-cycle-card">
                <div className="history-cycle-card__head">
                  <div>
                    <h4>{item.cycle}</h4>
                    <p>{item.period}</p>
                  </div>
                  <span className={`history-cycle-card__delta ${delta < 0 ? "negative" : ""}`}>
                    {index === 0 ? "Baseline" : delta >= 0 ? `+${delta}` : `${delta}`}
                  </span>
                </div>

                <div className="history-cycle-card__score">
                  <span>Overall Zeppelin score</span>
                  <strong>{item.overall}</strong>
                </div>

                <div className="progress">
                  <span style={{ width: `${item.overall}%` }} />
                </div>

                <ul className="trend-list">
                  <li>
                    <span>Continuous Integration</span>
                    <strong>{item.ci}</strong>
                  </li>
                  <li>
                    <span>Continuous Deployment</span>
                    <strong>{item.cd}</strong>
                  </li>
                  <li>
                    <span>Triggered recommendations</span>
                    <strong>{item.recommendationCount}</strong>
                  </li>
                </ul>
              </article>
            );
          })}
        </div>
      </section>

      <section className="panel">
        <h3>Adoption-level shift across cycles</h3>
        <p>
          The dissertation highlights a migration from localized practices to process-level and
          institutionalized adoption. The table below makes that movement explicit.
        </p>

        <table className="table">
          <thead>
            <tr>
              <th>Cycle</th>
              <th>Not adopted</th>
              <th>Abandoned</th>
              <th>Project/Product</th>
              <th>Process</th>
              <th>Institutionalized</th>
            </tr>
          </thead>
          <tbody>
            {historySeries.map((item) => (
              <tr key={item.cycle}>
                <td>
                  <strong>{item.cycle}</strong>
                  <div>{item.period}</div>
                </td>
                <td>{item.adoptionLevels.notAdopted}</td>
                <td>{item.adoptionLevels.abandoned}</td>
                <td>{item.adoptionLevels.project}</td>
                <td>{item.adoptionLevels.process}</td>
                <td>{item.adoptionLevels.institutionalized}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>

      <section className="grid-3">
        <article className="panel">
          <h3>Main improvements</h3>
          <ul className="insight-list">
            <li className="insight-item">
              <small>Stage evolution</small>
              <h4>Continuous Integration gained {ciDelta} points</h4>
              <p>
                CI moved faster than CD across the tracked cycles, reinforcing the thesis finding
                that stronger integration foundations tend to emerge before more advanced delivery capability.
              </p>
            </li>
            <li className="insight-item">
              <small>Adoption profile</small>
              <h4>Institutionalized practices grew by {institutionalizedGrowth}</h4>
              <p>
                Mature practices now represent the largest share of the assessed CI/CD subset.
              </p>
            </li>
          </ul>
        </article>

        <article className="panel">
          <h3>Persistent friction points</h3>
          <ul className="insight-list">
            <li className="insight-item">
              <small>Continuous Deployment</small>
              <h4>Release automation still advances more slowly</h4>
              <p>
                CD improved, but still lags behind CI because it depends on stronger feedback loops,
                coordination across areas and higher release confidence.
              </p>
            </li>
          </ul>
        </article>

        <article className="panel">
          <h3>Reading for the next cycle</h3>
          <ul className="insight-list">
            <li className="insight-item">
              <small>Recommended interpretation</small>
              <h4>Fewer recommendations, higher maturity</h4>
              <p>
                The number of triggered recommendations dropped from {baselineCycle.recommendationCount} to{" "}
                {currentCycle.recommendationCount}, indicating that more practices crossed the threshold
                from local adoption to process-level or institutionalized use.
              </p>
            </li>
          </ul>
        </article>
      </section>
    </>
  );
}
