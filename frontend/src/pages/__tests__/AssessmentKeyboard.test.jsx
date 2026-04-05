import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { AssessmentPage } from "../AssessmentPage";
import * as questionnaireService from "../../services/questionnaire";

// Mocking all services used in AssessmentPage
vi.mock("../../services/questionnaire", () => ({
  getStatements: vi.fn(),
  getAdoptedLevels: vi.fn(),
  getSavedAnswers: vi.fn(),
  createQuestionnaireCycle: vi.fn(),
  saveAnswer: vi.fn()
}));

describe("AssessmentPage Keyboard Interaction", () => {
  const mockOptions = [
    { id: 10, name: "Nivel 0", percentage: 0 },
    { id: 20, name: "Nivel 100", percentage: 100 }
  ];
  const mockQuestions = [
    { id: 1, code: "AO1", text: "Q1", sth_stage: { name: "Stage 1" } }
  ];

  beforeEach(() => {
    vi.clearAllMocks();
    questionnaireService.getStatements.mockResolvedValue(mockQuestions);
    questionnaireService.getAdoptedLevels.mockResolvedValue(mockOptions);
    questionnaireService.getSavedAnswers.mockResolvedValue([]);
  });

  it("should select an option when pressing keys 1-5", async () => {
    render(
      <AssessmentPage 
        organizationId="1" 
        questionnaireId="1" 
        cycleOptions={[{ id: "1", label: "Cycle 1", answeredPractices: 0 }]}
      />
    );

    // Enter form view
    fireEvent.click(screen.getByText(/Continue answering/i));

    await waitFor(() => expect(screen.getByText("[AO1]")).toBeInTheDocument());

    // Press key '2' for mockOptions[1] (Nivel 100, id 20)
    fireEvent.keyDown(window, { key: "2" });

    // Expecting saveAnswer to be called and button to be selected
    await waitFor(() => {
      expect(questionnaireService.saveAnswer).toHaveBeenCalledWith(1, 20, "1", "1");
    });

    const optionBtn = screen.getByText("100% - Nivel 100").closest("button");
    expect(optionBtn).toHaveClass("is-selected");
  });

  it("should advance to next question when pressing Enter (if answered)", async () => {
     // Setup with 2 questions
     const questions = [
        { id: 1, code: "AO1", text: "Q1", sth_stage: { name: "Stage 1" } },
        { id: 2, code: "AO2", text: "Q2", sth_stage: { name: "Stage 1" } }
     ];
     questionnaireService.getStatements.mockResolvedValue(questions);

     render(
        <AssessmentPage 
          organizationId="1" 
          questionnaireId="1" 
          cycleOptions={[{ id: "1", label: "Cycle 1", answeredPractices: 0 }]}
        />
      );

      fireEvent.click(screen.getByText(/Continue answering/i));
      await waitFor(() => expect(screen.getByText("Q1")).toBeInTheDocument());

      // Answer Q1
      fireEvent.keyDown(window, { key: "1" });

      // Press Enter to advance
      fireEvent.keyDown(window, { key: "Enter" });

      // Check if we are now on Q2
      await waitFor(() => expect(screen.getByText("Q2")).toBeInTheDocument());
  });

  it("should route back to first stage if last stage is finished but first is incomplete (Keyboard)", async () => {
    const questions = [
      { id: 1, code: "S1Q1", text: "Stage 1 Question", sth_stage: { name: "Stage 1" } },
      { id: 2, code: "S2Q1", text: "Stage 2 Question", sth_stage: { name: "Stage 2" } }
    ];
    questionnaireService.getStatements.mockResolvedValue(questions);

    render(
      <AssessmentPage 
        organizationId="1" 
        questionnaireId="1" 
        cycleOptions={[{ id: "1", label: "Cycle 1", answeredPractices: 0 }]}
      />
    );

    fireEvent.click(screen.getByText(/Continue answering/i));
    await waitFor(() => expect(screen.getByText("Stage 1 Question")).toBeInTheDocument());

    // Jump to Stage 2 tab
    fireEvent.click(screen.getByText("Stage 2"));
    await waitFor(() => expect(screen.getByText("Stage 2 Question")).toBeInTheDocument());

    // Answer with key '1'
    fireEvent.keyDown(window, { key: "1" });

    // Press Enter to finish stage 2
    fireEvent.keyDown(window, { key: "Enter" });

    // Should route back to Stage 1 because it's incomplete
    await waitFor(() => expect(screen.getByText("Stage 1 Question")).toBeInTheDocument());
    expect(screen.getByText("Stage 1").closest("button")).toHaveStyle({ background: "rgb(255, 255, 255)" });
  });

  it("should route back to first stage if last stage is finished but first is incomplete (Mouse)", async () => {
    const questions = [
      { id: 1, code: "S1Q1", text: "Stage 1 Question", sth_stage: { name: "Stage 1" } },
      { id: 2, code: "S2Q1", text: "Stage 2 Question", sth_stage: { name: "Stage 2" } }
    ];
    questionnaireService.getStatements.mockResolvedValue(questions);

    render(
      <AssessmentPage 
        organizationId="1" 
        questionnaireId="1" 
        cycleOptions={[{ id: "1", label: "Cycle 1", answeredPractices: 0 }]}
      />
    );

    fireEvent.click(screen.getByText(/Continue answering/i));
    await waitFor(() => expect(screen.getByText("Stage 1 Question")).toBeInTheDocument());

    // Jump to Stage 2 tab
    fireEvent.click(screen.getByText("Stage 2"));
    await waitFor(() => expect(screen.getByText("Stage 2 Question")).toBeInTheDocument());

    // Click on an option (Nivel 0 - id 10)
    fireEvent.click(screen.getByText("0% - Nivel 0"));

    // Click on 'Review Missing' button (The text changes because Stage 1 is behind)
    fireEvent.click(screen.getByText("Review Missing"));

    // Should route back to Stage 1
    await waitFor(() => expect(screen.getByText("Stage 1 Question")).toBeInTheDocument());
  });
});
