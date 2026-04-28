import { useMemo, useState } from "react";
import {
  PolarAngleAxis,
  PolarGrid,
  PolarRadiusAxis,
  Radar,
  RadarChart,
  ResponsiveContainer
} from "recharts";
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
  },
  {
    key: "adoption",
    label: "Adoption levels",
    description: "5 maturity levels"
  }
];

const REFERENCE_OPTIONS = [
  {
    key: "first-submission",
    label: "Compare with first submission",
    referenceLabel: "First submission"
  },
  {
    key: "specific-cycles",
    label: "Compare specific cycles",
    referenceLabel: "Specific cycles",
    isSpecialMode: true
  }
];

const MOCK_BENCHMARK_DATA = {
  eye: {
    title: "Eye of CSE benchmark",
    subtitle: "Seven-dimensional view of maturity balance across the organization.",
    currentLabel: "Q3 2023",
    axes: [
      "Development",
      "Quality",
      "Software Mgt",
      "Technical Solution",
      "Knowledge",
      "Business",
      "User/Customer"
    ],
    series: {
      "first-submission": {
        label: "First submission",
        values: [61, 56, 51, 58, 45, 40, 44],
        cohortSize: 12
      },
      current: {
        label: "Q3 2023",
        values: [72, 68, 64, 71, 59, 47, 56],
        cohortSize: 12
      }
    },
    cycles: [
      { key: "q1-2023", label: "Q1 2023" },
      { key: "q2-2023", label: "Q2 2023" },
      { key: "q3-2023", label: "Q3 2023" }
    ]
  },
  sth: {
    title: "StH benchmark",
    subtitle: "Stairway to Heaven stages compared against the selected cohort reference.",
    currentLabel: "Q3 2023",
    axes: ["ARO", "CI", "CD", "EXP"],
    series: {
      "first-submission": {
        label: "First submission",
        values: [43, 68, 55, 33],
        cohortSize: 12
      },
      current: {
        label: "Q3 2023",
        values: [53, 79, 68, 44],
        cohortSize: 12
      }
    },
    cycles: [
      { key: "q1-2023", label: "Q1 2023" },
      { key: "q2-2023", label: "Q2 2023" },
      { key: "q3-2023", label: "Q3 2023" }
    ]
  },
  adoption: {
    title: "Adoption level mix",
    subtitle: "Distribution across the maturity levels used in the questionnaire.",
    currentLabel: "Q3 2023",
    axes: [
      "Not adopted",
      "Abandoned",
      "Project/Product",
      "Process",
      "Institutionalized"
    ],
    series: {
      "first-submission": {
        label: "First submission",
        values: [18, 19, 25, 24, 14],
        cohortSize: 12
      },
      current: {
        label: "Q3 2023",
        values: [12, 14, 21, 31, 22],
        cohortSize: 12
      }
    },
    cycles: [
      { key: "q1-2023", label: "Q1 2023" },
      { key: "q2-2023", label: "Q2 2023" },
      { key: "q3-2023", label: "Q3 2023" }
    ]
  }
};

const ADOPTION_WEIGHTS = [0, 10, 30, 60, 100];

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

function getWeightedAdoptionScore(values) {
  const total = values.reduce((accumulator, value, index) => accumulator + value * ADOPTION_WEIGHTS[index], 0);
  return Math.round(total / 100);
}

