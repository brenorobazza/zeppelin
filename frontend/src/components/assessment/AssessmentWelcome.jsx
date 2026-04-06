import departingImg from "../../assets/departing.png";

export function AssessmentWelcome({ handleStartNew }) {
  return (
    <section className="panel" style={{ textAlign: "center", padding: "4rem 2rem" }}>
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
