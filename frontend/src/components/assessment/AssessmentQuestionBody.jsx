import { FormOptionButton } from "../FormOptionButton";

export function AssessmentQuestionBody({ currentQuestion, options, answers, handleSetAnswer, handleBack, handleNext, currentLocalIndex, isLastQuestionInStage, isLastStage, allAnswered, stages, groupedQuestions, activeStage }) {
  let nextButtonText = "Next";
  if (isLastQuestionInStage) {
      if (allAnswered) {
          nextButtonText = isLastStage ? "Finish" : "Next Stage";
      } else {
          let foundNextStage = null;
          const currentStageIndex = stages.indexOf(activeStage);
          
          for (let i = 1; i < stages.length; i++) {
              const checkIndex = (currentStageIndex + i) % stages.length;
              const stage = stages[checkIndex];
              if (groupedQuestions[stage].some(q => !answers[q.id])) {
                  foundNextStage = stage;
                  break;
              }
          }
          
          if (!foundNextStage && groupedQuestions[activeStage].some(q => !answers[q.id])) {
              foundNextStage = activeStage;
          }

          if (foundNextStage) {
              const nextIndex = stages.indexOf(foundNextStage);
              nextButtonText = nextIndex < currentStageIndex ? "Review Missing" : "Next Stage";
          } else {
              nextButtonText = "Next Stage";
          }
      }
  }

  return (
    <section className="panel">
      <h4 style={{ color: "#666", marginBottom: "0.5rem" }}>
        [{currentQuestion.code}]
      </h4>
      <h3 style={{ fontSize: "1.2rem", marginBottom: "2rem" }}>
        {currentQuestion.text || currentQuestion.statement}
      </h3>

      <div style={{ display: "flex", flexDirection: "column", gap: "10px" }}>
        {options.map((option) => {
          const isSelected = answers[currentQuestion.id] === option.id;
          return (
            <FormOptionButton
              key={option.id}
              title={`${option.percentage}% - ${option.name}`}
              description={option.description}
              selected={isSelected}
              radius="square"
              onClick={() => handleSetAnswer(option.id)}
            />
          );
        })}
      </div>

      <div className="btn-row" style={{ marginTop: "2rem", display: "flex", justifyContent: "space-between" }}>
        <button
          className="btn-secondary-ui"
          type="button"
          onClick={handleBack}
          disabled={currentLocalIndex === 0}
        >
          Back
        </button>
        
        <button
          className="btn-primary-ui"
          type="button"
          onClick={handleNext}
          disabled={!answers[currentQuestion.id]}
        >
          {nextButtonText}
        </button>
      </div>
    </section>
  );
}
