import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";
import { PlatformLayout } from "../PlatformLayout";

describe("PlatformLayout Navigation Policy", () => {
  const mockProps = {
    activePage: "dashboard",
    title: "Title",
    subtitle: "Subtitle",
    organization: "Org A",
    userName: "User",
    onNavigate: () => {},
    onLogout: () => {},
    organizationOptions: [{ id: "1", name: "Org A" }, { id: "2", name: "Org B" }],
    selectedOrganizationId: "1",
    onOrganizationChange: () => {},
    cycleOptions: [{ id: "101", label: "Cycle 1", shortLabel: "C1" }],
    selectedCycleId: "101",
    onCycleChange: () => {}
  };

  it("should enable selectors by default", () => {
    render(<PlatformLayout {...mockProps} />);
    
    // Procura o select de organização pelo valor
    const orgSelect = screen.getByDisplayValue("Org A");
    const cycleSelect = screen.getByDisplayValue("C1 - Cycle 1");

    expect(orgSelect).not.toBeDisabled();
    expect(cycleSelect).not.toBeDisabled();
  });

  it("should render fixed labels instead of selectors when disableGlobalSelectors is true", () => {
    render(<PlatformLayout {...mockProps} disableGlobalSelectors={true} />);
    
    // Check for the fixed labels
    const orgLabel = screen.getByText("Org A");
    const cycleLabel = screen.getByText("Cycle 1");

    expect(orgLabel).toHaveClass("org-label-fixed");
    expect(cycleLabel).toHaveClass("cycle-label-fixed");
    
    // Ensure the selects are gone
    expect(screen.queryByDisplayValue("Org A")).not.toBeInTheDocument();
    expect(screen.queryByDisplayValue("C1 - Cycle 1")).not.toBeInTheDocument();
  });
});