function getAverageScore(values) {
  if (!values.length) return 0;
  return Math.round(values.reduce((accumulator, value) => accumulator + value, 0) / values.length);
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
          <RadarChart data={chartData} aria-label={`${title} comparison radar`} margin={{ top: 20, right: 28, bottom: 20, left: 28 }}>
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
        <span>{lensKey === "adoption" ? "Adoption mix" : "Axis breakdown"}</span>
        <small>{lensKey === "adoption" ? "Distribution percentages" : "Current vs reference"}</small>
      </div>

      <div className="benchmark-comparison-card__levels-list">
        {axes.map((axis, index) => {
          const current = currentValues[index] ?? 0;
          const reference = referenceValues[index] ?? 0;
          const currentWidth = `${clamp((current / maxScore) * 100, 0, 100)}%`;
          const referenceWidth = `${clamp((reference / maxScore) * 100, 0, 100)}%`;
          const gap = current - reference;

          return (
            <article key={axis} className="benchmark-comparison-card__level-row">
              <div className="benchmark-comparison-card__level-copy">
                <strong>{axis}</strong>
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

export function BenchmarkComparisonCard({ className = "" }) {
  const [lensKey, setLensKey] = useState("eye");
  const [referenceKey, setReferenceKey] = useState("first-submission");
  const [selectedCycles, setSelectedCycles] = useState({
    cycle1: "q1-2023",
    cycle2: "q2-2023"
  });

  const handleReferenceChange = (nextReferenceKey) => {
    setReferenceKey(nextReferenceKey);
  };

  const lensData = MOCK_BENCHMARK_DATA[lensKey];
  let referenceData;

  if (referenceKey === "specific-cycles") {
    // For specific cycles comparison, create a synthetic reference from the first selected cycle
    const cycle1Data = lensData.series.current; // Placeholder - in real app, fetch actual cycle data
    referenceData = {
      label: `${selectedCycles.cycle1} vs ${selectedCycles.cycle2}`,
      values: cycle1Data.values,
      cohortSize: cycle1Data.cohortSize
    };
  } else {
    referenceData = lensData.series[referenceKey] || lensData.series["first-submission"];
  }

  const currentData = lensData.series.current;

  // Determine radar title based on comparison mode
  const radarTitle = referenceKey === "specific-cycles"
    ? `${selectedCycles.cycle1} vs ${selectedCycles.cycle2}`
    : `${currentData.label} vs ${referenceData.label}`;

  const summary = useMemo(() => {
    const currentScore =
      lensKey === "adoption"
        ? getWeightedAdoptionScore(currentData.values)
        : getAverageScore(currentData.values);
    const referenceScore =
      lensKey === "adoption"
        ? getWeightedAdoptionScore(referenceData.values)
        : getAverageScore(referenceData.values);

    return {
      currentScore,
      referenceScore,
      delta: currentScore - referenceScore,
      cohortSize: referenceData.cohortSize || 12
    };
  }, [currentData.values, lensKey, referenceData.cohortSize, referenceData.values]);

  return (
    <section className={["benchmark-comparison-card", className].filter(Boolean).join(" ")}>
      <div className="benchmark-comparison-card__toolbar">
        <div className="benchmark-comparison-card__toolbar-center">
          <h3>{lensData.title}</h3>
          <p>{lensData.subtitle}</p>
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
          <span>Compare with</span>
          <div className="benchmark-comparison-card__chips">
            {REFERENCE_OPTIONS.map((option) => (
              <button
                key={option.key}
                type="button"
                className={[
                  "benchmark-comparison-card__chip",
                  referenceKey === option.key && "is-active"
                ]
                  .filter(Boolean)
                  .join(" ")}
                onClick={() => handleReferenceChange(option.key)}
                aria-pressed={referenceKey === option.key}
              >
                {option.label}
              </button>
            ))}
          </div>

          {referenceKey === "specific-cycles" && (
            <div className="benchmark-comparison-card__cycles-picker">
              <div className="benchmark-comparison-card__cycle-group">
                <label htmlFor={`cycle1-${lensKey}`}>First cycle</label>
                <select
                  id={`cycle1-${lensKey}`}
                  value={selectedCycles.cycle1}
                  onChange={(e) =>
                    setSelectedCycles((prev) => ({
                      ...prev,
                      cycle1: e.target.value
                    }))
                  }
                  className="benchmark-comparison-card__cycle-select"
                >
                  {lensData.cycles.map((cycle) => (
                    <option key={cycle.key} value={cycle.key}>
                      {cycle.label}
                    </option>
                  ))}
                </select>
              </div>

              <div className="benchmark-comparison-card__cycle-group">
                <label htmlFor={`cycle2-${lensKey}`}>Second cycle</label>
                <select
                  id={`cycle2-${lensKey}`}
                  value={selectedCycles.cycle2}
                  onChange={(e) =>
                    setSelectedCycles((prev) => ({
                      ...prev,
                      cycle2: e.target.value
                    }))
                  }
                  className="benchmark-comparison-card__cycle-select"
                >
                  {lensData.cycles.map((cycle) => (
                    <option key={cycle.key} value={cycle.key}>
                      {cycle.label}
                    </option>
                  ))}
                </select>
              </div>
            </div>
          )}
        </div>

      </div>

      <div className="benchmark-comparison-card__body">
        <div className="benchmark-comparison-card__canvas">
          <RadarPlot
            key={
              referenceKey === "specific-cycles"
                ? `${lensKey}-${referenceKey}-${selectedCycles.cycle1}-${selectedCycles.cycle2}`
                : `${lensKey}-${referenceKey}`
            }
            title={radarTitle}
            axes={lensData.axes}
            currentValues={currentData.values}
            referenceValues={referenceData.values}
            currentLabel={currentData.label}
            referenceLabel={referenceData.label}
          />
        </div>

        <aside className="benchmark-comparison-card__summary">
          <article className="benchmark-comparison-card__score-card">
            <span >Score general</span>
            <strong>{summary.currentScore}/100</strong>
            <small>
              {summary.delta >= 0 ? `+${summary.delta}` : summary.delta} vs {referenceData.label}
            </small>
          </article>

          <article className="benchmark-comparison-card__reference-score-card benchmark-comparison-card__score-card--soft">
            <span>Reference score</span>
            <strong>{summary.referenceScore}/100</strong>
            <small>{referenceData.label}</small>
          </article>

          <LevelBars
            axes={lensData.axes}
            currentValues={currentData.values}
            referenceValues={referenceData.values}
            lensKey={lensKey}
          />
        </aside>
      </div>

      <footer className="benchmark-comparison-card__footer">
        <span>{lensData.currentLabel} selected as current snapshot</span>
        <span>{referenceData.label} used as benchmark reference</span>
      </footer>
    </section>
  );
}
