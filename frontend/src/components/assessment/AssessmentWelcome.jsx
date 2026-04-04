import departingImg from "../../assets/departing.png";

export function AssessmentWelcome({ organizations, organizationId, onChangeOrganization, handleStartNew }) {
  return (
    <section className="panel" style={{ textAlign: "center", padding: "4rem 2rem" }}>
      {organizations.length > 1 && (
        <div style={{ marginBottom: "2rem", display: "flex", justifyContent: "center", alignItems: "center", gap: "10px" }}>
          <span style={{ fontWeight: "bold" }}>Organization:</span>
          <select 
            value={organizationId} 
            onChange={(e) => onChangeOrganization && onChangeOrganization(e.target.value)}
            style={{ padding: "0.5rem", borderRadius: "4px", border: "1px solid #ccc", fontSize: "1rem" }}
          >
            {organizations.map(org => (
              <option key={org.id} value={org.id}>{org.name}</option>
            ))}
          </select>
        </div>
      )}
      <div style={{ 
        width: "300px", 
        height: "150px", 
        margin: "0 auto 2rem", 
        display: "flex", 
        alignItems: "center", 
        justifyContent: "center",
        borderRadius: "8px"
      }}>
        <img src={departingImg} alt="Zeppelin departing" style={{ width: "100%", height: "100%", objectFit: "cover", opacity: 0.4 }} />
      </div>
      <h3 style={{ marginBottom: "1rem", fontSize: "1.5rem" }}>Welcome to Zeppelin!</h3>
      <p style={{ color: "#666", marginBottom: "2rem", maxWidth: "400px", margin: "0 auto 2rem" }}>
        To understand your CSE maturity, start your first diagnostic
      </p>
      <button className="btn-primary-ui" onClick={handleStartNew}>
        Start assessment
      </button>
    </section>
  );
}
