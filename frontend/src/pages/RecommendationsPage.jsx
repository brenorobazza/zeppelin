import { useMemo, useState } from "react";
import { recommendations } from "../mock/zeppelinData";

export function RecommendationsPage() {
  const [pillar, setPillar] = useState("All");
  const [priority, setPriority] = useState("All");
  const [status, setStatus] = useState("All");

  const filtered = useMemo(
    () =>
      recommendations.filter((item) => {
        const okPillar = pillar === "All" || item.pillar === pillar;
        const okPriority = priority === "All" || item.priority === priority;
        const okStatus = status === "All" || item.status === status;
        return okPillar && okPriority && okStatus;
      }),
    [pillar, priority, status]
  );

  return (
    <>
      <section className="panel">
        <h3>Filters</h3>
        <div className="btn-row">
          <select value={pillar} onChange={(event) => setPillar(event.target.value)}>
            <option>All</option>
            <option>CI</option>
            <option>CD</option>
          </select>
          <select value={priority} onChange={(event) => setPriority(event.target.value)}>
            <option>All</option>
            <option>High</option>
            <option>Medium</option>
            <option>Low</option>
          </select>
          <select value={status} onChange={(event) => setStatus(event.target.value)}>
            <option>All</option>
            <option>Planned</option>
            <option>In progress</option>
            <option>Completed</option>
          </select>
        </div>
      </section>

      <section className="panel">
        <h3>Recommendation Backlog</h3>
        <table className="table">
          <thead>
            <tr>
              <th>Practice</th>
              <th>Current Level</th>
              <th>Impact</th>
              <th>Effort</th>
              <th>Priority</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {filtered.map((item) => (
              <tr key={item.id}>
                <td>
                  <strong>{item.practice}</strong>
                  <div>{item.suggestion}</div>
                </td>
                <td>{item.currentLevel}</td>
                <td>{item.expectedImpact}</td>
                <td>{item.estimatedEffort}</td>
                <td>
                  <span className={`pill ${item.priority === "High" ? "high" : "medium"}`}>
                    {item.priority}
                  </span>
                </td>
                <td>{item.status}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>
    </>
  );
}
