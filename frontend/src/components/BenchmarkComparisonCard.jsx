import { useMemo, useState } from "react";
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
    key: "previous",
    label: "Compare with previous",
    referenceLabel: "Q2 2023"
  },
  {
    key: "base",
    label: "Compare with base",
    referenceLabel: "Q1 2023"
  },
  {
    key: "average",
    label: "Compare with organization average",
    referenceLabel: "Org. average"
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
      previous: {
        label: "Q2 2023",
        values: [66, 62, 56, 64, 52, 43, 49],
        cohortSize: 12
      },
      base: {
        label: "Q1 2023",
        values: [61, 56, 51, 58, 45, 40, 44],
        cohortSize: 12
      },
      average: {
        label: "Org. average",
        values: [64, 60, 55, 61, 48, 42, 46],
        cohortSize: 12
      },
      current: {
        label: "Q3 2023",
        values: [72, 68, 64, 71, 59, 47, 56],
        cohortSize: 12
      }
    }
  },
  sth: {
    title: "StH benchmark",
    subtitle: "Stairway to Heaven stages compared against the selected cohort reference.",
    currentLabel: "Q3 2023",
    axes: ["ARO", "CI", "CD", "EXP"],
    series: {
      previous: {
        label: "Q2 2023",
        values: [47, 73, 60, 38],
        cohortSize: 12
      },
      base: {
        label: "Q1 2023",
        values: [43, 68, 55, 33],
        cohortSize: 12
      },
      average: {
        label: "Org. average",
        values: [45, 70, 58, 35],
        cohortSize: 12
      },
      current: {
        label: "Q3 2023",
        values: [53, 79, 68, 44],
        cohortSize: 12
      }
    }
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
      previous: {
        label: "Q2 2023",
        values: [15, 16, 24, 28, 17],
        cohortSize: 12
      },
      base: {
        label: "Q1 2023",
        values: [18, 19, 25, 24, 14],
        cohortSize: 12
      },
      average: {
        label: "Org. average",
        values: [16, 17, 23, 27, 17],
        cohortSize: 12
      },
      current: {
        label: "Q3 2023",
        values: [12, 14, 21, 31, 22],
        cohortSize: 12
      }
    }
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

function buildRadarGeometry(values, size, radius, maxValue = 100) {
  const center = size / 2;
  const steps = values.length;

  const axes = values.map((_, index) => {
    const angle = (Math.PI * 2 * index) / steps - Math.PI / 2;
    const x = center + Math.cos(angle) * radius;
    const y = center + Math.sin(angle) * radius;

    return {
      key: `${index}-axis`,
      x,
      y,
      labelX: center + Math.cos(angle) * (radius + 34),
      labelY: center + Math.sin(angle) * (radius + 34)
    };
  });

  const polygon = values
    .map((value, index) => {
      const angle = (Math.PI * 2 * index) / steps - Math.PI / 2;
      const normalized = clamp(value, 0, maxValue) / maxValue;
      const pointRadius = normalized * radius;
      const x = center + Math.cos(angle) * pointRadius;
      const y = center + Math.sin(angle) * pointRadius;
      return `${x},${y}`;
    })
    .join(" ");

  const vertices = values.map((value, index) => {
    const angle = (Math.PI * 2 * index) / steps - Math.PI / 2;
    const normalized = clamp(value, 0, maxValue) / maxValue;
    const pointRadius = normalized * radius;
    return {
      key: `${index}-vertex`,
      x: center + Math.cos(angle) * pointRadius,
      y: center + Math.sin(angle) * pointRadius,
      score: value
    };
  });

  return {
    axes,
    vertices,
    polygon,
    center,
    radius
  };
}

function getWeightedAdoptionScore(values) {
  const total = values.reduce((accumulator, value, index) => accumulator + value * ADOPTION_WEIGHTS[index], 0);
  return Math.round(total / 100);
}

function getAverageScore(values) {
  if (!values.length) return 0;
  return Math.round(values.reduce((accumulator, value) => accumulator + value, 0) / values.length);
}

