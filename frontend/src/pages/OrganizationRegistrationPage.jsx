import { useState } from "react";
import "./organization-registration-page.css";

const COUNTRY_OPTIONS = [
  "Brazil",
  "United States",
  "Canada",
  "Mexico",
  "Argentina",
  "Chile",
  "Colombia",
  "United Kingdom",
  "Germany",
  "France",
  "Spain",
  "Italy",
  "Netherlands",
  "Poland",
  "Russia",
  "India",
  "China",
  "Japan",
  "South Korea",
  "Singapore",
  "Australia",
  "South Africa",
  "Nigeria",
  "Kenya",
];

const BRAZIL_STATES = [
  "Acre",
  "Alagoas",
  "Amapa",
  "Amazonas",
  "Bahia",
  "Ceara",
  "Distrito Federal",
  "Espirito Santo",
  "Goias",
  "Maranhao",
  "Mato Grosso",
  "Mato Grosso do Sul",
  "Minas Gerais",
  "Para",
  "Paraiba",
  "Parana",
  "Pernambuco",
  "Piaui",
  "Rio de Janeiro",
  "Rio Grande do Norte",
  "Rio Grande do Sul",
  "Rondonia",
  "Roraima",
  "Santa Catarina",
  "Sao Paulo",
  "Sergipe",
  "Tocantins"
];

const TYPE_OPTIONS = ["Private", "Public", "Startup", "Scale-up", "Hybrid"];
const SECTOR_OPTIONS = ["Finance", "Healthcare", "Retail", "Industry", "Education", "Technology"];
const AUDIENCE_OPTIONS = ["B2B", "B2C", "B2G", "Internal", "Mixed"];

const INITIAL_FORM = {
  name: "",
  country: "Brazil",
  years: "",
  state: "",
  organizationType: "",
  sector: "",
  size: "",
  audience: ""
};

