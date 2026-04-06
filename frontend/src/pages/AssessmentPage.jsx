/**
 * ASSESSMENT PAGE - ZEPPELIN
 * 
 * This page manages the Continuous Software Engineering (CSE) maturity diagnostic.
 * 
 * ARCHITECTURE & LOGIC:
 * - Questionnaire Structure: 71 questions grouped by 4 Stairway to Heaven (StH) stages.
 * - Theoretical Ordering: Fixed progression (AO -> CI -> CD -> RD).
 * - Componentization: Deconstructed into specialized components (Tabs, Header, Body, Table) 
 *   located in `components/assessment/`.
 * 
 * NAVIGATION RULES (Circular & Progressive):
 * 1. Intra-stage Strictness: Users cannot skip questions within a single stage. The 'Next'
 *    button is disabled until an answer is selected.
 * 2. Inter-stage Flexibility: Users can jump between stages using the top tabs. Clicking a 
 *    tab redirects to the first unanswered question of that specific stage.
 * 3. Smart Circular Routing: Upon completing the last question of ANY stage, the system 
 *    automatically scans all OTHER stages in circular order (S_current+1, S_current+2...) 
 *    to find the next incomplete one.
 * 4. "Review Missing" State: If a user finishes a stage but skipped questions in previous 
 *    stages, the button text changes to "Review Missing" and routes them backwards.
 * 5. Completion: The 'Finish' action is only available when 100% of the 71 questions 
 *    are answered. If everything is complete, 'Next Stage' serves as a review navigation 
 *    until the absolute last question of the final stage.
 * 
 * EDGE CASES HANDLED:
 * - Keyboard Race Conditions: Uses `useRef` (answersRef, activeStageRef) to ensure the 
 *   'Enter' key logic always reads the most recent data, even if React state hasn't 
 *   finished re-rendering.
 * - Data Leakage: Strict cycle-based filtering in `getSavedAnswers` to ensure responses 
 *   from previous diagnostics don't pollute new cycles.
 */

import { useEffect, useMemo, useState, useRef } from "react";
import { getStatements, getAdoptedLevels, saveAnswer, getSavedAnswers, createQuestionnaireCycle } from "../services/questionnaire";
import { AssessmentTabs } from "../components/assessment/AssessmentTabs";
import { AssessmentProgressHeader } from "../components/assessment/AssessmentProgressHeader";
import { AssessmentQuestionBody } from "../components/assessment/AssessmentQuestionBody";
import { AssessmentWelcome } from "../components/assessment/AssessmentWelcome";
import { AssessmentHistoryTable } from "../components/assessment/AssessmentHistoryTable";

const STAGE_ORDER = {
  "Agile R&D Organization": 1,
  "Continuous Integration": 2,
  "Continuous Deployment": 3,
  "R&D as an Experiment System": 4
};

