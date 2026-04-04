export function AssessmentHistoryTable({ cycleOptions, organizationName, onCycleCreated, onViewResults, setCurrentView, organizations, organizationId, onChangeOrganization, handleStartNew }) {
  return (
    <section className="panel">
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "2rem" }}>
        <div style={{ display: "flex", alignItems: "center", gap: "15px" }}>
          <h3 style={{ margin: 0 }}>Your previous assessments</h3>
          {organizations.length > 1 && (
            <select 
              value={organizationId} 
              onChange={(e) => onChangeOrganization && onChangeOrganization(e.target.value)}
              style={{ padding: "0.4rem", borderRadius: "4px", border: "1px solid #ccc" }}
            >
              {organizations.map(org => (
                <option key={org.id} value={org.id}>{org.name}</option>
              ))}
            </select>
          )}
        </div>
        <button className="btn-primary-ui" onClick={handleStartNew} style={{ borderRadius: "20px", padding: "0.5rem 1.5rem" }}>
          New
        </button>
      </div>
      
      <div style={{ overflowX: "auto" }}>
        <table style={{ width: "100%", borderCollapse: "collapse", textAlign: "left", fontSize: "0.95rem" }}>
          <thead>
            <tr style={{ borderBottom: "2px solid #eaeaea", color: "#666" }}>
              <th style={{ padding: "1rem", fontWeight: "normal" }}>Organization Name</th>
              <th style={{ padding: "1rem", fontWeight: "normal" }}>Cycle</th>
              <th style={{ padding: "1rem", fontWeight: "normal" }}>Progress</th>
              <th style={{ padding: "1rem", textAlign: "right", fontWeight: "normal" }}>Actions</th>
            </tr>
          </thead>
          <tbody>
            {cycleOptions.map((cycle, index) => (
              <tr key={cycle.id} style={{ 
                borderBottom: "1px solid #eaeaea", 
                backgroundColor: index % 2 === 0 ? "#f9f9f9" : "transparent"
              }}>
                <td style={{ padding: "1rem" }}>{organizationName}</td>
                <td style={{ padding: "1rem" }}>{cycle.label}</td>
                <td style={{ padding: "1rem", color: cycle.answeredPractices < 71 ? "#f59f00" : "#22c55e", fontWeight: 500 }}>
                  {cycle.answeredPractices} / 71 answered
                </td>
                <td style={{ padding: "1rem", textAlign: "right" }}>
                  {cycle.answeredPractices < 71 ? (
                    <button 
                      onClick={() => {
                        if (onCycleCreated) onCycleCreated(cycle.id);
                        setCurrentView("form");
                      }}
                      style={{ 
                        background: "none", 
                        border: "none", 
                        color: "#007bff", 
                        cursor: "pointer",
                        fontSize: "0.95rem",
                        textDecoration: "none",
                        fontWeight: "500"
                      }}
                    >
                      Continue answering
                    </button>
                  ) : (
                    <button 
                      onClick={() => onViewResults && onViewResults(cycle.id)}
                      style={{ 
                        background: "none", 
                        border: "none", 
                        color: "#007bff", 
                        cursor: "pointer",
                        fontSize: "0.95rem",
                        textDecoration: "none"
                      }}
                    >
                      View results
                    </button>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </section>
  );
}
