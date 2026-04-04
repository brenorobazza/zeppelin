export function AssessmentTabs({ stages, groupedQuestions, answers, activeStage, onTabClick }) {
  return (
    <section className="panel" style={{ padding: 0, overflow: "hidden", marginBottom: "1rem" }}>
      <div style={{ display: "flex", borderBottom: "1px solid #d9e2ef", background: "#f8fbff", overflowX: "auto" }}>
        {stages.map((stage) => {
          const stageQuestions = groupedQuestions[stage];
          const answeredCount = stageQuestions.filter(q => answers[q.id]).length;
          const totalCount = stageQuestions.length;
          const isActive = activeStage === stage;
          
          return (
            <button
              key={stage}
              onClick={() => onTabClick(stage, stageQuestions)}
              style={{
                flex: 1,
                padding: "1rem 0.5rem",
                background: isActive ? "#ffffff" : "transparent",
                border: "none",
                borderBottom: isActive ? "2px solid #1877f2" : "2px solid transparent",
                color: isActive ? "#123764" : "#60708a",
                fontWeight: isActive ? "700" : "600",
                cursor: "pointer",
                minWidth: "max-content",
                borderRadius: 0,
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                gap: "0.25rem",
                transition: "all 0.2s ease"
              }}
            >
              <span style={{ fontSize: "0.85rem" }}>{stage}</span>
              <span style={{ 
                fontSize: "0.75rem", 
                background: answeredCount === totalCount ? "#eaf8ef" : "#f1f5fb", 
                color: answeredCount === totalCount ? "#1f6a3a" : "#60708a",
                padding: "0.1rem 0.5rem",
                borderRadius: "999px"
              }}>
                {answeredCount} / {totalCount}
              </span>
            </button>
          );
        })}
      </div>
    </section>
  );
}
