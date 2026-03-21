import { useEffect, useMemo, useState } from "react";
import { FormOptionButton } from "../components/FormOptionButton";
import { getStatements, getAdoptedLevels, saveAnswer, getSavedAnswers, createQuestionnaireCycle } from "../services/questionnaire";
import departingImg from "../assets/departing.png";

// Internal component for the questionnaire form
function AssessmentForm({ organizationId, questionnaireId, onFinish }) {
  const [questions, setQuestions] = useState([]);
  const [options, setOptions] = useState([]);
  
  // "current" indicates which question is being displayed
  const [current, setCurrent] = useState(0);

  // Stores chosen answers: { [statementId]: adoptedLevelId }
  const [answers, setAnswers] = useState({});
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function loadData() {
      try {
        const fetchedQuestions = await getStatements();
        const fetchedOptions = await getAdoptedLevels();
        const fetchedAnswers = await getSavedAnswers(organizationId, questionnaireId);
        
        const sortedQuestions = fetchedQuestions.sort((a, b) => {
           if(a.code < b.code) return -1;
           if(a.code > b.code) return 1;
           return 0;
        });

        const sortedOptions = fetchedOptions.sort((a, b) => a.percentage - b.percentage);

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

        if (sortedQuestions.length > 0) {
            const firstUnansweredIndex = sortedQuestions.findIndex(q => !initialAnswers[q.id]);
            if (firstUnansweredIndex !== -1) {
                setCurrent(firstUnansweredIndex);
            } else {
                setCurrent(sortedQuestions.length - 1);
            }
        }
      } catch (error) {
        console.error("Error loading questionnaire data:", error);
      } finally {
        setLoading(false);
      }
    }
    loadData();
  }, [organizationId, questionnaireId]);

  const currentQuestion = questions[current];

  const progress = useMemo(() => {
    if (questions.length === 0) return 0;
    return Math.round(((current + 1) / questions.length) * 100);
  }, [current, questions]);

  async function handleSetAnswer(optionId) {
    if (!currentQuestion) return;
    
    setAnswers((prev) => ({ ...prev, [currentQuestion.id]: optionId }));

    try {
      await saveAnswer(currentQuestion.id, optionId, organizationId, questionnaireId);
    } catch (err) {
      console.error("Auto-save failed:", err);
    }
  }

  function handleNext() {
    setCurrent((value) => Math.min(questions.length - 1, value + 1));
  }

  function handleBack() {
    setCurrent((value) => Math.max(0, value - 1));
  }

  useEffect(() => {
    function handleKeyDown(event) {
      if (event.key >= "1" && event.key <= "5") {
        const index = parseInt(event.key, 10) - 1;
        if (options[index]) {
          handleSetAnswer(options[index].id);
        }
      }

      if (event.key === "Enter") {
        if (current < questions.length - 1) {
          handleNext();
        } else if (onFinish) {
          onFinish();
        }
      }
    }

    window.addEventListener("keydown", handleKeyDown);
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [questions, options, current, onFinish]);

  if (loading) {
    return (
      <section className="panel">
        <h3>Loading the Zeppelin Instrument...</h3>
      </section>
    );
  }

  if (questions.length === 0) {
    return (
      <section className="panel">
        <h3>No questions found.</h3>
        <p>Make sure the database was populated by running <code>make seed-db</code>.</p>
      </section>
    );
  }

  return (
    <>
      <section className="panel">
        <h3>Assessment Progress</h3>
        <p>Question {current + 1} of {questions.length}</p>
        <div className="progress">
          <span style={{ width: `${progress}%` }} />
        </div>
      </section>

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
            disabled={current === 0}
          >
            Back
          </button>
          
          <button
            className="btn-primary-ui"
            type="button"
            onClick={current === questions.length - 1 ? onFinish : handleNext}
          >
            {current === questions.length - 1 ? "Finish" : "Next"}
          </button>
        </div>
      </section>
    </>
  );
}


