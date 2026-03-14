import { useMemo, useState } from "react";
import { answerScale, assessmentQuestions } from "../mock/zeppelinData";

export function AssessmentPage() {
  // "current" indica qual pergunta do questionario esta sendo exibida agora.
  const [current, setCurrent] = useState(0);

  // Guarda as respostas escolhidas pelo usuario durante a navegacao.
  // Neste prototipo, elas sao mantidas apenas em memoria para representar a experiencia.
  const [answers, setAnswers] = useState({});

  // Recupera a pergunta atual com base no indice selecionado.
  const currentQuestion = assessmentQuestions[current];

  // Calcula o percentual de progresso para alimentar a barra visual no topo.
  const progress = useMemo(
    () => Math.round(((current + 1) / assessmentQuestions.length) * 100),
    [current]
  );

  // Salva a resposta da pergunta atual.
  function setAnswer(value) {
    setAnswers((prev) => ({ ...prev, [currentQuestion.id]: value }));
  }

  return (
    <>
      {/* Bloco de progresso para o usuario entender em que ponto da avaliacao ele esta. */}
      <section className="panel">
        <h3>Assessment Progress</h3>
        <p>
          Question {current + 1} of {assessmentQuestions.length}
        </p>
        <div className="progress">
          <span style={{ width: `${progress}%` }} />
        </div>
      </section>

      {/* Card principal da pergunta atual.
          Ele foi desenhado de forma simples para nao cansar a leitura durante a avaliacao. */}
      <section className="panel">
        <h3>{currentQuestion.dimension}</h3>
        <p>{currentQuestion.question}</p>

        <div className="grid-3">
          {/* As alternativas seguem a escala padronizada do instrumento. */}
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
          {/* Navegacao basica do questionario:
              voltar, salvar progresso e avancar. */}
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
