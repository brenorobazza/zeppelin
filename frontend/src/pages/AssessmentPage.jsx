import { useEffect, useMemo, useState } from "react";
import { getStatements, getAdoptedLevels, saveAnswer } from "../services/questionnaire";

export function AssessmentPage() {
  const [questions, setQuestions] = useState([]);
  const [options, setOptions] = useState([]);
  
  // "current" indica qual pergunta do questionario esta sendo exibida (indice do array).
  const [current, setCurrent] = useState(0);

  // Guarda as respostas escolhidas pelo usuario. Formato: { [statementId]: adoptedLevelId }
  const [answers, setAnswers] = useState({});
  const [loading, setLoading] = useState(true);

  // Carrega perguntas e opcoes da API ao abrir a tela
  useEffect(() => {
    async function loadData() {
      try {
        const fetchedQuestions = await getStatements();
        const fetchedOptions = await getAdoptedLevels();
        
        // Ordenar as perguntas pela ordem cronologica do modelo (baseado no codigo, ex: AO.01)
        const sortedQuestions = fetchedQuestions.sort((a, b) => {
           if(a.code < b.code) return -1;
           if(a.code > b.code) return 1;
           return 0;
        });

        // Ordenar as alternativas de resposta pelo grau de maturidade (0% a 100%)
        const sortedOptions = fetchedOptions.sort((a, b) => a.percentage - b.percentage);

        setQuestions(sortedQuestions);
        setOptions(sortedOptions);
      } catch (error) {
        console.error("Erro ao carregar os dados do questionario:", error);
      } finally {
        setLoading(false);
      }
    }
    loadData();
  }, []);

  const currentQuestion = questions[current];

  // Calcula o percentual de progresso para a barra superior
  const progress = useMemo(() => {
    if (questions.length === 0) return 0;
    return Math.round(((current + 1) / questions.length) * 100);
  }, [current, questions]);

  // Salva a resposta localmente e envia para a API silenciosamente (Auto-save)
  async function handleSetAnswer(optionId) {
    if (!currentQuestion) return;
    
    // Atualiza a UI imediatamente (feedback instantaneo)
    setAnswers((prev) => ({ ...prev, [currentQuestion.id]: optionId }));

    // Dispara a requisicao de salvamento no backend em background
    try {
      await saveAnswer(currentQuestion.id, optionId);
    } catch (err) {
      console.error("Falha ao salvar a resposta no auto-save:", err);
      // Aqui podemos expandir futuramente mostrando um alerta de "erro de conexao" para o usuario
    }
  }

  function handleNext() {
    setCurrent((value) => Math.min(questions.length - 1, value + 1));
  }

  function handleBack() {
    setCurrent((value) => Math.max(0, value - 1));
  }

  if (loading) {
    return (
      <section className="panel">
        <h3>Carregando o Instrumento Zeppelin...</h3>
      </section>
    );
  }

  if (questions.length === 0) {
    return (
      <section className="panel">
        <h3>Nenhuma pergunta encontrada.</h3>
        <p>Certifique-se de que o banco de dados foi populado rodando <code>make seed-db</code>.</p>
      </section>
    );
  }

  return (
    <>
      {/* Bloco de progresso para o usuario entender em que ponto da avaliacao ele esta */}
      <section className="panel">
        <h3>Progresso da Avaliacao</h3>
        <p>
          Pergunta {current + 1} de {questions.length}
        </p>
        <div className="progress">
          <span style={{ width: `${progress}%` }} />
        </div>
      </section>

      {/* Card principal da pergunta atual (Visualizacao One-by-One / Wizard) */}
      <section className="panel">
        <h4 style={{ color: "#666", marginBottom: "0.5rem" }}>
          [{currentQuestion.code}]
        </h4>
        <h3 style={{ fontSize: "1.2rem", marginBottom: "2rem" }}>
          {/* O model do backend pode ter "text" ou "statement" dependendo do serializer */}
          {currentQuestion.text || currentQuestion.statement}
        </h3>

        <div style={{ display: "flex", flexDirection: "column", gap: "10px" }}>
          {options.map((option) => {
            const isSelected = answers[currentQuestion.id] === option.id;
            return (
              <button
                key={option.id}
                type="button"
                className={isSelected ? "btn-primary-ui" : "btn-secondary-ui"}
                style={{ textAlign: "left", padding: "15px", height: "auto" }}
                onClick={() => handleSetAnswer(option.id)}
              >
                <strong>{option.percentage}% - {option.name}</strong>
                <p style={{ margin: "5px 0 0 0", fontSize: "0.85rem", opacity: isSelected ? 1 : 0.8 }}>
                  {option.description}
                </p>
              </button>
            );
          })}
        </div>

        <div className="btn-row" style={{ marginTop: "2rem", display: "flex", justifyContent: "space-between" }}>
          <button
            className="btn-secondary-ui"
            type="button"
            onClick={handleBack}
            disabled={current === 0}
          >
            Anterior
          </button>
          
          <button
            className="btn-primary-ui"
            type="button"
            onClick={handleNext}
            disabled={current === questions.length - 1}
          >
            {current === questions.length - 1 ? "Finalizar" : "Proximo"}
          </button>
        </div>
      </section>
    </>
  );
}
