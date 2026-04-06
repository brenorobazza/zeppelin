import { fallbackDashboardData, fallbackResultsData } from "../mock/analyticsFallback";
import {
  getConstrainingStage,
  getLeadingStage,
  mapStagesToJourney
} from "./stairwayStages";

function formatDimensionValue(value) {
  return value == null ? "-" : `${value}%`;
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
    return <div className="empty-state">No dimension comparison is available for this cycle.</div>;
  }

  const size = 560;
  const center = size / 2;
  const radius = 170;
  const axes = buildRadarAxes(dimensions, radius, center);
  const polygonPoints = buildRadarPoints(dimensions, radius, center);
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

function buildStageSignal(stage) {
  if (!stage.available) {
    return "This stage is not represented in the current analytics payload.";
  }

  const strengthCount = stage.strengthCount || 0;
  const bottleneckCount = stage.bottleneckCount || 0;

  if (!strengthCount && !bottleneckCount) {
    return "No supporting or constraining practices are explicitly identified for this stage.";
  }

  return `${strengthCount} supporting practices and ${bottleneckCount} constraining practices are currently associated with this stage.`;
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
          <small>
            {item.stage} / {item.questionId}
          </small>
          <h4>{buildInsightTitle(item, variant)}</h4>
          <p>{buildInsightDescription(item, variant)}</p>
        </li>
      ))}
    </ul>
  );
}