export function OrganizationRegistrationPage({
  mode = "signup",
  accountData,
  onBack,
  onSubmit,
  onSubmitSuccess,
}) {
  const [form, setForm] = useState(INITIAL_FORM);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");

  function handleChange(event) {
    const { name, value } = event.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  }

  function validateForm() {
    const isBrazil = (form.country || "").trim().toLowerCase() === "brazil";
    const sizeValue = Number(form.size);
    const yearsValue = form.years === "" ? null : Number(form.years);

    if (!form.name || !form.country || !form.organizationType || !form.sector || !form.size) {
      return "Please fill in all required fields.";
    }

    if (!form.name.trim()) {
      return "Organization name is required.";
    }

    if (!Number.isFinite(sizeValue) || sizeValue <= 0) {
      return "Organization size must be a number greater than zero.";
    }

    if (yearsValue !== null && (!Number.isFinite(yearsValue) || yearsValue < 0)) {
      return "Years of experience must be a non-negative number.";
    }

    if (isBrazil && !form.state) {
      return "Please fill in the Brazilian state when the country is Brazil.";
    }

    return "";
  }

  async function handleSubmit(event) {
    event.preventDefault();
    const validationError = validateForm();

    if (validationError) {
      setError(validationError);
      return;
    }

    setError("");
    setSuccess("");
    setIsSubmitting(true);

    try {
      if (mode === "signup" && (!accountData?.username || !accountData?.email || !accountData?.password)) {
        setError("Create your account first to continue organization registration.");
        return;
      }

      if (typeof onSubmit !== "function") {
        setError("Organization registration flow is not configured.");
        return;
      }

      const result = await onSubmit({ form, mode, accountData });

      setSuccess(
        result?.message ||
          (mode === "signup"
            ? "Registration completed successfully. Your account is now linked to an organization."
            : "Organization added to your profile.")
      );
    } catch (err) {
      setError(err.message || "Could not complete registration.");
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <main className="org-registration-shell">
      <header className="org-registration-topbar">
        <div className="org-registration-topbar-content">
          <div className="org-registration-brand-mark" aria-hidden="true">[]</div>
          <div className="org-registration-brand-copy">
            <h1>Organization Registration</h1>
          </div>
          <p className="org-registration-time">~5 minutes</p>
        </div>
      </header>

      <section className="org-registration-page">
        <div className="org-registration-progress-line">
          <div className="org-registration-progress-labels">
            <span>Progress</span>
            <span>Step 1 of 1</span>
          </div>
          <div className="org-registration-progress-track">
            <div className="org-registration-progress-value" />
          </div>
        </div>

        <article className="org-registration-card">
          <div className="org-registration-card-head">
            <h2>Organization Details</h2>
            <p>Please provide information about your organization and software development practices.</p>
          </div>

          <form className="org-registration-form" onSubmit={handleSubmit}>
            <label>
              <span>
                Organization Name *
              </span>
              <input
                type="text"
                name="name"
                value={form.name}
                onChange={handleChange}
                placeholder="Enter your organization name"
                required
              />
            </label>

            <label>
              <span>In which country is your organization located? *</span>
              <small>If multiple countries, indicate your work unit's country</small>
              <select
                name="country"
                value={form.country}
                onChange={handleChange}
                required
              >
                <option value="">Select country</option>
                {COUNTRY_OPTIONS.map((option) => (
                  <option key={option} value={option}>
                    {option}
                  </option>
                ))}
              </select>
            </label>

            <label>
              <span>In which Brazilian state is your organization located? (required only if country is Brazil)</span>
              <small>If multiple locations, indicate your work unit's state</small>
              <select
                name="state"
                value={form.state}
                onChange={handleChange}
                required={(form.country || "").trim().toLowerCase() === "brazil"}
              >
                <option value="">Select state</option>
                {BRAZIL_STATES.map((option) => (
                  <option key={option} value={option}>
                    {option}
                  </option>
                ))}
              </select>
            </label>

            <label>
              <span>Organization Type *</span>
              <select name="organizationType" value={form.organizationType} onChange={handleChange} required>
                <option value="">Select type</option>
                {TYPE_OPTIONS.map((option) => (
                  <option key={option} value={option}>
                    {option}
                  </option>
                ))}
              </select>
            </label>

            <label>
              <span>Organization Sector *</span>
              <select name="sector" value={form.sector} onChange={handleChange} required>
                <option value="">Select sector</option>
                {SECTOR_OPTIONS.map((option) => (
                  <option key={option} value={option}>
                    {option}
                  </option>
                ))}
              </select>
            </label>

            <label>
              <span>Organization Size (number of employees) *</span>
              <input
                type="number"
                name="size"
                value={form.size}
                onChange={handleChange}
                min="1"
                step="1"
                required
                placeholder="e.g. 120"
              />
            </label>

            <label>
              <span>What is the main target audience of the software developed?</span>
              <select name="audience" value={form.audience} onChange={handleChange}>
                <option value="">Select target audience</option>
                {AUDIENCE_OPTIONS.map((option) => (
                  <option key={option} value={option}>
                    {option}
                  </option>
                ))}
              </select>
            </label>

            <label>
              <span>How many years has your organization been developing software?</span>
              <input
                type="number"
                name="years"
                value={form.years}
                onChange={handleChange}
                min="0"
                step="1"
                placeholder="e.g. 5"
              />
            </label>
            {error ? <p className="org-registration-error">{error}</p> : null}
            {success ? <p className="org-registration-success">{success}</p> : null}

            <footer className="org-registration-actions">
              <button
                type="button"
                className="org-registration-back"
                onClick={() => {
                  if (typeof onBack === "function") {
                    onBack();
                    return;
                  }
                  window.history.back();
                }}
              >
                Back
              </button>
              <button type="submit" className="org-registration-submit" disabled={isSubmitting}>
                {isSubmitting
                  ? "Submitting..."
                  : mode === "signup"
                    ? "Submit Registration"
                    : "Create Organization"}
              </button>
            </footer>

            {success && typeof onSubmitSuccess === "function" ? (
              <button
                type="button"
                className="org-registration-submit"
                onClick={() => onSubmitSuccess(form)}
              >
                {mode === "signup" ? "Continue to sign in" : "Back to settings"}
              </button>
            ) : null}
          </form>
        </article>
      </section>

      <footer className="org-registration-footnote">
        Your information is secure and will be used only for research purposes.
      </footer>
    </main>
  );
}