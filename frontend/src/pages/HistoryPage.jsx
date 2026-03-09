import { historySeries } from "../mock/zeppelinData";

export function HistoryPage() {
  return (
    <>
      <section className="panel">
        <h3>Maturity Evolution</h3>
        <p>Historical progression of overall, CI and CD maturity scores.</p>
        {historySeries.map((item) => (
          <div key={item.period} style={{ marginBottom: "0.8rem" }}>
            <strong>{item.period}</strong>
            <div style={{ marginTop: "0.25rem" }}>Overall: {item.overall}</div>
            <div className="progress" style={{ marginTop: "0.18rem" }}>
              <span style={{ width: `${item.overall}%` }} />
            </div>
          </div>
        ))}
      </section>

      <section className="panel">
        <h3>Assessment History Table</h3>
        <table className="table">
          <thead>
            <tr>
              <th>Cycle</th>
              <th>Overall</th>
              <th>CI</th>
              <th>CD</th>
              <th>Delta</th>
            </tr>
          </thead>
          <tbody>
            {historySeries.map((item, index) => {
              const previous = historySeries[index - 1];
              const delta = previous ? item.overall - previous.overall : 0;
              return (
                <tr key={item.period}>
                  <td>{item.period}</td>
                  <td>{item.overall}</td>
                  <td>{item.ci}</td>
                  <td>{item.cd}</td>
                  <td>{index === 0 ? "-" : delta > 0 ? `+${delta}` : `${delta}`}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </section>
    </>
  );
}
