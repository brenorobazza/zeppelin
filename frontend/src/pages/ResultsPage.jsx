import { useEffect, useState } from "react";
import { fallbackDashboardData, fallbackResultsData } from "../mock/analyticsFallback";
import {
  getConstrainingStage,
  getLeadingStage,
  mapStagesToJourney
} from "./stairwayStages";

function formatDimensionValue(value) {
  return value == null ? "-" : `${value}%`;
}

const PERCENTAGE_SCALE = [0, 20, 40, 60, 80, 100];

function getScaleLabelStyle(value) {
  if (value === 0) {
    return { left: "0%", transform: "translateX(0)" };
  }

  if (value === 100) {
    return { left: "100%", transform: "translateX(-100%)" };
  }

  return { left: `${value}%`, transform: "translateX(-50%)" };
}

function PercentageScale({
  score = null,
  title = "Percentage scale",
  className = "",
  showHeader = true,
  showMarker = false
}) {
  const safeScore =
    typeof score === "number" ? Math.max(0, Math.min(100, score)) : null;

  return (
    <div className={["maturity-scale", "maturity-scale--percentage", className].filter(Boolean).join(" ")}>
      {showHeader ? (
        <div className="maturity-scale__header">
          <span>{title}</span>
          {showMarker && safeScore != null ? <strong>{safeScore}/100</strong> : null}
        </div>
      ) : null}

      <div className="maturity-scale__track" aria-hidden="true">
        <div className="maturity-scale__line" />
        {PERCENTAGE_SCALE.map((tick) => (
          <span
            key={tick}
            className="maturity-scale__tick"
            style={{ left: `${tick}%` }}
          />
        ))}
        {showMarker && safeScore != null ? (
          <span
            className="maturity-scale__marker"
            style={{ left: `${safeScore}%` }}
            title={`Score ${safeScore}`}
          />
        ) : null}
      </div>

      <div className="maturity-scale__labels maturity-scale__labels--percentage">
        {PERCENTAGE_SCALE.map((tick) => (
          <div
            key={tick}
            className="maturity-scale__label is-reached"
            style={getScaleLabelStyle(tick)}
          >
            <strong>{tick}%</strong>
          </div>
        ))}
      </div>
    </div>
  );
}

function buildRadarPoints(dimensions, radius, center) {
  if (!dimensions.length) return "";

  return dimensions
    .map((item, index) => {
      const angle = (Math.PI * 2 * index) / dimensions.length - Math.PI / 2;
      const scaledRadius = ((item.organizationScore || 0) / 100) * radius;
      const x = center + Math.cos(angle) * scaledRadius;
      const y = center + Math.sin(angle) * scaledRadius;
      return `${x},${y}`;
    })
    .join(" ");
}

function buildRadarVertices(dimensions, radius, center) {
  return dimensions.map((item, index) => {
    const angle = (Math.PI * 2 * index) / dimensions.length - Math.PI / 2;
    const scaledRadius = ((item.organizationScore || 0) / 100) * radius;
    return {
      key: item.key,
      label: item.name,
      score: item.organizationScore || 0,
      x: center + Math.cos(angle) * scaledRadius,
      y: center + Math.sin(angle) * scaledRadius
    };
  });
}

function buildRadarAxes(dimensions, radius, center) {
  return dimensions.map((item, index) => {
    const angle = (Math.PI * 2 * index) / dimensions.length - Math.PI / 2;
    const x = center + Math.cos(angle) * radius;
    const y = center + Math.sin(angle) * radius;
    return {
      key: item.key,
      x,
      y,
      labelX: center + Math.cos(angle) * (radius + 40),
      labelY: center + Math.sin(angle) * (radius + 40),
      label: item.name
    };
  });
}

