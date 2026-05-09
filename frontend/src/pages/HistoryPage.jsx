import { useMemo, useState } from "react";
import { fallbackHistoryData } from "../mock/analyticsFallback";

const HISTORY_STAGE_METRICS = [
  {
    key: "agile",
    title: "Agile R&D evolution",
    label: "Agile R&D Organization"
  },
  {
    key: "ci",
    title: "CI evolution",
    label: "Continuous Integration"
  },
  {
    key: "cd",
    title: "CD evolution",
    label: "Continuous Deployment"
  },
  {
    key: "experimentation",
    title: "Experiment System evolution",
    label: "R&D as an Experiment System"
  }
];

function getCycleStageScore(cycle, stageKey) {
  if (!cycle) return null;
  if (cycle[stageKey] != null) return cycle[stageKey];
  return cycle.stages?.find((stage) => stage.key === stageKey)?.score ?? null;
}

function formatDelta(value) {
  if (value == null) return "-";
  return value >= 0 ? `+${value}` : `${value}`;
}

function formatScore(value) {
  return value == null ? "-" : value;
}

function buildComparison(baselineCycle, currentCycle) {
  const stageDeltas = HISTORY_STAGE_METRICS.reduce((acc, stage) => {
    const baselineScore = getCycleStageScore(baselineCycle, stage.key);
    const currentScore = getCycleStageScore(currentCycle, stage.key);

    acc[stage.key] =
      baselineScore != null && currentScore != null ? currentScore - baselineScore : null;
    return acc;
  }, {});

  return {
    overallDelta:
      baselineCycle && currentCycle ? currentCycle.overall - baselineCycle.overall : null,
    recommendationReduction:
      baselineCycle && currentCycle
        ? baselineCycle.recommendationCount - currentCycle.recommendationCount
        : null,
    institutionalizedGrowth:
      baselineCycle && currentCycle
        ? currentCycle.adoptionLevels.institutionalized -
          baselineCycle.adoptionLevels.institutionalized
        : null,
    stageDeltas
  };
}

