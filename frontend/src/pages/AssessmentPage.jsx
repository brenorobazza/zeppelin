import { useMemo, useState } from "react";
import { answerScale, assessmentQuestions } from "../mock/zeppelinData";

export function AssessmentPage() {
  const [current, setCurrent] = useState(0);
  const [answers, setAnswers] = useState({});

  const currentQuestion = assessmentQuestions[current];
  const progress = useMemo(
    () => Math.round(((current + 1) / assessmentQuestions.length) * 100),
    [current]
  );

  function setAnswer(value) {
    setAnswers((prev) => ({ ...prev, [currentQuestion.id]: value }));
  }

  return (
    <>
      <section className="panel">
        <h3>Assessment Progress</h3>
        <p>
          Question {current + 1} of {assessmentQuestions.length}
        </p>
        <div className="progress">
          <span style={{ width: `${progress}%` }} />
        </div>
      </section>

      <section className="panel">
        <h3>{currentQuestion.dimension}</h3>
        <p>{currentQuestion.question}</p>

        <div className="grid-3">
          {answerScale.map((option) => (
            <button
              key={option}
              type="button"
              className={answers[currentQuestion.id] === option ? "btn-primary-ui" : "btn-secondary-ui"}
              onClick={() => setAnswer(option)}
            >
              {option}
            </button>
          ))}
        </div>

        <div className="btn-row" style={{ marginTop: "1rem" }}>
          <button
            className="btn-secondary-ui"
            type="button"
            onClick={() => setCurrent((value) => Math.max(0, value - 1))}
          >
            Back
          </button>
          <button className="btn-secondary-ui" type="button">
            Save Progress
          </button>
          <button
            className="btn-primary-ui"
            type="button"
            onClick={() =>
              setCurrent((value) => Math.min(assessmentQuestions.length - 1, value + 1))
            }
          >
            Next
          </button>
        </div>
      </section>
    </>
  );
}
