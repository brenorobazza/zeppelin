import { useState } from "react";
import "./login-page.css";

export function CreateAccountPage({ onBackToLogin, onAccountCreated }) {
  const [form, setForm] = useState({
    username: "",
    email: "",
    password: "",
    role: ""
  });

  function handleChange(event) {
    const { name, value } = event.target;
    setForm((prev) => ({
      ...prev,
      [name]: value
    }));
  }

  function handleBackToLogin() {
    if (typeof onBackToLogin === "function") {
      onBackToLogin();
      return;
    }

    window.location.hash = "";
  }

  function handleSubmit(event) {
    event.preventDefault();

    if (typeof onAccountCreated === "function") {
      onAccountCreated(form);
      return;
    }

    window.location.hash = "join-organization";
  }

  return (
    <main className="login-shell">
      <section className="login-layout">
        {/* Coluna institucional, reaproveitando a mesma linguagem visual do login
            para manter consistencia na entrada da plataforma. */}
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

              <button className="btn-primary" type="submit">
                Continue
              </button>

              {/* Separador para destacar a acao de retorno ao login. */}
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
