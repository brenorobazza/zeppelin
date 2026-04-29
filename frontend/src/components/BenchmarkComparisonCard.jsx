import { useEffect, useMemo, useState } from "react";
import {
  PolarAngleAxis,
  PolarGrid,
  PolarRadiusAxis,
  Radar,
  RadarChart,
  ResponsiveContainer
} from "recharts";
import { loadComparisonAnalytics } from "../services/analytics";
import "./benchmark-comparison-card.css";

const LENS_OPTIONS = [
  {
    key: "eye",
    label: "Eye of CSE",
    description: "7 dimensions"
  },
  {
    key: "sth",
    label: "StH",
    description: "4 stages"
  }
];

function clamp(value, min, max) {
  return Math.min(max, Math.max(min, value));
}

function splitLabel(label, maxChars = 16) {
  if (!label) return [""];

  const words = label.split(" ");
  const lines = [];
  let currentLine = "";

  words.forEach((word) => {
    const nextLine = currentLine ? `${currentLine} ${word}` : word;
    if (nextLine.length <= maxChars) {
      currentLine = nextLine;
      return;
    }

    if (currentLine) {
      lines.push(currentLine);
    }
    currentLine = word;
  });

  if (currentLine) {
    lines.push(currentLine);
  }

  return lines;
}

function renderRadarAxisTick({ x, y, payload, textAnchor }) {
  const lines = splitLabel(payload.value);

  return (
    <text
      x={x}
      y={y}
      textAnchor={textAnchor}
      className="benchmark-comparison-card__label"
      style={{ fill: "#0f172a" }}
    >
      {lines.map((line, index) => (
        <tspan
          key={`${payload.value}-line-${index}`}
          x={x}
          dy={index === 0 ? 0 : 13}
          style={{ fill: "#0f172a" }}
        >
          {line}
        </tspan>
      ))}
    </text>
  );
}

function RadarPlot({ title, axes, currentValues, referenceValues, currentLabel, referenceLabel }) {
  const chartData = useMemo(
    () =>
      axes.map((axis, index) => ({
        axis,
        current: currentValues[index] ?? 0,
        reference: referenceValues[index] ?? 0
      })),
    [axes, currentValues, referenceValues]
  );

  return (
    <div className="benchmark-comparison-card__plot-card">
      <div className="benchmark-comparison-card__plot-header">
        <div>
          <span>Comparison radar</span>
          <h4>{title}</h4>
        </div>
        <small>{axes.length} dimensions</small>
      </div>

      <div className="benchmark-comparison-card__svg-wrap">
        <ResponsiveContainer width="100%" height={380}>
          <RadarChart
            data={chartData}
            aria-label={`${title} comparison radar`}
            margin={{ top: 20, right: 28, bottom: 20, left: 28 }}
          >
            <PolarGrid stroke="rgba(0, 0, 0, 0.2)" />
            <PolarAngleAxis dataKey="axis" tick={renderRadarAxisTick} />
            <PolarRadiusAxis domain={[0, 100]} tick={false} axisLine={false} tickLine={false} />

            <Radar
              name={referenceLabel}
              dataKey="reference"
              stroke="rgba(37, 99, 235, 0.72)"
              strokeDasharray="6 4"
              fill="rgba(37, 99, 235, 0.08)"
              fillOpacity={1}
              dot={{ r: 2.8, fill: "rgba(37, 99, 235, 0.9)" }}
            />
            <Radar
              name={currentLabel}
              dataKey="current"
              stroke="rgba(34, 197, 94, 0.94)"
              fill="rgba(34, 197, 94, 0.1)"
              fillOpacity={0.45}
              dot={{ r: 3.2, fill: "rgba(34, 197, 94, 1)" }}
            />
          </RadarChart>
        </ResponsiveContainer>
      </div>

      <div className="benchmark-comparison-card__legend">
        <span className="benchmark-comparison-card__legend-item">
          <i className="benchmark-comparison-card__legend-dot benchmark-comparison-card__legend-dot--current" />
          Current
        </span>
        <span className="benchmark-comparison-card__legend-item">
          <i className="benchmark-comparison-card__legend-dot benchmark-comparison-card__legend-dot--reference" />
          Reference
        </span>
      </div>
    </div>
  );
}

