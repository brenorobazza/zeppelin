import { useEffect, useMemo, useState } from "react";
import { FormOptionButton } from "../components/FormOptionButton";
import { getStatements, getAdoptedLevels, saveAnswer, getSavedAnswers } from "../services/questionnaire";

export function AssessmentPage() {
  const [questions, setQuestions] = useState([]);
  const [options, setOptions] = useState([]);
  
  // "current" indica qual pergunta do questionario esta sendo exibida (indice do array).
  const [current, setCurrent] = useState(0);

  // Guarda as respostas escolhidas pelo usuario. Formato: { [statementId]: adoptedLevelId }
  const [answers, setAnswers] = useState({});
  const [loading, setLoading] = useState(true);

  // Carrega perguntas e opções da API ao abrir a tela
  useEffect(() => {
    async function loadData() {
      try {
        const fetchedQuestions = await getStatements();
        const fetchedOptions = await getAdoptedLevels();
        const fetchedAnswers = await getSavedAnswers();
        
        // Ordenar as perguntas pela ordem cronológica do modelo (baseado no codigo, ex: AO.01)
        const sortedQuestions = fetchedQuestions.sort((a, b) => {
           if(a.code < b.code) return -1;
           if(a.code > b.code) return 1;
           return 0;
        });

        // Ordenar as alternativas de resposta pelo grau de maturidade (0% a 100%)
        const sortedOptions = fetchedOptions.sort((a, b) => a.percentage - b.percentage);

        // Mapear respostas ja dadas e salvas no backend
        const initialAnswers = {};
        fetchedAnswers.forEach(ans => {
            const statementId = ans.statement_answer?.id;
            const levelId = ans.adopted_level_answer?.id;
            if (statementId && levelId) {
                initialAnswers[statementId] = levelId;
            }
        });

        setQuestions(sortedQuestions);
        setOptions(sortedOptions);
        setAnswers(initialAnswers);

        // Determinar a primeira pergunta sem resposta para o usuario continuar de onde parou
        if (sortedQuestions.length > 0) {
            const firstUnansweredIndex = sortedQuestions.findIndex(q => !initialAnswers[q.id]);
            if (firstUnansweredIndex !== -1) {
                setCurrent(firstUnansweredIndex);
            } else {
                setCurrent(sortedQuestions.length - 1);
            }
        }
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

  // Atalhos de teclado para melhorar a UX no preenchimento do Zeppelin.
  useEffect(() => {
    function handleKeyDown(event) {
      // Teclas 1 a 5 para as alternativas de maturidade
      if (event.key >= "1" && event.key <= "5") {
        const index = parseInt(event.key, 10) - 1;
        if (options[index]) {
          handleSetAnswer(options[index].id);
        }
      }

      // Enter para avancar para a proxima pergunta
      if (event.key === "Enter") {
        if (current < questions.length - 1) {
          handleNext();
        }
      }
    }

    window.addEventListener("keydown", handleKeyDown);
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [questions, options, current]);

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
