import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { AssessmentPage } from "../AssessmentPage";
import * as questionnaireService from "../../services/questionnaire";

// Mocking the questionnaire service
vi.mock("../../services/questionnaire", () => ({
  getStatements: vi.fn(),
  getAdoptedLevels: vi.fn(),
  getSavedAnswers: vi.fn(),
  createQuestionnaireCycle: vi.fn(),
  saveAnswer: vi.fn()
}));

describe("AssessmentPage Multi-Organization Interaction", () => {
  const mockOrgs = [
    { id: "1", name: "Organization A" },
    { id: "2", name: "Organization B" }
  ];

  const mockCyclesOrgA = [
    { id: "101", label: "Cycle Org A", answeredPractices: 0 }
  ];

  const mockCyclesOrgB = [
    { id: "202", label: "Cycle Org B", answeredPractices: 0 }
  ];

  beforeEach(() => {
    vi.clearAllMocks();
    questionnaireService.getStatements.mockResolvedValue([
      { id: 1, code: "Q1", text: "Question 1", sth_stage: { name: "Stage 1" } }
    ]);
    questionnaireService.getAdoptedLevels.mockResolvedValue([
      { id: 10, name: "Level 0", percentage: 0 }
    ]);
    questionnaireService.getSavedAnswers.mockResolvedValue([]);
  });

  it("should filter the history table based on the selected organizationId", async () => {
    // Initial render with Org A
    const { rerender } = render(
      <AssessmentPage 
        organizationId="1"
        organizationName="Organization A"
        organizations={mockOrgs}
        cycleOptions={mockCyclesOrgA}
      />
    );

    expect(screen.getByText("Cycle Org A")).toBeInTheDocument();
    expect(screen.queryByText("Cycle Org B")).not.toBeInTheDocument();

    // Simulating the parent component (App.jsx) changing the organizationId to Org B
    rerender(
      <AssessmentPage 
        organizationId="2"
        organizationName="Organization B"
        organizations={mockOrgs}
        cycleOptions={mockCyclesOrgB}
      />
    );

    expect(screen.getByText("Cycle Org B")).toBeInTheDocument();
    expect(screen.queryByText("Cycle Org A")).not.toBeInTheDocument();
  });

  it("should create a new cycle for the currently selected organization", async () => {
    const onCycleCreated = vi.fn();
    questionnaireService.createQuestionnaireCycle.mockResolvedValue({ id: 303 });

    render(
      <AssessmentPage 
        organizationId="2" // Org B selected
        organizationName="Organization B"
        organizations={mockOrgs}
        cycleOptions={mockCyclesOrgB}
        onCycleCreated={onCycleCreated}
      />
    );

    // Click 'New'
    fireEvent.click(screen.getByText("New"));

    await waitFor(() => {
      expect(questionnaireService.createQuestionnaireCycle).toHaveBeenCalled();
      expect(onCycleCreated).toHaveBeenCalledWith("303");
    });

    // Should now show the question body (meaning we are in the form)
    await waitFor(() => expect(screen.getByText("Question 1")).toBeInTheDocument());
  });

  it("should keep the same questionnaire context even if parent organizationId changes while in form", async () => {
    const { rerender } = render(
      <AssessmentPage 
        organizationId="1"
        organizationName="Organization A"
        organizations={mockOrgs}
        cycleOptions={mockCyclesOrgA}
      />
    );

    // Go to form by continuing 'Cycle Org A'
    fireEvent.click(screen.getByText("Continue answering"));
    await waitFor(() => expect(screen.getByText("Question 1")).toBeInTheDocument());

    // While in form, parent changes to Org B
    rerender(
      <AssessmentPage 
        organizationId="2"
        organizationName="Organization B"
        organizations={mockOrgs}
        cycleOptions={mockCyclesOrgB}
        questionnaireId="101" // Same cycle
      />
    );

    // It should STILL be in the form, not back to the list of Org B
    expect(screen.getByText("Question 1")).toBeInTheDocument();
    expect(screen.queryByText("Cycle Org B")).not.toBeInTheDocument();
  });

  it("should not show the organization selector once the form is open", async () => {
    render(
      <AssessmentPage 
        organizationId="1"
        organizationName="Organization A"
        organizations={mockOrgs}
        cycleOptions={mockCyclesOrgA}
      />
    );

    const selectors = screen.queryAllByRole("combobox");
    expect(selectors.length).toBe(0); 
  });
});