function LevelBars({ axes, currentValues, referenceValues, lensKey }) {
  const maxScore = 100;

  return (
    <div className="benchmark-comparison-card__levels">
      <div className="benchmark-comparison-card__levels-head">
        <span>Axis breakdown</span>
        <small>Current vs reference</small>
      </div>

      <div className="benchmark-comparison-card__levels-list">
        {axes.map((axis, index) => {
          const current = axis.current ?? currentValues[index] ?? 0;
          const reference = axis.reference ?? referenceValues[index] ?? 0;
          const currentWidth = `${clamp((current / maxScore) * 100, 0, 100)}%`;
          const referenceWidth = `${clamp((reference / maxScore) * 100, 0, 100)}%`;
          const gap = current - reference;

          return (
            <article key={axis.key} className="benchmark-comparison-card__level-row">
              <div className="benchmark-comparison-card__level-copy">
                <strong>{axis.label}</strong>
                <span className={gap < 0 ? "is-negative" : "is-positive"}>
                  {gap >= 0 ? `+${gap}` : gap}% vs ref
                </span>
              </div>

              <div className="benchmark-comparison-card__level-track">
                <span
                  className="benchmark-comparison-card__level-bar benchmark-comparison-card__level-bar--reference"
                  style={{ width: referenceWidth }}
                />
                <span
                  className="benchmark-comparison-card__level-bar benchmark-comparison-card__level-bar--current"
                  style={{ width: currentWidth }}
                />
              </div>
            </article>
          );
        })}
      </div>
    </div>
  );
}

function createEmptyComparisonData() {
  return {
    selection: {
      currentCycle: { id: "", label: "", answeredPractices: 0 },
      referenceCycle: { id: "", label: "", answeredPractices: 0 },
      availableCycles: []
    },
    summary: {
      currentScore: 0,
      referenceScore: 0,
      delta: 0,
      currentAnsweredPractices: 0,
      referenceAnsweredPractices: 0
    },
    lenses: {
      eye: {
        key: "eye",
        title: "Benchmark comparison",
        subtitle: "Select two cycles to compare them.",
        currentScore: 0,
        referenceScore: 0,
        delta: 0,
        axes: []
      },
      sth: {
        key: "sth",
        title: "Benchmark comparison",
        subtitle: "Select two cycles to compare them.",
        currentScore: 0,
        referenceScore: 0,
        delta: 0,
        axes: []
      }
    }
  };
}

function normalizeAxisValues(axes = []) {
  return axes.map((axis, index) => ({
    ...axis,
    index
  }));
}

function getCycleLabel(comparisonData, cycleId) {
  return (
    comparisonData?.selection?.availableCycles?.find((cycle) => String(cycle.id) === String(cycleId))
      ?.label || ""
  );
}

function getDifferentCycleId(cycles = [], excludedId = "") {
  const candidate = cycles.find((cycle) => String(cycle.id) !== String(excludedId));
  return candidate ? String(candidate.id) : "";
}

