import { useEffect, useState } from "react";
import { registerAccount, searchOrganizations } from "../services/auth";

import "./join-organization-page.css";

export function JoinOrganizationPage({ accountData, onCreateOrganization, onBackToLogin }) {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState([]);
  const [selectedOrganizationId, setSelectedOrganizationId] = useState(null);
  const [isSearching, setIsSearching] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");

  const normalizedQuery = query.trim().toLowerCase();

  useEffect(() => {
    let ignore = false;

    async function loadOrganizations() {
      if (normalizedQuery.length < 3) {
        setResults([]);
        return;
      }

      setIsSearching(true);
      setError("");

      try {
        const data = await searchOrganizations(normalizedQuery);
        if (ignore) return;
        setResults(data);
      } catch (err) {
        if (ignore) return;
        setError(err.message || "Could not load organizations.");
      } finally {
        if (!ignore) {
          setIsSearching(false);
        }
      }
    }

    loadOrganizations();
    return () => {
      ignore = true;
    };
  }, [normalizedQuery]);

  async function handleFinalizeRegistration() {
    setError("");
    setSuccess("");

    if (!accountData?.username || !accountData?.email || !accountData?.password) {
      setError("Create your account first to continue.");
      return;
    }

    if (!selectedOrganizationId) {
      setError("Select an organization before finishing your registration.");
      return;
    }

    setIsSubmitting(true);
    try {
      await registerAccount({
        username: accountData.username,
        email: accountData.email,
        password: accountData.password,
        role: accountData.role || "",
        organization_id: selectedOrganizationId
      });

      setSuccess("Registration completed successfully. Your account is now linked to an organization.");
    } catch (err) {
      setError(err.message || "Could not complete registration.");
    } finally {
      setIsSubmitting(false);
    }
  }

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
                  setSelectedOrganizationId(null);
                  setSuccess("");
                }}
                placeholder="Start typing your company name..."
              />
            </div>

            <p className="join-org-hint">
              Type at least 3 characters to see matching organizations
            </p>

            {error ? <p className="join-org-hint join-org-hint-error">{error}</p> : null}

            {normalizedQuery.length >= 3 ? (
              <ul className="join-org-results" aria-label="Organization suggestions">
                {isSearching ? (
                  <li className="join-org-empty">Searching organizations...</li>
                ) : results.length > 0 ? (
                  results.map((organization) => (
                    <li key={organization.id}>
                      <button
                        type="button"
                        className={
                          selectedOrganizationId === organization.id
                            ? "join-org-option is-selected"
                            : "join-org-option"
                        }
                        onClick={() => setSelectedOrganizationId(organization.id)}
                      >
                        {organization.name}
                      </button>
                    </li>
                  ))
                ) : (
                  <li className="join-org-empty">No organizations found.</li>
                )}
              </ul>
            ) : null}

            {selectedOrganizationId ? (
              <button
                type="button"
                className="join-org-finalize-btn"
                onClick={handleFinalizeRegistration}
                disabled={isSubmitting}
              >
                {isSubmitting ? "Finalizing..." : "Finalize registration"}
              </button>
            ) : null}

            {success ? <p className="join-org-success">{success}</p> : null}
            {success && typeof onBackToLogin === "function" ? (
              <button
                type="button"
                className="join-org-finalize-btn"
                onClick={() => onBackToLogin()}
              >
                Continue to sign in
              </button>
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
              <button
                type="button"
                className="join-org-create-btn"
                onClick={() => {
                  if (typeof onCreateOrganization === "function") {
                    onCreateOrganization();
                    return;
                  }
                  window.location.hash = "organization-registration";
                }}
              >
                Create New Organization
              </button>
            </div>
          </section>

          <footer className="join-org-card-footer">
            <p>Your data is secure and encrypted</p>
            <button
              type="button"
              className="join-org-help-btn"
              onClick={() => {
                if (typeof onBackToLogin === "function") {
                  onBackToLogin();
                  return;
                }
                window.location.hash = "login";
              }}
            >
              {onBackToLogin ? "Back to sign in" : "Need help?"}
            </button>
          </footer>
        </section>

        <p className="join-org-disclaimer">
          By joining an organization, you agree to share your profile information with
          organization administrators.
        </p>

      </section>
    </main>
  );
}