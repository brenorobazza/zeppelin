export function AssessmentOrgSelectorModal({ organizations, selectedOrgId, setSelectedOrgId, handleSelectOrganization }) {
  return (
    <section className="panel" style={{ textAlign: "center", padding: "4rem 2rem", maxWidth: "500px", margin: "0 auto" }}>
      <h3>Select organization</h3>
      <p style={{ color: "#666", marginBottom: "2rem" }}>
        Choose which company this new diagnostic will be linked to.
      </p>
      
      <select 
        value={selectedOrgId} 
        onChange={(e) => setSelectedOrgId(e.target.value)}
        style={{ 
          width: "100%", 
          padding: "0.8rem", 
          marginBottom: "2rem", 
          borderRadius: "4px", 
          border: "1px solid #ccc",
          fontSize: "1rem"
        }}
      >
        <option value="" disabled>Select a company...</option>
        {organizations.map(org => (
          <option key={org.id} value={org.id}>{org.name}</option>
        ))}
      </select>

      <button 
        className="btn-primary-ui" 
        disabled={!selectedOrgId}
        onClick={handleSelectOrganization}
      >
        Next
      </button>
    </section>
  );
}