export function HistoryPage({ data, loading }) {
  // O historico compara ciclos para mostrar progressao real de maturidade ao longo do tempo.
  const view = data || fallbackHistoryData;
  const historySeries = view.historySeries || [];
  const [baselineIndex, setBaselineIndex] = useState("0");
  const [comparisonIndex, setComparisonIndex] = useState("");
  const lastCycleIndex = Math.max(historySeries.length - 1, 0);
  const baselineOptions =
    historySeries.length > 1 ? historySeries.slice(0, -1) : historySeries;
  const safeBaselineIndex = Math.min(
    Math.max(Number(baselineIndex) || 0, 0),
    Math.max(baselineOptions.length - 1, 0)
  );
  const comparisonOptions = historySeries
    .map((item, index) => ({ item, index }))
    .filter(({ index }) => index > safeBaselineIndex);
  const requestedComparisonIndex = comparisonIndex === "" ? null : Number(comparisonIndex);
  const safeComparisonIndex = comparisonOptions.some(
    ({ index }) => index === requestedComparisonIndex
  )
    ? requestedComparisonIndex
    : comparisonOptions[comparisonOptions.length - 1]?.index ?? lastCycleIndex;
  const baselineCycle = baselineOptions[safeBaselineIndex] || historySeries[0];
  const currentCycle =
    historySeries[safeComparisonIndex] || historySeries[lastCycleIndex] || baselineCycle;
  const comparison = useMemo(
    () => buildComparison(baselineCycle, currentCycle),
    [baselineCycle, currentCycle]
  );

  if (loading && !data) {
    return <section className="panel">Loading historical progression from backend...</section>;
  }

  if (view.selectedCycleEmpty) {
    return (
      <section className="panel">
        <p className="eyebrow">History</p>
        <h3>No submitted answers for this cycle</h3>
        <p>
          The selected assessment cycle does not contain submitted answers yet. Historical
          comparisons will be available after the cycle receives recorded answers.
        </p>
      </section>
    );
  }

  return (
    <>
      {/* Resumo rapido da evolucao desde o ciclo base. */}
      <section className="panel">
        <div className="roadmap-toolbar">
          <div className="roadmap-filters roadmap-filters--two">
            <label className="roadmap-filter-field">
              <span>Baseline cycle</span>
              <select
                value={String(safeBaselineIndex)}
                onChange={(event) => setBaselineIndex(event.target.value)}
              >
                {baselineOptions.map((item, index) => (
                  <option key={`${item.cycle}-${item.period}`} value={String(index)}>
                    {item.cycle} - {item.period}
                  </option>
                ))}
              </select>
            </label>

            <label className="roadmap-filter-field">
              <span>Comparison cycle</span>
              <select
                value={String(safeComparisonIndex)}
                onChange={(event) => setComparisonIndex(event.target.value)}
              >
                {comparisonOptions.map(({ item, index }) => (
                  <option key={`${item.cycle}-${item.period}`} value={String(index)}>
                    {item.cycle} - {item.period}
                  </option>
                ))}
              </select>
            </label>
          </div>
        </div>
      </section>

      <section className="grid-3">
        <article className="metric-card">
          <p>Overall evolution</p>
          <h2>{formatDelta(comparison.overallDelta)}</h2>
          <small>
            {baselineCycle?.cycle || "Baseline"} to {currentCycle?.cycle || "comparison cycle"}
          </small>
        </article>

        {HISTORY_STAGE_METRICS.map((stage) => (
          <article key={stage.key} className="metric-card">
            <p>{stage.title}</p>
            <h2>{formatDelta(comparison.stageDeltas[stage.key])}</h2>
            <small>{stage.label}</small>
          </article>
        ))}

        <article className="metric-card">
          <p>Recommendations reduced</p>
          <h2>{formatDelta(comparison.recommendationReduction)}</h2>
          <small>Fewer low-maturity practices needing intervention</small>
        </article>
      </section>

      {/* Cards comparativos por ciclo. */}
      <section className="panel">
        <div className="section-head">
          <div>
            <h3>What changed between cycles?</h3>
          </div>
        </div>

        <div className="history-cycles history-cycles--three">
          {view.historySeries.map((item, index) => (
            <article key={`${item.cycle}-${index}`} className="history-cycle-card">
              <div className="history-cycle-card__head">
                <div>
                  <h4>{item.cycle}</h4>
                  <p>{item.period}</p>
                </div>
                <span
                  className={`history-cycle-card__delta ${
                    item.overall - baselineCycle.overall < 0 ? "negative" : ""
                  }`}
                >
                  {index === safeBaselineIndex
                    ? "Baseline"
                    : index === safeComparisonIndex
                      ? `Target ${formatDelta(item.overall - baselineCycle.overall)}`
                      : formatDelta(item.overall - baselineCycle.overall)}
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
                {HISTORY_STAGE_METRICS.map((stage) => (
                  <li key={`${item.cycle}-${stage.key}`}>
                    <span>{stage.label}</span>
                    <strong>{formatScore(getCycleStageScore(item, stage.key))}</strong>
                  </li>
                ))}
                <li>
                  <span>Triggered recommendations</span>
                  <strong>{item.recommendationCount}</strong>
                </li>
              </ul>
            </article>
          ))}
        </div>
      </section>

      {/* Tabela que explicita a migracao das praticas entre niveis de adocao. */}
      <section className="panel">
        <h3>Adoption-level shift across cycles</h3>

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
            {view.historySeries.map((item) => (
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

      {/* Interpretacao final em linguagem mais humana para apresentacao do TCC. */}
      <section className="history-insight-grid">
        <article className="panel">
          <h3>Main improvements</h3>
          <ul className="insight-list">
            <li className="insight-item">
              <small>Stage evolution</small>
              <h4>Continuous Integration changed {formatDelta(comparison.stageDeltas.ci)} points</h4>
              <p>
                CI moved faster than CD across the tracked cycles, reinforcing the thesis finding
                that stronger integration foundations tend to emerge before more advanced delivery capability.
              </p>
            </li>
            <li className="insight-item">
              <small>Adoption profile</small>
              <h4>Institutionalized practices changed by {formatDelta(comparison.institutionalizedGrowth)}</h4>
              <p>Mature practices now represent the largest share of the assessed CI/CD subset.</p>
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

      </section>
    </>
  );
}