// Internal component for the questionnaire form
function AssessmentForm({ organizationId, questionnaireId, onFinish, onBackToList }) {
  const [groupedQuestions, setGroupedQuestions] = useState({});
  const [stages, setStages] = useState([]);
  const [activeStage, setActiveStage] = useState(null);
  const [currentLocalIndex, setCurrentLocalIndex] = useState(0);
  const [options, setOptions] = useState([]);
  const [answers, setAnswers] = useState({});
  const [loading, setLoading] = useState(true);

  // Refs to avoid race conditions and stale closures (especially for keyboard navigation)
  const answersRef = useRef({});
  const stagesRef = useRef([]);
  const activeStageRef = useRef(null);
  const currentLocalIndexRef = useRef(0);
  const groupedQuestionsRef = useRef({});

  useEffect(() => {
    activeStageRef.current = activeStage;
    currentLocalIndexRef.current = currentLocalIndex;
  }, [activeStage, currentLocalIndex]);

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

        const grouped = {};
        const stageListRaw = [];
        sortedQuestions.forEach(q => {
            const stageName = q.sth_stage?.name || "General";
            if (!grouped[stageName]) {
                grouped[stageName] = [];
                stageListRaw.push(stageName);
            }
            grouped[stageName].push(q);
        });

        const stageList = stageListRaw.sort((a, b) => {
            return (STAGE_ORDER[a] || 99) - (STAGE_ORDER[b] || 99);
        });

        setGroupedQuestions(grouped);
        groupedQuestionsRef.current = grouped;
        setStages(stageList);
        stagesRef.current = stageList;
        setOptions(sortedOptions);
        setAnswers(initialAnswers);
        answersRef.current = initialAnswers;

        if (stageList.length > 0) {
            let foundStage = stageList[0];
            let foundIndex = 0;

            for (const stage of stageList) {
                const questionsInStage = grouped[stage];
                const unansweredIndex = questionsInStage.findIndex(q => !initialAnswers[q.id]);
                if (unansweredIndex !== -1) {
                    foundStage = stage;
                    foundIndex = unansweredIndex;
                    break;
                }
            }

            if (stageList.every(stage => grouped[stage].every(q => initialAnswers[q.id]))) {
                foundStage = stageList[stageList.length - 1];
                foundIndex = grouped[foundStage].length - 1;
            }

            setActiveStage(foundStage);
            setCurrentLocalIndex(foundIndex);
        }
      } catch (error) {
        console.error("Error loading questionnaire data:", error);
      } finally {
        setLoading(false);
      }
    }
    loadData();
  }, [organizationId, questionnaireId]);

  const questionsInActiveStage = activeStage ? groupedQuestions[activeStage] : [];
  const currentQuestion = questionsInActiveStage ? questionsInActiveStage[currentLocalIndex] : null;

  const progress = useMemo(() => {
    if (!questionsInActiveStage || questionsInActiveStage.length === 0) return 0;
    return Math.round(((currentLocalIndex + 1) / questionsInActiveStage.length) * 100);
  }, [currentLocalIndex, questionsInActiveStage]);

  const allAnswered = useMemo(() => {
    if (!stages || stages.length === 0) return false;
    return stages.every(stage => 
      groupedQuestions[stage]?.every(q => answers[q.id])
    );
  }, [stages, groupedQuestions, answers]);

  // Use refs for everything used in keyboard shortcuts to avoid stale closures
  const onFinishRef = useRef(onFinish);
  const optionsRef = useRef([]);

  useEffect(() => {
    onFinishRef.current = onFinish;
  }, [onFinish]);

  useEffect(() => {
    optionsRef.current = options;
  }, [options]);

  const handleSetAnswer = async (optionId) => {
    const curStage = activeStageRef.current;
    const curLocalIdx = currentLocalIndexRef.current;
    const curGrouped = groupedQuestionsRef.current;
    const currentQ = curGrouped[curStage]?.[curLocalIdx];

    if (!currentQ) return;
    
    // Toggle logic: if the option is already selected, we remove it (null)
    const isCurrentlySelected = answersRef.current[currentQ.id] === optionId;
    const newAnswers = { ...answersRef.current };
    let newValue = optionId;

    if (isCurrentlySelected) {
      delete newAnswers[currentQ.id];
      newValue = null;
    } else {
      newAnswers[currentQ.id] = optionId;
    }

    setAnswers(newAnswers);
    answersRef.current = newAnswers;

    try {
      // Only send auto-save if a real value was selected
      if (newValue !== null) {
        await saveAnswer(currentQ.id, newValue, organizationId, questionnaireId);
      }
    } catch (err) {
      console.error("Auto-save failed:", err);
    }
  };

  function getNavState(currentAnswers, currentStage, currentStages, currentGrouped) {
      const allComplete = currentStages.every(s => currentGrouped[s].every(q => currentAnswers[q.id]));
      
      if (allComplete) return { isComplete: true, nextStage: null };

      const currentIndex = currentStages.indexOf(currentStage);
      // Circular search for next missing stage
      for (let i = 1; i < currentStages.length; i++) {
          const checkIndex = (currentIndex + i) % currentStages.length;
          const stage = currentStages[checkIndex];
          if (currentGrouped[stage].some(q => !currentAnswers[q.id])) {
              return { isComplete: false, nextStage: stage };
          }
      }

      // If only current stage has missing items
      if (currentGrouped[currentStage].some(q => !currentAnswers[q.id])) {
          return { isComplete: false, nextStage: currentStage };
      }

      return { isComplete: true, nextStage: null };
  }

  const handleNext = () => {
    const curStage = activeStageRef.current;
    const curLocalIdx = currentLocalIndexRef.current;
    const curStages = stagesRef.current;
    const curGrouped = groupedQuestionsRef.current;
    const curAnswers = answersRef.current;

    const questionsInStage = curGrouped[curStage] || [];

    if (curLocalIdx < questionsInStage.length - 1) {
        setCurrentLocalIndex(curLocalIdx + 1);
    } else {
        const nav = getNavState(curAnswers, curStage, curStages, curGrouped);
        if (nav.nextStage) {
            setActiveStage(nav.nextStage);
            const firstUnansweredIndex = curGrouped[nav.nextStage].findIndex(q => !curAnswers[q.id]);
            setCurrentLocalIndex(firstUnansweredIndex !== -1 ? firstUnansweredIndex : 0);
        } else {
            const currentStageIndex = curStages.indexOf(curStage);
            if (currentStageIndex < curStages.length - 1) {
                setActiveStage(curStages[currentStageIndex + 1]);
                setCurrentLocalIndex(0);
            } else if (onFinishRef.current) {
                onFinishRef.current();
            }
        }
    }
  };

  const handleBack = () => {
    setCurrentLocalIndex((value) => Math.max(0, value - 1));
  };

  useEffect(() => {
    function handleKeyDown(event) {
      if (event.key >= "1" && event.key <= "5") {
        const index = parseInt(event.key, 10) - 1;
        const currentOptions = optionsRef.current;
        if (currentOptions[index]) {
          handleSetAnswer(currentOptions[index].id);
        }
      }

      if (event.key === "Enter") {
        // Prevent default browser click on focused option buttons when advancing
        event.preventDefault();

        const curStage = activeStageRef.current;
        const curLocalIdx = currentLocalIndexRef.current;
        const curAnswers = answersRef.current;
        const curGrouped = groupedQuestionsRef.current;
        
        const currentQ = curGrouped[curStage]?.[curLocalIdx];
        if (currentQ && curAnswers[currentQ.id]) {
          handleNext();
        }
      }
    }

    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, []); // Run only once, use refs inside handleKeyDown

  if (loading) {
    return (
      <section className="panel">
        <h3>Loading the Zeppelin Instrument...</h3>
      </section>
    );
  }

  if (stages.length === 0 || !activeStage) {
    return (
      <section className="panel">
        <h3>No questions found.</h3>
      </section>
    );
  }

  const isLastQuestionInStage = currentLocalIndex === questionsInActiveStage.length - 1;
  const isLastStage = activeStage === stages[stages.length - 1];

  return (
    <>
      <AssessmentTabs 
        stages={stages} 
        groupedQuestions={groupedQuestions} 
        answers={answers} 
        activeStage={activeStage} 
        onTabClick={(stage, stageQuestions) => {
          setActiveStage(stage);
          const firstUnanswered = stageQuestions.findIndex(q => !answers[q.id]);
          setCurrentLocalIndex(firstUnanswered !== -1 ? firstUnanswered : 0);
        }}
      />

      <AssessmentProgressHeader 
        activeStage={activeStage} 
        currentLocalIndex={currentLocalIndex} 
        questionsInActiveStage={questionsInActiveStage} 
        progress={progress} 
        onBackToList={onBackToList} 
      />

      {currentQuestion && (
        <AssessmentQuestionBody 
          currentQuestion={currentQuestion} 
          options={options} 
          answers={answers} 
          handleSetAnswer={handleSetAnswer} 
          handleBack={handleBack} 
          handleNext={handleNext} 
          currentLocalIndex={currentLocalIndex} 
          isLastQuestionInStage={isLastQuestionInStage} 
          isLastStage={isLastStage} 
          allAnswered={allAnswered} 
          stages={stages} 
          groupedQuestions={groupedQuestions} 
          activeStage={activeStage}
        />
      )}
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
  onFinish,
  onExitForm,
  onFormStateChange
}) {
  const [currentView, setCurrentView] = useState("list"); // "list" | "form"
  const [isCreatingCycle, setIsCreatingCycle] = useState(false);

  useEffect(() => {
    if (onFormStateChange) {
      onFormStateChange(currentView === "form" || isCreatingCycle);
    }
    return () => {
      if (onFormStateChange) onFormStateChange(false);
    };
  }, [currentView, isCreatingCycle, onFormStateChange]);

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
    startNewCycleForOrganization(organizationId);
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
        onBackToList={() => {
          setCurrentView("list");
          if (onExitForm) onExitForm();
        }}
      />
    );
  }

  if (cycleOptions.length === 0) {
    return (
      <AssessmentWelcome 
        handleStartNew={handleStartNew} 
      />
    );
  }

  return (
    <AssessmentHistoryTable 
      cycleOptions={cycleOptions} 
      organizationName={organizationName} 
      onCycleCreated={onCycleCreated} 
      onViewResults={onViewResults} 
      setCurrentView={setCurrentView} 
      handleStartNew={handleStartNew} 
    />
  );
}
