import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import { AssessmentQuestionBody } from "../AssessmentQuestionBody";

describe("AssessmentQuestionBody Component", () => {
  const mockQuestion = { id: 1, code: "AO1", text: "Pergunta de Teste" };
  const mockOptions = [
    { id: 10, name: "Nivel 0", percentage: 0, description: "Desc 0" },
    { id: 20, name: "Nivel 100", percentage: 100, description: "Desc 100" }
  ];
  const mockAnswers = {};

  it("should render question code and text", () => {
    render(
      <AssessmentQuestionBody 
        currentQuestion={mockQuestion} 
        options={mockOptions} 
        answers={mockAnswers} 
        handleSetAnswer={() => {}} 
        handleBack={() => {}} 
        handleNext={() => {}} 
      />
    );

    expect(screen.getByText("[AO1]")).toBeInTheDocument();
    expect(screen.getByText("Pergunta de Teste")).toBeInTheDocument();
  });

  it("should render all provided options", () => {
    render(
      <AssessmentQuestionBody 
        currentQuestion={mockQuestion} 
        options={mockOptions} 
        answers={mockAnswers} 
        handleSetAnswer={() => {}} 
        handleBack={() => {}} 
        handleNext={() => {}} 
      />
    );

    expect(screen.getByText("0% - Nivel 0")).toBeInTheDocument();
    expect(screen.getByText("100% - Nivel 100")).toBeInTheDocument();
  });

  it("should call handleSetAnswer when an option is clicked", () => {
    const handleSetAnswer = vi.fn();
    render(
      <AssessmentQuestionBody 
        currentQuestion={mockQuestion} 
        options={mockOptions} 
        answers={mockAnswers} 
        handleSetAnswer={handleSetAnswer} 
        handleBack={() => {}} 
        handleNext={() => {}} 
      />
    );

    fireEvent.click(screen.getByText("100% - Nivel 100"));
    expect(handleSetAnswer).toHaveBeenCalledWith(20);
  });

  it("should disable Next button if no answer is selected", () => {
    render(
      <AssessmentQuestionBody 
        currentQuestion={mockQuestion} 
        options={mockOptions} 
        answers={{}} // No answer for id 1
        handleSetAnswer={() => {}} 
        handleBack={() => {}} 
        handleNext={() => {}} 
      />
    );

    const nextBtn = screen.getByText("Next");
    expect(nextBtn).toBeDisabled();
  });

  it("should enable Next button if answer is present", () => {
    render(
      <AssessmentQuestionBody 
        currentQuestion={mockQuestion} 
        options={mockOptions} 
        answers={{ 1: 20 }} // Answered!
        handleSetAnswer={() => {}} 
        handleBack={() => {}} 
        handleNext={() => {}} 
      />
    );

    const nextBtn = screen.getByText("Next");
    expect(nextBtn).not.toBeDisabled();
  });
});