export function ResultsPage({ data, overview, loading }) {
  // A Tela 2 funciona como aprofundamento analitico do diagnostico, sem repetir o resumo inicial.
  const view = data || fallbackResultsData;
  const overviewData = overview || fallbackDashboardData;
  const stages = mapStagesToJourney(view.stageScores);
  const leadingStage = getLeadingStage(stages);
  const constrainingStage = getConstrainingStage(stages);
  const analyticalNarrative = buildAnalyticalNarrative(leadingStage, constrainingStage);
  const practiceGroups = view.practiceThemes || [];
  const dimensionOverview = view.dimensionOverview || { dimensions: [], summary: {} };
  const adoptionLevels = overviewData.adoptionLevels || [];

  const diagnosticFacts = [
    { label: "Assessed statements", value: view.summary.answeredPractices },
    { label: "Spread across stages", value: formatStageSpread(leadingStage, constrainingStage) },
    { label: "Practice groups reviewed", value: practiceGroups.length }
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
        <p className="eyebrow">Diagnostic detail</p>

        <div className="section-head">
          <div>
            <h3>Detailed diagnostic interpretation</h3>
            <p>
              This page explains the current maturity position by combining stage-level evidence
              with the analysis of related practice groups.
            </p>
          </div>
        </div>

        <article className="insight-item">
          <small>Interpretive summary</small>
          <h4>How to interpret the current diagnosis</h4>
          <p>{analyticalNarrative}</p>
        </article>

        <div className="assessment-context-grid assessment-context-grid--compact">
          {diagnosticFacts.map((item) => (
            <article key={item.label} className="context-card">
              <span>{item.label}</span>
              <strong>{item.value}</strong>
            </article>
          ))}
        </div>
      </section>

      <section className="two-column-grid">
        <article className="panel">
          <h3>Stage interpretation</h3>
          <p>
            Stages are the primary analytical axis of the diagnostic. The section below shows where
            support and restriction currently concentrate across the Stairway to Heaven model.
          </p>

          <table className="table">
            <thead>
              <tr>
                <th>Stage</th>
                <th>Score</th>
                <th>Current level</th>
                <th>Supporting practices</th>
                <th>Constraining practices</th>
              </tr>
            </thead>
            <tbody>
              {stages.map((stage) => (
                <tr key={stage.key}>
                  <td>
                    <strong>{stage.name}</strong>
                  </td>
                  <td>{stage.available ? stage.score : "N/A"}</td>
                  <td>{stage.currentLevel}</td>
                  <td>{stage.available ? stage.strengthCount || 0 : "N/A"}</td>
                  <td>{stage.available ? stage.bottleneckCount || 0 : "N/A"}</td>
                </tr>
              ))}
            </tbody>
          </table>

          <div className="stage-profile-list">
            {stages.map((stage) => (
              <article
                key={`${stage.key}-signal`}
                className={`stage-profile-item ${stage.available ? "" : "stage-profile-item--missing"}`.trim()}
              >
                <div className="stage-profile-item__head">
                  <div>
                    <h4>{stage.name}</h4>
                    <span>{stage.currentLevel}</span>
                  </div>
                  <strong>{stage.available ? stage.score : "N/A"}</strong>
                </div>
                <p>{buildStageSignal(stage)}</p>
              </article>
            ))}
          </div>
        </article>

        <article className="panel support-panel">
          <h3>Adoption level distribution across assessed statements</h3>
          <p>
            This distribution shows how the assessed statements are currently positioned across the
            adoption levels defined by the diagnostic instrument.
          </p>

          <div className="level-rows">
            {adoptionLevels.map((item) => (
              <div key={item.key} className="level-row">
                <div className="level-row__meta">
                  <strong>{item.label}</strong>
                  <small>{item.count} statements</small>
                </div>
                <div className="progress">
                  <span style={{ width: `${item.percentage}%` }} />
                </div>
                <strong>{item.percentage}%</strong>
              </div>
            ))}
          </div>
        </article>
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Dimension adoption overview</h3>
            <p>
              This section reproduces the most useful part of the spreadsheet analysis in a
              web-friendly format, comparing CI, CD and organization-level adoption by dimension.
            </p>
          </div>
        </div>

        <div className="two-column-grid dimension-overview-grid">
          <article className="panel dimension-overview-panel">
            <table className="table">
              <thead>
                <tr>
                  <th>Dimension</th>
                  <th>CI</th>
                  <th>CD</th>
                  <th>Organization</th>
                  <th>CSE practices</th>
                </tr>
              </thead>
              <tbody>
                {dimensionOverview.dimensions.map((item) => (
                  <tr key={item.key}>
                    <td>
                      <strong>{item.name}</strong>
                    </td>
                    <td>{formatDimensionValue(item.ciScore)}</td>
                    <td>{formatDimensionValue(item.cdScore)}</td>
                    <td>{formatDimensionValue(item.organizationScore)}</td>
                    <td>{item.practiceCount}</td>
                  </tr>
                ))}
                <tr>
                  <td>
                    <strong>Degree of adoption</strong>
                  </td>
                  <td>{formatDimensionValue(dimensionOverview.summary.ciScore)}</td>
                  <td>{formatDimensionValue(dimensionOverview.summary.cdScore)}</td>
                  <td>{formatDimensionValue(dimensionOverview.summary.organizationScore)}</td>
                  <td>{dimensionOverview.summary.statementCount || 0}</td>
                </tr>
              </tbody>
            </table>
          </article>

          <article className="panel support-panel">
            <h3>Organization dimension radar</h3>
            <p>
              The radar highlights which dimensions currently show stronger or weaker adoption when
              the organization is read as a whole.
            </p>
            <DimensionRadar dimensions={dimensionOverview.dimensions} />
          </article>
        </div>
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <h3>Practice-group analysis</h3>
            <p>
              Practice groups are used here as a secondary analytical lens. They do not replace the
              stage reading; they clarify where related practices reinforce or constrain it.
            </p>
          </div>
        </div>

        {practiceGroups.length ? (
          <div className="dimension-grid">
            {practiceGroups.map((item) => (
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
                    <span>Current reading</span>
                    <strong>{normalizeLevel(item.currentLevel)}</strong>
                  </div>
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
          <p className="empty-state">No practice-group evidence is available in the current payload.</p>
        )}
      </section>

      <section className="grid-3">
        <article className="panel">
          <h3>Practices supporting the current maturity position</h3>
          {renderInsightList(view.strengths, "strengths")}
        </article>

        <article className="panel">
          <h3>Practices constraining progression to the next CSE stage</h3>
          {renderInsightList(view.bottlenecks, "bottlenecks")}
        </article>

        <article className="panel">
          <h3>Analytical priorities derived from the current diagnosis</h3>
          {renderInsightList(view.opportunities, "opportunities")}
        </article>
      </section>
    </>
  );
}