function RadarPlot({ title, axes, currentValues, referenceValues }) {
  const size = 460;
  const radius = 150;
  const rings = [0.25, 0.5, 0.75, 1];
  const currentGeometry = buildRadarGeometry(currentValues, size, radius);
  const referenceGeometry = buildRadarGeometry(referenceValues, size, radius);

  return (
    <div className="benchmark-comparison-card__plot-card">
      <div className="benchmark-comparison-card__plot-header">
        <div>
          <span>Comparison radar</span>
          <h4>{title}</h4>
        </div>
        <small>{axes.length} points</small>
      </div>

      <div className="benchmark-comparison-card__svg-wrap">
        <svg
          viewBox={`0 0 ${size} ${size}`}
          className="benchmark-comparison-card__radar"
          aria-label={`${title} comparison radar`}
        >
          {rings.map((ring) => (
            <circle
              key={ring}
              cx={currentGeometry.center}
              cy={currentGeometry.center}
              r={radius * ring}
              className="benchmark-comparison-card__ring"
            />
          ))}

          {currentGeometry.axes.map((axis) => (
            <line
              key={axis.key}
              x1={currentGeometry.center}
              y1={currentGeometry.center}
              x2={axis.x}
              y2={axis.y}
              className="benchmark-comparison-card__axis"
            />
          ))}

          <polygon
            points={referenceGeometry.polygon}
            className="benchmark-comparison-card__shape benchmark-comparison-card__shape--reference"
          />
          <polygon
            points={currentGeometry.polygon}
            className="benchmark-comparison-card__shape benchmark-comparison-card__shape--current"
          />

          {referenceGeometry.vertices.map((vertex, index) => (
            <circle
              key={`${vertex.key}-reference`}
              cx={vertex.x}
              cy={vertex.y}
              r="3.8"
              className="benchmark-comparison-card__point benchmark-comparison-card__point--reference"
            >
              <title>{`${axes[index]}: ${vertex.score}%`}</title>
            </circle>
          ))}

          {currentGeometry.vertices.map((vertex, index) => (
            <circle
              key={`${vertex.key}-current`}
              cx={vertex.x}
              cy={vertex.y}
              r="4.4"
              className="benchmark-comparison-card__point benchmark-comparison-card__point--current"
            >
              <title>{`${axes[index]}: ${vertex.score}%`}</title>
            </circle>
          ))}

          {currentGeometry.axes.map((axis, index) => (
            <text
              key={`${axis.key}-label`}
              x={axis.labelX}
              y={axis.labelY}
              className="benchmark-comparison-card__label"
              textAnchor={axis.labelX < currentGeometry.center - 12 ? "end" : axis.labelX > currentGeometry.center + 12 ? "start" : "middle"}
            >
              {splitLabel(axes[index]).map((line, lineIndex) => (
                <tspan key={`${axis.key}-line-${lineIndex}`} x={axis.labelX} dy={lineIndex === 0 ? 0 : 13}>
                  {line}
                </tspan>
              ))}
            </text>
          ))}
        </svg>
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
  const [referenceKey, setReferenceKey] = useState("previous");

  const lensData = MOCK_BENCHMARK_DATA[lensKey];
  const referenceData = lensData.series[referenceKey] || lensData.series.previous;
  const currentData = lensData.series.current;

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
      <header className="benchmark-comparison-card__header">

        <div className="benchmark-comparison-card__header-meta">
          <span className="benchmark-comparison-card__badge">Mock data</span>
        </div>
      </header>

      <div className="benchmark-comparison-card__toolbar">
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
        <div>
          <p className="benchmark-comparison-card__eyebrow">Benchmark preview</p>
          <h3>{lensData.title}</h3>
          <p style={{position: 'relative', textAlign: 'center'}}>{lensData.subtitle}</p>
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
                onClick={() => setReferenceKey(option.key)}
                aria-pressed={referenceKey === option.key}
              >
                {option.label}
              </button>
            ))}
          </div>
        </div>

      </div>

      <div className="benchmark-comparison-card__body">
        <div className="benchmark-comparison-card__canvas">
          <RadarPlot
            title={`${currentData.label} vs ${referenceData.label}`}
            axes={lensData.axes}
            currentValues={currentData.values}
            referenceValues={referenceData.values}
            lensKey={lensKey}
          />
        </div>

        <aside className="benchmark-comparison-card__summary">
          <article className="benchmark-comparison-card__score-card">
            <span>Score general</span>
            <strong>{summary.currentScore}/100</strong>
            <small>
              {summary.delta >= 0 ? `+${summary.delta}` : summary.delta} vs {referenceData.label}
            </small>
          </article>

          <article className="benchmark-comparison-card__score-card benchmark-comparison-card__score-card--soft">
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
