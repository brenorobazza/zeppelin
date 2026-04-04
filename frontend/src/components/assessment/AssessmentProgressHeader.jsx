export function AssessmentProgressHeader({ activeStage, currentLocalIndex, questionsInActiveStage, progress, onBackToList }) {
  return (
    <section className="panel" style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
      <div>
        <h3>{activeStage} Progress</h3>
        <p>Question {currentLocalIndex + 1} of {questionsInActiveStage.length}</p>
        <div className="progress" style={{ width: "200px", marginTop: "0.5rem" }}>
          <span style={{ width: `${progress}%` }} />
        </div>
      </div>
      <button 
        className="btn-secondary-ui" 
        onClick={onBackToList}
        style={{ fontSize: "0.9rem" }}
      >
        Exit and save
      </button>
    </section>
  );
}