function splitRadarLabel(label, maxChars = 16) {
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

function DimensionRadar({ dimensions }) {
  if (!dimensions.length) {
    return <div className="empty-state">No dimension adoption data is available for this cycle.</div>;
  }

  const size = 560;
  const center = size / 2;
  const radius = 170;
  const axes = buildRadarAxes(dimensions, radius, center);
  const polygonPoints = buildRadarPoints(dimensions, radius, center);
  const vertices = buildRadarVertices(dimensions, radius, center);
  const rings = [0.25, 0.5, 0.75, 1];

  return (
    <div className="dimension-radar-card">
      <svg viewBox={`0 0 ${size} ${size}`} className="dimension-radar" aria-label="Organization dimension radar">
        {rings.map((ring) => (
          <circle
            key={ring}
            cx={center}
            cy={center}
            r={radius * ring}
            className="dimension-radar__ring"
          />
        ))}

        {axes.map((axis) => (
          <line
            key={axis.key}
            x1={center}
            y1={center}
            x2={axis.x}
            y2={axis.y}
            className="dimension-radar__axis"
          />
        ))}

        <polygon points={polygonPoints} className="dimension-radar__shape" />

        {vertices.map((vertex) => (
          <circle
            key={`${vertex.key}-point`}
            cx={vertex.x}
            cy={vertex.y}
            r="4"
            className="dimension-radar__point"
          >
            <title>{`${vertex.label}: ${vertex.score}%`}</title>
          </circle>
        ))}

        {axes.map((axis) => (
          <text
            key={`${axis.key}-label`}
            x={axis.labelX}
            y={axis.labelY}
            className="dimension-radar__label"
            textAnchor={axis.labelX < center - 10 ? "end" : axis.labelX > center + 10 ? "start" : "middle"}
          >
            {splitRadarLabel(axis.label).map((line, index) => (
              <tspan
                key={`${axis.key}-line-${index}`}
                x={axis.labelX}
                dy={index === 0 ? 0 : 14}
              >
                {line}
              </tspan>
            ))}
          </text>
        ))}

        <text x={center} y={center - radius - 6} className="dimension-radar__tick" textAnchor="middle">
          100%
        </text>
        <text x={center} y={center - radius * 0.75 - 6} className="dimension-radar__tick" textAnchor="middle">
          75%
        </text>
        <text x={center} y={center - radius * 0.5 - 6} className="dimension-radar__tick" textAnchor="middle">
          50%
        </text>
        <text x={center} y={center - radius * 0.25 - 6} className="dimension-radar__tick" textAnchor="middle">
          25%
        </text>
        <text x={center} y={center + 14} className="dimension-radar__tick" textAnchor="middle">
          0%
        </text>
      </svg>
    </div>
  );
}

function formatStageSpread(leadingStage, constrainingStage) {
  if (!leadingStage || !constrainingStage) return "Not available";
  return `${leadingStage.score - constrainingStage.score} points`;
}

function buildAnalyticalNarrative(leadingStage, constrainingStage) {
  if (!leadingStage || !constrainingStage) {
    return "This page examines the diagnostic evidence available in the current assessment payload by combining the stage interpretation with the analysis of related practice groups.";
  }

  return `The current diagnosis is more strongly supported in ${leadingStage.name}, while ${constrainingStage.name} concentrates the main restrictions that still limit a more balanced progression across the CSE stages.`;
}

function normalizeLevel(level = "") {
  const value = level.trim().toLowerCase();

  if (value === "not adopted" || value === "nao adotado" || value === "não adotado") {
    return "Not adopted";
  }

  if (value === "abandoned" || value === "abandonado") {
    return "Abandoned";
  }

  if (
    value === "realized at project/product level" ||
    value === "project/product level" ||
    value === "realizado ao nivel de projeto/produto" ||
    value === "realizado ao nível de projeto/produto"
  ) {
    return "Project/Product level";
  }

  if (
    value === "realized at process level" ||
    value === "process level" ||
    value === "realizado ao nivel de processo" ||
    value === "realizado ao nível de processo"
  ) {
    return "Process level";
  }

  if (value === "institutionalized" || value === "institucionalizado") {
    return "Institutionalized";
  }

  return level || "Not informed";
}

function buildInsightTitle(item, variant) {
  if (variant === "strengths") return `${item.questionId} - supporting practice`;
  if (variant === "bottlenecks") return `${item.questionId} - constraining practice`;
  return `${item.questionId} - recommended action`;
}

function buildInsightDescription(item, variant) {
  if (variant === "strengths") {
    return `${item.questionId} currently operates at ${normalizeLevel(item.currentLevel).toLowerCase()} in ${item.stage} and reinforces the current diagnostic position.`;
  }

  if (variant === "bottlenecks") {
    return `${item.questionId} currently operates at ${normalizeLevel(item.currentLevel).toLowerCase()} in ${item.stage} and still constrains progression to the next stage.`;
  }

  return item.expectedImpact || "This recommended action strengthens the current diagnostic response.";
}

function buildPracticeGroupSignal(group, variant) {
  const insight = variant === "strength" ? group.strengthItem : group.bottleneckItem;

  if (!insight?.questionId) {
    if (variant === "strength") {
      return "The strongest supporting signal in this practice group is not explicitly available in the current payload.";
    }

    return "The main constraining signal in this practice group is not explicitly available in the current payload.";
  }

  if (variant === "strength") {
    return `${insight.questionId} currently provides the strongest supporting signal in this practice group.`;
  }

  return `${insight.questionId} currently represents the main constraining signal in this practice group.`;
}

function renderInsightList(items, variant) {
  if (!items.length) {
    return <p className="empty-state">No diagnostic evidence is available for this section.</p>;
  }

  return (
    <ul className="insight-list">
      {items.map((item) => (
        <li key={item.id} className="insight-item">
          <h4>{buildInsightTitle(item, variant)}</h4>
          <p>{buildInsightDescription(item, variant)}</p>
        </li>
      ))}
    </ul>
  );
}

function buildElementOverviewRows(rows) {
  const countsByDimension = rows.reduce((acc, row) => {
    acc[row.dimensionName] = (acc[row.dimensionName] || 0) + 1;
    return acc;
  }, {});

  let currentDimension = null;
  return rows.map((row) => {
    const showDimension = row.dimensionName !== currentDimension;
    if (showDimension) {
      currentDimension = row.dimensionName;
    }

    return {
      ...row,
      showDimension,
      rowSpan: showDimension ? countsByDimension[row.dimensionName] : 0
    };
  });
}

function buildDimensionFilterOptions(rows) {
  return [...new Set(rows.map((row) => row.dimensionName))].map((dimensionName) => ({
    value: dimensionName,
    label: dimensionName
  }));
}

function buildElementFilterOptions(rows) {
  return rows.map((row) => ({
    value: row.key,
    label: row.elementName,
    meta: row.dimensionName
  }));
}

function buildMultiSelectSummary(selectedValues, options, singularLabel, pluralLabel) {
  if (!options.length) {
    return `No ${pluralLabel}`;
  }

  if (selectedValues.length === options.length) {
    return `All ${pluralLabel}`;
  }

  if (selectedValues.length === 1) {
    return `1 ${singularLabel}`;
  }

  if (selectedValues.length === 0) {
    return `No ${pluralLabel}`;
  }

  return `${selectedValues.length} ${pluralLabel}`;
}

function sumVisibleCount(rows, field) {
  const values = rows
    .map((row) => row[field])
    .filter((value) => typeof value === "number");

  if (!values.length) {
    return 0;
  }

  return values.reduce((sum, value) => sum + value, 0);
}

function weightedVisibleScore(rows, scoreField, weightField) {
  const weighted = rows.reduce(
    (acc, row) => {
      const score = row[scoreField];
      const weight = row[weightField] || 0;

      if (typeof score !== "number" || !weight) {
        return acc;
      }

      return {
        total: acc.total + score * weight,
        weight: acc.weight + weight
      };
    },
    { total: 0, weight: 0 }
  );

  return weighted.weight ? Math.round(weighted.total / weighted.weight) : null;
}

function buildFilteredElementSummary(rows) {
  return {
    agileCount: sumVisibleCount(rows, "agileCount"),
    ciCount: sumVisibleCount(rows, "ciCount"),
    cdCount: sumVisibleCount(rows, "cdCount"),
    experimentationCount: sumVisibleCount(rows, "experimentationCount"),
    statementCount: sumVisibleCount(rows, "practiceCount"),
    agileScore: weightedVisibleScore(rows, "agileScore", "agileScoreCount"),
    ciScore: weightedVisibleScore(rows, "ciScore", "ciScoreCount"),
    cdScore: weightedVisibleScore(rows, "cdScore", "cdScoreCount"),
    experimentationScore: weightedVisibleScore(
      rows,
      "experimentationScore",
      "experimentationScoreCount"
    ),
    organizationScore: weightedVisibleScore(
      rows,
      "organizationScore",
      "scoreCount"
    )
  };
}

function formatElementMatrixValue(score) {
  return typeof score === "number" ? `${score}%` : "-";
}

function FilterDropdown({
  label,
  summary,
  options,
  selectedValues,
  onToggle,
  onSelectAll,
  onClearAll
}) {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <details
      className="results-filter-dropdown"
      onToggle={(event) => setIsOpen(event.currentTarget.open)}
    >
      <summary className="results-filter-dropdown__summary">
        <div className="results-filter-dropdown__copy">
          <span>{label}</span>
          <strong>{summary}</strong>
        </div>

        <div className="results-filter-dropdown__indicator">
          <span
            className={[
              "results-filter-dropdown__chevron",
              isOpen ? "results-filter-dropdown__chevron--open" : ""
            ]
              .filter(Boolean)
              .join(" ")}
            aria-hidden="true"
          />
        </div>
      </summary>

      <div className="results-filter-dropdown__menu">
        <div className="results-filter-dropdown__actions">
          <button type="button" className="btn-secondary-ui" onClick={onSelectAll}>
            Select all
          </button>
          <button type="button" className="btn-secondary-ui" onClick={onClearAll}>
            Clear
          </button>
        </div>

        <div className="results-filter-dropdown__options">
          {options.length ? (
            options.map((option) => (
              <label key={option.value} className="results-filter-dropdown__option">
                <input
                  type="checkbox"
                  checked={selectedValues.includes(option.value)}
                  onChange={() => onToggle(option.value)}
                />
                <span>{option.label}</span>
                {option.meta ? <small>{option.meta}</small> : null}
              </label>
            ))
          ) : (
            <p className="results-filter-dropdown__empty">No options available.</p>
          )}
        </div>
      </div>
    </details>
  );
}

