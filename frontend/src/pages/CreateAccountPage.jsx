import { useState } from "react";
import { registerAccount } from "../services/auth";
import "./login-page.css";

export function CreateAccountPage({ onBackToLogin }) {
  // Campos necessarios para o endpoint atual de cadastro.
  const [form, setForm] = useState({
    username: "",
    email: "",
    password: "",
    role: "",
    organization_name: "",
    organization_description: ""
  });
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  function handleChange(event) {
    const { name, value } = event.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  }

  function handleBackToLogin() {
    if (typeof onBackToLogin === "function") {
      onBackToLogin();
      return;
    }

    window.location.hash = "";
  }

  async function handleSubmit(event) {
    event.preventDefault();
    setError("");
    setSuccess("");
    setIsLoading(true);

    try {
      await registerAccount(form);
      setSuccess("Account created successfully. You can sign in now.");
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <main className="login-shell">
      <section className="login-layout">
        <aside className="promo-panel">
          <div className="promo-content">
            <img className="brand-logo" src="/branding/logo-zeppelin.png" alt="Zeppelin CI/CD" />
            <h1>
              Build your team profile with <span>clarity</span>.
            </h1>
            <p>
              Create your account, link your organization, and start measuring CI/CD maturity from
              day one.
            </p>
          </div>
        </aside>

        <section className="login-panel">
          <section className="login-card">
            <header>
              <h2>Create your Zeppelin account</h2>
              <p>Use your work details to set up access for your team.</p>
            </header>

            {error ? <p className="feedback error">{error}</p> : null}
            {success ? <p className="feedback success">{success}</p> : null}

            <form onSubmit={handleSubmit} className="login-form">
              <label htmlFor="username">Full name</label>
              <input
                id="username"
                name="username"
                type="text"
                value={form.username}
                onChange={handleChange}
                required
                placeholder="John Doe"
              />

              <label htmlFor="email">Work email</label>
              <input
                id="email"
                name="email"
                type="email"
                value={form.email}
                onChange={handleChange}
                required
                placeholder="you@company.com"
              />

              <label htmlFor="password">Password</label>
              <input
                id="password"
                name="password"
                type="password"
                value={form.password}
                onChange={handleChange}
                required
                placeholder="********"
              />

              <label htmlFor="role">Role</label>
              <input
                id="role"
                name="role"
                type="text"
                value={form.role}
                onChange={handleChange}
                placeholder="Engineering Manager"
              />

              <label htmlFor="organization_name">Organization name</label>
              <input
                id="organization_name"
                name="organization_name"
                type="text"
                value={form.organization_name}
                onChange={handleChange}
                required
                placeholder="Zeppelin Labs"
              />

              <label htmlFor="organization_description">Organization description (optional)</label>
              <textarea
                id="organization_description"
                name="organization_description"
                value={form.organization_description}
                onChange={handleChange}
                placeholder="Short description about your organization"
                rows={3}
              />

              <button className="btn-primary" type="submit" disabled={isLoading}>
                {isLoading ? "Creating account..." : "Create Account"}
              </button>

              <div className="separator">
                <span>Already have an account?</span>
              </div>

              <button className="btn-secondary" type="button" onClick={handleBackToLogin}>
                Back to Sign In
              </button>
            </form>

            <footer>
              <a href="#">Privacy Policy</a>
              <a href="#">Terms of Service</a>
            </footer>
          </section>
        </section>
      </section>
    </main>
  );
}