export function BenchmarkComparisonCard({ className = "", filters = {} }) {
  const [lensKey, setLensKey] = useState("eye");
  const [currentQuestionnaireId, setCurrentQuestionnaireId] = useState(filters.questionnaireId || "");
  const [referenceQuestionnaireId, setReferenceQuestionnaireId] = useState("");
  const [comparisonData, setComparisonData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    setCurrentQuestionnaireId(filters.questionnaireId || "");
    setReferenceQuestionnaireId("");
  }, [filters.organizationId, filters.questionnaireId, filters.stageScope]);

  useEffect(() => {
    let ignore = false;

    async function syncComparison() {
      if (!filters.organizationId) {
        setComparisonData(createEmptyComparisonData());
        setLoading(false);
        return;
      }

      setLoading(true);
      setError("");

      try {
        const useSpecificCycles = Boolean(currentQuestionnaireId && referenceQuestionnaireId);
        const requestFilters = {
          organizationId: filters.organizationId,
          questionnaireId: currentQuestionnaireId || filters.questionnaireId || "",
          stageScope: filters.stageScope,
          referenceMode: useSpecificCycles ? "specific-cycles" : "first-submission",
          referenceQuestionnaireId: useSpecificCycles ? referenceQuestionnaireId : ""
        };

        const bundle = await loadComparisonAnalytics(requestFilters);
        if (ignore) return;

        setComparisonData(bundle);

        const availableCycles = bundle.selection?.availableCycles || [];
        const resolvedCurrentId = currentQuestionnaireId || String(bundle.selection?.currentCycle?.id || "");
        const resolvedReferenceId = referenceQuestionnaireId || String(bundle.selection?.referenceCycle?.id || "");

        if (!currentQuestionnaireId && resolvedCurrentId) {
          setCurrentQuestionnaireId(resolvedCurrentId);
        }

        if (!resolvedReferenceId || resolvedReferenceId === resolvedCurrentId) {
          const nextReferenceId = getDifferentCycleId(availableCycles, resolvedCurrentId);
          if (nextReferenceId) {
            setReferenceQuestionnaireId(nextReferenceId);
          }
        } else if (!referenceQuestionnaireId) {
          setReferenceQuestionnaireId(resolvedReferenceId);
        }
      } catch (fetchError) {
        if (ignore) return;
        setComparisonData(createEmptyComparisonData());
        setError(fetchError.message || "Failed to load comparison analytics.");
      } finally {
        if (!ignore) {
          setLoading(false);
        }
      }
    }

    syncComparison();

    return () => {
      ignore = true;
    };
  }, [
    filters.organizationId,
    filters.questionnaireId,
    filters.stageScope,
    currentQuestionnaireId,
    referenceQuestionnaireId
  ]);

  const selectedCurrentCycleId = currentQuestionnaireId || String(comparisonData?.selection?.currentCycle?.id || "");
  const selectedReferenceCycleId = referenceQuestionnaireId || String(comparisonData?.selection?.referenceCycle?.id || "");
  const availableCycles = comparisonData?.selection?.availableCycles || [];
  const currentCycleLabel = getCycleLabel(comparisonData, selectedCurrentCycleId) || comparisonData?.selection?.currentCycle?.label || "Current cycle";
  const referenceCycleLabel = getCycleLabel(comparisonData, selectedReferenceCycleId) || comparisonData?.selection?.referenceCycle?.label || "Reference cycle";
  const referenceCycleOptions = availableCycles.filter(
    (cycle) => String(cycle.id) !== String(selectedCurrentCycleId)
  );

  const activeLens = comparisonData?.lenses?.[lensKey] || comparisonData?.lenses?.eye;
  const selectedAxes = normalizeAxisValues(activeLens?.axes || []);
  const radarTitle = `${currentCycleLabel} vs ${referenceCycleLabel}`;

  function handleCurrentCycleChange(nextCurrentQuestionnaireId) {
    setCurrentQuestionnaireId(nextCurrentQuestionnaireId);

    if (String(nextCurrentQuestionnaireId) === String(referenceQuestionnaireId)) {
      const nextReferenceId = getDifferentCycleId(availableCycles, nextCurrentQuestionnaireId);
      setReferenceQuestionnaireId(nextReferenceId);
    }
  }

  function handleReferenceCycleChange(nextReferenceQuestionnaireId) {
    setReferenceQuestionnaireId(nextReferenceQuestionnaireId);
  }

  if (loading && !comparisonData) {
    return <section className="panel">Loading comparison analytics from backend...</section>;
  }

  if (!comparisonData) {
    return <section className="panel">Loading comparison analytics from backend...</section>;
  }

  return (
    <section className={["benchmark-comparison-card", className].filter(Boolean).join(" ")}>
      <div className="benchmark-comparison-card__toolbar">
        <div className="benchmark-comparison-card__toolbar-center">
          <h3>{activeLens?.title || "Benchmark comparison"}</h3>
          <p>{activeLens?.subtitle || "Comparison data loaded from backend analytics."}</p>
          {error ? <small className="benchmark-comparison-card__error">{error}</small> : null}
        </div>

        <div className="benchmark-comparison-card__group">
          <span>Lens</span>
          <div className="benchmark-comparison-card__segmented">
            {LENS_OPTIONS.map((option) => (
              <button
                key={option.key}
                type="button"
                className={[
                  "benchmark-comparison-card__segment",
                  lensKey === option.key && "is-active"
                ]
                  .filter(Boolean)
                  .join(" ")}
                onClick={() => setLensKey(option.key)}
                aria-pressed={lensKey === option.key}
                title={option.description}
              >
                <strong>{option.label}</strong>
                <small>{option.description}</small>
              </button>
            ))}
          </div>
        </div>

        <div className="benchmark-comparison-card__group">
          <span>Cycles</span>
          <div className="benchmark-comparison-card__cycles-picker">
            <div className="benchmark-comparison-card__cycle-group">
              <label htmlFor={`current-cycle-${lensKey}`}>Current cycle</label>
              <select
                id={`current-cycle-${lensKey}`}
                value={selectedCurrentCycleId}
                onChange={(event) => handleCurrentCycleChange(event.target.value)}
                className="benchmark-comparison-card__cycle-select"
              >
                {availableCycles.map((cycle) => (
                  <option key={cycle.id} value={cycle.id}>
                    {cycle.label}
                  </option>
                ))}
              </select>
            </div>

            <div className="benchmark-comparison-card__cycle-group">
              <label htmlFor={`reference-cycle-${lensKey}`}>Reference cycle</label>
              <select
                id={`reference-cycle-${lensKey}`}
                value={selectedReferenceCycleId}
                onChange={(event) => handleReferenceCycleChange(event.target.value)}
                className="benchmark-comparison-card__cycle-select"
              >
                {referenceCycleOptions.map((cycle) => (
                  <option key={cycle.id} value={cycle.id}>
                    {cycle.label}
                  </option>
                ))}
              </select>
            </div>
          </div>
        </div>
      </div>

      <div className="benchmark-comparison-card__body">
        <div className="benchmark-comparison-card__canvas">
          <RadarPlot
            key={`${lensKey}-${selectedCurrentCycleId}-${selectedReferenceCycleId}`}
            title={radarTitle}
            axes={selectedAxes.map((axis) => axis.label)}
            currentValues={selectedAxes.map((axis) => axis.current ?? 0)}
            referenceValues={selectedAxes.map((axis) => axis.reference ?? 0)}
            currentLabel={currentCycleLabel}
            referenceLabel={referenceCycleLabel}
          />
        </div>

        <aside className="benchmark-comparison-card__summary">
          <article className="benchmark-comparison-card__score-card">
            <span>Score general</span>
            <strong>{comparisonData.summary.currentScore}/100</strong>
            <small>
              {comparisonData.summary.delta >= 0 ? `+${comparisonData.summary.delta}` : comparisonData.summary.delta} vs {referenceCycleLabel}
            </small>
          </article>

          <article className="benchmark-comparison-card__reference-score-card benchmark-comparison-card__score-card--soft">
            <span>Reference score</span>
            <strong>{comparisonData.summary.referenceScore}/100</strong>
            <small>{referenceCycleLabel}</small>
          </article>

          <LevelBars
            axes={selectedAxes}
            currentValues={selectedAxes.map((axis) => axis.current ?? 0)}
            referenceValues={selectedAxes.map((axis) => axis.reference ?? 0)}
            lensKey={lensKey}
          />
        </aside>
      </div>

      <footer className="benchmark-comparison-card__footer">
        <span>{currentCycleLabel} selected as current snapshot</span>
        <span>{referenceCycleLabel} used as benchmark reference</span>
      </footer>
    </section>
  );
}
