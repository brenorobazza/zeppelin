import { useMemo, useState } from "react";
import "./join-organization-page.css";

const MOCK_ORGANIZATIONS = [
  "Zeppelin Labs",
  "Zeppelin Digital",
  "Acme Corp",
  "Nexus Logistics",
  "Blue Orbit",
  "Rocket Dynamics"
];

export function JoinOrganizationPage() {
  const [query, setQuery] = useState("");
  const [selectedOrganization, setSelectedOrganization] = useState("");

  const normalizedQuery = query.trim().toLowerCase();

  const matches = useMemo(() => {
    if (normalizedQuery.length < 3) return [];

    return MOCK_ORGANIZATIONS.filter((name) =>
      name.toLowerCase().includes(normalizedQuery)
    );
  }, [normalizedQuery]);

  return (
    <main className="join-org-shell">
      <section className="join-org-wrapper">
        <div className="join-org-icon" aria-hidden="true">
          <span>▦</span>
        </div>

        <header className="join-org-header">
          <h1>Join Your Organization</h1>
          <p>Connect with your company to get started</p>
        </header>

        <section className="join-org-card" aria-label="Join organization form">
          <div className="join-org-field">
            <label htmlFor="organization-search">Search for your organization</label>

            <div className="join-org-input-wrap">
              <span className="join-org-search-icon" aria-hidden="true">
                ⌕
              </span>
              <input
                id="organization-search"
                type="text"
                value={query}
                onChange={(event) => {
                  setQuery(event.target.value);
                  setSelectedOrganization("");
                }}
                placeholder="Start typing your company name..."
              />
            </div>

            <p className="join-org-hint">
              Type at least 3 characters to see matching organizations
            </p>

            {normalizedQuery.length >= 3 ? (
              <ul className="join-org-results" aria-label="Organization suggestions">
                {matches.length > 0 ? (
                  matches.map((organizationName) => (
                    <li key={organizationName}>
                      <button
                        type="button"
                        className={
                          selectedOrganization === organizationName
                            ? "join-org-option is-selected"
                            : "join-org-option"
                        }
                        onClick={() => setSelectedOrganization(organizationName)}
                      >
                        {organizationName}
                      </button>
                    </li>
                  ))
                ) : (
                  <li className="join-org-empty">No organizations found.</li>
                )}
              </ul>
            ) : null}
          </div>

          <div className="join-org-separator">
            <span>OR</span>
          </div>

          <section className="join-org-create-card">
            <div className="join-org-create-icon" aria-hidden="true">
              +
            </div>

            <div className="join-org-create-copy">
              <h2>Can't find your organization?</h2>
              <p>Create a new organization profile and invite your team members to join.</p>
              <button type="button" className="join-org-create-btn">
                Create New Organization
              </button>
            </div>
          </section>

          <footer className="join-org-card-footer">
            <p>Your data is secure and encrypted</p>
            <button type="button" className="join-org-help-btn">
              Need help?
            </button>
          </footer>
        </section>

        <p className="join-org-disclaimer">
          By joining an organization, you agree to share your profile information with
          organization administrators.
        </p>

        <p className="join-org-todo">TODO: integrar endpoint real para autocomplete e criação de organização.</p>
      </section>
    </main>
  );
}