const ADOPTION_LEVEL_COLORS = {
  "not-adopted": "#4f79c7",
  abandoned: "#f4a62a",
  "realized-at-project-product-level": "#ffd561",
  "realized-at-process-level": "#96c97e",
  institutionalized: "#4b8b3b",
  "project-product-level": "#ffd561",
  "process-level": "#96c97e"
};

const ADOPTION_STAGE_LABELS = {
  agile: {
    chartLabel: "Agile R&D",
    shortLabel: "Agile R&D",
    longLabel: "Agile R&D Organization"
  },
  ci: {
    chartLabel: "CI",
    shortLabel: "CI",
    longLabel: "Continuous Integration"
  },
  cd: {
    chartLabel: "CD",
    shortLabel: "CD",
    longLabel: "Continuous Deployment"
  },
  experimentation: {
    chartLabel: "Exp. system",
    shortLabel: "Exp. system",
    longLabel: "R&D as an Experiment System"
  },
  organization: {
    chartLabel: "Organization",
    shortLabel: "Organization",
    longLabel: "Combined organizational reading"
  }
};

function getAdoptionStagePresentation(stageKey, fallbackTitle) {
  return (
    ADOPTION_STAGE_LABELS[stageKey] || {
      chartLabel: fallbackTitle,
      shortLabel: fallbackTitle,
      longLabel: fallbackTitle
    }
  );
}