// Main component managing visualization states
export function AssessmentPage({ 
  organizationId, 
  questionnaireId, 
  organizations = [], 
  cycleOptions = [],
  organizationName = "Organization",
  onChangeOrganization,
  onCycleCreated,
  onViewResults,
  onFinish 
}) {
  const [currentView, setCurrentView] = useState("list"); // "list" | "modal" | "form"
  const [selectedOrgId, setSelectedOrgId] = useState("");
  const [isCreatingCycle, setIsCreatingCycle] = useState(false);

  async function startNewCycleForOrganization(targetOrgId) {
    setIsCreatingCycle(true);
    try {
      if (onChangeOrganization && targetOrgId !== organizationId) {
        onChangeOrganization(targetOrgId);
      }
      
      const newCycle = await createQuestionnaireCycle();
      
      if (onCycleCreated && newCycle.id) {
        onCycleCreated(String(newCycle.id));
      }
      
      setCurrentView("form");
    } catch (error) {
      console.error("Failed to create questionnaire cycle:", error);
      alert("There was a problem starting the diagnostic. Please try again.");
    } finally {
      setIsCreatingCycle(false);
    }
  }

  function handleStartNew() {
    if (organizations.length > 1) {
      setCurrentView("modal");
    } else {
      const defaultOrgId = organizations.length === 1 ? String(organizations[0].id) : organizationId;
      startNewCycleForOrganization(defaultOrgId);
    }
  }

  function handleSelectOrganization() {
    if (selectedOrgId) {
      startNewCycleForOrganization(selectedOrgId);
    }
  }

  if (isCreatingCycle) {
    return (
      <section className="panel" style={{ textAlign: "center", padding: "4rem 2rem" }}>
        <h3>Starting new assessment cycle...</h3>
        <p>Preparing the environment for your answers.</p>
      </section>
    );
  }

  if (currentView === "form") {
    return (
      <AssessmentForm 
        organizationId={organizationId}
        questionnaireId={questionnaireId}
        onFinish={onFinish}
      />
    );
  }

  if (currentView === "modal") {
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

  // currentView === "list"
  if (cycleOptions.length === 0) {
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
          {/* visual Placeholder */}
          {/* <span style={{ color: "#888", fontSize: "3rem" }}>📋</span> */}
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

  // Table view with history
  return (
    <section className="panel">
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "2rem" }}>
        <div style={{ display: "flex", alignItems: "center", gap: "15px" }}>
          <h3 style={{ margin: 0 }}>Your previous assessments</h3>
          {organizations.length > 1 && (
            <select 
              value={organizationId} 
              onChange={(e) => onChangeOrganization && onChangeOrganization(e.target.value)}
              style={{ padding: "0.4rem", borderRadius: "4px", border: "1px solid #ccc" }}
            >
              {organizations.map(org => (
                <option key={org.id} value={org.id}>{org.name}</option>
              ))}
            </select>
          )}
        </div>
        <button className="btn-primary-ui" onClick={handleStartNew} style={{ borderRadius: "20px", padding: "0.5rem 1.5rem" }}>
          New
        </button>
      </div>
      
      <div style={{ overflowX: "auto" }}>
        <table style={{ width: "100%", borderCollapse: "collapse", textAlign: "left", fontSize: "0.95rem" }}>
          <thead>
            <tr style={{ borderBottom: "2px solid #eaeaea", color: "#666" }}>
              <th style={{ padding: "1rem", fontWeight: "normal" }}>Organization Name</th>
              <th style={{ padding: "1rem", fontWeight: "normal" }}>Cycle</th>
              <th style={{ padding: "1rem", textAlign: "right", fontWeight: "normal" }}>Actions</th>
            </tr>
          </thead>
          <tbody>
            {cycleOptions.map((cycle, index) => (
              <tr key={cycle.id} style={{ 
                borderBottom: "1px solid #eaeaea", 
                backgroundColor: index % 2 === 0 ? "#f9f9f9" : "transparent"
              }}>
                <td style={{ padding: "1rem" }}>{organizationName}</td>
                <td style={{ padding: "1rem" }}>{cycle.label}</td>
                <td style={{ padding: "1rem", textAlign: "right" }}>
                  <button 
                    onClick={() => onViewResults && onViewResults(cycle.id)}
                    style={{ 
                      background: "none", 
                      border: "none", 
                      color: "#007bff", 
                      cursor: "pointer",
                      fontSize: "0.95rem",
                      textDecoration: "none"
                    }}
                  >
                    View results
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </section>
  );
}
