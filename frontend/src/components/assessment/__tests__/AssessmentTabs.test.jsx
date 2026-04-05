import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import { AssessmentTabs } from "../AssessmentTabs";

describe("AssessmentTabs Component", () => {
  const mockStages = ["Stage A", "Stage B"];
  const mockGroupedQuestions = {
    "Stage A": [{ id: 1 }, { id: 2 }],
    "Stage B": [{ id: 3 }]
  };
  const mockAnswers = { 1: 10 }; // 1 question answered in Stage A

  it("should render all stage names", () => {
    render(
      <AssessmentTabs 
        stages={mockStages} 
        groupedQuestions={mockGroupedQuestions} 
        answers={mockAnswers} 
        activeStage="Stage A" 
        onTabClick={() => {}} 
      />
    );

    expect(screen.getByText("Stage A")).toBeInTheDocument();
    expect(screen.getByText("Stage B")).toBeInTheDocument();
  });

  it("should mark the active stage with the correct styles", () => {
    render(
      <AssessmentTabs 
        stages={mockStages} 
        groupedQuestions={mockGroupedQuestions} 
        answers={mockAnswers} 
        activeStage="Stage A" 
        onTabClick={() => {}} 
      />
    );

    const activeTab = screen.getByText("Stage A").closest("button");
    expect(activeTab).toHaveStyle({ background: "rgb(255, 255, 255)" });
  });

  it("should call onTabClick when a tab is clicked", () => {
    const onTabClick = vi.fn();
    render(
      <AssessmentTabs 
        stages={mockStages} 
        groupedQuestions={mockGroupedQuestions} 
        answers={mockAnswers} 
        activeStage="Stage A" 
        onTabClick={onTabClick} 
      />
    );

    fireEvent.click(screen.getByText("Stage B"));
    expect(onTabClick).toHaveBeenCalledWith("Stage B", mockGroupedQuestions["Stage B"]);
  });

  it("should display progress indicators (count / total)", () => {
    render(
      <AssessmentTabs 
        stages={mockStages} 
        groupedQuestions={mockGroupedQuestions} 
        answers={mockAnswers} 
        activeStage="Stage A" 
        onTabClick={() => {}} 
      />
    );

    // Stage A has 1 / 2 answered
    expect(screen.getByText("1 / 2")).toBeInTheDocument();
    // Stage B has 0 / 1 answered
    expect(screen.getByText("0 / 1")).toBeInTheDocument();
  });
});