function buildStageAdoptionColumns(overview) {
  const stageDefinitions = overview.stages || [];

  return stageDefinitions.map((stage) => {
    const countKey = `${stage.key}Count`;
    const total = overview.totals?.[countKey] || 0;
    const segments = overview.levels.map((level) => {
      const count = level[countKey] || 0;
      return {
        key: `${countKey}-${level.key}`,
        label: level.label,
        count,
        percentage: total ? (count / total) * 100 : 0,
        color: ADOPTION_LEVEL_COLORS[level.key] || "#d8e3f5"
      };
    });

    return {
      key: countKey,
      label: stage.title,
      stageKey: stage.key,
      ...getAdoptionStagePresentation(stage.key, stage.title),
      total,
      segments
    };
  });
}

function AdoptionLevelStageChart({ overview }) {
  if (!overview.levels?.length) {
    return <div className="empty-state">No stage adoption breakdown is available for this cycle.</div>;
  }

  const columns = buildStageAdoptionColumns(overview);

  return (
    <div className="adoption-stage-chart">
      <div className="adoption-stage-chart__plot">
        <div className="adoption-stage-chart__axis">
          {[100, 75, 50, 25, 0].map((tick) => (
            <span key={tick}>{tick}%</span>
          ))}
        </div>

        <div className="adoption-stage-chart__surface">
          <div
            className="adoption-stage-chart__bars"
            style={{ gridTemplateColumns: `repeat(${columns.length}, minmax(0, 1fr))` }}
          >
            {[100, 75, 50, 25].map((tick) => (
              <div
                key={tick}
                className="adoption-stage-chart__gridline"
                style={{ bottom: `${tick}%` }}
              />
            ))}

            {columns.map((column) => (
              <div key={column.key} className="adoption-stage-chart__bar-group">
                <div className="adoption-stage-chart__bar">
                  {column.segments.map((segment) => (
                    <div
                      key={segment.key}
                      className="adoption-stage-chart__segment"
                      style={{
                        height: `${segment.percentage}%`,
                        background: segment.color
                      }}
                      title={`${column.label}: ${segment.label} (${segment.count} practices)`}
                    />
                  ))}
                </div>
              </div>
            ))}
          </div>

          <div
            className="adoption-stage-chart__captions"
            style={{ gridTemplateColumns: `repeat(${columns.length}, minmax(0, 1fr))` }}
          >
            {columns.map((column) => (
              <div key={`${column.key}-caption`} className="adoption-stage-chart__caption">
                <strong>{column.chartLabel}</strong>
                <small>{column.total} practices</small>
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="adoption-stage-chart__legend">
        {overview.levels.map((level) => (
          <div key={level.key} className="adoption-stage-chart__legend-item">
            <span
              className="adoption-stage-chart__legend-swatch"
              style={{ background: ADOPTION_LEVEL_COLORS[level.key] || "#d8e3f5" }}
            />
            <small>{level.label}</small>
          </div>
        ))}
      </div>
    </div>
  );
}

export function ResultsPage({ data, overview, loading }) {
  // A Tela 2 funciona como aprofundamento analitico do diagnostico, sem repetir o resumo inicial.
  const [selectedDimensions, setSelectedDimensions] = useState([]);
  const [selectedElements, setSelectedElements] = useState([]);
  const [selectedGroupDimensions, setSelectedGroupDimensions] = useState([]);
  const view = data || fallbackResultsData;
  const overviewData = overview || fallbackDashboardData;
  const stages = mapStagesToJourney(view.stageScores);
  const leadingStage = getLeadingStage(stages);
  const constrainingStage = getConstrainingStage(stages);
  const analyticalNarrative = buildAnalyticalNarrative(leadingStage, constrainingStage);
  const dimensionGroupsSource = (view.practiceThemes || []).filter(
    (group) =>
      group.name !== "Agile Development" &&
      group.name !== "Continuous Experimentation"
  );
  const dimensionScoreOverview = view.dimensionScoreOverview || {
    dimensions: [],
    summary: {}
  };
  const dimensionOverview = view.dimensionOverview || { dimensions: [], summary: {} };
  const processOverview = view.processOverview || { rows: [], summary: {} };
  const elementOverview = view.elementOverview || { rows: [], summary: {} };
  const adoptionLevelStageOverview = view.adoptionLevelStageOverview || {
    levels: [],
    totals: {},
    degreeOfAdoption: {}
  };
  const adoptionLevels = overviewData.adoptionLevels || [];
  const allElementRows = elementOverview.rows || [];
  const dimensionFilterOptions = buildDimensionFilterOptions(allElementRows);
  const dimensionSelectionSet = new Set(selectedDimensions);
  const elementFilterOptions = buildElementFilterOptions(
    allElementRows.filter((row) => dimensionSelectionSet.has(row.dimensionName))
  );
  const dimensionFilterKey = dimensionFilterOptions.map((item) => item.value).join("|");
  const elementFilterKey = elementFilterOptions.map((item) => item.value).join("|");

  useEffect(() => {
    const availableDimensions = new Set(dimensionFilterOptions.map((item) => item.value));

    setSelectedDimensions((current) => {
      const next = current.filter((item) => availableDimensions.has(item));
      return next.length || !dimensionFilterOptions.length
        ? next
        : dimensionFilterOptions.map((item) => item.value);
    });
  }, [dimensionFilterKey]);

  useEffect(() => {
    const availableElements = new Set(elementFilterOptions.map((item) => item.value));

    setSelectedElements((current) => {
      const next = current.filter((item) => availableElements.has(item));
      return next.length || !elementFilterOptions.length
        ? next
        : elementFilterOptions.map((item) => item.value);
    });
  }, [elementFilterKey]);

  function toggleMultiSelectValue(value, setter) {
    setter((current) =>
      current.includes(value)
        ? current.filter((item) => item !== value)
        : [...current, value]
    );
  }

  const filteredElementBaseRows = allElementRows.filter(
    (row) =>
      selectedDimensions.includes(row.dimensionName) &&
      selectedElements.includes(row.key)
  );
  const elementRows = buildElementOverviewRows(filteredElementBaseRows);
  const isFilteredElementView =
    selectedDimensions.length !== dimensionFilterOptions.length ||
    selectedElements.length !== elementFilterOptions.length;
  const visibleElementSummary = isFilteredElementView
    ? buildFilteredElementSummary(filteredElementBaseRows)
    : elementOverview.summary;
  const filteredDimensionCount = new Set(
    filteredElementBaseRows.map((row) => row.dimensionName)
  ).size;
  const elementFilterSummary = `${filteredElementBaseRows.length} of ${allElementRows.length} elements shown across ${filteredDimensionCount} dimensions.`;
  const groupDimensionFilterOptions = dimensionGroupsSource.map((group) => ({
    value: group.name,
    label: group.name
  }));
  const groupDimensionFilterKey = groupDimensionFilterOptions
    .map((item) => item.value)
    .join("|");

  useEffect(() => {
    const availableGroupDimensions = new Set(
      groupDimensionFilterOptions.map((item) => item.value)
    );

    setSelectedGroupDimensions((current) => {
      const next = current.filter((item) => availableGroupDimensions.has(item));
      return next.length || !groupDimensionFilterOptions.length
        ? next
        : groupDimensionFilterOptions.map((item) => item.value);
    });
  }, [groupDimensionFilterKey]);

  const practiceGroups = dimensionGroupsSource.filter((group) =>
    selectedGroupDimensions.includes(group.name)
  );
  const practiceGroupSummary = `${practiceGroups.length} of ${dimensionGroupsSource.length} dimensions shown.`;
  const dimensionScoreLookup = new Map(
    (dimensionScoreOverview.dimensions || []).map((item) => [
      item.name,
      item.organizationScore
    ])
  );
  const dimensionRadarSource = (dimensionOverview.dimensions || []).length
    ? dimensionOverview.dimensions
    : dimensionScoreOverview.dimensions || [];
  const dimensionRadarData = dimensionRadarSource.map((item) => ({
    ...item,
    organizationScore: dimensionScoreLookup.get(item.name) ?? item.organizationScore ?? 0
  }));

  const diagnosticFacts = [
    {
      label: "Questionnaire status",
      value: view.summary.questionnaireStatus || "Under Assessment"
    },
    { label: "Spread across stages", value: formatStageSpread(leadingStage, constrainingStage) }
  ];

  if (loading && !data) {
    return <section className="panel">Loading diagnostic detail...</section>;
  }

  if (view.selectedCycleEmpty) {
    return (
      <section className="panel">
        <p className="eyebrow">Diagnostic detail</p>
        <h3>No submitted answers for this cycle</h3>
        <p>
          The selected assessment cycle does not contain submitted answers yet. Detailed
          interpretation becomes available after the cycle receives recorded answers.
        </p>
      </section>
    );
  }

  return (
    <>
      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Diagnostic detail</h3>
          </div>
        </div>

        <article className="insight-item">
          <h4>How to interpret the current diagnosis</h4>
          <p>{analyticalNarrative}</p>
        </article>

        <div className="assessment-context-grid">
          {diagnosticFacts.map((item) => (
            <article key={item.label} className="context-card">
              <span>{item.label}</span>
              <strong>{item.value}</strong>
            </article>
          ))}
        </div>
      </section>

      <section className="panel support-panel">
        <h3>Adoption level across assessment items</h3>

        {adoptionLevels.length ? (
          <table className="table">
            <thead>
              <tr>
                <th>Adoption level</th>
                <th>Statements</th>
                <th>Share</th>
              </tr>
            </thead>
            <tbody>
              {adoptionLevels.map((item) => (
                <tr key={item.key}>
                  <td>
                    <strong>{item.label}</strong>
                  </td>
                  <td>{item.count}</td>
                  <td>{item.percentage}%</td>
                </tr>
              ))}
            </tbody>
          </table>
        ) : (
          <p className="empty-state">
            No adoption-level distribution is available for this cycle.
          </p>
        )}
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Adoption by level and stage</h3>
          </div>
        </div>

        <div className="two-column-grid dimension-overview-grid">
          <article className="panel dimension-overview-panel">
            {adoptionLevelStageOverview.levels.length ? (
              <div className="results-adoption-breakdown">
                <div className="results-adoption-breakdown__section">
                  <small className="eyebrow">Distribution table</small>
                  <table className="table table--stage-distribution">
                    <colgroup>
                      <col className="table--stage-distribution__col-label" />
                      <col className="table--stage-distribution__col-stage" />
                      <col className="table--stage-distribution__col-stage" />
                      <col className="table--stage-distribution__col-stage" />
                      <col className="table--stage-distribution__col-stage" />
                    </colgroup>
                    <thead>
                      <tr>
                        <th rowSpan="2">Adoption level</th>
                        <th colSpan="4">Number of CSE practices</th>
                      </tr>
                      <tr>
                        <th>
                          <div className="table-stage-head">
                            <strong>Agile R&amp;D</strong>
                          </div>
                        </th>
                        <th>
                          <div className="table-stage-head">
                            <strong>CI</strong>
                          </div>
                        </th>
                        <th>
                          <div className="table-stage-head">
                            <strong>CD</strong>
                          </div>
                        </th>
                        <th>
                          <div className="table-stage-head">
                            <strong>Experiment system</strong>
                          </div>
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      {adoptionLevelStageOverview.levels.map((level) => (
                        <tr key={level.key}>
                          <td>
                            <strong>{level.label}</strong>
                          </td>
                          <td>{level.agileCount}</td>
                          <td>{level.ciCount}</td>
                          <td>{level.cdCount}</td>
                          <td>{level.experimentationCount}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>

                <div className="results-adoption-breakdown__section">
                  <small className="eyebrow">Summary results</small>
                  <div className="results-adoption-summary">
                    <article className="results-adoption-summary__card">
                      <span>Total CSE practices</span>
                      <dl className="results-adoption-summary__list">
                        <div className="results-adoption-summary__row">
                          <dt>Agile R&amp;D</dt>
                          <dd>{adoptionLevelStageOverview.totals.agileCount}</dd>
                        </div>
                        <div className="results-adoption-summary__row">
                          <dt>CI</dt>
                          <dd>{adoptionLevelStageOverview.totals.ciCount}</dd>
                        </div>
                        <div className="results-adoption-summary__row">
                          <dt>CD</dt>
                          <dd>{adoptionLevelStageOverview.totals.cdCount}</dd>
                        </div>
                        <div className="results-adoption-summary__row">
                          <dt>Experiment system</dt>
                          <dd>{adoptionLevelStageOverview.totals.experimentationCount}</dd>
                        </div>
                      </dl>
                    </article>

                    <article className="results-adoption-summary__card results-adoption-summary__card--highlight">
                      <span>Degree of adoption</span>
                      <dl className="results-adoption-summary__list">
                        <div className="results-adoption-summary__row">
                          <dt>Agile R&amp;D</dt>
                          <dd>{formatDimensionValue(adoptionLevelStageOverview.degreeOfAdoption.agileScore)}</dd>
                        </div>
                        <div className="results-adoption-summary__row">
                          <dt>CI</dt>
                          <dd>{formatDimensionValue(adoptionLevelStageOverview.degreeOfAdoption.ciScore)}</dd>
                        </div>
                        <div className="results-adoption-summary__row">
                          <dt>CD</dt>
                          <dd>{formatDimensionValue(adoptionLevelStageOverview.degreeOfAdoption.cdScore)}</dd>
                        </div>
                        <div className="results-adoption-summary__row">
                          <dt>Experiment system</dt>
                          <dd>
                            {formatDimensionValue(
                              adoptionLevelStageOverview.degreeOfAdoption.experimentationScore
                            )}
                          </dd>
                        </div>
                      </dl>
                    </article>
                  </div>
                </div>
              </div>
            ) : (
              <p className="empty-state">No stage adoption breakdown is available for this cycle.</p>
            )}
          </article>

          <article className="panel support-panel">
            <h3>Practices adopted by level and stage</h3>
            <p>
              The chart highlights how the current answered practices are distributed across the
              adoption levels in each assessed CSE stage.
            </p>
            <AdoptionLevelStageChart overview={adoptionLevelStageOverview} />
          </article>
        </div>
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Dimension adoption overview</h3>
          </div>
        </div>

        <div className="two-column-grid dimension-overview-grid dimension-overview-grid--matrix">
          <article className="panel dimension-overview-panel">
            <table className="table table--stage-distribution table--dimension-matrix">
              <colgroup>
                <col className="table--dimension-matrix__col-label" />
                <col className="table--dimension-matrix__col-stage" />
                <col className="table--dimension-matrix__col-stage" />
                <col className="table--dimension-matrix__col-stage" />
                <col className="table--dimension-matrix__col-stage" />
                <col className="table--dimension-matrix__col-total" />
              </colgroup>
              <thead>
                <tr>
                  <th rowSpan="2">Dimension</th>
                  <th colSpan="4">Stages of StH</th>
                  <th rowSpan="2">
                    <div className="table-stage-head">
                      <strong>
                        <span>Number of</span>
                        <span>CSE practices</span>
                      </strong>
                    </div>
                  </th>
                </tr>
                <tr>
                  <th>
                    <div className="table-stage-head">
                      <strong>
                        <span>Agile</span>
                        <span>Organization</span>
                      </strong>
                    </div>
                  </th>
                  <th>
                    <div className="table-stage-head">
                      <strong>
                        <span>Continuous</span>
                        <span>Integration</span>
                      </strong>
                    </div>
                  </th>
                  <th>
                    <div className="table-stage-head">
                      <strong>
                        <span>Continuous</span>
                        <span>Deployment</span>
                      </strong>
                    </div>
                  </th>
                  <th>
                    <div className="table-stage-head">
                      <strong>
                        <span>R&amp;D as</span>
                        <span>Innovation</span>
                        <span>System</span>
                      </strong>
                    </div>
                  </th>
                </tr>
              </thead>
              <tbody>
                {dimensionOverview.dimensions.map((item) => (
                  <tr key={item.key}>
                    <td>
                      <strong>{item.name}</strong>
                    </td>
                    <td>{item.agileCount}</td>
                    <td>{item.ciCount}</td>
                    <td>{item.cdCount}</td>
                    <td>{item.experimentationCount}</td>
                    <td>{item.practiceCount}</td>
                  </tr>
                ))}
                <tr>
                  <td>
                    <strong>Number of the statements</strong>
                  </td>
                  <td>{dimensionOverview.summary.agileCount}</td>
                  <td>{dimensionOverview.summary.ciCount}</td>
                  <td>{dimensionOverview.summary.cdCount}</td>
                  <td>{dimensionOverview.summary.experimentationCount}</td>
                  <td>{dimensionOverview.summary.statementCount}</td>
                </tr>
              </tbody>
            </table>
          </article>

          <article className="panel support-panel">
            <h3>Dimension adoption radar</h3>
            <DimensionRadar dimensions={dimensionRadarData} />
          </article>
        </div>
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Process adoption by stage</h3>
          </div>
        </div>

        {processOverview.rows.length ? (
          <table className="table table--grouped table--process-matrix">
            <colgroup>
              <col className="table--process-matrix__col-label" />
              <col className="table--process-matrix__col-stage" />
              <col className="table--process-matrix__col-stage" />
              <col className="table--process-matrix__col-stage" />
              <col className="table--process-matrix__col-stage" />
              <col className="table--process-matrix__col-total" />
            </colgroup>
            <thead>
              <tr>
                <th rowSpan="2">Processes</th>
                <th colSpan="4" className="table-numeric-head">
                  Stages of StH
                </th>
                <th rowSpan="2" className="table-numeric-head">
                  Process adoption
                </th>
              </tr>
              <tr>
                <th className="table-numeric-head">
                  <div className="table-stage-head">
                    <strong>
                      <span>Agile</span>
                      <span>Organization</span>
                    </strong>
                  </div>
                </th>
                <th className="table-numeric-head">CI</th>
                <th className="table-numeric-head">CD</th>
                <th className="table-numeric-head">
                  <div className="table-stage-head">
                    <strong>
                      <span>R&amp;D as</span>
                      <span>Innovation</span>
                      <span>System</span>
                    </strong>
                  </div>
                </th>
              </tr>
            </thead>
            <tbody>
              {processOverview.rows.map((item) => (
                <tr key={item.key}>
                  <td>
                    <strong>{item.name}</strong>
                  </td>
                  <td className="table-numeric-cell">{formatDimensionValue(item.agileScore)}</td>
                  <td className="table-numeric-cell">{formatDimensionValue(item.ciScore)}</td>
                  <td className="table-numeric-cell">{formatDimensionValue(item.cdScore)}</td>
                  <td className="table-numeric-cell">
                    {formatDimensionValue(item.experimentationScore)}
                  </td>
                  <td className="table-numeric-cell">
                    {formatDimensionValue(item.organizationScore)}
                  </td>
                </tr>
              ))}
              <tr className="table-summary-row table-summary-row--final">
                <td>
                  <strong>Degree of adoption</strong>
                </td>
                <td className="table-numeric-cell">
                  {formatDimensionValue(processOverview.summary.agileScore)}
                </td>
                <td className="table-numeric-cell">
                  {formatDimensionValue(processOverview.summary.ciScore)}
                </td>
                <td className="table-numeric-cell">
                  {formatDimensionValue(processOverview.summary.cdScore)}
                </td>
                <td className="table-numeric-cell">
                  {formatDimensionValue(processOverview.summary.experimentationScore)}
                </td>
                <td className="table-numeric-cell">
                  {formatDimensionValue(processOverview.summary.organizationScore)}
                </td>
              </tr>
            </tbody>
          </table>
        ) : (
          <p className="empty-state">No process-level adoption evidence is available.</p>
        )}
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Element adoption by dimension</h3>
          </div>
        </div>

        {allElementRows.length ? (
          <>
            <div className="roadmap-toolbar">
              <div className="roadmap-filters roadmap-filters--two">
                <div className="roadmap-filter-field">
                  <span>Filter dimensions</span>
                  <FilterDropdown
                    label="Dimensions"
                    summary={buildMultiSelectSummary(
                      selectedDimensions,
                      dimensionFilterOptions,
                      "dimension",
                      "dimensions"
                    )}
                    options={dimensionFilterOptions}
                    selectedValues={selectedDimensions}
                    onToggle={(value) => toggleMultiSelectValue(value, setSelectedDimensions)}
                    onSelectAll={() =>
                      setSelectedDimensions(dimensionFilterOptions.map((item) => item.value))
                    }
                    onClearAll={() => setSelectedDimensions([])}
                  />
                </div>

                <div className="roadmap-filter-field">
                  <span>Filter elements</span>
                  <FilterDropdown
                    label="Elements"
                    summary={buildMultiSelectSummary(
                      selectedElements,
                      elementFilterOptions,
                      "element",
                      "elements"
                    )}
                    options={elementFilterOptions}
                    selectedValues={selectedElements}
                    onToggle={(value) => toggleMultiSelectValue(value, setSelectedElements)}
                    onSelectAll={() =>
                      setSelectedElements(elementFilterOptions.map((item) => item.value))
                    }
                    onClearAll={() => setSelectedElements([])}
                  />
                </div>
              </div>

              <div className="roadmap-toolbar__meta">
                <p className="roadmap-summary">{elementFilterSummary}</p>
              </div>
            </div>

            {elementRows.length ? (
              <table className="table table--grouped table--element-matrix">
                <colgroup>
                  <col className="table--element-matrix__col-dimension" />
                  <col className="table--element-matrix__col-element" />
                  <col className="table--element-matrix__col-stage" />
                  <col className="table--element-matrix__col-stage" />
                  <col className="table--element-matrix__col-stage" />
                  <col className="table--element-matrix__col-stage" />
                  <col className="table--element-matrix__col-total" />
                </colgroup>
                <thead>
                  <tr>
                    <th rowSpan="2">Dimension</th>
                    <th rowSpan="2">Element</th>
                    <th colSpan="4" className="table-numeric-head">
                      Stages of StH
                    </th>
                    <th rowSpan="2" className="table-numeric-head">
                      Element adoption
                    </th>
                  </tr>
                  <tr>
                    <th className="table-numeric-head">
                      <div className="table-stage-head">
                        <strong>
                          <span>Agile</span>
                          <span>Organization</span>
                        </strong>
                      </div>
                    </th>
                    <th className="table-numeric-head">CI</th>
                    <th className="table-numeric-head">CD</th>
                    <th className="table-numeric-head">
                      <div className="table-stage-head">
                        <strong>
                          <span>R&amp;D as</span>
                          <span>Innovation</span>
                          <span>System</span>
                        </strong>
                      </div>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  {elementRows.map((row) => (
                    <tr key={row.key}>
                      {row.showDimension ? (
                        <td rowSpan={row.rowSpan} className="table-group-cell">
                          <strong>{row.dimensionName}</strong>
                        </td>
                      ) : null}
                      <td>
                        <strong>{row.elementName}</strong>
                      </td>
                      <td className="table-numeric-cell">
                        {formatElementMatrixValue(row.agileScore)}
                      </td>
                      <td className="table-numeric-cell">
                        {formatElementMatrixValue(row.ciScore)}
                      </td>
                      <td className="table-numeric-cell">
                        {formatElementMatrixValue(row.cdScore)}
                      </td>
                      <td className="table-numeric-cell">
                        {formatElementMatrixValue(row.experimentationScore)}
                      </td>
                      <td className="table-numeric-cell">
                        {formatElementMatrixValue(row.organizationScore)}
                      </td>
                    </tr>
                  ))}
                  <tr className="table-summary-row table-summary-row--final">
                    <td colSpan="2">
                      <strong>Degree of adoption</strong>
                    </td>
                    <td className="table-numeric-cell">
                      {formatElementMatrixValue(visibleElementSummary.agileScore)}
                    </td>
                    <td className="table-numeric-cell">
                      {formatElementMatrixValue(visibleElementSummary.ciScore)}
                    </td>
                    <td className="table-numeric-cell">
                      {formatElementMatrixValue(visibleElementSummary.cdScore)}
                    </td>
                    <td className="table-numeric-cell">
                      {formatElementMatrixValue(
                        visibleElementSummary.experimentationScore
                      )}
                    </td>
                    <td className="table-numeric-cell">
                      {formatElementMatrixValue(
                        visibleElementSummary.organizationScore
                      )}
                    </td>
                  </tr>
                </tbody>
              </table>
            ) : (
              <p className="empty-state">
                No elements match the selected dimensions and elements.
              </p>
            )}
          </>
        ) : (
          <p className="empty-state">No element-level evidence is available for this cycle.</p>
        )}
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Dimension-group analysis</h3>
          </div>
        </div>

        {dimensionGroupsSource.length ? (
          <>
            <div className="roadmap-toolbar">
              <div className="roadmap-filters roadmap-filters--one">
                <div className="roadmap-filter-field">
                  <span>Filter dimensions</span>
                  <FilterDropdown
                    label="Dimensions"
                    summary={buildMultiSelectSummary(
                      selectedGroupDimensions,
                      groupDimensionFilterOptions,
                      "dimension",
                      "dimensions"
                    )}
                    options={groupDimensionFilterOptions}
                    selectedValues={selectedGroupDimensions}
                    onToggle={(value) => toggleMultiSelectValue(value, setSelectedGroupDimensions)}
                    onSelectAll={() =>
                      setSelectedGroupDimensions(groupDimensionFilterOptions.map((item) => item.value))
                    }
                    onClearAll={() => setSelectedGroupDimensions([])}
                  />
                </div>
              </div>

              <div className="roadmap-toolbar__meta">
                <p className="roadmap-summary">{practiceGroupSummary}</p>
              </div>
            </div>

            {practiceGroups.length ? (
              <div className="dimension-grid">
                {practiceGroups.map((item) => (
                  <article key={item.key} className="dimension-card dimension-card--detailed">
                    <div className="dimension-card__head">
                      <div>
                        <h4>{item.name}</h4>
                        {item.focus ? <span>{item.focus}</span> : null}
                      </div>
                      <strong>{item.score}</strong>
                    </div>

                    <PercentageScale
                      score={item.score}
                      showMarker
                      className="dimension-card__scale"
                    />

                    <div className="dimension-card__evidence">
                      <div>
                        <span>What supports this group</span>
                        <strong>{buildPracticeGroupSignal(item, "strength")}</strong>
                      </div>
                      <div>
                        <span>What constrains this group</span>
                        <strong>{buildPracticeGroupSignal(item, "bottleneck")}</strong>
                      </div>
                    </div>
                  </article>
                ))}
              </div>
            ) : (
              <p className="empty-state">No dimensions match the selected filter.</p>
            )}
          </>
        ) : (
          <p className="empty-state">No dimension-group evidence is available in the current payload.</p>
        )}
      </section>
    </>
  );
}
