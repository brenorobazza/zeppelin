import { BenchmarkComparisonCard } from "../components/BenchmarkComparisonCard";
import { BenchmarkStatePanel } from "../components/BenchmarkStatePanel";
import { Lock } from "lucide-react";
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
  return {
    stageDeltas: HISTORY_STAGE_METRICS.reduce((acc, stage) => {
      const baselineScore = getCycleStageScore(baselineCycle, stage.key);
      const currentScore = getCycleStageScore(currentCycle, stage.key);

      acc[stage.key] =
        baselineScore != null && currentScore != null ? currentScore - baselineScore : null;
      return acc;
    }, {}),
    institutionalizedGrowth:
      baselineCycle && currentCycle
        ? currentCycle.adoptionLevels.institutionalized - baselineCycle.adoptionLevels.institutionalized
        : null
  };
}

export function HistoryPage({ data, loading, filters }) {
  // O historico compara ciclos para mostrar progressao real de maturidade ao longo do tempo.
  const view = data || fallbackHistoryData;
  const historySeries = view.historySeries || [];
  const completeHistorySeries = historySeries.filter((item) => item.complete);
  const hasHistory = Array.isArray(view.historySeries) && view.historySeries.length > 0;
  const hasCompleteHistory = completeHistorySeries.length > 0;
  const hasEnoughCompleteCycles = completeHistorySeries.length >= 2;
  const displayHistorySeries = completeHistorySeries;

  // Use `historySeries` as the single source of truth for baseline and comparison.
  const baselineCycle = displayHistorySeries[0] || historySeries[0] || null;
  const currentCycle =
    displayHistorySeries[displayHistorySeries.length - 1] ||
    historySeries[historySeries.length - 1] ||
    null;
  const safeBaselineIndex = 0;
  const safeComparisonIndex = Math.max(displayHistorySeries.length - 1, 0);
  const comparison = buildComparison(baselineCycle, currentCycle);
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

  if (!hasHistory) {
    return (
      <section className="panel">
        <p className="eyebrow">History</p>
        <h3>No historical data available</h3>
        <p>
          The selected organization does not have a fully submitted assessment snapshot yet, so
          historical trends and benchmark comparisons cannot be shown.
        </p>
      </section>
    );
  }

  if (!hasCompleteHistory) {
    return (
      <section className="panel">
        <p className="eyebrow">History</p>
        <h3>No complete historical cycles available</h3>
        <p>
          The selected organization still has only incomplete assessment cycles, so historical
          cards and comparisons stay hidden until at least one cycle is fully submitted.
        </p>
      </section>
    );
  }

  return (
    <>
      {hasEnoughCompleteCycles ? (
        <BenchmarkComparisonCard filters={filters} />
      ) : (
        <BenchmarkStatePanel
          tone="warning"
          badge="Insufficient Data"
          icon={<Lock size={24} strokeWidth={2.2} />}
          title="At least two complete cycles are required for comparison"
          message="The comparative radar chart will be enabled once at least two complete cycles are available."
          details="Minimum required: 2 complete cycles"
        />
      )}

      {/* Cards comparativos por ciclo. */}
      <section className="panel">
        <div className="section-head">
          <div>
            <h3>What changed between cycles?</h3>
          </div>
        </div>

        <div className="history-cycles history-cycles--three">
          {displayHistorySeries.map((item, index) => (
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
            {displayHistorySeries.map((item) => (
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
